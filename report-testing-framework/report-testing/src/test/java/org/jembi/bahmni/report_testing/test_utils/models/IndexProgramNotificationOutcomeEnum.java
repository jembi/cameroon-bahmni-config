package org.jembi.bahmni.report_testing.test_utils.models;

public enum IndexProgramNotificationOutcomeEnum {
	ACCEPTED_TESTING("Accepted Testing");

	private String value;

	IndexProgramNotificationOutcomeEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
