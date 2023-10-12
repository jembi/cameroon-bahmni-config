package org.jembi.bahmni.report_testing.test_utils;

import java.sql.Statement;

import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;
import org.jembi.bahmni.report_testing.test_utils.models.PatientIdenfierTypeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.RelationshipEnum;
import org.joda.time.LocalDate;

public class RegistrationTestDataGenerator {
    Statement stmt;

    public RegistrationTestDataGenerator(Statement stmt) {
        this.stmt = stmt;
    }

    public int createPerson(GenderEnum gender, LocalDate dateOfBirth, String firstName, String familyName) throws Exception {
        String uuid = TestDataGenerator.generateUUID();

        String updateQuery = "INSERT INTO person "
                + "(gender, birthdate, birthdate_estimated, dead, date_created, voided, uuid, deathdate_estimated) VALUES"
                + "('" + gender + "', '" + dateOfBirth + "', 0, 0, now(), 0, '" + uuid + "', 0)";

        stmt.executeUpdate(updateQuery);

        int personId = TestDataGenerator.getQueryIntResult( "SELECT person_id FROM person WHERE uuid = '" + uuid + "'", stmt);

        String query = "INSERT INTO person_name (preferred, person_id, given_name, family_name, creator, date_created, voided, uuid) VALUES " +
            "(1," + personId + ",'" + firstName + "','" + familyName + "',4,now(),0,'" + TestDataGenerator.generateUUID() + "')";
        stmt.executeUpdate(query);

        return personId;
    }

    public int createPatient(GenderEnum gender, LocalDate dateOfBirth, String firstName, String familyName) throws Exception {
        int personId = createPerson(gender, dateOfBirth, firstName, familyName);

        String createQuery = "INSERT INTO patient "
                + "(patient_id, creator, date_created, voided, allergy_status) VALUES"
                + "('" + personId + "', 1, now(), 0, '')";

        stmt.executeUpdate(createQuery);

        return personId;
    }

    public int createPatient(String uniqueId, GenderEnum gender, LocalDate dateOfBirth,String firstName, String familyName, String telephone, String artCode) throws Exception {
        int patientId = createPatient(gender, dateOfBirth, firstName, familyName);

        addPatientIdentifier(patientId, PatientIdenfierTypeEnum.BAHMNI_IDENTIFIER, uniqueId, true);

        if (telephone != null) {
            addPersonAttributeTextValue(patientId, "PERSON_ATTRIBUTE_TYPE_PHONE_NUMBER", telephone);
        }

        if (artCode != null) {
            addPatientIdentifier(patientId, PatientIdenfierTypeEnum.ART, artCode, false);
        }

        return patientId;
    }

    public void markPatientAsDead(int patientId, LocalDate deathDate, ConceptEnum causeOfDeath) throws Exception {
        String query = "UPDATE person SET dead = 1, death_date = '" + deathDate + "', cause_of_death = (SELECT concept_id FROM concept WHERE uuid = '" + causeOfDeath + "') WHERE person_id = " + patientId + ";";
        stmt.executeUpdate(query);
    }

    public void addPatientIdentifier(int patientId, PatientIdenfierTypeEnum identifierType, String value, boolean preferred) throws Exception {
        int identifierTypeId = TestDataGenerator.getQueryIntResult("SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = '" + identifierType +"'", stmt);
        String queryPatientIdentifer = "INSERT INTO patient_identifier " +
            "(patient_id, identifier, identifier_type, preferred, location_id, creator, date_created, voided, uuid) VALUES " +
            "(" + patientId + ",'" + value + "'," + identifierTypeId + "," + (preferred ? 1:0) + "," + 18 + ",4,now(),0,'" + TestDataGenerator.generateUUID() + "')";
        stmt.executeUpdate(queryPatientIdentifer);
    }

    public void addRelationshipToPatient(int idPatientA, int idPatientB, RelationshipEnum relPersonAToPersonB, RelationshipEnum relPersonBToPersonA) throws Exception {
        int relationshipTypeId = TestDataGenerator.getQueryIntResult("SELECT relationship_type_id FROM relationship_type WHERE a_is_to_b = '" + relPersonAToPersonB + "'  AND b_is_to_a = '" + relPersonBToPersonA + "'", stmt);
        String query = "INSERT INTO relationship (person_a, relationship, person_b, creator, date_created, voided, uuid) VALUES " +
            "(" + idPatientA +"," + relationshipTypeId + "," + idPatientB + ",4,now(),0,'" + TestDataGenerator.generateUUID() + "')";
        
        stmt.executeUpdate(query);
    }

    public void addPersonAttributeTextValue(int patientId, String personAttributeName, String value) throws Exception {
        int personAttributeId = TestDataGenerator.getQueryIntResult("SELECT person_attribute_type_id FROM person_attribute_type WHERE name = '" + personAttributeName + "'", stmt);
        String queryPersonAttribute = "INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, voided, uuid) VALUES " +
        "(" + patientId + ", '" + value + "'," + personAttributeId + ",4,now(),0,'" + TestDataGenerator.generateUUID() + "')";
        stmt.executeUpdate(queryPersonAttribute);
    }

    public void addPersonAttributeCodedValue(int patientId, String personAttributeName, ConceptEnum value) throws Exception {
        int conceptId = TestDataGenerator.getConceptId(value, stmt);
        int personAttributeId = TestDataGenerator.getQueryIntResult("SELECT person_attribute_type_id FROM person_attribute_type WHERE name = '" + personAttributeName + "'", stmt);
        String queryPersonAttribute = "INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, voided, uuid) VALUES " +
        "(" + patientId + ", '" + conceptId + "'," + personAttributeId + ",4,now(),0,'" + TestDataGenerator.generateUUID() + "')";
        stmt.executeUpdate(queryPersonAttribute);
    }

    public void recordPersonAddress(
        int patientId,
        String address1,
        String address2,
        String address3,
        String address4,
        String cityVillage,
        String stateProvince,
        String countryDistrict,
        String country) throws Exception {
        String query = "INSERT INTO person_address (person_id, preferred, address1, address2, address3, address4, city_village, state_province, county_district, country, creator, date_created, voided, uuid) VALUES "+
            "(" + patientId + ",1,'" + address1 +"','" + address2 + "','" + address3 +"','" + address4 +"','" + cityVillage +"','" + stateProvince +"','" + countryDistrict +"','" + country +"',4,now(),0,'" + TestDataGenerator.generateUUID() +"')";
        stmt.executeUpdate(query);
    }

    public void recordServiceTypeRequested(int patientId, ConceptEnum service, LocalDate visitDate) throws Exception {
        int servicesConceptId = TestDataGenerator.getConceptId(ConceptEnum.SERVICES, stmt);
        int serviceConceptId = TestDataGenerator.getConceptId(service, stmt);
        String query = "INSERT INTO obs (person_id, concept_id, obs_datetime, value_coded, creator, date_created, voided, status, uuid) VALUES " + 
        "(" + patientId + "," + servicesConceptId + ",'" + visitDate + "'," + serviceConceptId + ",4,'" + visitDate + "',0,'FINAL','" + TestDataGenerator.generateUUID() + "')";
        stmt.executeUpdate(query);
    }
}
