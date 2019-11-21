package org.jembi.bahmni.report_testing.test_utils.models;

public enum DrugNameEnum {
	ABC_3TC_120_60MG("ABC/3TC 120/60mg");

	private String value;

	DrugNameEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}