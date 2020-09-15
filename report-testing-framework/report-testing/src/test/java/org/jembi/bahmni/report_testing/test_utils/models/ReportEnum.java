package org.jembi.bahmni.report_testing.test_utils.models;

public enum ReportEnum {
	PECG_REPORT("PECG_REPORT"),
	TESTING_REPORT("TESTING_REPORT"),
	TREATMENT_REPORT("TREATMENT_REPORT"),
	GEORGETOWN_INDEX_TESTING_REPORT("GEORGETOWN_INDEX_TESTING_REPORT"),
	VIRAL_SUPPRESSION("VIRAL_SUPPRESSION");

	private String value;

	ReportEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
