package org.jembi.bahmni.report_testing.test_utils.models;

public enum TrackingOutcomeEnum {
    PHONE_OFF("Phone off"),
	CALLS_NOT_PICKED_UP("Calls not picked up");

	private String value;

	TrackingOutcomeEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
