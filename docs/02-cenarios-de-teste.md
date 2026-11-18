# Cenários de Teste

Os cenários estão em Gherkin, na pasta [`features/`](../features):

| Arquivo | História | Cenários* |
|---|---|---|
| [`cadastro.feature`](../features/cadastro.feature) | HU-01 Cadastro | 9 (+ exemplos) |
| [`login.feature`](../features/login.feature) | HU-02 Login | 8 (+ exemplos) |
| [`pontos.feature`](../features/pontos.feature) | HU-03 Atividade e extrato | 9 |

\* Um `Scenario Outline` conta como 1 cenário, mas executa uma vez por linha de `Examples`.

Padrão: palavras-chave do Gherkin em inglês (`Feature`, `Scenario`, `Given`, `When`,
`Then`, `And`), passos em português. Um comportamento por cenário.

## Como ler um cenário

- **Given** — o estado de partida (pré-condição). Não é a ação testada.
- **When** — a ação que está sendo testada. Idealmente uma só.
- **Then** — o resultado observável que prova o critério.
- **And** — continua o passo anterior (um `And` depois de `Then` também é verificação).
- **Background** — passos `Given` comuns a **todos** os cenários do arquivo; executados antes de cada um.
- **Scenario Outline + Examples** — o mesmo comportamento com dados diferentes; `<campo>` é substituído pelo valor da coluna.
- O comentário `# HU-xx / CA-yy` acima de cada cenário diz qual critério ele prova.

## Preparação para o teste manual

1. **Comece cada rodada com o servidor reiniciado** (`Ctrl+C` e `npm start`).
   Os dados ficam em memória; sem reiniciar, um e-mail usado num cenário anterior
   pode causar "E-mail já cadastrado." num cenário seguinte.
2. **Passos `Given` que pedem uma conta existente** ("que existe uma conta com…",
   "logado com uma conta sem atividades…"): crie a conta pela tela de cadastro antes
   de executar o cenário. Para "conta sem atividades", use sempre um e-mail novo.
3. **"Outro usuário"** (HU-03 / CA-07): use uma janela anônima ou outro navegador,
   para que as duas sessões não se misturem.
4. **"Não estou logado"**: clique em "Sair" antes, ou use uma janela anônima nova.
5. Anote o resultado de cada cenário: **Passou**, **Falhou** (gera card de defeito)
   ou **Bloqueado** (não deu para executar — diga por quê).

## Matriz de rastreabilidade

Todo critério de aceite precisa ser coberto por pelo menos um cenário.

| Critério | Cenário(s) |
|---|---|
| HU-01 / CA-01 | Cadastrar com dados válidos |
| HU-01 / CA-02 | Não cadastrar com `<campo>` vazio (nome, e-mail, senha) · Não cadastrar com nome preenchido apenas com espaços |
| HU-01 / CA-03 | Não cadastrar com e-mail em formato inválido (5 exemplos) |
| HU-01 / CA-04 | Cadastrar com senha de exatamente 6 caracteres · Não cadastrar com senha de 5 caracteres |
| HU-01 / CA-05 | Não cadastrar com e-mail já cadastrado · …escrito com outras maiúsculas e minúsculas |
| HU-01 / CA-06 | Não criar conta quando o cadastro falha (+ "continuo na tela de cadastro" nos cenários de erro) |
| HU-02 / CA-01 | Entrar com e-mail e senha corretos |
| HU-02 / CA-02 | Entrar digitando o e-mail com letras maiúsculas · Não entrar com a senha escrita em maiúsculas |
| HU-02 / CA-03 | Não entrar com `<campo>` vazio (e-mail, senha) |
| HU-02 / CA-04 | Não entrar com senha incorreta |
| HU-02 / CA-05 | Não entrar com e-mail sem conta cadastrada |
| HU-02 / CA-06 | Sair da aplicação · Não acessar o painel depois de sair |
| HU-03 / CA-01 | Exibir saldo zero e extrato vazio para usuário sem atividades |
| HU-03 / CA-02 | Registrar uma atividade |
| HU-03 / CA-03 | Somar 10 pontos ao saldo a cada nova atividade |
| HU-03 / CA-04 | Exibir no extrato o item da atividade registrada |
| HU-03 / CA-05 | Ordenar o extrato do mais recente para o mais antigo |
| HU-03 / CA-06 | Exibir saldo igual à soma dos itens do extrato |
| HU-03 / CA-07 | Não exibir pontos de outro usuário |
| HU-03 / CA-08 | Manter os pontos depois de sair e entrar novamente |
| HU-03 / CA-09 | Redirecionar para o login ao acessar o painel sem estar logado |

## Observação de testabilidade

**HU-03 / CA-05 (ordem do extrato):** todos os itens do extrato têm a mesma descrição
e os mesmos pontos; a única diferença visível é a data e hora, com precisão de segundos.
Se duas atividades forem registradas no mesmo segundo, **não há como verificar a ordem
pela tela**. Por isso o cenário pede intervalos de alguns segundos. Sugestão para o
time: exibir um identificador ou descrições distintas nos lançamentos.
