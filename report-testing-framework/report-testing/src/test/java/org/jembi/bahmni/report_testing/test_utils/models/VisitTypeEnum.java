package org.jembi.bahmni.report_testing.test_utils.models;

public enum VisitTypeEnum {
	VISIT_TYPE_OPD("VISIT_TYPE_OPD");

	private String value;

	VisitTypeEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
