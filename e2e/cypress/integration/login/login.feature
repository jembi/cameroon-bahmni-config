Feature: EMR login screen

Scenario: All english locations should be available on the login screen
  Given I open the login screen
  Then all the locations should be available on the dropdown

Scenario: All french locations should be available on the login screen
  Given I open the login screen
  When I change the language to French
  Then all the french locations should be available on the dropdown
