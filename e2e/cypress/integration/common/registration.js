import { When, Then, Given } from 'cypress-cucumber-preprocessor/steps'

Given('I click on create new patient', () => {
  cy.get('span').contains('Create').click();
});
