package org.jembi.bahmni.report_testing.testing_report;

import java.sql.ResultSet;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
import org.jembi.bahmni.report_testing.test_utils.models.ConceptUuidEnum;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;
import org.jembi.bahmni.report_testing.test_utils.models.IndicatorTypeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.VisitTypeEnum;
import org.joda.time.LocalDate;
import org.junit.Test;

public class TestingIndicator5aTests extends BaseReportTest{
	@Test
	public void indicator5aIndex_TestedBeforeWithPositiveFinalResult_ShouldCountPatient() throws Exception {
        // Prepare
		int patientId = testDataGenerator.createPatient(GenderEnum.MALE, new LocalDate().minusYears(17));
		int encounterId = testDataGenerator.startVisit(patientId, VisitTypeEnum.OPD);
		testDataGenerator.setHivTestedBefore(patientId, encounterId, ConceptUuidEnum.YES);
		testDataGenerator.setHivTestDate(patientId, encounterId, new LocalDate());
		testDataGenerator.setTestingEntryPointAndModality(patientId, encounterId, ConceptUuidEnum.TESTING_ENTRY_POINT_AND_MODALITY_INDEX);
		testDataGenerator.setHivFinalTestResult(patientId, encounterId, ConceptUuidEnum.POSITIVE);

		// Execute
		String query = readReportQuery(
            IndicatorTypeEnum.TESTING_REPORT_HTS_RECENT,
            "indicator5a_index.sql",
            getFirstDayOfCurrentMonth(),
            getLastDayOfCurrentMonth());
		ResultSet result = getIndicatorResult(query);

		// Assert
		assertThatAllColumnsHaveZeroesExcept(result, "15-19 years M");
	}

	@Test
	public void indicator5aIndex_NotTestedBeforeWithPositiveFinalResult_ShouldCountPatient() throws Exception {
        // Prepare
		int patientId = testDataGenerator.createPatient(GenderEnum.FEMALE, new LocalDate().minusYears(22));
		int encounterId = testDataGenerator.startVisit(patientId, VisitTypeEnum.OPD);
		testDataGenerator.setHivTestedBefore(patientId, encounterId, ConceptUuidEnum.NO);
		testDataGenerator.setHivTestDate(patientId, encounterId, new LocalDate());
		testDataGenerator.setTestingEntryPointAndModality(patientId, encounterId, ConceptUuidEnum.TESTING_ENTRY_POINT_AND_MODALITY_INDEX);
		testDataGenerator.setHivFinalTestResult(patientId, encounterId, ConceptUuidEnum.POSITIVE);

		// Execute
		String query = readReportQuery(
            IndicatorTypeEnum.TESTING_REPORT_HTS_RECENT,
            "indicator5a_index.sql",
            getFirstDayOfCurrentMonth(),
            getLastDayOfCurrentMonth());
		ResultSet result = getIndicatorResult(query);

		// Assert
		assertThatAllColumnsHaveZeroesExcept(result, "20-24 years F");
	}

	@Test
	public void indicator5aIndex_WithPositiveFinalResult_ShouldCountPatient() throws Exception {
        // Prepare
		int patientId = testDataGenerator.createPatient(GenderEnum.MALE, new LocalDate().minusYears(55));
		int encounterId = testDataGenerator.startVisit(patientId, VisitTypeEnum.OPD);
		testDataGenerator.setHivTestDate(patientId, encounterId, new LocalDate());
		testDataGenerator.setTestingEntryPointAndModality(patientId, encounterId, ConceptUuidEnum.TESTING_ENTRY_POINT_AND_MODALITY_INDEX);
		testDataGenerator.setHivFinalTestResult(patientId, encounterId, ConceptUuidEnum.POSITIVE);

		// Execute
		String query = readReportQuery(
            IndicatorTypeEnum.TESTING_REPORT_HTS_RECENT,
            "indicator5a_index.sql",
            getFirstDayOfCurrentMonth(),
            getLastDayOfCurrentMonth());
		ResultSet result = getIndicatorResult(query);

		// Assert
		assertThatAllColumnsHaveZeroesExcept(result, ">=50 years M");
	}

