import { When, Then, Given } from 'cypress-cucumber-preprocessor/steps'

Given('I open the login screen', () => {
  cy.visit('/bahmni/home/index.html#/login');
});

When('I change the language to French', () => {
  cy.get('select[id="locale"]').select('Français');
});
