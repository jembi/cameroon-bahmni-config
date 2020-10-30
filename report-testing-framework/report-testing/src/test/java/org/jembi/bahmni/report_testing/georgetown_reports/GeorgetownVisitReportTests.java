package org.jembi.bahmni.report_testing.georgetown_reports;

import static org.junit.Assert.assertEquals;

import java.util.List;
import java.util.Map;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
import org.jembi.bahmni.report_testing.test_utils.models.AppointmentServiceEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.jembi.bahmni.report_testing.test_utils.models.DrugNameEnum;
import org.jembi.bahmni.report_testing.test_utils.models.DurationUnitEnum;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ReportEnum;
import org.jembi.bahmni.report_testing.test_utils.models.TherapeuticLineEnum;
import org.jembi.bahmni.report_testing.test_utils.models.VisitTypeEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.joda.time.Years;
import org.junit.Test;

public class GeorgetownVisitReportTests extends BaseReportTest {
    @Test
    public void visitWithinReportingPeriod_shouldBeReported() throws Exception {
        // Prepare
        /* create a patient */
        int patientId = testDataGenerator.registration.createPatient("BAH203001", GenderEnum.MALE,
                new LocalDate(2000, 1, 15), "John", "Wayawaya", "081234567", "ART 123");

        /* start an OPD visit */
        int encounterIdOpdVisit = testDataGenerator.startVisit(patientId, new LocalDate(2020, 1, 1),
                VisitTypeEnum.VISIT_TYPE_OPD);

        /* record the HIV test date and result */
        int encounterIdHtc = testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(patientId,
                new LocalDateTime(2020, 1, 2, 8, 0), new LocalDate(2020, 1, 2), null);
        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(patientId, new LocalDateTime(2020, 1, 2, 8, 0),
                ConceptEnum.POSITIVE, encounterIdHtc);

        /* enroll into the HIV program, including reason for consultation */
        int patientProgramId = testDataGenerator.program.enrollPatientIntoHIVProgram(patientId,
                new LocalDate(2020, 1, 3), ConceptEnum.WHO_STAGE_1, TherapeuticLineEnum.FIRST_LINE,
                new LocalDate(2020, 1, 4));
        testDataGenerator.program.recordProgramOutcome(patientProgramId, ConceptEnum.REFUSED_STOPPED_TREATMENT, null);

        /* dispense ARV */
        testDataGenerator.drug.orderDrug(patientId, encounterIdOpdVisit, DrugNameEnum.ABC_3TC_60_30MG,
        new LocalDateTime(2020, 1, 4, 8, 0, 0), 1, DurationUnitEnum.MONTH, true);

        testDataGenerator.drug.orderDrug(patientId, encounterIdOpdVisit, DrugNameEnum.ABC_3TC_120_60MG,
                new LocalDateTime(2020, 1, 5, 8, 0, 0), 1, DurationUnitEnum.MONTH, true);

        testDataGenerator.drug.orderDrug(patientId, encounterIdOpdVisit, DrugNameEnum.COTRIMOXAZOLE_400MG,
                new LocalDateTime(2020, 1, 6, 8, 0, 0), 2, DurationUnitEnum.WEEK, true);

        testDataGenerator.drug.orderDrug(patientId, encounterIdOpdVisit, DrugNameEnum.INH_100MG,
                new LocalDateTime(2020, 1, 7, 8, 0, 0), 3, DurationUnitEnum.MONTH, true);

        /* record an ART Dispensation appointment */
        testDataGenerator.appointment.recordAppointment(patientId, AppointmentServiceEnum.ART_DISPENSARY,
                new LocalDateTime(2020, 1, 15, 8, 0, 0), new LocalDateTime(2020, 1, 15, 10, 0, 0));

        /* record TB screening */
        testDataGenerator.tbForm.setTBScreened(patientId, new LocalDateTime(2020, 1, 6, 10, 0), ConceptEnum.YES,
                encounterIdOpdVisit);

        testDataGenerator.tbForm.setTBScreeningResult(patientId, new LocalDateTime(2020, 1, 6, 10, 0),
                ConceptEnum.SUSPECTED_PROBABLE, encounterIdOpdVisit);
        
        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_VISIT_REPORT, "georgetownVisitReport.sql",
                new LocalDate(2020, 1, 1), new LocalDate(2020, 1, 31));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("serialNumber"), "1");
        assertEquals(result.get(0).get("drugSource"), "N/A");
        assertEquals(result.get(0).get("existingArtCode"), "ART 123");
        assertEquals(result.get(0).get("visitDate"), "2020-01-01");
        assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
        assertEquals(result.get(0).get("age"),
                Years.yearsBetween(new LocalDate(2000, 1, 15), LocalDate.now()).getYears() + "");
        assertEquals(result.get(0).get("sex"), "m");
        assertEquals(result.get(0).get("artStartDate"), "2020-01-04");
        assertEquals(result.get(0).get("telephone"), "081234567");
        assertEquals(result.get(0).get("nextAppointmentDate"), "2020-01-15");
        assertEquals(result.get(0).get("arvRegimen"),
                "ABC/3TC 60/30mg,ABC/3TC 120/60mg");
        assertEquals(result.get(0).get("cotrim"), "Yes");
        assertEquals(result.get(0).get("tbScreening"), "Yes");
        assertEquals(result.get(0).get("tbScreeningResult"), "Suspected / Probable");
        assertEquals(result.get(0).get("inh"), "Yes");
        assertEquals(result.get(0).get("patientStatus"), "Positive");
        assertEquals(result.get(0).get("treatmentLine"), "1st line");
        assertEquals(result.get(0).get("numberOfMonthsDispensed"), 1);
        assertEquals(result.get(0).get("numberOfDaysDispensed"), null);
        assertEquals(result.get(0).get("previousOutcome"), "Refused (Stopped) Treatment");
        assertEquals(result.get(0).get("previousRegimen"), "ABC/3TC 60/30mg");
        assertEquals(result.get(0).get("switchedLine"), "Yes");
        assertEquals(result.get(0).get("reasonOfSwitchLine"), "N/A");
    }

    @Test
    public void visitWithinReportingPeriodWithNoTBScreenAndNoRegimenSwitch_shouldBeReported() throws Exception {
        // Prepare
        /* create a patient */
        int patientId = testDataGenerator.registration.createPatient("BAH203001", GenderEnum.MALE,
                new LocalDate(2000, 1, 15), "John", "Wayawaya", "081234567", "ART 123");

        /* start an OPD visit */
        int encounterIdOpdVisit = testDataGenerator.startVisit(patientId, new LocalDate(2020, 1, 1),
                VisitTypeEnum.VISIT_TYPE_OPD);

        /* record the HIV test date and result */
        int encounterIdHtc = testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(patientId,
                new LocalDateTime(2020, 1, 2, 8, 0), new LocalDate(2020, 1, 2), null);
        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(patientId, new LocalDateTime(2020, 1, 2, 8, 0),
                ConceptEnum.POSITIVE, encounterIdHtc);

        /* enroll into the HIV program, including reason for consultation */
        int patientProgramId = testDataGenerator.program.enrollPatientIntoHIVProgram(patientId,
                new LocalDate(2020, 1, 3), ConceptEnum.WHO_STAGE_1, TherapeuticLineEnum.FIRST_LINE,
                new LocalDate(2020, 1, 4));
        testDataGenerator.program.recordProgramOutcome(patientProgramId, ConceptEnum.REFUSED_STOPPED_TREATMENT, null);

        /* dispense ARV */
        testDataGenerator.drug.orderDrug(patientId, encounterIdOpdVisit, DrugNameEnum.ABC_3TC_120_60MG,
                new LocalDateTime(2020, 1, 5, 8, 0, 0), 2, DurationUnitEnum.WEEK, true);

        /* record an ART Dispensation appointment */
        testDataGenerator.appointment.recordAppointment(patientId, AppointmentServiceEnum.ART_DISPENSARY,
                new LocalDateTime(2020, 1, 15, 8, 0, 0), new LocalDateTime(2020, 1, 15, 10, 0, 0));

        /* record TB screening */
        testDataGenerator.tbForm.setTBScreened(patientId, new LocalDateTime(2020, 1, 6, 10, 0), ConceptEnum.NO,
                encounterIdOpdVisit);

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_VISIT_REPORT, "georgetownVisitReport.sql",
                new LocalDate(2020, 1, 1), new LocalDate(2020, 1, 31));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("serialNumber"), "1");
        assertEquals(result.get(0).get("drugSource"), "N/A");
        assertEquals(result.get(0).get("existingArtCode"), "ART 123");
        assertEquals(result.get(0).get("visitDate"), "2020-01-01");
        assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
        assertEquals(result.get(0).get("age"),
                Years.yearsBetween(new LocalDate(2000, 1, 15), LocalDate.now()).getYears() + "");
        assertEquals(result.get(0).get("sex"), "m");
        assertEquals(result.get(0).get("artStartDate"), "2020-01-04");
        assertEquals(result.get(0).get("telephone"), "081234567");
        assertEquals(result.get(0).get("nextAppointmentDate"), "2020-01-15");
        assertEquals(result.get(0).get("arvRegimen"), "ABC/3TC 120/60mg");
        assertEquals(result.get(0).get("cotrim"), "No");
        assertEquals(result.get(0).get("tbScreening"), "No");
        assertEquals(result.get(0).get("tbScreeningResult"), null);
        assertEquals(result.get(0).get("inh"), "No");
        assertEquals(result.get(0).get("patientStatus"), "Positive");
        assertEquals(result.get(0).get("treatmentLine"), "1st line");
        assertEquals(result.get(0).get("numberOfMonthsDispensed"), 0);
        assertEquals(result.get(0).get("numberOfDaysDispensed"), 14);
        assertEquals(result.get(0).get("previousOutcome"), "Refused (Stopped) Treatment");
        assertEquals(result.get(0).get("previousRegimen"), null);
        assertEquals(result.get(0).get("switchedLine"), "No");
        assertEquals(result.get(0).get("reasonOfSwitchLine"), "N/A");
    }
}