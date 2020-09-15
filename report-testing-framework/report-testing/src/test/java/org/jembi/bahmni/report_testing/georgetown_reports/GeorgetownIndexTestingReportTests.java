package org.jembi.bahmni.report_testing.georgetown_reports;

import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.joda.time.Years;

import static org.junit.Assert.assertEquals;

import java.sql.ResultSet;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
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
        int patientIdContact = testDataGenerator.createPatient(
            "BAH203001", GenderEnum.MALE, new LocalDate(2000, 9, 1), "John", "Malonda", "0123456789", null);
        int patientIdIndex = testDataGenerator.createPatient(
            "BAH203002", GenderEnum.FEMALE, new LocalDate(2004, 1, 15), "Marie", "Tambwe", null, "ART 123");
        testDataGenerator.addRelationshipToPatient(patientIdContact, patientIdIndex, RelationshipEnum.RELATIONSHIP_PARTNER, RelationshipEnum.RELATIONSHIP_PARTNER);

        recordIndexTestingOfferAndAcceptance(patientIdIndex);
        enrollPatientToIndexAndHIVPrograms(patientIdContact);
        recordHivTestDateAndResult(patientIdContact);
        
		// Execute
		String query = readReportQuery(ReportEnum.GEORGETOWN_INDEX_TESTING_REPORT, "georgetownIndexTestingReport.sql", new LocalDate(2020, 9, 1), new LocalDate(2020, 9, 30));
		ResultSet result = getIndicatorResult(query);

        // Assert
		assertEquals(result.getInt("Serial Number"), 1);
		assertEquals(result.getString("Unique Patient ID"), "BAH203001");
		assertEquals(result.getString("Date of Birth"), "2000-09-01");
		assertEquals(result.getInt("Age"), Years.yearsBetween(new LocalDate(2000, 9, 1), LocalDate.now()).getYears());
		assertEquals(result.getString("Sex"), "m");
		assertEquals(result.getString("Relation with index"), "PARTNER");
		assertEquals(result.getString("Notified for Index case testing ?"), "Notification 1");
		assertEquals(result.getString("Date of Notification"), "2020-08-05");
		assertEquals(result.getString("Notification Outcome"), "Accepted Testing");
		assertEquals(result.getString("Contact telephone"), "0123456789");
		assertEquals(result.getString("Tested for HIV ?"), "Yes");
		assertEquals(result.getString("HIV Test Date"), "2020-08-15");
		assertEquals(result.getString("Test results"), "Positive");
		assertEquals(result.getString("Date of Initiation"), "2020-08-09");
		assertEquals(result.getString("Index Related ART Code"), "ART 123");
		assertEquals(result.getString("Index Related Unique ID"), "BAH203002");
    }

    @Test
    public void shouldNotDisplayReportRecordWhenPatientIsNotAContact() throws Exception {
        // Prepare
        int patientIdContact = testDataGenerator.createPatient(
            "BAH203001", GenderEnum.MALE, new LocalDate(2000, 9, 1), "John", "Malonda", "0123456789", null);
        int patientIdIndex = testDataGenerator.createPatient(
            "BAH203002", GenderEnum.FEMALE, new LocalDate(2004, 1, 15), "Marie", "Tambwe", null, "ART 123");

        recordIndexTestingOfferAndAcceptance(patientIdIndex);
        enrollPatientToIndexAndHIVPrograms(patientIdContact);
        recordHivTestDateAndResult(patientIdContact);
        
		// Execute
		String query = readReportQuery(ReportEnum.GEORGETOWN_INDEX_TESTING_REPORT, "georgetownIndexTestingReport.sql", new LocalDate(2020, 9, 1), new LocalDate(2020, 9, 30));
		int result = getNumberRecords(query);

        // Assert
		assertEquals(result, 0);
    }

    @Test
    public void shouldDisplayReportRecordWithoutHivTestInformationWhenHIVResultIsNotAvailable() throws Exception {
        // Prepare
        int patientIdContact = testDataGenerator.createPatient(
            "BAH203001", GenderEnum.MALE, new LocalDate(2000, 9, 1), "John", "Malonda", "0123456789", null);
        int patientIdIndex = testDataGenerator.createPatient(
            "BAH203002", GenderEnum.FEMALE, new LocalDate(2004, 1, 15), "Marie", "Tambwe", null, "ART 123");
        testDataGenerator.addRelationshipToPatient(patientIdContact, patientIdIndex, RelationshipEnum.RELATIONSHIP_PARTNER, RelationshipEnum.RELATIONSHIP_PARTNER);

        recordIndexTestingOfferAndAcceptance(patientIdIndex);
        enrollPatientToIndexAndHIVPrograms(patientIdContact);
        // recordHivTestDateAndResult(patientIdContact);
        
		// Execute
		String query = readReportQuery(ReportEnum.GEORGETOWN_INDEX_TESTING_REPORT, "georgetownIndexTestingReport.sql", new LocalDate(2020, 9, 1), new LocalDate(2020, 9, 30));
		ResultSet result = getIndicatorResult(query);

        // Assert
		assertEquals(result.getInt("Serial Number"), 1);
		assertEquals(result.getString("Unique Patient ID"), "BAH203001");
		assertEquals(result.getString("Date of Birth"), "2000-09-01");
		assertEquals(result.getInt("Age"), Years.yearsBetween(new LocalDate(2000, 9, 1), LocalDate.now()).getYears());
		assertEquals(result.getString("Sex"), "m");
		assertEquals(result.getString("Relation with index"), "PARTNER");
		assertEquals(result.getString("Notified for Index case testing ?"), "Notification 1");
		assertEquals(result.getString("Date of Notification"), "2020-08-05");
		assertEquals(result.getString("Notification Outcome"), "Accepted Testing");
		assertEquals(result.getString("Contact telephone"), "0123456789");
		assertEquals(result.getString("Tested for HIV ?"), "");
		assertEquals(result.getString("HIV Test Date"), null);
		assertEquals(result.getString("Test results"), null);
		assertEquals(result.getString("Date of Initiation"), "2020-08-09");
		assertEquals(result.getString("Index Related ART Code"), "ART 123");
		assertEquals(result.getString("Index Related Unique ID"), "BAH203002");
    }

    private void recordIndexTestingOfferAndAcceptance(int patientId) throws Exception {
        int encounterId = testDataGenerator.setIndexTestingOffered(patientId, new LocalDateTime(2020, 7, 10, 10,0), null);
        testDataGenerator.setIndexTestingDateOffered(patientId, new LocalDateTime(2020, 7, 10, 10,0),  new LocalDate(2020, 7, 10), encounterId);
        testDataGenerator.setIndexTestingAccepted(patientId, new LocalDateTime(2020, 7, 10, 10,0), encounterId);
        testDataGenerator.setIndexTestingDateAccepted(patientId, new LocalDateTime(2020, 7, 10, 10,0), new LocalDate(2020, 7, 10), encounterId);
    }

    private void enrollPatientToIndexAndHIVPrograms(int patientId) throws Exception {
        testDataGenerator.enrollPatientIntoIndexTestingProgram(
            patientId,
            new LocalDate(2020, 8, 1),
            ConceptEnum.NOTIFICATION_1,
            new LocalDate(2020, 8, 5),
            NotificationOutcomeEnum.ACCPETED_TESTING);

        testDataGenerator.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 8, 7),
            ConceptEnum.WHO_STAGE_1,
            null,
            new LocalDate(2020, 8, 9));
    }

    private void recordHivTestDateAndResult(int patientId) throws Exception {
        int encounterIdHtc = testDataGenerator.setHTCHivTestDate(patientId, new LocalDateTime(2020, 8, 15, 8, 0), new LocalDate(2020, 8, 15), null);
        testDataGenerator.setHTCFinalResult(patientId, new LocalDateTime(2020, 8, 15, 8, 0), ConceptEnum.POSITIVE, encounterIdHtc);
    }
}