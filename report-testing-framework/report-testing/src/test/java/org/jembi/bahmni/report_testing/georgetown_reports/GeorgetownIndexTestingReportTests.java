package org.jembi.bahmni.report_testing.georgetown_reports;

import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.joda.time.Years;

import static org.junit.Assert.assertEquals;

import java.util.List;
import java.util.Map;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
import org.jembi.bahmni.report_testing.test_utils.TestDataGenerator;
import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ReportEnum;
import org.jembi.bahmni.report_testing.test_utils.models.NotificationOutcomeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.RelationshipEnum;
import org.junit.Test;

public class GeorgetownIndexTestingReportTests extends BaseReportTest {
    @Test
    public void shouldDisplayReportRecordWhenHIVResultIsAvailable() throws Exception {
        // Prepare
        int patientIdContact = testDataGenerator.registration.createPatient(
            "BAH203001", GenderEnum.MALE, new LocalDate(2000, 9, 1), "John", "Malonda", "0123456789", null);
        int patientIdIndex = testDataGenerator.registration.createPatient(
            "BAH203002", GenderEnum.FEMALE, new LocalDate(2004, 1, 15), "Marie", "Tambwe", null, "ART 123");
        testDataGenerator.registration.addRelationshipToPatient(patientIdContact, patientIdIndex, RelationshipEnum.RELATIONSHIP_PARTNER, RelationshipEnum.RELATIONSHIP_PARTNER);

        /* record the patient address */
        testDataGenerator.registration.recordPersonAddress(
            patientIdContact,
            "14 BAMBI STR", // address1
            "NKUM", // address2
            "NKUM", // address3
            "NKUM", // address4
            "NKUM", // city_village
            "NORD-OUEST", // state_province
            "BUI", // country_district
            "CAMEROON"); // country
    
        recordIndexTestingOfferAndAcceptance(patientIdIndex);
        int patientProgramId = enrollPatientToIndexAndHIVPrograms(patientIdContact);
        recordHivTestDateAndResult(patientIdContact);

        int conceptId = TestDataGenerator.getConceptId(ConceptEnum.ACCEPTED_TESTING, stmt);

        testDataGenerator.program.recordIndexNotificationDateAndOutcome(patientProgramId, new LocalDate(2020, 8, 5), "Accepted Testing");
        testDataGenerator.program.recordProgramHistoricalData(patientProgramId, 31,  new LocalDateTime(2020, 8, 5, 8, 0), "2020-08-05");
        testDataGenerator.program.recordProgramHistoricalData(patientProgramId, 32, new LocalDateTime(2020, 8, 5, 8, 0), conceptId+"");

		// Execute
		String query = readReportQuery(ReportEnum.GEORGETOWN_INDEX_TESTING_REPORT, "georgetownIndexTestingReport.sql", new LocalDate(2020, 9, 1), new LocalDate(2020, 9, 30));
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
		assertEquals(result.get(0).get("Unique Patient ID"), "BAH203001");
		assertEquals(result.get(0).get("Facility Name"), "CENTRE");
		assertEquals(result.get(0).get("Address"), "NKUM,14 BAMBI STR");
		assertEquals(result.get(0).get("Date of Birth"), "2000-09-01");
		assertEquals(result.get(0).get("Age"), Years.yearsBetween(new LocalDate(2000, 9, 1), LocalDate.now()).getYears() + "");
		assertEquals(result.get(0).get("Sex"), "m");
		assertEquals(result.get(0).get("Relation with index"), "PARTNER");
		assertEquals(result.get(0).get("Notified for Index case testing ?"), "Notification 1");
		assertEquals(result.get(0).get("Date of Notification"), "2020-08-05");
		assertEquals(result.get(0).get("Notification Outcome"), "Accepted Testing");
		assertEquals(result.get(0).get("Contact telephone"), "0123456789");
		assertEquals(result.get(0).get("Tested for HIV ?"), "Yes");
		assertEquals(result.get(0).get("HIV Test Date"), "2020-08-15");
		assertEquals(result.get(0).get("Test results"), "Positive");
		assertEquals(result.get(0).get("Date of Initiation"), "2020-08-09");
		assertEquals(result.get(0).get("Index Related ART Code"), "ART 123");
		assertEquals(result.get(0).get("Index Related Unique ID"), "BAH203002");
    }

    @Test
    public void shouldNotDisplayReportRecordWhenPatientIsNotAContact() throws Exception {
        // Prepare
        int patientIdContact = testDataGenerator.registration.createPatient(
            "BAH203001", GenderEnum.MALE, new LocalDate(2000, 9, 1), "John", "Malonda", "0123456789", null);
        int patientIdIndex = testDataGenerator.registration.createPatient(
            "BAH203002", GenderEnum.FEMALE, new LocalDate(2004, 1, 15), "Marie", "Tambwe", null, "ART 123");

        recordIndexTestingOfferAndAcceptance(patientIdIndex);
        enrollPatientToIndexAndHIVPrograms(patientIdContact);
        recordHivTestDateAndResult(patientIdContact);
        
		// Execute
		String query = readReportQuery(ReportEnum.GEORGETOWN_INDEX_TESTING_REPORT, "georgetownIndexTestingReport.sql", new LocalDate(2020, 9, 1), new LocalDate(2020, 9, 30));
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
		assertEquals(result.size(), 0);
    }

