package org.jembi.bahmni.report_testing.georgetown_reports;

import static org.junit.Assert.assertEquals;

import java.util.List;
import java.util.Map;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ReportEnum;
import org.jembi.bahmni.report_testing.test_utils.models.VisitTypeEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.joda.time.Years;
import org.junit.Test;

public class GeorgetownTBReportTests extends BaseReportTest {
    /** a patient that is screened and tb positive should be included in the report */
    @Test
    public void patientThatIsScreenedAndTBPositive_shouldBeIncludedToTheReport() throws Exception {
        // Prepare
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            null
        );

        testDataGenerator.program.enrollPatientIntoTBProgram(
            patientId,
            new LocalDate(2020, 1, 2),
            ConceptEnum.INITIAL_TREATMENT_PHASE,
            new LocalDate(2020, 1, 5)
        );

        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 2),
            ConceptEnum.WHO_STAGE_1,
            null,
            new LocalDate(2020, 1, 4)
        );

        int encounterId = testDataGenerator.startVisit(
            patientId,
            new LocalDate(2020, 1, 1),
            VisitTypeEnum.VISIT_TYPE_OPD
        );
        testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
            patientId,
            new LocalDateTime(2020, 1, 1, 10, 0),
            new LocalDate(2020, 1, 1),
            encounterId);

        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
            patientId, 
            new LocalDateTime(2020, 1, 1, 10, 0),
            ConceptEnum.POSITIVE,
            encounterId);

        encounterId  = testDataGenerator.tbForm.setDateBaselineAssessment(
            patientId,
            new LocalDateTime(2020, 1, 6, 10, 0),
            new LocalDate(2020, 1, 6),
            null);

        testDataGenerator.tbForm.setTBScreened(
            patientId,
            new LocalDateTime(2020, 1, 6, 10, 0),
            ConceptEnum.YES,
            encounterId);

        testDataGenerator.tbForm.setTBScreeningResult(
            patientId,
            new LocalDateTime(2020, 1, 6, 10, 0),
            ConceptEnum.SUSPECTED_PROBABLE,
            encounterId);

        testDataGenerator.tbForm.setMTBConfirmation(
            patientId,
            new LocalDateTime(2020, 1, 6, 10, 0),
            ConceptEnum.MTB_BACTERIOLOGICALLY_CONFIRMED,
            encounterId);
        
        testDataGenerator.tbForm.setMethodOfConfirmation(
            patientId,
            new LocalDateTime(2020, 1, 6, 10, 0),
            ConceptEnum.SMEAR,
            encounterId);

        // Execute
		String query = readReportQuery(
            ReportEnum.GEORGETOWN_TB_REPORT,
            "georgetownTbReport.sql",
            new LocalDate(2020, 1, 1),
            new LocalDate(2020, 1, 31)
        );
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
		assertEquals(result.get(0).get("serialNumber"), "1");
		assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
		assertEquals(result.get(0).get("Facility Name"), "CENTRE");
		assertEquals(result.get(0).get("telephone"), "081234567");
		assertEquals(result.get(0).get("Type of Exam"), "Smear");
		assertEquals(result.get(0).get("dateTBPosDiag"), "2020-01-06");
		assertEquals(result.get(0).get("age"), Years.yearsBetween(new LocalDate(2000, 1, 15), LocalDate.now()).getYears()+"");
		assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
		assertEquals(result.get(0).get("sex"), "f");
		assertEquals(result.get(0).get("dateOfInitiation"), "2020-01-04");
		assertEquals(result.get(0).get("dateOfTxTbStart"), "2020-01-05");
		assertEquals(result.get(0).get("dateOfHivTesting"), "2020-01-01");
		assertEquals(result.get(0).get("hivTestingResult"), "Positive");
    }

    /** a patient that is NOT screened and and tb positive should NOT be included in the report */
    @Test
    public void patientThatIsNotScreenedAndTBPositive_shouldNotBeIncludedToTheReport() throws Exception {
        // Prepare
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            null
        );

        testDataGenerator.program.enrollPatientIntoTBProgram(
            patientId,
            new LocalDate(2020, 1, 2),
            ConceptEnum.INITIAL_TREATMENT_PHASE,
            new LocalDate(2020, 1, 5)
        );

        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 2),
            ConceptEnum.WHO_STAGE_1,
            null,
            new LocalDate(2020, 1, 4)
        );

        int encounterId = testDataGenerator.startVisit(
            patientId,
            new LocalDate(2020, 1, 1),
            VisitTypeEnum.VISIT_TYPE_OPD
        );
        testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
            patientId,
            new LocalDateTime(2020, 1, 1, 10, 0),
            new LocalDate(2020, 1, 1),
            encounterId);

        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
            patientId, 
            new LocalDateTime(2020, 1, 1, 10, 0),
            ConceptEnum.POSITIVE,
            encounterId);

        encounterId  = testDataGenerator.tbForm.setDateBaselineAssessment(
            patientId,
            new LocalDateTime(2020, 1, 6, 10, 0),
            new LocalDate(2020, 1, 6),
            null);

        testDataGenerator.tbForm.setTBScreened(
            patientId,
            new LocalDateTime(2020, 1, 6, 10, 0),
            ConceptEnum.NO,
            encounterId);
        
        testDataGenerator.tbForm.setMTBConfirmation(
            patientId,
            new LocalDateTime(2020, 1, 6, 10, 0),
            ConceptEnum.MTB_BACTERIOLOGICALLY_CONFIRMED,
            encounterId);

        // Execute
		String query = readReportQuery(
            ReportEnum.GEORGETOWN_TB_REPORT,
            "georgetownTbReport.sql",
            new LocalDate(2020, 1, 1),
            new LocalDate(2020, 1, 31)
        );
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
		assertEquals(result.size(), 0);
    }

    /** a patient that is screened and and tb NOT positive should NOT be included in the report */
    @Test
    public void patientThatIsScreenedAndTBNotPositive_shouldNotBeIncludedToTheReport() throws Exception {
        // Prepare
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            null
        );

        testDataGenerator.program.enrollPatientIntoTBProgram(
            patientId,
            new LocalDate(2020, 1, 2),
            ConceptEnum.INITIAL_TREATMENT_PHASE,
            new LocalDate(2020, 1, 5)
        );

        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 2),
            ConceptEnum.WHO_STAGE_1,
            null,
            new LocalDate(2020, 1, 4)
        );

        int encounterId = testDataGenerator.startVisit(
            patientId,
            new LocalDate(2020, 1, 1),
            VisitTypeEnum.VISIT_TYPE_OPD
        );
        testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
            patientId,
            new LocalDateTime(2020, 1, 1, 10, 0),
            new LocalDate(2020, 1, 1),
            encounterId);

        testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
            patientId, 
            new LocalDateTime(2020, 1, 1, 10, 0),
            ConceptEnum.POSITIVE,
            encounterId);

        encounterId  = testDataGenerator.tbForm.setDateBaselineAssessment(
            patientId,
            new LocalDateTime(2020, 1, 6, 10, 0),
            new LocalDate(2020, 1, 6),
            null);

        testDataGenerator.tbForm.setTBScreened(
            patientId,
            new LocalDateTime(2020, 1, 6, 10, 0),
            ConceptEnum.YES,
            encounterId);
        
        testDataGenerator.tbForm.setMTBConfirmation(
            patientId,
            new LocalDateTime(2020, 1, 6, 10, 0),
            ConceptEnum.MTB_NOT_CONFIRMED,
            encounterId);

        // Execute
		String query = readReportQuery(
            ReportEnum.GEORGETOWN_TB_REPORT,
            "georgetownTbReport.sql",
            new LocalDate(2020, 1, 1),
            new LocalDate(2020, 1, 31)
        );
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
		assertEquals(result.size(), 0);
    }
}
