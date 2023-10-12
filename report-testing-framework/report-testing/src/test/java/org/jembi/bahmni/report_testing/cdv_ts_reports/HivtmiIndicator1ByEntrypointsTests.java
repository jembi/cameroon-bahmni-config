package org.jembi.bahmni.report_testing.cdv_ts_reports;

import static org.junit.Assert.assertEquals;

import java.util.List;
import java.util.Map;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.jembi.bahmni.report_testing.test_utils.models.TherapeuticLineEnum;
import org.jembi.bahmni.report_testing.test_utils.models.VisitTypeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ReportEnum;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;

import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.junit.Test;

public class HivtmiIndicator1ByEntrypointsTests extends BaseReportTest {
    @Test
    public void shouldCountHivPatientByEntryPoints() throws Exception {
        // register a new patient
        int patientId = testDataGenerator.registration.createPatient(
                GenderEnum.MALE,
                new LocalDate(2000, 9, 1),
                "John",
                "Doe");

        // start a new visit
        int encounterId = testDataGenerator.startVisit(
                patientId,
                new LocalDate(2022, 11, 1),
                VisitTypeEnum.VISIT_TYPE_OPD);

        // enrol patient into hiv program
        testDataGenerator.program.enrollPatientIntoHIVProgram(
                patientId,
                new LocalDate(2022, 11, 3),
                ConceptEnum.WHO_STAGE_1,
                TherapeuticLineEnum.FIRST_LINE,
                new LocalDate(2022, 11, 3));

        // set hiv test date
        testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
                patientId,
                new LocalDateTime(2022, 11, 5, 8, 0),
                new LocalDate(2022, 11, 5),
                encounterId);

