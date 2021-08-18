package org.jembi.bahmni.report_testing.georgetown_reports;

import static org.junit.Assert.assertEquals;

import java.util.List;
import java.util.Map;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
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
import org.junit.Ignore;

public class GeorgetownViralLoadReportTests extends BaseReportTest {
    @Test
    public void patientEligibleForVL_shouldBeReported() throws Exception {
        // Prepare
        /* record patient information */
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            "ART 123"
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

        /* start an OPD visit */
        int encounterIdOpdVisit = testDataGenerator.startVisit(
            patientId,
            new LocalDate(2020, 1, 1),
            VisitTypeEnum.VISIT_TYPE_OPD
        );

        /* record VL test */
        testDataGenerator.manualLabAndResultForm.setRoutineViralLoadTestDateAndResult(
            patientId,
            new LocalDateTime(2019, 3, 1, 8, 0),
            new LocalDate(2019, 3, 1),
            800,
            null);

        /* enroll into the HIV program */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 2),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.SECOND_LINE,
            new LocalDate(2020, 1, 3)
        );

        /* enroll into the EAC program */
        int patientProgramId = testDataGenerator.program.enrollPatientIntoEACProgram(
            patientId,
            new LocalDate(2020, 1, 5),
            ConceptEnum.EAC_1);
        testDataGenerator.program.recordProgramOutcome(
            patientProgramId,
            ConceptEnum.CONTINUE_SAME_ART_REGIMEN,
            new LocalDate(2020, 1, 28));

        /* dispense ARV */
        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.ABC_3TC_120_60MG,
			new LocalDateTime(2020, 1, 4, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.INH_100MG,
			new LocalDateTime(2020, 2, 4, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_VIRAL_LOAD_REPORT, "georgetownViralLoadReport.sql",
                new LocalDate(2019, 3, 1), new LocalDate(2020, 3, 1));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("artCode"), "ART 123");
        assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
        assertEquals(result.get(0).get("healthFacility"), "CENTRE");
        assertEquals(result.get(0).get("artStartDate"), "2020-01-03");
        assertEquals(result.get(0).get("age"),
            Years.yearsBetween(new LocalDate(2000, 1, 15), LocalDate.now()).getYears() + "");
        assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("telephone"), "081234567");
        assertEquals(result.get(0).get("address"), "14 BAMBI STR, NKUM");
        assertEquals(result.get(0).get("treatmentRegimen"), "ABC/3TC 120/60mg");
        assertEquals(result.get(0).get("lineAtTheMomentOfVL"), "N/A");
        assertEquals(result.get(0).get("eligibilityDate"), "2019-09-01");
        assertEquals(result.get(0).get("sampleCollectionDate"), "N/A");
        assertEquals(result.get(0).get("resultDate"), "2019-03-01");
        assertEquals(result.get(0).get("vlResult"), 800);
        assertEquals(result.get(0).get("dateResultGivenToPatient"), "2020-01-01");
        assertEquals(result.get(0).get("reasonVLRequest"), "Routine");
        assertEquals(result.get(0).get("eacDone"), "Yes");
        assertEquals(result.get(0).get("eacStartDate"), "2020-01-05");
        assertEquals(result.get(0).get("eacEndDate"), "2020-01-28");
        assertEquals(result.get(0).get("numberOfEacDone"), "EAC 1");
    }

    /**
     * The patient doesn’t have an ARV initiation date;
     * the patient is not in EAC program and hasn’t been on treatment for a year.
     * The eligibility date should be 6 months after the date of the last VL exam
     */
    @Test
    public void patientWithNoARVInitiationAndNotInEacProgram_shouldBeReportedWithVLEligibility6MonthsAfterLastVL() throws Exception {
        // Prepare
        /* record patient information */
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
            new LocalDate(2020, 1, 1),
            VisitTypeEnum.VISIT_TYPE_OPD
        );

        /* enroll into the HIV program */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 2),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.SECOND_LINE,
            new LocalDate(2020, 1, 3)
        );

        /* record VL test */
        testDataGenerator.manualLabAndResultForm.setRoutineViralLoadTestDateAndResult(
            patientId,
            new LocalDateTime(2019, 4, 1, 8, 0),
            new LocalDate(2019, 4, 1),
            800,
            null);

        /* dispense ARV */
        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.ABC_3TC_120_60MG,
			new LocalDateTime(2020, 1, 4, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.INH_100MG,
			new LocalDateTime(2020, 2, 4, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_VIRAL_LOAD_REPORT, "georgetownViralLoadReport.sql",
                new LocalDate(2019, 3, 1), new LocalDate(2020, 3, 1));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("artCode"), "ART 123");
        assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
        assertEquals(result.get(0).get("healthFacility"), "CENTRE");
        assertEquals(result.get(0).get("artStartDate"), "2020-01-03");
        assertEquals(result.get(0).get("age"),
            Years.yearsBetween(new LocalDate(2000, 1, 15), LocalDate.now()).getYears() + "");
        assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("telephone"), "081234567");
        assertEquals(result.get(0).get("address"), null);
        assertEquals(result.get(0).get("treatmentRegimen"), "ABC/3TC 120/60mg");
        assertEquals(result.get(0).get("lineAtTheMomentOfVL"), "N/A");
        assertEquals(result.get(0).get("eligibilityDate"), "2019-10-01");
        assertEquals(result.get(0).get("sampleCollectionDate"), "N/A");
        assertEquals(result.get(0).get("resultDate"), "2019-04-01");
        assertEquals(result.get(0).get("vlResult"), 800);
        assertEquals(result.get(0).get("dateResultGivenToPatient"), "2020-01-01");
        assertEquals(result.get(0).get("reasonVLRequest"), "Routine");
        assertEquals(result.get(0).get("eacDone"), "No");
        assertEquals(result.get(0).get("eacStartDate"), null);
        assertEquals(result.get(0).get("eacEndDate"), null);
        assertEquals(result.get(0).get("numberOfEacDone"), null);
    }

    /**
     * The patient does have an ARV initiation date;
     * and the last VL test was done while the patient was enrolled on the EAC program.
     * The eligibility date should be 3 months after the date of the last VL exam
     */
    @Test
    public void patientNotInitiatedToARVWithVLDoneWhileOnEACProgram_shouldBeReportedWithVLEligibility3MonthsAfterVL() throws Exception {
        // Prepare
        /* record patient information */
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
            new LocalDate(2020, 1, 1),
            VisitTypeEnum.VISIT_TYPE_OPD
        );

        /* enroll into the HIV program */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 2),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.SECOND_LINE,
            new LocalDate(2020, 1, 3)
        );

        /* record VL test */
        testDataGenerator.manualLabAndResultForm.setRoutineViralLoadTestDateAndResult(
            patientId,
            new LocalDateTime(2020, 1, 15, 8, 0),
            new LocalDate(2020, 1, 15),
            800,
            null);

        /* enroll into the EAC program */
        int patientProgramId = testDataGenerator.program.enrollPatientIntoEACProgram(
            patientId,
            new LocalDate(2020, 1, 5),
            ConceptEnum.EAC_1);
        testDataGenerator.program.recordProgramOutcome(
            patientProgramId,
            ConceptEnum.CONTINUE_SAME_ART_REGIMEN,
            new LocalDate(2020, 1, 28));

        /* dispense ARV */
        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.ABC_3TC_120_60MG,
			new LocalDateTime(2020, 1, 4, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.INH_100MG,
			new LocalDateTime(2020, 2, 4, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_VIRAL_LOAD_REPORT, "georgetownViralLoadReport.sql",
                new LocalDate(2019, 5, 1), new LocalDate(2020, 5, 1));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("artCode"), "ART 123");
        assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
        assertEquals(result.get(0).get("healthFacility"), "CENTRE");
        assertEquals(result.get(0).get("artStartDate"), "2020-01-03");
        assertEquals(result.get(0).get("age"),
            Years.yearsBetween(new LocalDate(2000, 1, 15), LocalDate.now()).getYears() + "");
        assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("telephone"), "081234567");
        assertEquals(result.get(0).get("address"), null);
        assertEquals(result.get(0).get("treatmentRegimen"), "ABC/3TC 120/60mg");
        assertEquals(result.get(0).get("lineAtTheMomentOfVL"), "N/A");
        assertEquals(result.get(0).get("eligibilityDate"), "2020-04-15");
        assertEquals(result.get(0).get("sampleCollectionDate"), "N/A");
        assertEquals(result.get(0).get("resultDate"), "2020-01-15");
        assertEquals(result.get(0).get("vlResult"), 800);
        assertEquals(result.get(0).get("dateResultGivenToPatient"), null);
        assertEquals(result.get(0).get("reasonVLRequest"), "Routine");
        assertEquals(result.get(0).get("eacDone"), "Yes");
        assertEquals(result.get(0).get("eacStartDate"), "2020-01-05");
        assertEquals(result.get(0).get("eacEndDate"), "2020-01-28");
        assertEquals(result.get(0).get("numberOfEacDone"), "EAC 1");
    }

    /**
     * The patient does have an ARV initiation date;
     * and the last VL test was done while the patient was enrolled on the EAC program that hasn't ended yet.
     * The eligibility date should be 3 months after the date of the last VL exam
     */
    @Test
    public void patientNotInitiatedToARVWithVLDoneWhileOnEACProgramNotEnded_shouldBeReportedWithVLEligibility3MonthsAfterVL() throws Exception {
        // Prepare
        /* record patient information */
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
            new LocalDate(2020, 1, 1),
            VisitTypeEnum.VISIT_TYPE_OPD
        );

        /* enroll into the HIV program */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 2),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.SECOND_LINE,
            new LocalDate(2020, 1, 3)
        );

        /* record VL test */
        testDataGenerator.manualLabAndResultForm.setRoutineViralLoadTestDateAndResult(
            patientId,
            new LocalDateTime(2020, 1, 15, 8, 0),
            new LocalDate(2020, 1, 15),
            800,
            null);

        /* enroll into the EAC program */
        testDataGenerator.program.enrollPatientIntoEACProgram(
            patientId,
            new LocalDate(2020, 1, 5),
            ConceptEnum.EAC_1);

        /* dispense ARV */
        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.ABC_3TC_120_60MG,
			new LocalDateTime(2020, 1, 4, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.INH_100MG,
			new LocalDateTime(2020, 2, 4, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_VIRAL_LOAD_REPORT, "georgetownViralLoadReport.sql",
                new LocalDate(2019, 5, 1), new LocalDate(2020, 5, 1));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("artCode"), "ART 123");
        assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
        assertEquals(result.get(0).get("healthFacility"), "CENTRE");
        assertEquals(result.get(0).get("artStartDate"), "2020-01-03");
        assertEquals(result.get(0).get("age"),
            Years.yearsBetween(new LocalDate(2000, 1, 15), LocalDate.now()).getYears() + "");
        assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("telephone"), "081234567");
        assertEquals(result.get(0).get("address"), null);
        assertEquals(result.get(0).get("treatmentRegimen"), "ABC/3TC 120/60mg");
        assertEquals(result.get(0).get("lineAtTheMomentOfVL"), "N/A");
        assertEquals(result.get(0).get("eligibilityDate"), "2020-04-15");
        assertEquals(result.get(0).get("sampleCollectionDate"), "N/A");
        assertEquals(result.get(0).get("resultDate"), "2020-01-15");
        assertEquals(result.get(0).get("vlResult"), 800);
        assertEquals(result.get(0).get("dateResultGivenToPatient"), null);
        assertEquals(result.get(0).get("reasonVLRequest"), "Routine");
        assertEquals(result.get(0).get("eacDone"), "Yes");
        assertEquals(result.get(0).get("eacStartDate"), "2020-01-05");
        assertEquals(result.get(0).get("eacEndDate"), null);
        assertEquals(result.get(0).get("numberOfEacDone"), "EAC 1");
    }

    /**
     * The patient doesn’t have an ARV initiation date;
     * they have been on treatment for a year and the last VL result is less than 1000 copies.
     * The eligibility date should be 1 year after the last VL exam
     */
    @Test
    public void patientNotInitiatedToARVWhoHaveBeenOnTreatmentForAYear_shouldBeReportedWithEligibilityDateOneYearAfterVL() throws Exception {
        // Prepare
        /* record patient information */
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
            new LocalDate(2020, 1, 1),
            VisitTypeEnum.VISIT_TYPE_OPD
        );

        /* enroll into the HIV program */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 2),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.SECOND_LINE,
            new LocalDate(2020, 1, 3)
        );

        /* record VL test */
        testDataGenerator.manualLabAndResultForm.setRoutineViralLoadTestDateAndResult(
            patientId,
            new LocalDateTime(2019, 3, 1, 8, 0),
            new LocalDate(2019, 3, 1),
            800,
            null);

        /* enroll into the EAC program */
        int patientProgramId = testDataGenerator.program.enrollPatientIntoEACProgram(
            patientId,
            new LocalDate(2020, 1, 5),
            ConceptEnum.EAC_1);
        testDataGenerator.program.recordProgramOutcome(
            patientProgramId,
            ConceptEnum.CONTINUE_SAME_ART_REGIMEN,
            new LocalDate(2020, 1, 28));

        /* dispense ARV */
        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.ABC_3TC_120_60MG,
			new LocalDateTime(2019, 1, 4, 8, 0, 0),
			12,
			DurationUnitEnum.MONTH,
			true
        );

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_VIRAL_LOAD_REPORT, "georgetownViralLoadReport.sql",
                new LocalDate(2019, 3, 1), new LocalDate(2020, 3, 1));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("artCode"), "ART 123");
        assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
        assertEquals(result.get(0).get("healthFacility"), "CENTRE");
        assertEquals(result.get(0).get("artStartDate"), "2020-01-03");
        assertEquals(result.get(0).get("age"),
            Years.yearsBetween(new LocalDate(2000, 1, 15), LocalDate.now()).getYears() + "");
        assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("telephone"), "081234567");
        assertEquals(result.get(0).get("address"), null);
        assertEquals(result.get(0).get("treatmentRegimen"), "ABC/3TC 120/60mg");
        assertEquals(result.get(0).get("lineAtTheMomentOfVL"), "N/A");
        assertEquals(result.get(0).get("eligibilityDate"), "2020-03-01");
        assertEquals(result.get(0).get("sampleCollectionDate"), "N/A");
        assertEquals(result.get(0).get("resultDate"), "2019-03-01");
        assertEquals(result.get(0).get("vlResult"), 800);
        assertEquals(result.get(0).get("dateResultGivenToPatient"), "2020-01-01");
        assertEquals(result.get(0).get("reasonVLRequest"), "Routine");
        assertEquals(result.get(0).get("eacDone"), "Yes");
        assertEquals(result.get(0).get("eacStartDate"), "2020-01-05");
        assertEquals(result.get(0).get("eacEndDate"), "2020-01-28");
        assertEquals(result.get(0).get("numberOfEacDone"), "EAC 1");
    }

    /** 
     * The patient doesn’t have any previous VL exam
     * and have never been enrolled into the EAC program;
     * and they have an ARV initiation date.
     * The eligibility date should be 6 months after the date ARV initiation
     */
    @Ignore
    public void patientInitiatedToARVAndNotInEACProgramAndWithNoPreviousVLExam_shouldBeReportedWithVLEligibilityDate6MonthsAfterARVInitiation() throws Exception {
        // Prepare
        /* record patient information */
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
            new LocalDate(2020, 1, 1),
            VisitTypeEnum.VISIT_TYPE_OPD
        );

        /* enroll into the HIV program */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 2),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.SECOND_LINE,
            new LocalDate(2020, 1, 3)
        );

        /* dispense ARV */
        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.ABC_3TC_120_60MG,
			new LocalDateTime(2020, 1, 4, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.INH_100MG,
			new LocalDateTime(2020, 2, 4, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_VIRAL_LOAD_REPORT, "georgetownViralLoadReport.sql",
                new LocalDate(2019, 8, 1), new LocalDate(2020, 8, 1));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("serialNumber"), "1");
        assertEquals(result.get(0).get("artCode"), "ART 123");
        assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
        assertEquals(result.get(0).get("healthFacility"), "CENTRE");
        assertEquals(result.get(0).get("artStartDate"), "2020-01-03");
        assertEquals(result.get(0).get("age"),
            Years.yearsBetween(new LocalDate(2000, 1, 15), LocalDate.now()).getYears() + "");
        assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("telephone"), "081234567");
        assertEquals(result.get(0).get("address"), null);
        assertEquals(result.get(0).get("treatmentRegimen"), "ABC/3TC 120/60mg");
        assertEquals(result.get(0).get("lineAtTheMomentOfVL"), "N/A");
        assertEquals(result.get(0).get("eligibilityDate"), "2020-07-03");
        assertEquals(result.get(0).get("sampleCollectionDate"), "N/A");
        assertEquals(result.get(0).get("resultDate"), null);
        assertEquals(result.get(0).get("vlResult"), null);
        assertEquals(result.get(0).get("dateResultGivenToPatient"), null);
        assertEquals(result.get(0).get("reasonVLRequest"), null);
        assertEquals(result.get(0).get("eacDone"), "No");
        assertEquals(result.get(0).get("eacStartDate"), null);
        assertEquals(result.get(0).get("eacEndDate"), null);
        assertEquals(result.get(0).get("numberOfEacDone"), null);
    }

    /**
     * The patient doesn’t have any previous VL exam;
     * have never been enrolled into the EAC program;
     * and doesn’t have an ARV initiation date.
     * The patient won’t be included into the report because there is no eligibility date.
     */
    @Test
    public void patientWithNoPreviousVLAndNeverInEACProgramAndNotInitiatedToARV_shouldNOTBeReported() throws Exception {
        // Prepare
        /* record patient information */
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
        testDataGenerator.startVisit(
            patientId,
            new LocalDate(2020, 1, 1),
            VisitTypeEnum.VISIT_TYPE_OPD
        );

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_VIRAL_LOAD_REPORT, "georgetownViralLoadReport.sql",
                new LocalDate(2019, 3, 1), new LocalDate(2020, 3, 1));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.size(), 0);
    }

    /**
     * when the calculated eligibility date is out of the reporting period,
     * the patient should not be included into the report
     */
    @Test
    public void patientWithVLEligibleDateOutOfReportingPeriod_shouldNOTBeReported() throws Exception {
        // Prepare
        /* record patient information */
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            "ART 123"
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

        /* start an OPD visit */
        int encounterIdOpdVisit = testDataGenerator.startVisit(
            patientId,
            new LocalDate(2020, 1, 1),
            VisitTypeEnum.VISIT_TYPE_OPD
        );

        /* record VL test */
        testDataGenerator.manualLabAndResultForm.setRoutineViralLoadTestDateAndResult(
            patientId,
            new LocalDateTime(2019, 3, 1, 8, 0),
            new LocalDate(2019, 3, 1),
            800,
            null);

        /* enroll into the HIV program */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 2),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.SECOND_LINE,
            new LocalDate(2020, 1, 3)
        );

        /* enroll into the EAC program */
        int patientProgramId = testDataGenerator.program.enrollPatientIntoEACProgram(
            patientId,
            new LocalDate(2020, 1, 5),
            ConceptEnum.EAC_1);
        testDataGenerator.program.recordProgramOutcome(
            patientProgramId,
            ConceptEnum.CONTINUE_SAME_ART_REGIMEN,
            new LocalDate(2020, 1, 28));

        /* dispense ARV */
        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.ABC_3TC_120_60MG,
			new LocalDateTime(2020, 1, 4, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.INH_100MG,
			new LocalDateTime(2020, 2, 4, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_VIRAL_LOAD_REPORT, "georgetownViralLoadReport.sql",
                new LocalDate(2020, 2, 1), new LocalDate(2020, 3, 1));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.size(), 0);
    }

    /**
     * When a patient hasn’t visited the health facility after the result was available;
     * the column “Date of final results given to patient” should be empty
     */
    @Ignore
    public void patientEligibleForVLWhoHasntVisitedHospitalAfterVLResult_shouldBeReported() throws Exception {
        // Prepare
        /* record patient information */
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            "ART 123"
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

        /* Record an OPD visit that is before the VL Exam result */
        int encounterIdOpdVisit = testDataGenerator.startVisit(
            patientId,
            new LocalDate(2018, 1, 1),
            VisitTypeEnum.VISIT_TYPE_OPD
        );

        /* record VL test */
        testDataGenerator.manualLabAndResultForm.setRoutineViralLoadTestDateAndResult(
            patientId,
            new LocalDateTime(2019, 3, 1, 8, 0),
            new LocalDate(2019, 3, 1),
            800,
            null);

        /* enroll into the HIV program */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2020, 1, 2),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.SECOND_LINE,
            new LocalDate(2020, 1, 3)
        );

        /* enroll into the EAC program */
        int patientProgramId = testDataGenerator.program.enrollPatientIntoEACProgram(
            patientId,
            new LocalDate(2020, 1, 5),
            ConceptEnum.EAC_1);
        testDataGenerator.program.recordProgramOutcome(
            patientProgramId,
            ConceptEnum.CONTINUE_SAME_ART_REGIMEN,
            new LocalDate(2020, 1, 28));

        /* dispense ARV */
        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.ABC_3TC_120_60MG,
			new LocalDateTime(2020, 1, 4, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        testDataGenerator.drug.orderDrug(
			patientId,
			encounterIdOpdVisit,
			DrugNameEnum.INH_100MG,
			new LocalDateTime(2020, 2, 4, 8, 0, 0),
			1,
			DurationUnitEnum.MONTH,
			true
        );

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_VIRAL_LOAD_REPORT, "georgetownViralLoadReport.sql",
                new LocalDate(2019, 3, 1), new LocalDate(2020, 3, 1));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.get(0).get("serialNumber"), "1");
        assertEquals(result.get(0).get("artCode"), "ART 123");
        assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
        assertEquals(result.get(0).get("healthFacility"), "CENTRE");
        assertEquals(result.get(0).get("artStartDate"), "2020-01-03");
        assertEquals(result.get(0).get("age"),
            Years.yearsBetween(new LocalDate(2000, 1, 15), LocalDate.now()).getYears() + "");
        assertEquals(result.get(0).get("sex"), "f");
        assertEquals(result.get(0).get("telephone"), "081234567");
        assertEquals(result.get(0).get("address"), "14 BAMBI STR, NKUM");
        assertEquals(result.get(0).get("treatmentRegimen"), "ABC/3TC 120/60mg");
        assertEquals(result.get(0).get("lineAtTheMomentOfVL"), "N/A");
        assertEquals(result.get(0).get("eligibilityDate"), "2019-09-01");
        assertEquals(result.get(0).get("sampleCollectionDate"), "N/A");
        assertEquals(result.get(0).get("resultDate"), "2019-03-01");
        assertEquals(result.get(0).get("vlResult"), 800);
        assertEquals(result.get(0).get("dateResultGivenToPatient"), null);
        assertEquals(result.get(0).get("reasonVLRequest"), "Routine");
        assertEquals(result.get(0).get("eacDone"), "Yes");
        assertEquals(result.get(0).get("eacStartDate"), "2020-01-05");
        assertEquals(result.get(0).get("eacEndDate"), "2020-01-28");
        assertEquals(result.get(0).get("numberOfEacDone"), "EAC 1");
    }
}