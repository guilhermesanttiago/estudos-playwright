# pontos-qa

Aplicação de pontos (fidelidade) para estudo de QA e Playwright.

## Rodar

Requisito: Node.js 18+. Não há dependências para instalar.

```bash
npm start
```

Abra http://localhost:3000

## Telas
- `/cadastro.html` — cadastro (nome, e-mail, senha)
- `/index.html` — login
- `/painel.html` — registrar atividade (+10 pontos) e extrato

Os dados ficam em memória: reiniciar o servidor apaga usuários e pontos.

## Documentação de QA
1. [Histórias e critérios de aceite](docs/01-historias-e-criterios.md)
2. [Cenários de teste (Gherkin) e matriz de rastreabilidade](docs/02-cenarios-de-teste.md)
