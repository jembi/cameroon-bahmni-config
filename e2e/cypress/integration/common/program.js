import { When, Then, Given } from 'cypress-cucumber-preprocessor/steps'

Given('I enroll {string} into the HIV Program', (patientFullName) => {
    cy.get('a[id="bahmni.programs"]').click()
      .get('a').contains('All').click()
      .get('input[id="patientIdentifier"]').type(patientFullName)
      .get('button').contains('Search').click()
      .get('a[class="section-title ng-binding ng-isolate-scope active"]').contains('New Program Enrollment').click()
      .get('select').select('HIV Program')
      .get('select[ng-model="$parent.workflowStateSelected"]').select('WHO stage 1')
      .get('input[ng-model="programEnrollmentDate"]').type('2022-01-01')
      .get('input[value="Enroll"]').click()
      .visit('/bahmni/home/index.html#/dashboard');
  });

Then('The patient {string} should be registered into the HIV program', (patientFullName) => {
    cy.get('a[id="bahmni.programs"]').click()
      .get('a').contains('All').click()
      .get('input[id="patientIdentifier"]').type(patientFullName)
      .get('button').contains('Search').click()
      .get('section[class="active-program-tiles program-tiles ng-scope"]').should('contain', 'HIV Program')
  });
  