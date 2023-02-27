package org.jembi.bahmni.report_testing.cdv_ts_reports;

import static org.junit.Assert.assertEquals;

import java.util.List;
import java.util.Map;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.jembi.bahmni.report_testing.test_utils.models.VisitTypeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ReportEnum;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;

import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.junit.Test;

public class HivtmiIndicator5Tests extends BaseReportTest {
    @Test
    public void shouldCountPatientWhenHIVResultIsIndeterminate() throws Exception {
        int patientId = testDataGenerator.registration.createPatient(
                GenderEnum.MALE,
                new LocalDate(2000, 9, 1),
                "John",
                "Doe");
        int encounterId = testDataGenerator.startVisit(
                patientId,
                new LocalDate(2022, 11, 1),
                VisitTypeEnum.VISIT_TYPE_OPD);

        testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
                patientId,
                new LocalDateTime(2022, 11, 5, 8, 0),
                new LocalDate(2022, 11, 5),
                encounterId);

        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
                patientId,
                new LocalDateTime(2022, 11, 11, 8, 0),
                ConceptEnum.INDETERMINATE,
                encounterId);

        String query = readReportQuery(ReportEnum.CDV_TS_REPORT,
                "indicator5_CDV_TS_number_of_indeterminate_results_in_the_month.sql", new LocalDate(2022, 11, 1),
                new LocalDate(2022, 11, 30));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("Title"), "Number of HIV indeterminate results in the month");
        assertEquals(result.get(0).get("<1 M"), 0);
        assertEquals(result.get(0).get("<1 F"), 0);
        assertEquals(result.get(0).get("1-4 M"), 0);
        assertEquals(result.get(0).get("1-4 F"), 0);
        assertEquals(result.get(0).get("5-9 M"), 0);
        assertEquals(result.get(0).get("5-9 F"), 0);
        assertEquals(result.get(0).get("10-14 M"), 0);
        assertEquals(result.get(0).get("10-14 F"), 0);
        assertEquals(result.get(0).get("15-19 M"), 0);
        assertEquals(result.get(0).get("15-19 F"), 0);
        assertEquals(result.get(0).get("20-24 M"), 1);
        assertEquals(result.get(0).get("20-24 F"), 0);
        assertEquals(result.get(0).get("25-29 M"), 0);
        assertEquals(result.get(0).get("25-29 F"), 0);
        assertEquals(result.get(0).get("30-34 M"), 0);
        assertEquals(result.get(0).get("30-34 F"), 0);
        assertEquals(result.get(0).get("35-39 M"), 0);
        assertEquals(result.get(0).get("35-39 F"), 0);
        assertEquals(result.get(0).get("40-44 M"), 0);
        assertEquals(result.get(0).get("40-44 F"), 0);
        assertEquals(result.get(0).get("45-49 M"), 0);
        assertEquals(result.get(0).get("45-49 F"), 0);
        assertEquals(result.get(0).get(">=50 M"), 0);
        assertEquals(result.get(0).get(">=50 F"), 0);
    }

    @Test
    public void shouldNotCountPatientWhenHIVResultIsNotIndeterminate() throws Exception {
        int patientId = testDataGenerator.registration.createPatient(
                GenderEnum.MALE,
                new LocalDate(2000, 9, 1),
                "John",
                "Doe");
        int encounterId = testDataGenerator.startVisit(
                patientId,
                new LocalDate(2022, 11, 1),
                VisitTypeEnum.VISIT_TYPE_OPD);

        testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
                patientId,
                new LocalDateTime(2022, 11, 5, 8, 0),
                new LocalDate(2022, 11, 5),
                encounterId);

        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
                patientId,
                new LocalDateTime(2022, 11, 11, 8, 0),
                ConceptEnum.POSITIVE,
                encounterId);

        String query = readReportQuery(ReportEnum.CDV_TS_REPORT,
                "indicator5_CDV_TS_number_of_indeterminate_results_in_the_month.sql", new LocalDate(2022, 11, 1),
                new LocalDate(2022, 11, 30));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("Title"), "Number of HIV indeterminate results in the month");
        assertEquals(result.get(0).get("<1 M"), 0);
        assertEquals(result.get(0).get("<1 F"), 0);
        assertEquals(result.get(0).get("1-4 M"), 0);
        assertEquals(result.get(0).get("1-4 F"), 0);
        assertEquals(result.get(0).get("5-9 M"), 0);
        assertEquals(result.get(0).get("5-9 F"), 0);
        assertEquals(result.get(0).get("10-14 M"), 0);
        assertEquals(result.get(0).get("10-14 F"), 0);
        assertEquals(result.get(0).get("15-19 M"), 0);
        assertEquals(result.get(0).get("15-19 F"), 0);
        assertEquals(result.get(0).get("20-24 M"), 0);
        assertEquals(result.get(0).get("20-24 F"), 0);
        assertEquals(result.get(0).get("25-29 M"), 0);
        assertEquals(result.get(0).get("25-29 F"), 0);
        assertEquals(result.get(0).get("30-34 M"), 0);
        assertEquals(result.get(0).get("30-34 F"), 0);
        assertEquals(result.get(0).get("35-39 M"), 0);
        assertEquals(result.get(0).get("35-39 F"), 0);
        assertEquals(result.get(0).get("40-44 M"), 0);
        assertEquals(result.get(0).get("40-44 F"), 0);
        assertEquals(result.get(0).get("45-49 M"), 0);
        assertEquals(result.get(0).get("45-49 F"), 0);
        assertEquals(result.get(0).get(">=50 M"), 0);
        assertEquals(result.get(0).get(">=50 F"), 0);
    }

    @Test
    public void shouldNotCountPatientWhenHIVTestDateIsOutsideReportingPeriod() throws Exception {
        int patientId = testDataGenerator.registration.createPatient(
                GenderEnum.MALE,
                new LocalDate(2000, 9, 1),
                "John",
                "Doe");
        int encounterId = testDataGenerator.startVisit(
                patientId,
                new LocalDate(2022, 11, 1),
                VisitTypeEnum.VISIT_TYPE_OPD);

        testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
                patientId,
                new LocalDateTime(2022, 11, 5, 8, 0),
                new LocalDate(2022, 11, 5),
                encounterId);

        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
                patientId,
                new LocalDateTime(2022, 11, 11, 8, 0),
                ConceptEnum.INDETERMINATE,
                encounterId);

        String query = readReportQuery(ReportEnum.CDV_TS_REPORT,
                "indicator5_CDV_TS_number_of_indeterminate_results_in_the_month.sql", new LocalDate(2023, 1, 1),
                new LocalDate(2023, 1, 31));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("Title"), "Number of HIV indeterminate results in the month");
        assertEquals(result.get(0).get("<1 M"), 0);
        assertEquals(result.get(0).get("<1 F"), 0);
        assertEquals(result.get(0).get("1-4 M"), 0);
        assertEquals(result.get(0).get("1-4 F"), 0);
        assertEquals(result.get(0).get("5-9 M"), 0);
        assertEquals(result.get(0).get("5-9 F"), 0);
        assertEquals(result.get(0).get("10-14 M"), 0);
        assertEquals(result.get(0).get("10-14 F"), 0);
        assertEquals(result.get(0).get("15-19 M"), 0);
        assertEquals(result.get(0).get("15-19 F"), 0);
        assertEquals(result.get(0).get("20-24 M"), 0);
        assertEquals(result.get(0).get("20-24 F"), 0);
        assertEquals(result.get(0).get("25-29 M"), 0);
        assertEquals(result.get(0).get("25-29 F"), 0);
        assertEquals(result.get(0).get("30-34 M"), 0);
        assertEquals(result.get(0).get("30-34 F"), 0);
        assertEquals(result.get(0).get("35-39 M"), 0);
        assertEquals(result.get(0).get("35-39 F"), 0);
        assertEquals(result.get(0).get("40-44 M"), 0);
        assertEquals(result.get(0).get("40-44 F"), 0);
        assertEquals(result.get(0).get("45-49 M"), 0);
        assertEquals(result.get(0).get("45-49 F"), 0);
        assertEquals(result.get(0).get(">=50 M"), 0);
        assertEquals(result.get(0).get(">=50 F"), 0);
    }
}
