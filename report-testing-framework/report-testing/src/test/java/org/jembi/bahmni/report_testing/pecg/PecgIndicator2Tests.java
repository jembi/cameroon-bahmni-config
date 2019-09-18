package org.jembi.bahmni.report_testing.pecg;

import static org.junit.Assert.assertEquals;

import java.sql.ResultSet;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
import org.jembi.bahmni.report_testing.test_utils.models.DrugNameEnum;
import org.jembi.bahmni.report_testing.test_utils.models.DurationUnitEnum;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;
import org.jembi.bahmni.report_testing.test_utils.models.IndicatorTypeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.TherapeuticLineEnum;
import org.jembi.bahmni.report_testing.test_utils.models.VisitTypeEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.junit.Test;

public class PecgIndicator2Tests extends BaseReportTest{
	@Test
	public void shouldCountPatient() throws Exception {
		// Prepare
		int patientId = testDataGenerator.createPatient(GenderEnum.MALE, new LocalDate(2000, 9, 1));
		int encounterId = testDataGenerator.startVisit(patientId, VisitTypeEnum.OPD);
		testDataGenerator.enrollPatientIntoHIVProgram(patientId, new LocalDate(2019, 8, 1), TherapeuticLineEnum.FIRST_LINE);
		testDataGenerator.setARVStartDate(patientId, new LocalDate(2019, 8, 1));
		int orderId = testDataGenerator.orderDrug(patientId, encounterId, DrugNameEnum.ABC_3TC_120_60MG, new LocalDateTime(2019, 9, 1, 8, 0, 0), 2, DurationUnitEnum.MONTH);
		testDataGenerator.dispenseDrugOrder(patientId, orderId);

		// Execute
		String query = readReportQuery(IndicatorTypeEnum.PECG_REPORT, "indicator2_ARV_old_treatment.sql", new LocalDate(2019, 9, 1), new LocalDate(2019, 9, 30));
		ResultSet result = getIndicatorResult(query);

		// Assert
		assertEquals(result.getString("Title"), "Number of old PLWHA on ARV who came for treatment in the month");
		assertEquals(result.getInt("<1 M"), 1);
		assertEquals(result.getInt("<1 F"), 0);
		assertEquals(result.getInt("1-4 M"), 0);
		assertEquals(result.getInt("1-4 F"), 0);
		assertEquals(result.getInt("5-9 M"), 0);
		assertEquals(result.getInt("5-9 F"), 0);
		assertEquals(result.getInt("10-14 M"), 0);
		assertEquals(result.getInt("10-14 F"), 0);
		assertEquals(result.getInt("15-19 M"), 1);
		assertEquals(result.getInt("15-19 F"), 0);
		assertEquals(result.getInt("20-24 M"), 0);
		assertEquals(result.getInt("20-24 F"), 0);
		assertEquals(result.getInt("25-49 M"), 0);
		assertEquals(result.getInt("25-49 F"), 0);
		assertEquals(result.getInt(">=50 M"), 0);
		assertEquals(result.getInt(">=50 F"), 0);
	}
}
