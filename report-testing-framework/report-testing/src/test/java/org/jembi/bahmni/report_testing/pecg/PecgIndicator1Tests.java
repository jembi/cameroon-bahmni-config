package org.jembi.bahmni.report_testing.pecg;

import static org.junit.Assert.assertEquals;

import java.util.List;
import java.util.Map;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
import org.jembi.bahmni.report_testing.test_utils.models.DrugNameEnum;
import org.jembi.bahmni.report_testing.test_utils.models.DurationUnitEnum;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ReportEnum;
import org.jembi.bahmni.report_testing.test_utils.models.TherapeuticLineEnum;
import org.jembi.bahmni.report_testing.test_utils.models.VisitTypeEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.junit.Test;

public class PecgIndicator1Tests extends BaseReportTest{
	@Test
	public void shouldCountPatient() throws Exception {
		// Prepare
		int patientId = testDataGenerator.registration.createPatient(GenderEnum.MALE, new LocalDate(2000, 9, 1), "Alex", "Durin");
		int encounterId = testDataGenerator.startVisit(patientId, new LocalDate(2019, 8, 1), VisitTypeEnum.VISIT_TYPE_OPD);
		testDataGenerator.program.enrollPatientIntoHIVProgram(
			patientId,
			new LocalDate(2019, 8, 1),
			null,
			TherapeuticLineEnum.FIRST_LINE,
			new LocalDate(2019, 8, 10));
		testDataGenerator.drug.orderDrug(
			patientId,
			encounterId,
			DrugNameEnum.ABC_3TC_120_60MG,
			new LocalDateTime(2019, 9, 1, 8, 0, 0),
			2,
			DurationUnitEnum.MONTH,
			true
		);

		// Execute
		String query = readReportQuery(ReportEnum.PECG_REPORT, "indicator1_ARV_old_treatment.sql", new LocalDate(2019, 9, 1), new LocalDate(2019, 9, 30));
		List<Map<String,Object>> result = getReportResult(query);

		// Assert
		assertEquals(result.get(0).get("Title"), "Number of old PLWHA on ARV who came for treatment in the month");
		assertEquals(result.get(0).get("<1 M"), 0);
		assertEquals(result.get(0).get("<1 F"), 0);
		assertEquals(result.get(0).get("1-4 M"), 0);
		assertEquals(result.get(0).get("1-4 F"), 0);
		assertEquals(result.get(0).get("5-9 M"), 0);
		assertEquals(result.get(0).get("5-9 F"), 0);
		assertEquals(result.get(0).get("10-14 M"), 0);
		assertEquals(result.get(0).get("10-14 F"), 0);
		assertEquals(result.get(0).get("15-19 M"), 1);
		assertEquals(result.get(0).get("15-19 F"), 0);
		assertEquals(result.get(0).get("20-24 M"), 0);
		assertEquals(result.get(0).get("20-24 F"), 0);
		assertEquals(result.get(0).get("25-29 M"), 0);
		assertEquals(result.get(0).get("25-29 F"), 0);
		assertEquals(result.get(0).get("30-34 M"), 0);
		assertEquals(result.get(0).get("30-34 F"), 0);
		assertEquals(result.get(0).get("35-39 M"), 0);
		assertEquals(result.get(0).get("35-39 F"), 0);
		assertEquals(result.get(0).get("40-44 M"), 0);
		assertEquals(result.get(0).get("40-44 F"), 0);
		assertEquals(result.get(0).get("45-49 M"), 0);
		assertEquals(result.get(0).get("45-49 F"), 0);
		assertEquals(result.get(0).get(">=50 M"), 0);
		assertEquals(result.get(0).get(">=50 F"), 0);
	}
}
