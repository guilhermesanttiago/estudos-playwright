Feature: Login
  Como um usuário cadastrado
  Eu quero entrar na aplicação com meu e-mail e senha
  De modo que eu tenha acesso aos meus pontos de forma segura

  Background:
    Given que existe uma conta com nome "Eva Rocha", e-mail "eva@teste.com" e senha "senha123"
    And que estou na tela de login

  # HU-02 / CA-01
  Scenario: Entrar com e-mail e senha corretos
    When faço login com e-mail "eva@teste.com" e senha "senha123"
    Then sou levado para o painel
    And vejo a saudação "Olá, Eva Rocha!"

  # HU-02 / CA-02
  Scenario: Entrar digitando o e-mail com letras maiúsculas
    When faço login com e-mail "EVA@Teste.com" e senha "senha123"
    Then sou levado para o painel

  # HU-02 / CA-02
  Scenario: Não entrar com a senha escrita em maiúsculas
    When faço login com e-mail "eva@teste.com" e senha "SENHA123"
    Then vejo a mensagem de erro "Senha incorreta."
    And continuo na tela de login

  # HU-02 / CA-03
  Scenario Outline: Não entrar com <campo> vazio
    When faço login com e-mail "<email>" e senha "<senha>"
    Then vejo a mensagem de erro "Informe e-mail e senha."
    And continuo na tela de login

    Examples:
      | campo  | email         | senha    |
      | e-mail |               | senha123 |
      | senha  | eva@teste.com |          |

  # HU-02 / CA-04
  Scenario: Não entrar com senha incorreta
    When faço login com e-mail "eva@teste.com" e senha "errada99"
    Then vejo a mensagem de erro "Senha incorreta."
    And continuo na tela de login

  # HU-02 / CA-05
  Scenario: Não entrar com e-mail sem conta cadastrada
    When faço login com e-mail "ninguem@teste.com" e senha "senha123"
    Then vejo a mensagem de erro "Conta não encontrada."
    And continuo na tela de login

  # HU-02 / CA-06
  Scenario: Sair da aplicação
    Given que fiz login com e-mail "eva@teste.com" e senha "senha123"
    When clico em sair
    Then sou levado para a tela de login

  # HU-02 / CA-06
  Scenario: Não acessar o painel depois de sair
    Given que fiz login com e-mail "eva@teste.com" e senha "senha123"
    And que cliquei em sair
    When acesso o endereço "/painel.html" diretamente
    Then sou levado para a tela de login
