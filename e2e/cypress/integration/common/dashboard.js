import { When, Then, Given } from 'cypress-cucumber-preprocessor/steps'

Given('I click on registration', () => {
  cy.get('a[id="bahmni.registration"]').click();
});
