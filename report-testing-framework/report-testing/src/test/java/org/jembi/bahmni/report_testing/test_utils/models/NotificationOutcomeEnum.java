package org.jembi.bahmni.report_testing.test_utils.models;

public enum NotificationOutcomeEnum {
    ACCPETED_TESTING("Accepted Testing"),
	REFUSED_TESTING("Refused Testing");

	private String value;

	NotificationOutcomeEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
