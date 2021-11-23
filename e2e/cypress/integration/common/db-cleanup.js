import { When, Then, Given } from 'cypress-cucumber-preprocessor/steps'

Given('the database has been cleaned', () => {
    cy.request('http://192.168.33.11:3000/cleanup').its('body').should('contain', 'done');
})
