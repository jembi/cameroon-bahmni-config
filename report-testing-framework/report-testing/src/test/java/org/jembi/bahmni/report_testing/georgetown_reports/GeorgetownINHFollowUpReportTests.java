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
import org.jembi.bahmni.report_testing.test_utils.models.VisitTypeEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.joda.time.Years;
import org.junit.Test;

public class GeorgetownINHFollowUpReportTests extends BaseReportTest {
    /** A patient with a full INH course that has started and ended
     * within the reporting period should be included in the report */
    @Test
    public void patientWithFullINHCourseThatStartedAndEndedWithinReportingPeriod_shouldBeIncludedInTheReport() throws Exception {
        // Prepare
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            null,
            "ART 123"
        );

        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2019, 12, 15),
            ConceptEnum.WHO_STAGE_1,
            null,
            new LocalDate(2019, 12, 20),
            "Name of APS"
        );

        int encounterId = testDataGenerator.startVisit(
            patientId,
            new LocalDate(2019, 12, 15),
            VisitTypeEnum.VISIT_TYPE_OPD
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_100MG,
            new LocalDateTime(2020, 1, 1, 10, 0),
            1,
            DurationUnitEnum.MONTH,
            true
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_100MG,
            new LocalDateTime(2020, 3, 1, 10, 0),
            2,
            DurationUnitEnum.MONTH,
            true
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_100MG,
            new LocalDateTime(2020, 5, 1, 10, 0),
            3,
            DurationUnitEnum.MONTH,
            true
        );

		// Execute
		String query = readReportQuery(
            ReportEnum.GEORGETOWN_INH_FOLLOW_UP_REPORT,
            "georgetownInhFollowUpReport.sql",
            new LocalDate(2020, 1, 1),
            new LocalDate(2020, 8, 1)
        );
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
		assertEquals(result.get(0).get("serialNumber"), "1");
		assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
		assertEquals(result.get(0).get("artCode"), "ART 123");
		assertEquals(result.get(0).get("age"), Years.yearsBetween(new LocalDate(2000, 1, 15), LocalDate.now()).getYears() + "");
		assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
		assertEquals(result.get(0).get("sex"), "f");
		assertEquals(result.get(0).get("dateOfArtInitiation"), "2019-12-20");
		assertEquals(result.get(0).get("scheduled_date").toString(), "2020-01-01 10:00:00.0");
		assertEquals(result.get(0).get("inhEndDate"), "2020-08-01");
		assertEquals(result.get(0).get("APS Name"), "Name of APS");
    }

    /** A patient with a full INH course that has started before the reporting period
     *  and ended within the reporting period should be included in the report */
    @Test
    public void patientWithFullINHCourseThatStartedBeforeReportingPeriodAndEndedWithinReportingPeriod_shouldBeIncludedInTheReport() throws Exception {
        // Prepare
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            null,
            "ART 123"
        );

        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2019, 12, 15),
            ConceptEnum.WHO_STAGE_1,
            null,
            new LocalDate(2019, 12, 20)
        );

        int encounterId = testDataGenerator.startVisit(
            patientId,
            new LocalDate(2019, 12, 15),
            VisitTypeEnum.VISIT_TYPE_OPD
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_100MG,
            new LocalDateTime(2020, 1, 1, 10, 0),
            1,
            DurationUnitEnum.MONTH,
            true
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_100MG,
            new LocalDateTime(2020, 3, 1, 10, 0),
            2,
            DurationUnitEnum.MONTH,
            true
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_100MG,
            new LocalDateTime(2020, 5, 1, 10, 0),
            3,
            DurationUnitEnum.MONTH,
            true
        );

		// Execute
		String query = readReportQuery(
            ReportEnum.GEORGETOWN_INH_FOLLOW_UP_REPORT,
            "georgetownInhFollowUpReport.sql",
            new LocalDate(2020, 6, 1),
            new LocalDate(2020, 8, 1)
        );
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
		assertEquals(result.get(0).get("serialNumber"), "1");
		assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
		assertEquals(result.get(0).get("artCode"), "ART 123");
		assertEquals(result.get(0).get("age"), Years.yearsBetween(new LocalDate(2000, 1, 15), LocalDate.now()).getYears() + "");
		assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
		assertEquals(result.get(0).get("sex"), "f");
		assertEquals(result.get(0).get("dateOfArtInitiation"), "2019-12-20");
		assertEquals(result.get(0).get("scheduled_date").toString(), "2020-01-01 10:00:00.0");
		assertEquals(result.get(0).get("inhEndDate"), "2020-08-01");
    }

    /** A patient with 2 full INH courses should be printed in 2 records */
    @Test
    public void patientWith2FullINHCourses_shouldReportedIn2Records() throws Exception {
        // Prepare
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            null,
            "ART 123"
        );

        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2019, 12, 15),
            ConceptEnum.WHO_STAGE_1,
            null,
            new LocalDate(2019, 12, 20)
        );

        int encounterId = testDataGenerator.startVisit(
            patientId,
            new LocalDate(2019, 12, 15),
            VisitTypeEnum.VISIT_TYPE_OPD
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_100MG,
            new LocalDateTime(2020, 1, 1, 10, 0),
            2,
            DurationUnitEnum.MONTH,
            true
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_100MG,
            new LocalDateTime(2020, 3, 1, 10, 0),
            2,
            DurationUnitEnum.MONTH,
            true
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_100MG,
            new LocalDateTime(2020, 5, 1, 10, 0),
            2,
            DurationUnitEnum.MONTH,
            true
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_300MG,
            new LocalDateTime(2020, 7, 1, 10, 0),
            1,
            DurationUnitEnum.MONTH,
            true
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_300MG,
            new LocalDateTime(2020, 8, 1, 10, 0),
            3,
            DurationUnitEnum.MONTH,
            true
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_300MG,
            new LocalDateTime(2020, 11, 1, 10, 0),
            2,
            DurationUnitEnum.MONTH,
            true
        );

		// Execute
		String query = readReportQuery(
            ReportEnum.GEORGETOWN_INH_FOLLOW_UP_REPORT,
            "georgetownInhFollowUpReport.sql",
            new LocalDate(2020, 1, 1),
            new LocalDate(2021, 1, 1)
        );
        
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.size(), 2);
		assertEquals(result.get(0).get("serialNumber"), "1");
		assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
		assertEquals(result.get(0).get("artCode"), "ART 123");
		assertEquals(result.get(0).get("age"), Years.yearsBetween(new LocalDate(2000, 1, 15), LocalDate.now()).getYears() + "");
		assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
		assertEquals(result.get(0).get("sex"), "f");
		assertEquals(result.get(0).get("dateOfArtInitiation"), "2019-12-20");
		assertEquals(result.get(0).get("scheduled_date").toString(), "2020-01-01 10:00:00.0");
		assertEquals(result.get(0).get("inhEndDate"), "2020-07-01");
		assertEquals(result.get(1).get("serialNumber"), "2");
		assertEquals(result.get(1).get("uniquePatientId"), "BAH203001");
		assertEquals(result.get(1).get("artCode"), "ART 123");
		assertEquals(result.get(1).get("age"), Years.yearsBetween(new LocalDate(2000, 1, 15), LocalDate.now()).getYears() + "");
		assertEquals(result.get(1).get("dateOfBirth"), "2000-01-15");
		assertEquals(result.get(1).get("sex"), "f");
		assertEquals(result.get(1).get("dateOfArtInitiation"), "2019-12-20");
		assertEquals(result.get(1).get("scheduled_date").toString(), "2020-07-01 10:00:00.0");
		assertEquals(result.get(1).get("inhEndDate"), "2021-01-01");
    }

    /** a patient that has been prescribed a partial course of INH (i.e. less than 6 months)
     * should NOT be included in the report */
    @Test
    public void patientWithPartialINHCourse_shouldNotBeIncludedInTheReport() throws Exception {
        // Prepare
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            null,
            "ART 123"
        );

        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2019, 12, 15),
            ConceptEnum.WHO_STAGE_1,
            null,
            new LocalDate(2019, 12, 20)
        );

        int encounterId = testDataGenerator.startVisit(
            patientId,
            new LocalDate(2019, 12, 15),
            VisitTypeEnum.VISIT_TYPE_OPD
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_100MG,
            new LocalDateTime(2020, 1, 1, 10, 0),
            1,
            DurationUnitEnum.MONTH,
            true
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_100MG,
            new LocalDateTime(2020, 3, 1, 10, 0),
            2,
            DurationUnitEnum.MONTH,
            true
        );

		// Execute
		String query = readReportQuery(
            ReportEnum.GEORGETOWN_INH_FOLLOW_UP_REPORT,
            "georgetownInhFollowUpReport.sql",
            new LocalDate(2020, 1, 1),
            new LocalDate(2020, 8, 1)
        );
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
		assertEquals(result.size(), 0);
    }

    /** a patient that has been prescribed a full INH course
     * but without the drug being dispensed
     * should NOT be included in the report */
    @Test
    public void patientWithFullNonDispensedINHCourse_shouldBeNotBeIncludedInTheReport() throws Exception {
        // Prepare
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            null,
            "ART 123"
        );

        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2019, 12, 15),
            ConceptEnum.WHO_STAGE_1,
            null,
            new LocalDate(2019, 12, 20)
        );

        int encounterId = testDataGenerator.startVisit(
            patientId,
            new LocalDate(2019, 12, 15),
            VisitTypeEnum.VISIT_TYPE_OPD
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_100MG,
            new LocalDateTime(),
            6,
            DurationUnitEnum.MONTH,
            false // INH not dispensed
        );

		// Execute
		String query = readReportQuery(
            ReportEnum.GEORGETOWN_INH_FOLLOW_UP_REPORT,
            "georgetownInhFollowUpReport.sql",
            new LocalDate(2020, 1, 1),
            new LocalDate(2100, 8, 1)
        );
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
		assertEquals(result.size(), 0);
    }

    /** a patient that has started an INH course but has not completed
     * a full course by the report end date 
     * should NOT be included in the report */
    @Test
    public void patientWithFullINHCourseThatIsNotCompletedByEndOfReportingPeriod_shouldNotBeIncludedInTheReport() throws Exception {
        // Prepare
        int patientId = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(2000, 1, 15),
            "Marie",
            "Tambwe",
            null,
            "ART 123"
        );

        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientId,
            new LocalDate(2019, 12, 15),
            ConceptEnum.WHO_STAGE_1,
            null,
            new LocalDate(2019, 12, 20)
        );

        int encounterId = testDataGenerator.startVisit(
            patientId,
            new LocalDate(2019, 12, 15),
            VisitTypeEnum.VISIT_TYPE_OPD
        );
        testDataGenerator.drug.orderDrug(
            patientId,
            encounterId,
            DrugNameEnum.INH_100MG,
            new LocalDateTime(2020, 1, 1, 10, 0),
            6,
            DurationUnitEnum.MONTH,
            true
        );

		// Execute
		String query = readReportQuery(
            ReportEnum.GEORGETOWN_INH_FOLLOW_UP_REPORT,
            "georgetownInhFollowUpReport.sql",
            new LocalDate(2020, 1, 1),
            new LocalDate(2020, 6, 1)
        );
		List<Map<String,Object>> result = getReportResult(query);

        // Assert
		assertEquals(result.size(), 0);
    }

}
