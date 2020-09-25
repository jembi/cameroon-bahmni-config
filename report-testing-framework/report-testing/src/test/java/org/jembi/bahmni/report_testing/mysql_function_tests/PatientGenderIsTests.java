package org.jembi.bahmni.report_testing.mysql_function_tests;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;
import org.joda.time.LocalDate;
import org.junit.Test;
import static org.junit.Assert.*;

public class PatientGenderIsTests extends BaseReportTest {
	@Test
	public void shouldReturnOneWhenPatientIsMale() throws Exception {
		// Prepare
		int personId = testDataGenerator.registration.createPerson(GenderEnum.MALE, new LocalDate(2000, 9, 1), "Leon", "Aziza");

		// Execute
		String query = "SELECT patientGenderIs(" + personId + ", '" + GenderEnum.MALE + "')";
		String result = getFunctionCallResult(query);

		// Assert
		assertEquals(result, "1");
	}

	@Test
	public void shouldReturnOneWhenPatientIsFemale() throws Exception {
		// Prepare
		int personId = testDataGenerator.registration.createPerson(GenderEnum.FEMALE, new LocalDate(2000, 9, 1), "Louise", "Palaku");

		// Execute
		String query = "SELECT patientGenderIs(" + personId + ", '" + GenderEnum.FEMALE + "')";
		String result = getFunctionCallResult(query);

		// Assert
		assertEquals(result, "1");
	}

	@Test
	public void shouldReturnZeroWhenPatientIsNotMale() throws Exception {
		// Prepare
		int personId = testDataGenerator.registration.createPerson(GenderEnum.FEMALE, new LocalDate(2000, 9, 1), "Jeff", "Wena");

		// Execute
		String query = "SELECT patientGenderIs(" + personId + ", '" + GenderEnum.MALE + "')";
		String result = getFunctionCallResult(query);

		// Assert
		assertEquals(result, "0");
	}

	@Test
	public void shouldReturnZeroWhenPatientIsNotFemale() throws Exception {
		// Prepare
		int personId = testDataGenerator.registration.createPerson(GenderEnum.MALE, new LocalDate(2000, 9, 1), "Chris", "Kutamina");

		// Execute
		String query = "SELECT patientGenderIs(" + personId + ", '" + GenderEnum.FEMALE + "')";
		String result = getFunctionCallResult(query);

		// Assert
		assertEquals(result, "0");
	}
}
