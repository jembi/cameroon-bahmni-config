package org.jembi.bahmni.report_testing.test_utils.models;

public enum HivProgramStageEnum {
    WHO_STAGE_1("WHO stage 1"),
	WHO_STAGE_2("WHO stage 2"),
	WHO_STAGE_3("WHO stage 3"),
	WHO_STAGE_4("WHO stage 4");

	private String value;

	HivProgramStageEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
