package org.jembi.bahmni.report_testing.georgetown_reports;

import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import static org.junit.Assert.assertEquals;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
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
    public void aNewPatient_withHIVTreatmentStartingWithinReportingPeriod_andDispensedWithinReportingPeriod_shouldBeReported() throws Exception {
        // Prepare
        createAPatientEnrolledInHIVWithTreatmentStartingOn(new LocalDate(2023, 1, 01));

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 1, 31));

        // Assert
        assertThatThePatientIsReported(result);
    }

    @Test
    public void aNewPatient_withHIVTreatmentStartingWithinReportingPeriod_butNotDispensed_shouldNotBeReported() throws Exception {
        // Prepare
        createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2023, 1, 01),
            null,
            0
        );

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 1, 31));

        // Assert
        assertEquals(0, result.size());
    }

    @Test
    public void aNewPatient_withHIVTreatmentStartingWithinReportingPeriod_butDispensedAfterReportingPeriod_shouldNotBeReported() throws Exception {
        // Prepare
        createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2023, 1, 01),
            new LocalDate(2023, 2, 01),
            1
        );

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 1, 31));

        // Assert
        assertEquals(0, result.size());
    }

    @Test
    public void aDeadPatient_shouldNotBeReported() throws Exception {
        // Prepare
        int patientId = createAPatientEnrolledInHIVWithTreatmentStartingOn(new LocalDate(2023, 1, 01));
        testDataGenerator.registration.markPatientAsDead(patientId, new LocalDate(2023, 2, 1), ConceptEnum.HEART_FAILURE);

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 1, 31));

        // Assert
        assertEquals(0, result.size());
    }

    @Test
    public void aPatientTransferredOut_shouldNotBeReported() throws Exception {
        // Prepare
        int patientId = createAPatientEnrolledInHIVWithTreatmentStartingOn(new LocalDate(2023, 1, 01));
        testDataGenerator.program.markPatientAsTransferredOut(patientId, new LocalDate(2023, 1, 10));

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 1, 31));

        // Assert
        assertEquals(0, result.size());
    }

    @Test
    public void anOldPatient_withHIVTreatmentStartingBeforeReportingPeriod_andNeverBeenDispensedARV_shouldNotBeReported() throws Exception {
        // Prepare
        createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2022, 10, 01),
            null,
            0
        );

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 1, 31));

        // Assert
        assertEquals(0, result.size());
    }

    @Test
    public void aPatientOnUnplannedAid_shouldNotBeReported() throws Exception {
        // Prepare
        int patientId = createAPatientEnrolledInHIVWithTreatmentStartingOn(new LocalDate(2023, 1, 01));
        testDataGenerator.program.markPatientAsUnplannedAid(patientId, new LocalDate(2023, 1, 10));

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 1, 31));

        // Assert
        assertEquals(0, result.size());
    }

    @Test
    public void aPatient_whoDidNotStartHivTreatment_shouldNotBeReported() throws Exception {
        // Prepare
        createAPatientEnrolledInHIVWithNoTreatment(new LocalDate(2023, 1, 01));

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 1, 31));

        // Assert
        assertEquals(0, result.size());
    }

    @Test
    public void aNewPatient_withHIVTreatmentStartingAfterReportingPeriod_shouldNotBeReported() throws Exception {
        // Prepare
        createAPatientEnrolledInHIVWithTreatmentStartingOn(new LocalDate(2023, 2, 1));

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 1, 31));

        // Assert
        assertEquals(0, result.size());
    }

    @Test
    public void anOldPatient_withHIVTreatmentStartingBeforeReportingPeriod_andTreatmentCoveringFullMonth_shouldBeReported_case1() throws Exception {
        // Prepare
       createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2022, 12, 1), // treatment start date
            new LocalDate(2023, 2, 1), // drug start date
            1); // drug duration in months

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 3, 31));

        // Assert
        assertEquals(1, result.size());
    }

    @Test
    public void anOldPatient_withHIVTreatmentStartingBeforeReportingPeriod_andTreatmentCoveringFullMonth_shouldBeReported_case2() throws Exception {
        // Prepare
       createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2022, 12, 1), // treatment start date
            new LocalDate(2022, 12, 20), // drug start date
            2); // drug duration in months

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 1, 31));

        // Assert
        assertEquals(1, result.size());
    }

    @Test
    public void anOldPatient_withHIVTreatmentStartingBeforeReportingPeriod_andTreatmentCoveringFullMonth_shouldBeReported_case3() throws Exception {
        // Prepare
       createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2022, 12, 1), // treatment start date
            new LocalDate(2023, 1, 1), // drug start date
            1); // drug duration in months

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 3, 31));

        // Assert
        assertEquals(1, result.size());
    }

    @Test
    public void anOldPatient_withHIVTreatmentStartingBeforeReportingPeriod_andTreatmentCoveringFullMonth_shouldBeReported_case4() throws Exception {
        // Prepare
       createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2022, 12, 1), // treatment start date
            new LocalDate(2023, 3, 1), // drug start date
            2); // drug duration in months

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 3, 31));

        // Assert
        assertEquals(1, result.size());
    }

    @Test
    public void anOldPatient_withHIVTreatmentStartingBeforeReportingPeriod_andTreatmentCoveringFullMonth_shouldBeReported_case5() throws Exception {
        // Prepare
       createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2022, 12, 1), // treatment start date
            new LocalDate(2023, 1, 20), // drug start date
            3); // drug duration in months

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 3, 31));

        // Assert
        assertEquals(1, result.size());
    }

    @Test
    public void anOldPatient_withHIVTreatmentStartingBeforeReportingPeriod_andTreatmentCoveringFullMonth_shouldBeReported_case6() throws Exception {
        // Prepare
       createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2022, 12, 1), // treatment start date
            new LocalDate(2023, 1, 1), // drug start date
            1); // drug duration in months

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 5, 31));

        // Assert
        assertEquals(1, result.size());
    }

    @Test
    public void anOldPatientWhoIsDefaulter_withHIVTreatmentStartingBeforeReportingPeriod_andTreatmentNotCoveringFullMonth_shouldNotBeReported() throws Exception {
        // Prepare
       createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2022, 12, 1), // treatment start date
            new LocalDate(2022, 11, 25), // drug start date
            2); // drug duration in months

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 1, 31));

        // Assert
        assertEquals(0, result.size());
    }

    @Test
    public void anOldPatientWhoIsLTFU_withHIVTreatmentStartingBeforeReportingPeriod_andTreatmentNotCoveringFullMonth_shouldNotBeReported() throws Exception {
        // Prepare
       createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2022, 12, 1), // treatment start date
            new LocalDate(2023, 1, 10), // drug start date
            1); // drug duration in months

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 5, 31));

        // Assert
        assertEquals(0, result.size());
    }

    @Test
    public void anOldPatient_withHIVTreatmentStartingBeforeReportingPeriod_withMultiMonthDispensation_butNotCoveringFullMonthInReportingPeriod_shouldNotBeReported() throws Exception {
        // Prepare
       createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2022, 10, 1), // treatment start date
            new LocalDate(2022, 10, 10), // drug start date
            3); // drug duration in months

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 3, 31));

        // Assert
        assertEquals(0, result.size());
    }

    @Test
    public void anOldPatientWhoIsNotDefaulter_withHIVTreatmentStartingBeforeReportingPeriod_andTreatmentNotCoveringFullMonth_shouldNotBeReported() throws Exception {
        // Prepare
       createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2022, 12, 1), // treatment start date
            new LocalDate(2023, 1, 10), // drug start date
            1); // drug duration in months

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 1, 31));

        // Assert
        assertEquals(1, result.size());
    }

    @Test
    public void anOldPatientWhoIsNotLTFU_withHIVTreatmentStartingBeforeReportingPeriod_andTreatmentNotCoveringFullMonth_shouldNotBeReported() throws Exception {
        // Prepare
       createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2022, 12, 1), // treatment start date
            new LocalDate(2023, 3, 15), // drug start date
            1); // drug duration in months

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 1, 1),
            new LocalDate(2023, 3, 31));

        // Assert
        assertEquals(1, result.size());
    }

    @Test
    public void aNewPatient_withDispenseInReportingPeriod_andAppointmentsAfterReportingPeriod_shouldReturnAppointment() throws Exception {
        // Prepare
       int patientId = createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2023, 3, 1), // treatment start date
            new LocalDate(2023, 3, 15), // drug start date
            1); // drug duration in months

        testDataGenerator.appointment.recordARTAppointment(
            patientId,
            new LocalDate(2023, 4, 15));
        testDataGenerator.appointment.recordARTAppointment(
            patientId,
            new LocalDate(2023, 5, 15));

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 3, 1),
            new LocalDate(2023, 3, 31));

        // Assert
        assertEquals("2023-04-15", result.get(0).get("lastAppointmentDate"));
    }

    @Test
    public void aNewPatient_withDispenseInReportingPeriod_andMissedAppointmentAfterReportingPeriod_shouldReturnAppointment() throws Exception {
        // Prepare
       int patientId = createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2023, 3, 1), // treatment start date
            new LocalDate(2023, 3, 15), // drug start date
            1); // drug duration in months

        testDataGenerator.appointment.recordMissedARTAppointment(
            patientId,
            new LocalDate(2023, 4, 15));
        testDataGenerator.appointment.recordARTAppointment(
            patientId,
            new LocalDate(2023, 5, 15));

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 3, 1),
            new LocalDate(2023, 3, 31));

        // Assert
        assertEquals("2023-04-15", result.get(0).get("lastAppointmentDate"));
    }

    @Test
    public void aNewPatient_withDispenseInReportingPeriod_andCancelledAppointmentAfterReportingPeriod_shouldNotReturnAppointment() throws Exception {
        // Prepare
       int patientId = createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2023, 3, 1), // treatment start date
            new LocalDate(2023, 3, 15), // drug start date
            1); // drug duration in months

        testDataGenerator.appointment.recordCancelledARTAppointment(
            patientId,
            new LocalDate(2023, 4, 15));

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 3, 1),
            new LocalDate(2023, 3, 31));

        // Assert
        assertEquals(null, result.get(0).get("lastAppointmentDate"));
    }

    @Test
    public void aNewPatient_withNoDispensation_andAppointmentAfterReportingPeriod_shouldReturnAppointment() throws Exception {
        // Prepare
       int patientId = createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2023, 3, 1) // treatment start date
            ); 

        testDataGenerator.appointment.recordARTAppointment(
            patientId,
            new LocalDate(2023, 5, 15));

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 3, 1),
            new LocalDate(2023, 3, 31));

        // Assert
        assertEquals("2023-05-15", result.get(0).get("lastAppointmentDate"));
    }

    @Test
    public void aNewPatient_withDispenseWithinReportingPeriod_andNoAppointment_shouldNotReturnAppointment() throws Exception {
        // Prepare
        createAPatientEnrolledInHIVWithTreatmentStartingOn(
            new LocalDate(2023, 3, 1), // treatment start date
            new LocalDate(2023, 3, 15), // drug start date
            1); // drug duration in months

        // Execute
        List<Map<String,Object>> result = runPatientOnTreatmentReport(
            new LocalDate(2023, 3, 1),
            new LocalDate(2023, 3, 31));

        // Assert
        assertEquals(null, result.get(0).get("lastAppointmentDate"));
    }

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

        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.TDF_FTC_300_300MG,
			new LocalDateTime(2023, 1, 10, 8, 30, 0),
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
		assertEquals(result.get(0).get("currentRegimen"), "TDF/FTC 300/200mg;TDF/FTC 300/300mg");
		assertEquals(result.get(0).get("currentLine"), "1st line");
		assertEquals(result.get(0).get("eligibilityForVl"), "No");
		assertEquals(result.get(0).get("lastAppointmentDate"), "2023-02-13");
		assertEquals(result.get(0).get("getLastARVDispensed"), "TDF/FTC 300/300mg");
		assertEquals(result.get(0).get("lastARVDispenseDate"), "2023-01-10");
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

        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.TDF_FTC_300_300MG,
			new LocalDateTime(2022, 12, 10, 8, 30, 0),
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
		assertEquals(result.get(0).get("currentRegimen"), "TDF/FTC 300/200mg;TDF/FTC 300/300mg");
		assertEquals(result.get(0).get("currentLine"), "1st line");
		assertEquals(result.get(0).get("eligibilityForVl"), "No");
		assertEquals(result.get(0).get("lastAppointmentDate"), "2023-02-09");
		assertEquals(result.get(0).get("getLastARVDispensed"), "TDF/FTC 300/300mg");
		assertEquals(result.get(0).get("lastARVDispenseDate"), "2022-12-10");
		assertEquals(result.get(0).get("durationMostRecentArv"), 60);
		assertEquals(result.get(0).get("kp"), "False");
    }

    private int createAPatientEnrolledInHIVWithTreatmentStartingOn(LocalDate treatmentStartDate) throws Exception {
        return createAPatientEnrolledInHIVWithTreatmentStartingOn(treatmentStartDate, treatmentStartDate, 1);
    }

    private int createAPatientEnrolledInHIVWithTreatmentStartingOn(LocalDate treatmentStartDate, LocalDate drugStartDate, int drugDurationInMonths) throws Exception {
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
            treatmentStartDate,
            VisitTypeEnum.VISIT_TYPE_OPD
        );

        /* enroll into the HIV program, including reason for consultation */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            treatmentStartDate,
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            treatmentStartDate
        );

        /* dispense ARV */
        if (drugStartDate != null && drugDurationInMonths > 0) {
            testDataGenerator.drug.orderDrug(
                patientId,
                encounterIdOpdVisit,
                DrugNameEnum.TDF_FTC_300_200MG,
                new LocalDateTime(drugStartDate.getYear(), drugStartDate.getMonthOfYear(), drugStartDate.getDayOfMonth(), 8, 0, 0),
                drugDurationInMonths,
                DurationUnitEnum.MONTH,
                true
            );
        }

        return patientId;
    }

    private int createAPatientEnrolledInHIVWithNoTreatment(LocalDate enrollmentDate) throws Exception {
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

        /* start an OPD visit */
        int encounterIdOpdVisit = testDataGenerator.startVisit(
            patientId,
            enrollmentDate,
            VisitTypeEnum.VISIT_TYPE_OPD
        );

        /* enroll into the HIV program, including reason for consultation */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            enrollmentDate,
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            null
        );

        /* dispense ARV */
        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.TDF_FTC_300_200MG,
			new LocalDateTime(enrollmentDate.getYear(), enrollmentDate.getMonthOfYear(), enrollmentDate.getDayOfMonth(), 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        return patientId;
    }

    List<Map<String,Object>> runPatientOnTreatmentReport(LocalDate startDate, LocalDate endDate) throws Exception {
        String query = readReportQuery(
            ReportEnum.GEORGETOWN_HIV_PATIENT_ON_TREATMENT_REPORT,
            "georgetownHIVPatientOnTreatmentReport.sql",
             startDate,
             endDate
        );

		return getReportResult(query);
    }

    private void assertThatThePatientIsReported(List<Map<String,Object>> result) {
        assertEquals(result.get(0).get("serialNumber"), "1");
		assertEquals(result.get(0).get("facilityName"), "CENTRE");
		assertEquals(result.get(0).get("uniquePatientID"), "BAH203001");
		assertEquals(result.get(0).get("age"), 23);
		assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
		assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("address"), "NKUM,14 BAMBI STR");
		assertEquals(result.get(0).get("telephone"), "081234567");
		assertEquals(result.get(0).get("clinicalWhoStage"), "WHO stage 1");
		assertEquals(result.get(0).get("artStartDate"), "2023-01-01");
        assertEquals(result.get(0).get("regimentAtArtInitiation"), "TDF/FTC 300/200mg");
		assertEquals(result.get(0).get("currentLine"), "1st line");
		assertEquals(result.get(0).get("currentRegimen"), "TDF/FTC 300/200mg");
		assertEquals(result.get(0).get("currentLine"), "1st line");
		assertEquals(result.get(0).get("eligibilityForVl"), "No");
		assertEquals(result.get(0).get("lastAppointmentDate"), null);
		assertEquals(result.get(0).get("getLastARVDispensed"), "TDF/FTC 300/200mg");
		assertEquals(result.get(0).get("lastARVDispenseDate"), "2023-01-01");
		assertEquals(result.get(0).get("getLastARVDispensed"), "TDF/FTC 300/200mg");
		assertEquals(result.get(0).get("durationMostRecentArv"), 31);
		assertEquals(result.get(0).get("kp"), "False");
    }
}
