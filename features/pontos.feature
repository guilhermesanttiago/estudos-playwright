Feature: Registrar atividade e consultar extrato
  Como um usuário logado
  Eu quero registrar minhas atividades e consultar o extrato dos pontos ganhos
  De modo que eu acompanhe quantos pontos acumulei e de onde eles vieram

  # HU-03 / CA-01
  Scenario: Exibir saldo zero e extrato vazio para usuário sem atividades
    Given que estou logado com uma conta sem atividades registradas
    Then vejo o saldo de 0 pontos
    And vejo no extrato a mensagem "Nenhum ponto ganho ainda."

  # HU-03 / CA-02
  Scenario: Registrar uma atividade
    Given que estou logado com uma conta sem atividades registradas
    When registro uma atividade
    Then vejo a mensagem de sucesso "Atividade registrada! +10 pontos."
    And vejo o saldo de 10 pontos sem recarregar a página

  # HU-03 / CA-03
  Scenario: Somar 10 pontos ao saldo a cada nova atividade
    Given que estou logado com uma conta que já registrou 2 atividades
    When registro uma atividade
    Then vejo o saldo de 30 pontos

  # HU-03 / CA-04
  Scenario: Exibir no extrato o item da atividade registrada
    Given que estou logado com uma conta sem atividades registradas
    When registro uma atividade
    Then vejo 1 item no extrato
    And o item exibe a descrição "Atividade registrada", a data e hora do registro e os pontos "+10"

  # HU-03 / CA-05
  Scenario: Ordenar o extrato do mais recente para o mais antigo
    Given que estou logado com uma conta sem atividades registradas
    When registro 3 atividades com alguns segundos de intervalo entre elas
    Then os itens do extrato aparecem do mais recente para o mais antigo, pela data e hora

  # HU-03 / CA-06
  Scenario: Exibir saldo igual à soma dos itens do extrato
    Given que estou logado com uma conta que já registrou 3 atividades
    Then a soma dos pontos dos itens do extrato é igual ao saldo exibido

  # HU-03 / CA-07
  Scenario: Não exibir pontos de outro usuário
    Given que outro usuário registrou 2 atividades na conta dele
    And que estou logado com uma conta sem atividades registradas
    Then vejo o saldo de 0 pontos
    And vejo no extrato a mensagem "Nenhum ponto ganho ainda."

  # HU-03 / CA-08
  Scenario: Manter os pontos depois de sair e entrar novamente
    Given que estou logado com uma conta que já registrou 2 atividades
    When saio e faço login novamente com a mesma conta
    Then vejo o saldo de 20 pontos
    And vejo 2 itens no extrato

  # HU-03 / CA-09
  Scenario: Redirecionar para o login ao acessar o painel sem estar logado
    Given que não estou logado
    When acesso o endereço "/painel.html" diretamente
    Then sou levado para a tela de login
