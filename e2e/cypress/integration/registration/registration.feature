Feature: Patient Registration

Scenario: All the custom patient identifiers should exist on the registration form
  Given I log in with superman and Admin123
  And I click on registration
  And I click on create new patient
  Then all custom patient identifiers should exist

Scenario Outline: The <identifier> cannot be duplicated
  Given the database has been cleaned
  And I log in with superman and Admin123
  And I create a new 24 years old male patient called Paul Mutombo without saving
  And I capture <id_example> on the <identifier_code> field
  And I save the registration form and return to the dashboard
  And I create a new 35 years old female patient called Sandrine Paku without saving
  And I capture <id_example> on the <identifier_code> field
  And I click on save registration
  Then I should get an error that the identifier <id_example> is already used

  Examples:
    | identifier | identifier_code | id_example |
    |    Nic number |   Nic_number |    123 |
    |    Unique identification NIC |   Unique_identification_NIC |    234 |
    |    TARV number |   TARV_number |    345 |
    |    ANC number |   ANC_number |    456 |
    |    Passport number |   Passport_number |    567 |
    |    Receipt number |   Receipt_number |    678 |
    |    Other number |   Other_number |    789 |
