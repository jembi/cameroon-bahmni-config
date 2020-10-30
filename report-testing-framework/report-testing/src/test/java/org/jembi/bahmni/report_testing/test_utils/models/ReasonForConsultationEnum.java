package org.jembi.bahmni.report_testing.test_utils.models;

public enum ReasonForConsultationEnum {
    TRANSFER_IN("Transfer in"),
	INITIATION_OF_ART("Initiation of ART");

	private String value;

	ReasonForConsultationEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