        // set hiv final result
        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
                patientId,
                new LocalDateTime(2022, 11, 11, 8, 0),
                ConceptEnum.NEGATIVE,
                encounterId);

        // set entrypoints
        testDataGenerator.hivTestingAndCounsellingForm.recordTestingEntryPointAndModality(
                patientId,
                new LocalDateTime(2022, 11, 11, 8, 0),
                ConceptEnum.VCT,
                encounterId);

        // execute
        String query = readReportQuery(ReportEnum.CDV_TS_REPORT,
                "indicator1_CDV_TS_number_of_people_tested_in_the_month_disaggregation_entry_point.sql",
                new LocalDate(2022, 11, 1),
                new LocalDate(2022, 11, 30));

        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("Title"), "Number of people tested in the month disaggregated by entry point");
        assertEquals(result.get(0).get("Index"), 0);
        assertEquals(result.get(0).get("Emergency"), 0);
        assertEquals(result.get(0).get("CPN / ANC"), 0);
        assertEquals(result.get(0).get("SA/Maternité / Delivery room/Postpartumn"), 0);
        assertEquals(result.get(0).get("VCT"), 1);
        assertEquals(result.get(0).get("Hospitalization"), 0);
        assertEquals(result.get(0).get("Pediatrics"), 0);
        assertEquals(result.get(0).get("Other testing at TB Unit"), 0);
        assertEquals(result.get(0).get("Blood Bank"), 0);
        assertEquals(result.get(0).get("Screening Campaign"), 0);
        assertEquals(result.get(0).get("Other entry Points"), 0);

    }

    @Test
    public void shouldNotCountHivPatientWhenNoEntryPointsIsSelected() throws Exception {
        // register a new patient
        int patientId = testDataGenerator.registration.createPatient(
                GenderEnum.MALE,
                new LocalDate(2000, 9, 1),
                "John",
                "Doe");

        // start a new visit
        int encounterId = testDataGenerator.startVisit(
                patientId,
                new LocalDate(2022, 11, 1),
                VisitTypeEnum.VISIT_TYPE_OPD);

        // enrol patient into hiv program
        testDataGenerator.program.enrollPatientIntoHIVProgram(
                patientId,
                new LocalDate(2022, 11, 3),
                ConceptEnum.WHO_STAGE_1,
                TherapeuticLineEnum.FIRST_LINE,
                new LocalDate(2022, 11, 3));

        // set hiv test date
        testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
                patientId,
                new LocalDateTime(2022, 11, 5, 8, 0),
                new LocalDate(2022, 11, 5),
                encounterId);

        // set hiv final result
        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
                patientId,
                new LocalDateTime(2022, 11, 11, 8, 0),
                ConceptEnum.NEGATIVE,
                encounterId);

        // execute
        String query = readReportQuery(ReportEnum.CDV_TS_REPORT,
                "indicator1_CDV_TS_number_of_people_tested_in_the_month_disaggregation_entry_point.sql",
                new LocalDate(2022, 11, 1),
                new LocalDate(2022, 11, 30));

        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("Title"), "Number of people tested in the month disaggregated by entry point");
        assertEquals(result.get(0).get("Index"), 0);
        assertEquals(result.get(0).get("Emergency"), 0);
        assertEquals(result.get(0).get("CPN / ANC"), 0);
        assertEquals(result.get(0).get("SA/Maternité / Delivery room/Postpartumn"), 0);
        assertEquals(result.get(0).get("VCT"), 0);
        assertEquals(result.get(0).get("Hospitalization"), 0);
        assertEquals(result.get(0).get("Pediatrics"), 0);
        assertEquals(result.get(0).get("Other testing at TB Unit"), 0);
        assertEquals(result.get(0).get("Blood Bank"), 0);
        assertEquals(result.get(0).get("Screening Campaign"), 0);
        assertEquals(result.get(0).get("Other entry Points"), 0);

    }

    @Test
    public void shouldNotCountHivPatientOutsideReportingPeriod() throws Exception {
        // register a new patient
        int patientId = testDataGenerator.registration.createPatient(
                GenderEnum.MALE,
                new LocalDate(2000, 9, 1),
                "John",
                "Doe");

        // start a new visit
        int encounterId = testDataGenerator.startVisit(
                patientId,
                new LocalDate(2022, 11, 1),
                VisitTypeEnum.VISIT_TYPE_OPD);

        // enrol patient into hiv program
        testDataGenerator.program.enrollPatientIntoHIVProgram(
                patientId,
                new LocalDate(2022, 11, 3),
                ConceptEnum.WHO_STAGE_1,
                TherapeuticLineEnum.FIRST_LINE,
                new LocalDate(2022, 11, 3));

        // set hiv test date
        testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
                patientId,
                new LocalDateTime(2022, 11, 5, 8, 0),
                new LocalDate(2022, 11, 5),
                encounterId);

        // set hiv final result
        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
                patientId,
                new LocalDateTime(2022, 11, 11, 8, 0),
                ConceptEnum.NEGATIVE,
                encounterId);

        // set entrypoints
        testDataGenerator.hivTestingAndCounsellingForm.recordTestingEntryPointAndModality(
                patientId,
                new LocalDateTime(2022, 11, 11, 8, 0),
                ConceptEnum.VCT,
                encounterId);

        // execute
        String query = readReportQuery(ReportEnum.CDV_TS_REPORT,
                "indicator1_CDV_TS_number_of_people_tested_in_the_month_disaggregation_entry_point.sql",
                new LocalDate(2023, 01, 1),
                new LocalDate(2023, 01, 31));

        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("Title"), "Number of people tested in the month disaggregated by entry point");
        assertEquals(result.get(0).get("Index"), 0);
        assertEquals(result.get(0).get("Emergency"), 0);
        assertEquals(result.get(0).get("CPN / ANC"), 0);
        assertEquals(result.get(0).get("SA/Maternité / Delivery room/Postpartumn"), 0);
        assertEquals(result.get(0).get("VCT"), 0);
        assertEquals(result.get(0).get("Hospitalization"), 0);
        assertEquals(result.get(0).get("Pediatrics"), 0);
        assertEquals(result.get(0).get("Other testing at TB Unit"), 0);
        assertEquals(result.get(0).get("Blood Bank"), 0);
        assertEquals(result.get(0).get("Screening Campaign"), 0);
        assertEquals(result.get(0).get("Other entry Points"), 0);

    }

    @Test
    public void shouldNotCountHivPatientWhenThereIsNoResult() throws Exception {
        // register a new patient
        int patientId = testDataGenerator.registration.createPatient(
                GenderEnum.MALE,
                new LocalDate(2000, 9, 1),
                "John",
                "Doe");

        // start a new visit
        int encounterId = testDataGenerator.startVisit(
                patientId,
                new LocalDate(2022, 11, 1),
                VisitTypeEnum.VISIT_TYPE_OPD);

        // enrol patient into hiv program
        testDataGenerator.program.enrollPatientIntoHIVProgram(
                patientId,
                new LocalDate(2022, 11, 3),
                ConceptEnum.WHO_STAGE_1,
                TherapeuticLineEnum.FIRST_LINE,
                new LocalDate(2022, 11, 3));

        // set hiv test date
        testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
                patientId,
                new LocalDateTime(2022, 11, 5, 8, 0),
                new LocalDate(2022, 11, 5),
                encounterId);

        // set entrypoints
        testDataGenerator.hivTestingAndCounsellingForm.recordTestingEntryPointAndModality(
                patientId,
                new LocalDateTime(2022, 11, 11, 8, 0),
                ConceptEnum.VCT,
                encounterId);

        // execute
        String query = readReportQuery(ReportEnum.CDV_TS_REPORT,
                "indicator1_CDV_TS_number_of_people_tested_in_the_month_disaggregation_entry_point.sql",
                new LocalDate(2022, 11, 1),
                new LocalDate(2022, 11, 30));

        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("Title"), "Number of people tested in the month disaggregated by entry point");
        assertEquals(result.get(0).get("Index"), 0);
        assertEquals(result.get(0).get("Emergency"), 0);
        assertEquals(result.get(0).get("CPN / ANC"), 0);
        assertEquals(result.get(0).get("SA/Maternité / Delivery room/Postpartumn"), 0);
        assertEquals(result.get(0).get("VCT"), 0);
        assertEquals(result.get(0).get("Hospitalization"), 0);
        assertEquals(result.get(0).get("Pediatrics"), 0);
        assertEquals(result.get(0).get("Other testing at TB Unit"), 0);
        assertEquals(result.get(0).get("Blood Bank"), 0);
        assertEquals(result.get(0).get("Screening Campaign"), 0);
        assertEquals(result.get(0).get("Other entry Points"), 0);

    }
}
