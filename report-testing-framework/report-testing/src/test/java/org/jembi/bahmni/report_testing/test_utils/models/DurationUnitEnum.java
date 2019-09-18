package org.jembi.bahmni.report_testing.test_utils.models;

public enum DurationUnitEnum {
	DAY("Jour(s)"),
	WEEK("Semaine(s)"),
	MONTH("Mois");

	private String value;

	DurationUnitEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
