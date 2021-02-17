package org.jembi.bahmni.report_testing.georgetown_reports;

import static org.junit.Assert.assertEquals;

import java.util.List;
import java.util.Map;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ReportEnum;
import org.jembi.bahmni.report_testing.test_utils.models.TherapeuticLineEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.joda.time.Years;
import org.junit.Test;

public class GeorgetownTestingReportTests extends BaseReportTest {
    @Test
    public void patientWhoTestedForHiv_shouldBeReported() throws Exception {
        // Prepare
        /* record patient information */
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            null
        );

        testDataGenerator.registration.recordPersonAddress(
            patientId,
            "14 BAMBI STR", // address1
            "ATALA", // address2
            "WANGI", // address3
            "PAKONI", // address4
            "NKUM", // city_village
            "NORD-OUEST", // state_province
            "BUI", // country_district
            "CAMEROON");
        
        /* record pre-test counseling */
        int encounterId = testDataGenerator.hivTestingAndCounsellingForm.recordPreTestCounseling(
            patientId,
            new LocalDateTime(2020,01,01,8,0),
            ConceptEnum.TRUE,
            null);
        
        /* record hiv test date and result */
        testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            new LocalDate(2020, 1, 2),
            encounterId);
        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            ConceptEnum.POSITIVE,
            encounterId);

        /* enroll into the HIV program, including reason for consultation */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 3),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            new LocalDate(2020, 1, 4)
        );

        /* record reason for not starting a treatment */
        testDataGenerator.hivTestingAndCounsellingForm.recordHTCResult(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.POSITIVE,
            encounterId);
        
        testDataGenerator.hivTestingAndCounsellingForm.recordStartTreatment(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.NO,
            encounterId);

        testDataGenerator.hivTestingAndCounsellingForm.recordReasonForNotStartingATreatment(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.PATIENT_REFUSED,
            encounterId);

        /* record testing entry point and modality */
        testDataGenerator.hivTestingAndCounsellingForm.recordTestingEntryPointAndModality(
            patientId,
            new LocalDateTime(2020, 1, 5, 8, 0),
            ConceptEnum.OPERATIVE_NOTES_EMERGENCY,
            encounterId);

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_TESTING_REPORT, "georgetownTestingReport.sql",
                new LocalDate(2020, 1, 1), new LocalDate(2020, 1, 31));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.size(), 1);
        assertEquals(result.get(0).get("serialNumber"), "1");
        assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
        assertEquals(result.get(0).get("healthFacility"), "CENTRE");
        assertEquals(result.get(0).get("telOfClient"), "081234567");
        assertEquals(result.get(0).get("clientsAddress"), "14 BAMBI STR, NKUM");
        assertEquals(result.get(0).get("age"), Years.yearsBetween(new LocalDate(2000, 01, 15), LocalDate.now()).getYears() + "");
        assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
        assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("hivScreeningTool"), "Yes");
        assertEquals(result.get(0).get("eligibleForTesting"), "Yes");
        assertEquals(result.get(0).get("dateOfHivTesting"), "2020-01-02");
        assertEquals(result.get(0).get("result"), "Positive");
        assertEquals(result.get(0).get("dateOfArtInitiation"), "2020-01-04");
        assertEquals(result.get(0).get("reasonOfNonInitiation"), "Patient refused");
        assertEquals(result.get(0).get("facilityEntryPoint"), "Emergency");
        assertEquals(result.get(0).get("dateFinalResultProvidedToPatient"), "2020-01-02");
    }

    @Test
    public void patientWhoTestedForHivAtANCVisit_shouldBeReported() throws Exception {
        // Prepare
        /* record patient information */
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            null
        );

        testDataGenerator.registration.recordPersonAddress(
            patientId,
            "14 BAMBI STR", // address1
            "ATALA", // address2
            "WANGI", // address3
            "PAKONI", // address4
            "NKUM", // city_village
            "NORD-OUEST", // state_province
            "BUI", // country_district
            "CAMEROON");
        
        /* record pre-test counseling */
        int encounterId = testDataGenerator.hivTestingAndCounsellingForm.recordPreTestCounseling(
            patientId,
            new LocalDateTime(2020,01,01,8,0),
            ConceptEnum.TRUE,
            null);
        
        /* record hiv test date and result */
        testDataGenerator.ancInitialForm.recordAtAncEnrolmentHivTestDateAndResult(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            new LocalDate(2020, 1, 2),
            ConceptEnum.POSITIVE,
            encounterId);

        /* enroll into the HIV program, including reason for consultation */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 3),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            new LocalDate(2020, 1, 4)
        );

        /* record reason for not starting a treatment */
        testDataGenerator.hivTestingAndCounsellingForm.recordHTCResult(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.POSITIVE,
            encounterId);
        
        testDataGenerator.hivTestingAndCounsellingForm.recordStartTreatment(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.NO,
            encounterId);

        testDataGenerator.hivTestingAndCounsellingForm.recordReasonForNotStartingATreatment(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.PATIENT_REFUSED,
            encounterId);

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_TESTING_REPORT, "georgetownTestingReport.sql",
                new LocalDate(2020, 1, 1), new LocalDate(2020, 1, 31));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.size(), 1);
        assertEquals(result.get(0).get("serialNumber"), "1");
        assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
        assertEquals(result.get(0).get("healthFacility"), "CENTRE");
        assertEquals(result.get(0).get("telOfClient"), "081234567");
        assertEquals(result.get(0).get("clientsAddress"), "14 BAMBI STR, NKUM");
        assertEquals(result.get(0).get("age"), Years.yearsBetween(new LocalDate(2000, 01, 15), LocalDate.now()).getYears() + "");
        assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
        assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("hivScreeningTool"), "Yes");
        assertEquals(result.get(0).get("eligibleForTesting"), "Yes");
        assertEquals(result.get(0).get("dateOfHivTesting"), "2020-01-02");
        assertEquals(result.get(0).get("result"), "Positive");
        assertEquals(result.get(0).get("dateOfArtInitiation"), "2020-01-04");
        assertEquals(result.get(0).get("reasonOfNonInitiation"), "Patient refused");
        assertEquals(result.get(0).get("facilityEntryPoint"), "PMTCT [ANC1-only]");
        assertEquals(result.get(0).get("dateFinalResultProvidedToPatient"), "2020-01-02");
    }

    @Test
    public void patientWithNoPreTestCounselingAndNotEligibleForHivTesting_shouldBeReported() throws Exception {
        // Prepare
        /* record patient information  */
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            null
        );

        testDataGenerator.registration.recordPersonAddress(
            patientId,
            "14 BAMBI STR", // address1
            "ATALA", // address2
            "WANGI", // address3
            "PAKONI", // address4
            "NKUM", // city_village
            "NORD-OUEST", // state_province
            "BUI", // country_district
            "CAMEROON");
        
        /* record hiv test date and result */
        int encounterId = testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            new LocalDate(2020, 1, 2),
            null);
        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            ConceptEnum.POSITIVE,
            encounterId);

        /* enroll into the HIV program, including reason for consultation */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 3),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            new LocalDate(2020, 1, 4)
        );

        /* record reason for not starting a treatment */
        testDataGenerator.hivTestingAndCounsellingForm.recordHTCResult(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.POSITIVE,
            encounterId);
        
        testDataGenerator.hivTestingAndCounsellingForm.recordStartTreatment(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.NO,
            encounterId);

        testDataGenerator.hivTestingAndCounsellingForm.recordReasonForNotStartingATreatment(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.PATIENT_REFUSED,
            encounterId);

        /* record testing entry point and modality */
        testDataGenerator.hivTestingAndCounsellingForm.recordTestingEntryPointAndModality(
            patientId,
            new LocalDateTime(2020, 1, 5, 8, 0),
            ConceptEnum.OPERATIVE_NOTES_EMERGENCY,
            encounterId);

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_TESTING_REPORT, "georgetownTestingReport.sql",
                new LocalDate(2020, 1, 1), new LocalDate(2020, 1, 31));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.size(), 1);
        assertEquals(result.get(0).get("serialNumber"), "1");
        assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
        assertEquals(result.get(0).get("healthFacility"), "CENTRE");
        assertEquals(result.get(0).get("telOfClient"), "081234567");
        assertEquals(result.get(0).get("clientsAddress"), "14 BAMBI STR, NKUM");
        assertEquals(result.get(0).get("age"), Years.yearsBetween(new LocalDate(2000, 01, 15), LocalDate.now()).getYears() + "");
        assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
        assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("hivScreeningTool"), "No");
        assertEquals(result.get(0).get("eligibleForTesting"), "No");
        assertEquals(result.get(0).get("dateOfHivTesting"), "2020-01-02");
        assertEquals(result.get(0).get("result"), "Positive");
        assertEquals(result.get(0).get("dateOfArtInitiation"), "2020-01-04");
        assertEquals(result.get(0).get("reasonOfNonInitiation"), "Patient refused");
        assertEquals(result.get(0).get("facilityEntryPoint"), "Emergency");
        assertEquals(result.get(0).get("dateFinalResultProvidedToPatient"), "2020-01-02");
    }

    @Test
    public void patientWhoTestedForHivAndIsPregnant_shouldBeReported() throws Exception {
        // Prepare
        /* record patient information */
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            null
        );

        testDataGenerator.registration.recordPersonAddress(
            patientId,
            "14 BAMBI STR", // address1
            "ATALA", // address2
            "WANGI", // address3
            "PAKONI", // address4
            "NKUM", // city_village
            "NORD-OUEST", // state_province
            "BUI", // country_district
            "CAMEROON");
        
        /* record hiv test date and result */
        int encounterId = testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            new LocalDate(2020, 1, 2),
            null);
        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            ConceptEnum.POSITIVE,
            encounterId);

        /* enroll into the HIV program, including reason for consultation */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 3),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            new LocalDate(2020, 1, 4)
        );

        /* record reason for not starting a treatment */
        testDataGenerator.hivTestingAndCounsellingForm.recordHTCResult(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.POSITIVE,
            encounterId);
        
        testDataGenerator.hivTestingAndCounsellingForm.recordStartTreatment(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.NO,
            encounterId);

        testDataGenerator.hivTestingAndCounsellingForm.recordReasonForNotStartingATreatment(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.PATIENT_REFUSED,
            encounterId);

        /* record testing entry point and modality */
        testDataGenerator.hivTestingAndCounsellingForm.recordTestingEntryPointAndModality(
            patientId,
            new LocalDateTime(2020, 1, 5, 8, 0),
            ConceptEnum.OPERATIVE_NOTES_EMERGENCY,
            encounterId);

        /* record pregnancy */
        testDataGenerator.hivTestingAndCounsellingForm.recordPregnancy(
            patientId,
            new LocalDateTime(2020, 1, 6, 8, 0),
            ConceptEnum.YES,
            encounterId);

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_TESTING_REPORT, "georgetownTestingReport.sql",
                new LocalDate(2020, 1, 1), new LocalDate(2020, 1, 31));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.size(), 1);
        assertEquals(result.get(0).get("serialNumber"), "1");
        assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
        assertEquals(result.get(0).get("healthFacility"), "CENTRE");
        assertEquals(result.get(0).get("telOfClient"), "081234567");
        assertEquals(result.get(0).get("clientsAddress"), "14 BAMBI STR, NKUM");
        assertEquals(result.get(0).get("age"), Years.yearsBetween(new LocalDate(2000, 01, 15), LocalDate.now()).getYears() + "");
        assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
        assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("hivScreeningTool"), "No");
        assertEquals(result.get(0).get("eligibleForTesting"), "Yes");
        assertEquals(result.get(0).get("dateOfHivTesting"), "2020-01-02");
        assertEquals(result.get(0).get("result"), "Positive");
        assertEquals(result.get(0).get("dateOfArtInitiation"), "2020-01-04");
        assertEquals(result.get(0).get("reasonOfNonInitiation"), "Patient refused");
        assertEquals(result.get(0).get("facilityEntryPoint"), "Emergency");
        assertEquals(result.get(0).get("dateFinalResultProvidedToPatient"), "2020-01-02");
    }

    @Test
    public void patientWithinRiskGroup_shouldBeReported() throws Exception {
        // Prepare
        /* record patient information */
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            null
        );

        testDataGenerator.registration.recordPersonAddress(
            patientId,
            "14 BAMBI STR", // address1
            "ATALA", // address2
            "WANGI", // address3
            "PAKONI", // address4
            "NKUM", // city_village
            "NORD-OUEST", // state_province
            "BUI", // country_district
            "CAMEROON");
        
        /* record hiv test date and result */
        int encounterId = testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            new LocalDate(2020, 1, 2),
            null);
        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            ConceptEnum.POSITIVE,
            encounterId);

        /* enroll into the HIV program, including reason for consultation */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 3),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            new LocalDate(2020, 1, 4)
        );

        /* record reason for not starting a treatment */
        testDataGenerator.hivTestingAndCounsellingForm.recordHTCResult(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.POSITIVE,
            encounterId);
        
        testDataGenerator.hivTestingAndCounsellingForm.recordStartTreatment(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.NO,
            encounterId);

        testDataGenerator.hivTestingAndCounsellingForm.recordReasonForNotStartingATreatment(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.PATIENT_REFUSED,
            encounterId);

        /* record testing entry point and modality */
        testDataGenerator.hivTestingAndCounsellingForm.recordTestingEntryPointAndModality(
            patientId,
            new LocalDateTime(2020, 1, 5, 8, 0),
            ConceptEnum.OPERATIVE_NOTES_EMERGENCY,
            encounterId);

        /* record risk group */
        testDataGenerator.hivTestingAndCounsellingForm.recordRiskGroup(
            patientId,
            new LocalDateTime(2020, 1, 6, 8, 0),
            ConceptEnum.SEX_WORKER,
            encounterId);

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_TESTING_REPORT, "georgetownTestingReport.sql",
                new LocalDate(2020, 1, 1), new LocalDate(2020, 1, 31));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.size(), 1);
        assertEquals(result.get(0).get("serialNumber"), "1");
        assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
        assertEquals(result.get(0).get("healthFacility"), "CENTRE");
        assertEquals(result.get(0).get("telOfClient"), "081234567");
        assertEquals(result.get(0).get("clientsAddress"), "14 BAMBI STR, NKUM");
        assertEquals(result.get(0).get("age"), Years.yearsBetween(new LocalDate(2000, 01, 15), LocalDate.now()).getYears() + "");
        assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
        assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("hivScreeningTool"), "No");
        assertEquals(result.get(0).get("eligibleForTesting"), "Yes");
        assertEquals(result.get(0).get("dateOfHivTesting"), "2020-01-02");
        assertEquals(result.get(0).get("result"), "Positive");
        assertEquals(result.get(0).get("dateOfArtInitiation"), "2020-01-04");
        assertEquals(result.get(0).get("reasonOfNonInitiation"), "Patient refused");
        assertEquals(result.get(0).get("facilityEntryPoint"), "Emergency");
        assertEquals(result.get(0).get("dateFinalResultProvidedToPatient"), "2020-01-02");
    }

    @Test
    public void patientWithNoHivTest_shouldNOTBeReported() throws Exception {
        // Prepare
        /* record patient information */
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            null
        );

        testDataGenerator.registration.recordPersonAddress(
            patientId,
            "14 BAMBI STR", // address1
            "ATALA", // address2
            "WANGI", // address3
            "PAKONI", // address4
            "NKUM", // city_village
            "NORD-OUEST", // state_province
            "BUI", // country_district
            "CAMEROON");
        
        /* enroll into the HIV program, including reason for consultation */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 3),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            new LocalDate(2020, 1, 4)
        );

        /* record reason for not starting a treatment */
        int encounterId = testDataGenerator.hivTestingAndCounsellingForm.recordHTCResult(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.POSITIVE,
            null);
        
        testDataGenerator.hivTestingAndCounsellingForm.recordStartTreatment(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.NO,
            encounterId);

        testDataGenerator.hivTestingAndCounsellingForm.recordReasonForNotStartingATreatment(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.PATIENT_REFUSED,
            encounterId);

        /* record testing entry point and modality */
        testDataGenerator.hivTestingAndCounsellingForm.recordTestingEntryPointAndModality(
            patientId,
            new LocalDateTime(2020, 1, 5, 8, 0),
            ConceptEnum.OPERATIVE_NOTES_EMERGENCY,
            encounterId);

        /* record risk group */
        testDataGenerator.hivTestingAndCounsellingForm.recordRiskGroup(
            patientId,
            new LocalDateTime(2020, 1, 6, 8, 0),
            ConceptEnum.SEX_WORKER,
            encounterId);

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_TESTING_REPORT, "georgetownTestingReport.sql",
                new LocalDate(2020, 1, 1), new LocalDate(2020, 1, 31));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.size(), 0);
    }

    @Test
    public void patientWithNoEntryPoint_shouldBeReported() throws Exception {
        // Prepare
        /* record patient information */
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            null
        );

        testDataGenerator.registration.recordPersonAddress(
            patientId,
            "14 BAMBI STR", // address1
            "ATALA", // address2
            "WANGI", // address3
            "PAKONI", // address4
            "NKUM", // city_village
            "NORD-OUEST", // state_province
            "BUI", // country_district
            "CAMEROON");
        
        /* record pre-test counseling */
        int encounterId = testDataGenerator.hivTestingAndCounsellingForm.recordPreTestCounseling(
            patientId,
            new LocalDateTime(2020,01,01,8,0),
            ConceptEnum.TRUE,
            null);
        
        /* record hiv test date and result */
        testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            new LocalDate(2020, 1, 2),
            encounterId);
        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            ConceptEnum.POSITIVE,
            encounterId);

        /* enroll into the HIV program, including reason for consultation */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 3),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            new LocalDate(2020, 1, 4)
        );

        /* record reason for not starting a treatment */
        testDataGenerator.hivTestingAndCounsellingForm.recordHTCResult(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.POSITIVE,
            encounterId);
        
        testDataGenerator.hivTestingAndCounsellingForm.recordStartTreatment(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.NO,
            encounterId);

        testDataGenerator.hivTestingAndCounsellingForm.recordReasonForNotStartingATreatment(
            patientId,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.PATIENT_REFUSED,
            encounterId);

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_TESTING_REPORT, "georgetownTestingReport.sql",
                new LocalDate(2020, 1, 1), new LocalDate(2020, 1, 31));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.size(), 1);
        assertEquals(result.get(0).get("serialNumber"), "1");
        assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
        assertEquals(result.get(0).get("healthFacility"), "CENTRE");
        assertEquals(result.get(0).get("telOfClient"), "081234567");
        assertEquals(result.get(0).get("clientsAddress"), "14 BAMBI STR, NKUM");
        assertEquals(result.get(0).get("age"), Years.yearsBetween(new LocalDate(2000, 01, 15), LocalDate.now()).getYears() + "");
        assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
        assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("hivScreeningTool"), "Yes");
        assertEquals(result.get(0).get("eligibleForTesting"), "Yes");
        assertEquals(result.get(0).get("dateOfHivTesting"), "2020-01-02");
        assertEquals(result.get(0).get("result"), "Positive");
        assertEquals(result.get(0).get("dateOfArtInitiation"), "2020-01-04");
        assertEquals(result.get(0).get("reasonOfNonInitiation"), "Patient refused");
        assertEquals(result.get(0).get("facilityEntryPoint"), null);
        assertEquals(result.get(0).get("dateFinalResultProvidedToPatient"), "2020-01-02");
    }

}
