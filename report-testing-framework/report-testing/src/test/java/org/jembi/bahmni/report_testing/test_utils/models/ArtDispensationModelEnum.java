package org.jembi.bahmni.report_testing.test_utils.models;

public enum ArtDispensationModelEnum {
    FAMILY_MODEL("Family Model"),
    VIP_MODEL("VIP model"),
    CBO_DISPENSATION("CBO Dispensation");

    private String value;

    ArtDispensationModelEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
