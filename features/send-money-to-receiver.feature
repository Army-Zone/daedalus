Feature: Send Money to Receiver

  Background:
    Given I have selected English language
    And I have accepted "Terms of use"
    And I agree to send logs to remote server
    And I have the following wallets:
      | name   |
      | first  |

  Scenario: User Sends Money to Receiver
    Given I have a wallet with funds
    And I am on the "Genesis wallet" wallet "send" screen
    When I fill out the send form with a transaction to "first" wallet:
      | amount   |
      | 0.000010 |
    And the transaction fees are calculated
    And I submit the wallet send form
    Then I should be on the "Genesis wallet" wallet "summary" screen
    And the latest transaction should show:
      | title                      | amountWithoutFees |
      | wallet.transaction.adaSent | -0.000010         |
    And the balance of "first" wallet should be:
      | balance  |
      | 0.000010 |

  Scenario: User Sends Money from wallet with spending password to Receiver
    Given I have a wallet with funds and password
    And I am on the "Genesis wallet" wallet "send" screen
    When I fill out the send form with a transaction to "first" wallet:
      | amount   |  walletPassword |
      | 0.000010 |  Secret123      |
    And the transaction fees are calculated
    And I submit the wallet send form
    Then I should be on the "Genesis wallet" wallet "summary" screen
    And the latest transaction should show:
      | title                      | amountWithoutFees |
      | wallet.transaction.adaSent | -0.000010         |
    And the balance of "first" wallet should be:
      | balance  |
      | 0.000010 |

  Scenario: User Enters Wrong Receiver Address
    Given I am on the "first" wallet "send" screen
    When I fill out the wallet send form with:
      | address | amount    |
      | invalid | 0.000010  |
    Then I should see the following error messages on the wallet send form:
      | message                                |
      | wallet.send.form.errors.invalidAddress |

  Scenario Outline: User Enters Wrong Amount
    Given I am on the "first" wallet "send" screen
    When I fill out the send form with a transaction to "first" wallet:
      | title          | amount         |
      | my transaction | <WRONG_AMOUNT> |
    Then I should see the following error messages on the wallet send form:
      | message                               |
      | wallet.send.form.errors.invalidAmount |

    Examples:
      | WRONG_AMOUNT |
      | 45000000001  |
      | 0            |
