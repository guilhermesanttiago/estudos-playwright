Feature: Cadastro de usuário
  Como um visitante da aplicação
  Eu quero criar uma conta informando nome, e-mail e senha
  De modo que eu possa acumular pontos no programa de fidelidade

  Background:
    Given que estou na tela de cadastro

  # HU-01 / CA-01
  Scenario: Cadastrar com dados válidos
    When me cadastro com nome "Ana Souza", e-mail "ana@teste.com" e senha "123456"
    Then vejo a mensagem de sucesso "Cadastro realizado com sucesso."
    And sou levado para a tela de login

  # HU-01 / CA-02
  Scenario Outline: Não cadastrar com <campo> vazio
    When me cadastro com nome "<nome>", e-mail "<email>" e senha "<senha>"
    Then vejo a mensagem de erro "Preencha todos os campos."
    And continuo na tela de cadastro

    Examples:
      | campo  | nome     | email         | senha  |
      | nome   |          | bia@teste.com | 123456 |
      | e-mail | Bia Lima |               | 123456 |
      | senha  | Bia Lima | bia@teste.com |        |

  # HU-01 / CA-02
  Scenario: Não cadastrar com nome preenchido apenas com espaços
    When me cadastro com nome "   ", e-mail "bia@teste.com" e senha "123456"
    Then vejo a mensagem de erro "Preencha todos os campos."
    And continuo na tela de cadastro

  # HU-01 / CA-03
  Scenario Outline: Não cadastrar com e-mail em formato inválido: <email>
    When me cadastro com nome "Bia Lima", e-mail "<email>" e senha "123456"
    Then vejo a mensagem de erro "E-mail inválido."
    And continuo na tela de cadastro

    Examples:
      | email              |
      | bia                |
      | bia@               |
      | bia@teste          |
      | @teste.com         |
      | bia lima@teste.com |

  # HU-01 / CA-04 (valor limite: mínimo aceito)
  Scenario: Cadastrar com senha de exatamente 6 caracteres
    When me cadastro com nome "Caio Melo", e-mail "caio@teste.com" e senha "abc123"
    Then vejo a mensagem de sucesso "Cadastro realizado com sucesso."

  # HU-01 / CA-04 (valor limite: um abaixo do mínimo)
  Scenario: Não cadastrar com senha de 5 caracteres
    When me cadastro com nome "Caio Melo", e-mail "caio2@teste.com" e senha "abc12"
    Then vejo a mensagem de erro "A senha deve ter no mínimo 6 caracteres."
    And continuo na tela de cadastro

  # HU-01 / CA-05
  Scenario: Não cadastrar com e-mail já cadastrado
    Given que já existe uma conta com o e-mail "dani@teste.com"
    When me cadastro com nome "Dani Alves", e-mail "dani@teste.com" e senha "123456"
    Then vejo a mensagem de erro "E-mail já cadastrado."
    And continuo na tela de cadastro

  # HU-01 / CA-05
  Scenario: Não cadastrar e-mail já existente escrito com outras maiúsculas e minúsculas
    Given que já existe uma conta com o e-mail "dani@teste.com"
    When me cadastro com nome "Dani Alves", e-mail "DANI@Teste.com" e senha "123456"
    Then vejo a mensagem de erro "E-mail já cadastrado."
    And continuo na tela de cadastro

  # HU-01 / CA-06
  Scenario: Não criar conta quando o cadastro falha
    Given que tentei me cadastrar com nome "Davi Reis", e-mail "davi@teste.com" e senha "12345" e recebi um erro
    When faço login com e-mail "davi@teste.com" e senha "12345"
    Then vejo a mensagem de erro "Conta não encontrada."