    @Test
    public void shouldNotDisplayReportRecordWhenPatientIsNotEnrolledToIndexTestingAndHasNotTestedForHIV() throws Exception {
        // Prepare
        int patientIdContact = testDataGenerator.registration.createPatient(
            "BAH203001", GenderEnum.MALE, new LocalDate(2000, 9, 1), "John", "Malonda", "0123456789", null);
        int patientIdIndex = testDataGenerator.registration.createPatient(
            "BAH203002", GenderEnum.FEMALE, new LocalDate(2004, 1, 15), "Marie", "Tambwe", null, "ART 123");
            testDataGenerator.registration.addRelationshipToPatient(patientIdContact, patientIdIndex, RelationshipEnum.RELATIONSHIP_PARTNER, RelationshipEnum.RELATIONSHIP_PARTNER);

        recordIndexTestingOfferAndAcceptance(patientIdIndex);
        
		// Execute
		String query = readReportQuery(ReportEnum.GEORGETOWN_INDEX_TESTING_REPORT, "georgetownIndexTestingReport.sql", new LocalDate(2020, 9, 1), new LocalDate(2020, 9, 30));
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
		assertEquals(result.size(), 0);
    }

    @Test
    public void shouldDisplayReportRecordWithoutHivTestInformationWhenHIVResultIsNotAvailable() throws Exception {
        // Prepare
        int patientIdContact = testDataGenerator.registration.createPatient(
            "BAH203001", GenderEnum.MALE, new LocalDate(2000, 9, 1), "John", "Malonda", "0123456789", null);
        int patientIdIndex = testDataGenerator.registration.createPatient(
            "BAH203002", GenderEnum.FEMALE, new LocalDate(2004, 1, 15), "Marie", "Tambwe", null, "ART 123");
        testDataGenerator.registration.addRelationshipToPatient(patientIdContact, patientIdIndex, RelationshipEnum.RELATIONSHIP_PARTNER, RelationshipEnum.RELATIONSHIP_PARTNER);

        recordIndexTestingOfferAndAcceptance(patientIdIndex);
        int patientProgramId = enrollPatientToIndexAndHIVPrograms(patientIdContact);
        
        int conceptId = TestDataGenerator.getConceptId(ConceptEnum.ACCEPTED_TESTING, stmt);
        
        testDataGenerator.program.recordIndexNotificationDateAndOutcome(patientProgramId, new LocalDate(2020, 8, 5), "Accepted Testing");
        testDataGenerator.program.recordProgramHistoricalData(patientProgramId, 31,  new LocalDateTime(2020, 8, 5, 8, 0), "2020-08-05");
        testDataGenerator.program.recordProgramHistoricalData(patientProgramId, 32, new LocalDateTime(2020, 8, 5, 8, 0), conceptId+"");

		// Execute
		String query = readReportQuery(ReportEnum.GEORGETOWN_INDEX_TESTING_REPORT, "georgetownIndexTestingReport.sql", new LocalDate(2020, 9, 1), new LocalDate(2020, 9, 30));
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
		assertEquals(result.get(0).get("Unique Patient ID"), "BAH203001");
		assertEquals(result.get(0).get("Date of Birth"), "2000-09-01");
		assertEquals(result.get(0).get("Age"), Years.yearsBetween(new LocalDate(2000, 9, 1), LocalDate.now()).getYears()+"");
		assertEquals(result.get(0).get("Sex"), "m");
		assertEquals(result.get(0).get("Relation with index"), "PARTNER");
		assertEquals(result.get(0).get("Notified for Index case testing ?"), "Notification 1");
		assertEquals(result.get(0).get("Date of Notification"), "2020-08-05");
		assertEquals(result.get(0).get("Notification Outcome"), "Accepted Testing");
		assertEquals(result.get(0).get("Contact telephone"), "0123456789");
		assertEquals(result.get(0).get("Tested for HIV ?"), "");
		assertEquals(result.get(0).get("HIV Test Date"), null);
		assertEquals(result.get(0).get("Test results"), null);
		assertEquals(result.get(0).get("Date of Initiation"), "2020-08-09");
		assertEquals(result.get(0).get("Index Related ART Code"), "ART 123");
		assertEquals(result.get(0).get("Index Related Unique ID"), "BAH203002");
    }

    private void recordIndexTestingOfferAndAcceptance(int patientId) throws Exception {
        int encounterId = testDataGenerator.hivTestingAndCounsellingForm.setIndexTestingOffered(patientId, new LocalDateTime(2020, 7, 10, 10,0), null);
        testDataGenerator.hivTestingAndCounsellingForm.setIndexTestingDateOffered(patientId, new LocalDateTime(2020, 7, 10, 10,0),  new LocalDate(2020, 7, 10), encounterId);
        testDataGenerator.hivTestingAndCounsellingForm.setIndexTestingAccepted(patientId, new LocalDateTime(2020, 7, 10, 10,0), encounterId);
        testDataGenerator.hivTestingAndCounsellingForm.setIndexTestingDateAccepted(patientId, new LocalDateTime(2020, 7, 10, 10,0), new LocalDate(2020, 7, 10), encounterId);
    }

    private int enrollPatientToIndexAndHIVPrograms(int patientId) throws Exception {
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 8, 7),
            ConceptEnum.WHO_STAGE_1,
            null,
            new LocalDate(2020, 8, 9));

        return testDataGenerator.program.enrollPatientIntoIndexTestingProgram(
            patientId,
            new LocalDate(2020, 9, 1),
            ConceptEnum.NOTIFICATION_1,
            new LocalDate(2020, 9, 5),
            NotificationOutcomeEnum.ACCPETED_TESTING);
    }

    private void recordHivTestDateAndResult(int patientId) throws Exception {
        int encounterIdHtc = testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(patientId, new LocalDateTime(2020, 8, 15, 8, 0), new LocalDate(2020, 8, 15), null);
        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(patientId, new LocalDateTime(2020, 8, 15, 8, 0), ConceptEnum.POSITIVE, encounterIdHtc);
    }
}