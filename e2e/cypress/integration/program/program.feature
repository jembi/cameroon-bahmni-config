Feature: Registration of patient to a program

Scenario: It should be possible to register a patient to the HIV Program
  Given the database has been cleaned
  And I log in with superman and Admin123
  And I create and save a new 41 years old female patient called Marie Williams
  And I enroll "Williams Marie" into the HIV Program
  Then The patient "Williams Marie" should be registered into the HIV program