package org.jembi.bahmni.report_testing.test_utils.models;

public enum TherapeuticLineEnum {
	FIRST_LINE("1st line"),
	SECOND_LINE("2nd line"),
	THIRD_LINE("3rd line");

	private String value;

	TherapeuticLineEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
