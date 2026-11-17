// Servidor mínimo da aplicação de pontos.
// Sem dependências: usa só módulos nativos do Node.js.
// Os dados ficam em memória — reiniciar o servidor zera tudo.

const http = require('http');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const PORT = process.env.PORT || 3000;
const PUBLIC_DIR = path.join(__dirname, 'public');

// ---------------- Regras de negócio ----------------
const PONTOS_POR_ATIVIDADE = 10;
const SENHA_MIN = 6;
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// ---------------- "Banco de dados" em memória ----------------
const usuarios = new Map();  // email -> { nome, email, senhaHash, salt }
const sessoes = new Map();   // token -> email
const lancamentos = [];      // { id, email, descricao, pontos, data }
let proximoId = 1;

function hashSenha(senha, salt) {
  return crypto.scryptSync(senha, salt, 32).toString('hex');
}

// ---------------- Helpers HTTP ----------------
function json(res, status, body) {
  res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify(body));
}

function lerCorpo(req) {
  return new Promise((resolve) => {
    let dados = '';
    req.on('data', (c) => (dados += c));
    req.on('end', () => {
      try { resolve(JSON.parse(dados || '{}')); } catch { resolve({}); }
    });
  });
}

function usuarioDaSessao(req) {
  const auth = req.headers['authorization'] || '';
  const token = auth.replace('Bearer ', '');
  const email = sessoes.get(token);
  return email ? usuarios.get(email) : null;
}

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
};

function servirEstatico(req, res) {
  let url = req.url.split('?')[0];
  if (url === '/') url = '/index.html';
  const arquivo = path.normalize(path.join(PUBLIC_DIR, url));
  if (!arquivo.startsWith(PUBLIC_DIR)) return json(res, 403, { erro: 'Proibido' });
  fs.readFile(arquivo, (err, conteudo) => {
    if (err) {
      res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
      return res.end('Página não encontrada');
    }
    res.writeHead(200, { 'Content-Type': MIME[path.extname(arquivo)] || 'text/plain' });
    res.end(conteudo);
  });
}

// ---------------- Rotas da API ----------------
async function cadastro(req, res) {
  const { nome = '', email = '', senha = '' } = await lerCorpo(req);
  const emailNorm = String(email).trim().toLowerCase();

  if (!String(nome).trim() || !emailNorm || !senha) {
    return json(res, 400, { erro: 'Preencha todos os campos.' });
  }
  if (!EMAIL_REGEX.test(emailNorm)) {
    return json(res, 400, { erro: 'E-mail inválido.' });
  }
  if (String(senha).length < SENHA_MIN) {
    return json(res, 400, { erro: `A senha deve ter no mínimo ${SENHA_MIN} caracteres.` });
  }
  if (usuarios.has(emailNorm)) {
    return json(res, 409, { erro: 'E-mail já cadastrado.' });
  }

  const salt = crypto.randomBytes(16).toString('hex');
  usuarios.set(emailNorm, {
    nome: String(nome).trim(),
    email: emailNorm,
    salt,
    senhaHash: hashSenha(String(senha), salt),
  });
  return json(res, 201, { mensagem: 'Cadastro realizado com sucesso.' });
}

async function login(req, res) {
  const { email = '', senha = '' } = await lerCorpo(req);
  const emailNorm = String(email).trim().toLowerCase();

  if (!emailNorm || !senha) {
    return json(res, 400, { erro: 'Informe e-mail e senha.' });
  }
  const usuario = usuarios.get(emailNorm);
  if (!usuario) {
    return json(res, 404, { erro: 'Conta não encontrada.' });
  }
  if (hashSenha(String(senha), usuario.salt) !== usuario.senhaHash) {
    return json(res, 401, { erro: 'Senha incorreta.' });
  }

  const token = crypto.randomBytes(24).toString('hex');
  sessoes.set(token, usuario.email);
  return json(res, 200, { token, nome: usuario.nome });
}

function registrarAtividade(req, res) {
  const usuario = usuarioDaSessao(req);
  if (!usuario) return json(res, 401, { erro: 'Sessão inválida. Faça login novamente.' });

  const lancamento = {
    id: proximoId++,
    email: usuario.email,
    descricao: 'Atividade registrada',
    pontos: PONTOS_POR_ATIVIDADE,
    data: new Date().toISOString(),
  };
  lancamentos.push(lancamento);
  return json(res, 201, { lancamento, saldo: saldoDe(usuario.email) });
}

function saldoDe(email) {
  return lancamentos
    .filter((l) => l.email === email)
    .reduce((total, l) => total + l.pontos, 0);
}

function extrato(req, res) {
  const usuario = usuarioDaSessao(req);
  if (!usuario) return json(res, 401, { erro: 'Sessão inválida. Faça login novamente.' });

  const itens = lancamentos
    .filter((l) => l.email === usuario.email)
    .sort((a, b) => b.id - a.id) // mais recente primeiro
    .map(({ email, ...resto }) => resto);

  return json(res, 200, { nome: usuario.nome, saldo: saldoDe(usuario.email), itens });
}

function logout(req, res) {
  const token = (req.headers['authorization'] || '').replace('Bearer ', '');
  sessoes.delete(token);
  return json(res, 200, { mensagem: 'Sessão encerrada.' });
}

// ---------------- Roteador ----------------
const server = http.createServer((req, res) => {
  const rota = `${req.method} ${req.url.split('?')[0]}`;
  switch (rota) {
    case 'POST /api/cadastro': return cadastro(req, res);
    case 'POST /api/login': return login(req, res);
    case 'POST /api/logout': return logout(req, res);
    case 'POST /api/atividades': return registrarAtividade(req, res);
    case 'GET /api/extrato': return extrato(req, res);
    default:
      if (req.method === 'GET') return servirEstatico(req, res);
      return json(res, 404, { erro: 'Rota não encontrada' });
  }
});

server.listen(PORT, () => {
  console.log(`Aplicação de pontos rodando em http://localhost:${PORT}`);
});
