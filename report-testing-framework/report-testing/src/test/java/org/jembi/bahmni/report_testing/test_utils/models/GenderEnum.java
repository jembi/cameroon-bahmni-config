package org.jembi.bahmni.report_testing.test_utils.models;

public enum GenderEnum {
	MALE("m"),
	FEMALE("f");
	
	private String value;

	GenderEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
