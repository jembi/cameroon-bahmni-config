package org.jembi.bahmni.report_testing.test_utils.models;

public enum ObsValueTypeEnum {
    CODED("value_coded"),
    DATE_TIME("value_datetime"),
    TEXT("value_text"),
    NUMERIC("value_numeric");

    private String value;

	ObsValueTypeEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
