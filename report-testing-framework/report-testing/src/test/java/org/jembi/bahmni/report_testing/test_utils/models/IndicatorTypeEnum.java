package org.jembi.bahmni.report_testing.test_utils.models;

public enum IndicatorTypeEnum {
	PECG_REPORT("PECG_REPORT"),
	TESTING_REPORT("TESTING_REPORT"),
	TREATMENT_REPORT("TREATMENT_REPORT"),
	VIRAL_SUPPRESSION("VIRAL_SUPPRESSION");

	private String value;

	IndicatorTypeEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
