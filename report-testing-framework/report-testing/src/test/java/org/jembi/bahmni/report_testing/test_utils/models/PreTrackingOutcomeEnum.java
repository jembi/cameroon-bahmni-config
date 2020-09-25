package org.jembi.bahmni.report_testing.test_utils.models;

public enum PreTrackingOutcomeEnum {
    _7_TO_30_DAYS("7 to 30 days"),
	_31_TO_60_DAYS("31 to 60 days");

	private String value;

	PreTrackingOutcomeEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
