import {  Given, Then } from 'cypress-cucumber-preprocessor/steps'

Then('all custom patient identifiers should exist', () => {
  cy.get('div.field-attribute')
    .should('contain', 'NIC number')
    .should('contain', 'Unique identification NIC')
    .should('contain', 'TARV number')
    .should('contain', 'ANC number')
    .should('contain', 'Passport number')
    .should('contain', 'Receipt number')
    .should('contain', 'Other number');
});

Given('I create a new {word} years old {word} patient called {word} {word} without saving', (age, gender, firstName, familyName) => {
  let _gender = 'F';
  if (gender === 'male') _gender = 'M';
  cy.get('a[id="bahmni.registration"]').click()
    .get('span').contains('Create').click()
    .get('input[id="givenName"]').type(firstName)
    .get('input[id="familyName"]').type(familyName)
    .get('select[id="gender"]').select(_gender)
    .get('input[id="ageYears"]').type(age);
});

Given('I capture {word} on the {word} field', (value, idenifier) => {
  if (idenifier === 'Nic_number') {
    cy.get('input[id="2042b38a-fbee-4d58-812e-496022130419"]')
    .type(value);
  } else if (idenifier === 'Unique_identification_NIC') {
    cy.get('input[id="a9f7dc56-fae1-40e6-9357-06a75a569123"]')
    .type(value);
  } else if (idenifier === 'TARV_number') {
    cy.get('input[id="270d55d3-337d-4a18-ba21-fe521b3f55e3"]')
    .type(value);
  } else if (idenifier === 'ANC_number') {
    cy.get('input[id="d7372b19-2f36-44df-9113-9c483f4410c9"]')
    .type(value);
  } else if (idenifier === 'Passport_number') {
    cy.get('input[id="64e7547a-21b5-4cd1-8607-4d29edccb45a"]')
    .type(value);
  } else if (idenifier === 'Receipt_number') {
    cy.get('input[id="d66a7f67-f559-4ef4-87c8-128de0db22f0"]')
    .type(value);
  } else if (idenifier === 'Other_number') {
    cy.get('input[id="f9870d29-1c19-4bc8-9e42-ca237355c9b8"]')
    .type(value);
  }
});

Given('I save the registration form and return to the dashboard', (value) => {
  cy.get('button').contains('ave').click()
    .visit('/bahmni/home/index.html#/dashboard');
});

Given('I click on save registration', (value) => {
  cy.get('button').contains('ave').click();
});

Then('I should get an error that the identifier {word} is already used', (identifier) => {
  cy.get('div.message-text')
    .should('contain', `Identifier ${identifier} already in use by another patient`);
});