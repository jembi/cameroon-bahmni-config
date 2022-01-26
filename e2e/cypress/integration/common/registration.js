import { When, Then, Given } from 'cypress-cucumber-preprocessor/steps'

Given('I click on create new patient', () => {
  cy.get('span').contains('Create').click();
});

Given('I create and save a new {word} years old {word} patient called {word} {word}', (age, gender, firstName, familyName) => {
  let _gender = 'F';
  if (gender === 'male') _gender = 'M';
  cy.get('a[id="bahmni.registration"]').click()
    .get('span').contains('Create').click()
    .get('input[id="givenName"]').type(firstName)
    .get('input[id="familyName"]').type(familyName)
    .get('select[id="gender"]').select(_gender)
    .get('input[id="ageYears"]').type(age)
    .get('button').contains('ave').click()
    .visit('/bahmni/home/index.html#/dashboard');
});