	@Test
	public void indicator5aIndex_WithNegativeFinalResult_ShouldNotCountPatient() throws Exception {
        // Prepare
		int patientId = testDataGenerator.createPatient(GenderEnum.MALE, new LocalDate().minusYears(17));
		int encounterId = testDataGenerator.startVisit(patientId, VisitTypeEnum.OPD);
		testDataGenerator.setHivTestedBefore(patientId, encounterId, ConceptUuidEnum.YES);
		testDataGenerator.setHivTestDate(patientId, encounterId, new LocalDate());
		testDataGenerator.setTestingEntryPointAndModality(patientId, encounterId, ConceptUuidEnum.TESTING_ENTRY_POINT_AND_MODALITY_INDEX);
		testDataGenerator.setHivFinalTestResult(patientId, encounterId, ConceptUuidEnum.NEGATIVE);

		// Execute
		String query = readReportQuery(
            IndicatorTypeEnum.TESTING_REPORT_HTS_RECENT,
            "indicator5a_index.sql",
            getFirstDayOfCurrentMonth(),
            getLastDayOfCurrentMonth());
		ResultSet result = getIndicatorResult(query);

		// Assert
		assertThatAllColumnsHaveZeroes(result);
	}


	@Test
	public void indicator5aIndex_WithEntryPointNotIndex_ShouldNotCountPatient() throws Exception {
        // Prepare
		int patientId = testDataGenerator.createPatient(GenderEnum.MALE, new LocalDate().minusYears(17));
		int encounterId = testDataGenerator.startVisit(patientId, VisitTypeEnum.OPD);
		testDataGenerator.setHivTestedBefore(patientId, encounterId, ConceptUuidEnum.YES);
		testDataGenerator.setHivTestDate(patientId, encounterId, new LocalDate());
		testDataGenerator.setTestingEntryPointAndModality(patientId, encounterId, ConceptUuidEnum.TESTING_ENTRY_POINT_AND_MODALITY_IMPATIENT);
		testDataGenerator.setHivFinalTestResult(patientId, encounterId, ConceptUuidEnum.POSITIVE);

		// Execute
		String query = readReportQuery(
            IndicatorTypeEnum.TESTING_REPORT_HTS_RECENT,
            "indicator5a_index.sql",
            getFirstDayOfCurrentMonth(),
            getLastDayOfCurrentMonth());
		ResultSet result = getIndicatorResult(query);

		// Assert
		assertThatAllColumnsHaveZeroes(result);
	}

	@Test
	public void indicator5aIndex_WithTestDoneMoreThanAMonthAgo_ShouldNotCountPatient() throws Exception {
        // Prepare
		int patientId = testDataGenerator.createPatient(GenderEnum.MALE, new LocalDate().minusYears(17));
		int encounterId = testDataGenerator.startVisit(patientId, VisitTypeEnum.OPD);
		testDataGenerator.setHivTestedBefore(patientId, encounterId, ConceptUuidEnum.YES);
		testDataGenerator.setHivTestDate(patientId, encounterId, new LocalDate().minusMonths(2));
		testDataGenerator.setTestingEntryPointAndModality(patientId, encounterId, ConceptUuidEnum.TESTING_ENTRY_POINT_AND_MODALITY_INDEX);
		testDataGenerator.setHivFinalTestResult(patientId, encounterId, ConceptUuidEnum.POSITIVE);

		// Execute
		String query = readReportQuery(
            IndicatorTypeEnum.TESTING_REPORT_HTS_RECENT,
            "indicator5a_index.sql",
            getFirstDayOfCurrentMonth(),
            getLastDayOfCurrentMonth());
		ResultSet result = getIndicatorResult(query);

		// Assert
		assertThatAllColumnsHaveZeroes(result);
	}

	@Test
	public void indicator5aIndex_WithNoFinalTestResult_ShouldNotCountPatient() throws Exception {
        // Prepare
		int patientId = testDataGenerator.createPatient(GenderEnum.MALE, new LocalDate().minusYears(17));
		int encounterId = testDataGenerator.startVisit(patientId, VisitTypeEnum.OPD);
		testDataGenerator.setHivTestedBefore(patientId, encounterId, ConceptUuidEnum.YES);
		testDataGenerator.setHivTestDate(patientId, encounterId, new LocalDate());
		testDataGenerator.setTestingEntryPointAndModality(patientId, encounterId, ConceptUuidEnum.TESTING_ENTRY_POINT_AND_MODALITY_INDEX);

		// Execute
		String query = readReportQuery(
            IndicatorTypeEnum.TESTING_REPORT_HTS_RECENT,
            "indicator5a_index.sql",
            getFirstDayOfCurrentMonth(),
            getLastDayOfCurrentMonth());
		ResultSet result = getIndicatorResult(query);

		// Assert
		assertThatAllColumnsHaveZeroes(result);
	}
}