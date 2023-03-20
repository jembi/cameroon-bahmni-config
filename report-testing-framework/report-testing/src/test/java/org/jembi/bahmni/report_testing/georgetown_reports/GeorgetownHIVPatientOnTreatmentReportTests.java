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
import org.jembi.bahmni.report_testing.test_utils.models.DrugNameEnum;
import org.jembi.bahmni.report_testing.test_utils.models.DurationUnitEnum;
import org.jembi.bahmni.report_testing.test_utils.models.VisitTypeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.TherapeuticLineEnum;
import org.jembi.bahmni.report_testing.test_utils.models.AppointmentServiceEnum;


import org.junit.Test;

public class GeorgetownHIVPatientOnTreatmentReportTests extends BaseReportTest {
    @Test
    public void hivPatientShouldBeReported() throws Exception {
        /* create a patient */
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            "ART 123"
        );

        /* record the patient address */
        testDataGenerator.registration.recordPersonAddress(
            patientId,
            "14 BAMBI STR", // address1
            "NKUM", // address2
            "NKUM", // address3
            "NKUM", // address4
            "NKUM", // city_village
            "NORD-OUEST", // state_province
            "BUI", // country_district
            "CAMEROON"  // country
        ); 

        /* start an OPD visit */
        int encounterIdOpdVisit = testDataGenerator.startVisit(
            patientId,
            new LocalDate(2023, 1, 10),
            VisitTypeEnum.VISIT_TYPE_OPD
        );

        /* enroll into the HIV program, including reason for consultation */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2023, 1, 10),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            new LocalDate(2023, 1, 10)
        );

        /* dispense ARV */
        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.TDF_FTC_300_200MG,
			new LocalDateTime(2023, 1, 10, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        /* record an ART Dispensation appointment */
        testDataGenerator.appointment.recordAppointment(
            patientId,
            AppointmentServiceEnum.ART_DISPENSARY,
            new LocalDateTime(2023, 2, 13, 8, 0, 0),
            new LocalDateTime(2023, 2, 13, 10, 0, 0)
        );

        // Execute
		String query = readReportQuery(
            ReportEnum.GEORGETOWN_HIV_PATIENT_ON_TREATMENT_REPORT,
            "georgetownHIVPatientOnTreatmentReport.sql",
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 1, 31)
        );
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
		assertEquals(result.get(0).get("serialNumber"), "1");
		assertEquals(result.get(0).get("facilityName"), "CENTRE");
		assertEquals(result.get(0).get("uniquePatientID"), "BAH203001");
		assertEquals(result.get(0).get("age"), 23);
		assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
		assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("address"), "NKUM,14 BAMBI STR");
		assertEquals(result.get(0).get("telephone"), "081234567");
		assertEquals(result.get(0).get("clinicalWhoStage"), "WHO stage 1");
		assertEquals(result.get(0).get("artStartDate"), "2023-01-10");
        assertEquals(result.get(0).get("regimentAtArtInitiation"), "TDF/FTC 300/200mg");
		assertEquals(result.get(0).get("currentLine"), "1st line");
		assertEquals(result.get(0).get("currentRegimen"), "TDF/FTC 300/200mg");
		assertEquals(result.get(0).get("currentLine"), "1st line");
		assertEquals(result.get(0).get("eligibilityForVl"), "No");
		assertEquals(result.get(0).get("lastAppointmentDate"), "2023-02-13");
		assertEquals(result.get(0).get("getLastARVDispensed"), "TDF/FTC 300/200mg");
		assertEquals(result.get(0).get("lastARVDispenseDate"), "2023-01-10");
		assertEquals(result.get(0).get("getLastARVDispensed"), "TDF/FTC 300/200mg");
		assertEquals(result.get(0).get("durationMostRecentArv"), 31);
		assertEquals(result.get(0).get("kp"), "False");
    }

    @Test
    public void hivPatientWhoRegisteredBeforeShouldBeReported() throws Exception {
        /* create a patient */
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            "ART 123"
        );

        /* record the patient address */
        testDataGenerator.registration.recordPersonAddress(
            patientId,
            "14 BAMBI STR", // address1
            "NKUM", // address2
            "NKUM", // address3
            "NKUM", // address4
            "NKUM", // city_village
            "NORD-OUEST", // state_province
            "BUI", // country_district
            "CAMEROON"  // country
        ); 

        /* start an OPD visit */
        int encounterIdOpdVisit = testDataGenerator.startVisit(
            patientId,
            new LocalDate(2022, 12, 10),
            VisitTypeEnum.VISIT_TYPE_OPD
        );

        /* enroll into the HIV program, including reason for consultation */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2022, 12, 10),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            new LocalDate(2022, 12, 10)
        );

        /* dispense ARV */
        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.TDF_FTC_300_200MG,
			new LocalDateTime(2022, 12, 10, 8, 0, 0),
			60,
			DurationUnitEnum.DAY,
			true
        );

        /* record an ART Dispensation appointment */
        testDataGenerator.appointment.recordAppointment(
            patientId,
            AppointmentServiceEnum.ART_DISPENSARY,
            new LocalDateTime(2023, 2, 9, 8, 0, 0),
            new LocalDateTime(2023, 2, 9, 10, 0, 0)
        );

        // Execute
		String query = readReportQuery(
            ReportEnum.GEORGETOWN_HIV_PATIENT_ON_TREATMENT_REPORT,
            "georgetownHIVPatientOnTreatmentReport.sql",
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 2, 28)
        );
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
		assertEquals(result.get(0).get("serialNumber"), "1");
		assertEquals(result.get(0).get("facilityName"), "CENTRE");
		assertEquals(result.get(0).get("uniquePatientID"), "BAH203001");
		assertEquals(result.get(0).get("age"), 23);
		assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
		assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("address"), "NKUM,14 BAMBI STR");
		assertEquals(result.get(0).get("telephone"), "081234567");
		assertEquals(result.get(0).get("clinicalWhoStage"), "WHO stage 1");
		assertEquals(result.get(0).get("artStartDate"), "2022-12-10");
        assertEquals(result.get(0).get("regimentAtArtInitiation"), "TDF/FTC 300/200mg");
		assertEquals(result.get(0).get("currentLine"), "1st line");
		assertEquals(result.get(0).get("currentRegimen"), "TDF/FTC 300/200mg");
		assertEquals(result.get(0).get("currentLine"), "1st line");
		assertEquals(result.get(0).get("eligibilityForVl"), "No");
		assertEquals(result.get(0).get("lastAppointmentDate"), "2023-02-09");
		assertEquals(result.get(0).get("getLastARVDispensed"), "TDF/FTC 300/200mg");
		assertEquals(result.get(0).get("lastARVDispenseDate"), "2022-12-10");
		assertEquals(result.get(0).get("getLastARVDispensed"), "TDF/FTC 300/200mg");
		assertEquals(result.get(0).get("durationMostRecentArv"), 60);
		assertEquals(result.get(0).get("kp"), "False");
    }

}
