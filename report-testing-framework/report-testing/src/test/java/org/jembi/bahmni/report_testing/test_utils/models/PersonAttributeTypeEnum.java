package org.jembi.bahmni.report_testing.test_utils.models;

public enum PersonAttributeTypeEnum {
    OCCUPATION("occupation");

    private String value;

	PersonAttributeTypeEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
    
}
