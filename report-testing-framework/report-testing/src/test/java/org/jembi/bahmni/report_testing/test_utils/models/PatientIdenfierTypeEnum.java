package org.jembi.bahmni.report_testing.test_utils.models;

public enum PatientIdenfierTypeEnum {
    ART("REGISTRATION_IDTYPE_3_ART_KEY"),
    BAHMNI_IDENTIFIER("Patient Identifier");

    private String value;

	PatientIdenfierTypeEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
