package org.jembi.bahmni.report_testing.georgetown_reports;

import static org.junit.Assert.assertEquals;

import java.util.List;
import java.util.Map;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.jembi.bahmni.report_testing.test_utils.models.DrugNameEnum;
import org.jembi.bahmni.report_testing.test_utils.models.DurationUnitEnum;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;
import org.jembi.bahmni.report_testing.test_utils.models.PatientIdenfierTypeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ReportEnum;
import org.jembi.bahmni.report_testing.test_utils.models.TherapeuticLineEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.junit.Test;

public class GeorgetownANC1ReportTests extends BaseReportTest {

    @Test
    public void ancPatient_shouldBeReported() throws Exception {
        // Prepare
        /* register a new patient */
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 1),
            "Marie",
            "Tambwe",
            "081234567",
            "ART 123"
        );

        testDataGenerator.registration.addPatientIdentifier(
            patientId,
            PatientIdenfierTypeEnum.ANC,
            "ANC 456",
            false);

        testDataGenerator.registration.recordServiceTypeRequested(
            patientId,
            ConceptEnum.LOCATION_ANC,
            new LocalDate(2019, 1, 1));

        /* record date of first anc visit */
        int ancEncounterId = testDataGenerator.ancInitialForm.recordDateOfFirstANC(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            new LocalDate(2019, 12, 31),
            null);

        /* record prior anc enrolment hiv test result */
        testDataGenerator.ancInitialForm.recordPriorAncEnrolmentHivTestDateAndResult(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            new LocalDate(2018, 1, 1),
            ConceptEnum.NEGATIVE,
            ancEncounterId);

        /* record at anc enrolment hiv test result */
        testDataGenerator.ancInitialForm.recordAtAncEnrolmentHivTestDateAndResult(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            new LocalDate(2020, 1, 2),
            ConceptEnum.POSITIVE,
            ancEncounterId);

        /* record LLIN fields */
        testDataGenerator.ancInitialForm.recordReceivedCotrimoxazole(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            ConceptEnum.YES,
            ancEncounterId);

        testDataGenerator.ancInitialForm.recordReceivedLongLastingInsecticideNet(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            ConceptEnum.YES,
            ancEncounterId);

        testDataGenerator.ancInitialForm.recordReceivedAntiTetanusToxoid(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            ConceptEnum.NUMBER_1,
            ancEncounterId);

        /* record the ARV status */
        testDataGenerator.ancInitialForm.recordArtStatus(
            patientId,
            new LocalDateTime(2020, 1, 2, 8, 0),
            ConceptEnum.NEWLY_INITIATING_ART,
            ancEncounterId);

        /* enroll to the HIV program */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 3),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            new LocalDate(2020, 1, 4)
        );

        /* dispense ARV */
        testDataGenerator.drug.orderDrug(
			patientId,
			ancEncounterId,
			DrugNameEnum.ABC_3TC_120_60MG,
			new LocalDateTime(2020, 1, 5, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );
    
        /* record TB screening */
        testDataGenerator.tbForm.setTBScreened(
            patientId,
            new LocalDateTime(2020, 1, 6, 10, 0),
            ConceptEnum.YES,
            ancEncounterId);

        testDataGenerator.tbForm.setTBScreeningResult(
            patientId,
            new LocalDateTime(2020, 1, 6, 10, 0),
            ConceptEnum.SUSPECTED_PROBABLE,
            ancEncounterId);
        
        testDataGenerator.tbForm.setMTBConfirmation(
            patientId,
            new LocalDateTime(2020, 1, 6, 10, 0),
            ConceptEnum.MTB_BACTERIOLOGICALLY_CONFIRMED,
            ancEncounterId);

		// Execute
		String query = readReportQuery(ReportEnum.GEORGETOWN_ANC1_REPORT, "georgetownAnc1Report.sql", new LocalDate(2019, 12, 31), new LocalDate(2020, 1, 31));
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
		assertEquals(result.get(0).get("serialNumber"), "1");
		assertEquals(result.get(0).get("facilityName"), "CENTRE");
		assertEquals(result.get(0).get("patientId"), "BAH203001");
		assertEquals(result.get(0).get("dateOfAncVisit"), "2019-12-31");
		assertEquals(result.get(0).get("pregnancyId"), "ANC 456");
		assertEquals(result.get(0).get("dateOfBirth"), "2000-01-01");
		assertEquals(result.get(0).get("ageAtFirstAnc"), 19);
		assertEquals(result.get(0).get("hivTestedBeforeAnc1"), "Yes");
		assertEquals(result.get(0).get("resultHivTestDoneBeforeAnc1"), "Negative");
        assertEquals(result.get(0).get("dateOfTestAtAnc1"), "2020-01-02");
        assertEquals(result.get(0).get("resultTestAtAnc1"), "Positive");
        assertEquals(result.get(0).get("resultReceived"), "Yes");
        assertEquals(result.get(0).get("dateArtInitiation"), "2020-01-04");
        assertEquals(result.get(0).get("arvStatus"), "Newly initiating ART");
        assertEquals(result.get(0).get("arvRegiment"), "ABC/3TC 120/60mg");
        assertEquals(result.get(0).get("screenForTB"), "Yes");
        assertEquals(result.get(0).get("tbScreeningResult"), "Suspected / Probable");
        assertEquals(result.get(0).get("cotrim"), "Yes");
        assertEquals(result.get(0).get("milda"), "Yes");
        assertEquals(result.get(0).get("vat"), "Yes");
    }
    
}
