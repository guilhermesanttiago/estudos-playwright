# Histórias e Critérios de Aceite

Aplicação: **Pontos** (programa de fidelidade simples)

| ID | História |
|---|---|
| HU-01 | Cadastro de usuário |
| HU-02 | Login |
| HU-03 | Registrar atividade e consultar extrato |

> **Convenção de referência:** os critérios são numerados dentro de cada história.
> Para citar um critério fora deste documento (em cenários, defeitos, commits),
> use `HU-xx / CA-yy` — por exemplo, `HU-02 / CA-03`.

> **Textos entre aspas** são as mensagens exatas exibidas ao usuário. Eles fazem
> parte do critério: mensagem diferente = critério não atendido.

---

## HU-01 — Cadastro de usuário

**Como um** visitante da aplicação
**Eu quero** criar uma conta informando nome, e-mail e senha
**De modo que** eu possa acumular pontos no programa de fidelidade

### Critérios de aceite

| CA | Tipo | Critério |
|---|---|---|
| CA-01 | Sucesso | Dado que informo nome, e-mail e senha válidos, ao clicar em "Cadastrar" o sistema exibe "Cadastro realizado com sucesso." e, em seguida, me leva para a tela de login. |
| CA-02 | Regra de negócio | Nome, e-mail e senha são obrigatórios. Se qualquer um estiver vazio (ou contiver apenas espaços, no caso de nome e e-mail), o cadastro não é feito e o sistema exibe "Preencha todos os campos." |
| CA-03 | Regra de negócio | O e-mail deve ter formato válido (ex.: `nome@dominio.com`). Caso contrário, o cadastro não é feito e o sistema exibe "E-mail inválido." |
| CA-04 | Regra de negócio | A senha deve ter **no mínimo 6 caracteres**. Uma senha com 6 caracteres é aceita; com 5 ou menos, o cadastro não é feito e o sistema exibe "A senha deve ter no mínimo 6 caracteres." |
| CA-05 | Regra de negócio | Não pode existir mais de uma conta com o mesmo e-mail. A comparação **não diferencia maiúsculas de minúsculas** (`Ana@Teste.com` = `ana@teste.com`). Tentando cadastrar um e-mail já existente, o cadastro não é feito e o sistema exibe "E-mail já cadastrado." |
| CA-06 | Erro | Em qualquer erro de cadastro, o usuário permanece na tela de cadastro e nenhuma conta é criada. |

---

## HU-02 — Login

**Como um** usuário cadastrado
**Eu quero** entrar na aplicação com meu e-mail e senha
**De modo que** eu tenha acesso aos meus pontos de forma segura

### Critérios de aceite

| CA | Tipo | Critério |
|---|---|---|
| CA-01 | Sucesso | Dado que informo e-mail e senha corretos, ao clicar em "Entrar" sou levado ao painel, que exibe "Olá, {meu nome}!". |
| CA-02 | Regra de negócio | O e-mail no login **não diferencia maiúsculas de minúsculas**: uma conta cadastrada como `ana@teste.com` pode entrar digitando `ANA@teste.com`. A senha **diferencia** maiúsculas de minúsculas. |
| CA-03 | Regra de negócio | E-mail e senha são obrigatórios. Se algum estiver vazio, o sistema exibe "Informe e-mail e senha." |
| CA-04 | Erro | Dado um e-mail cadastrado com a senha errada, o sistema exibe "Senha incorreta." e o usuário permanece na tela de login. |
| CA-05 | Erro | Dado um e-mail que não possui conta, o sistema exibe "Conta não encontrada." e o usuário permanece na tela de login. |
| CA-06 | Regra de negócio | Ao clicar em "Sair" no painel, a sessão é encerrada e o usuário volta à tela de login. Para acessar o painel novamente, é preciso fazer login. |

---

## HU-03 — Registrar atividade e consultar extrato

**Como um** usuário logado
**Eu quero** registrar minhas atividades e consultar o extrato dos pontos ganhos
**De modo que** eu acompanhe quantos pontos acumulei e de onde eles vieram

### Critérios de aceite

| CA | Tipo | Critério |
|---|---|---|
| CA-01 | Sucesso | Dado um usuário sem nenhuma atividade, o painel exibe saldo **0 pontos** e o extrato exibe "Nenhum ponto ganho ainda." |
| CA-02 | Sucesso | Ao clicar em "Registrar atividade", o sistema exibe "Atividade registrada! +10 pontos." e o saldo aumenta em 10 imediatamente, sem recarregar a página. |
| CA-03 | Regra de negócio | Cada atividade registrada vale **exatamente 10 pontos**. |
| CA-04 | Regra de negócio | Cada atividade gera **um** item no extrato, contendo a descrição "Atividade registrada", a data e hora do registro e os pontos ganhos no formato "+10". |
| CA-05 | Regra de negócio | O extrato é ordenado do lançamento **mais recente para o mais antigo** (o último registrado aparece no topo). |
| CA-06 | Regra de negócio | O saldo exibido é sempre igual à soma dos pontos de todos os itens do extrato. |
| CA-07 | Regra de negócio | Cada usuário vê **apenas os próprios** pontos e lançamentos. Atividades de outro usuário não aparecem no seu extrato nem somam no seu saldo. |
| CA-08 | Regra de negócio | Os pontos são mantidos entre sessões: ao sair e entrar novamente, saldo e extrato continuam os mesmos. |
| CA-09 | Erro | Ao tentar acessar o painel sem estar logado (ex.: digitando `/painel.html` direto no navegador), o usuário é redirecionado para a tela de login. |

---

## Premissas e fora de escopo

- Os dados ficam em memória: **reiniciar o servidor apaga todas as contas e pontos**. Isso é uma limitação do ambiente de estudo, não um defeito.
- Fora de escopo nesta versão: recuperação de senha, edição de perfil, resgate/gasto de pontos, limite de atividades por dia.

## Pontos em aberto para refinamento (dúvidas do QA para o PO)

Perguntas que um QA levaria para a reunião de refinamento. Ficam registradas aqui
até alguém decidir — e a decisão pode virar critério novo.

1. **HU-02 / CA-04 e CA-05 — Enumeração de usuários.** Mensagens diferentes para
   "senha incorreta" e "conta não encontrada" permitem a qualquer pessoa descobrir
   quais e-mails estão cadastrados. Mantemos (melhor para o usuário) ou trocamos por
   uma mensagem genérica, ex.: "E-mail ou senha inválidos" (melhor para segurança)?
   *Decisão atual: manter mensagens distintas (requisito do estudo).*
2. **HU-03 — Limite de atividades.** Hoje não há limite: o usuário pode clicar
   quantas vezes quiser e ganhar pontos infinitos. Deveria haver limite (ex.: por dia)?
3. **HU-01 — Força da senha.** Basta o mínimo de 6 caracteres, ou deveria exigir
   letras e números?
