package org.jembi.bahmni.report_testing.test_utils.models;

public enum VisitTypeEnum {
	OPD("OPD");

	private String value;

	VisitTypeEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
