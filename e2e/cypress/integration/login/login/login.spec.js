import {  Then } from 'cypress-cucumber-preprocessor/steps'

Then('all the locations should be available on the dropdown', () => {
  cy.get('select[id="location"]')
    .should('contain', 'ANC')
    .should('contain', 'ART Dispensary')
    .should('contain', 'Cardiology')
    .should('contain', 'Community Home')
    .should('contain', 'Community Mobile')
    .should('contain', 'Delivery')
    .should('contain', 'Dentistry')
    .should('contain', 'Emergency')
    .should('contain', 'Family planning')
    .should('contain', 'Gynaecology')
    .should('contain', 'Kinesiology')
    .should('contain', 'Laboratory')
    .should('contain', 'Major Surgery')
    .should('contain', 'Maternity')
    .should('contain', 'Minor Surgery')
    .should('contain', 'Neonatology')
    .should('contain', 'OPD')
    .should('contain', 'Ophthalmology')
    .should('contain', 'Physiotherapy')
    .should('contain', 'Post Natal')
    .should('contain', 'Psychology')
    .should('contain', 'Radiology')
    .should('contain', 'Registration Desk')
    .should('contain', 'Rheumatology');
});

Then('all the french locations should be available on the dropdown', () => {
  cy.get('select[id="location"]')
    .should('contain', 'Cardiologie')
    .should('contain', 'Chirurgie mineure')
    .should('contain', 'Communauté Domicile')
    .should('contain', 'Communauté Mobile')
    .should('contain', 'Consultations Externes')
    .should('contain', 'CPN')
    .should('contain', 'D\'accouchement') // TODO double check this translation
    .should('contain', 'Dentisterie')
    .should('contain', 'Enregistrement')
    .should('contain', 'Grande Chirurgie')
    .should('contain', 'Gynécologie')
    .should('contain', 'Kinésiologie')
    .should('contain', 'Laboratoire')
    .should('contain', 'Maternité')
    .should('contain', 'Neonatologie')
    .should('contain', 'Ophtalmologie')
    .should('contain', 'Physiothérapie')
    .should('contain', 'Physiothérapie') // TODO this is repeated
    .should('contain', 'Planning familial')
    .should('contain', 'Post Natal')
    .should('contain', 'Pédiatrie')
    .should('contain', 'Radiologie')
    .should('contain', 'Rhumatologie')
    .should('contain', 'UPEC Clinique')
    .should('contain', 'UPEC Dispensation')
    .should('contain', 'Urgence');
});

