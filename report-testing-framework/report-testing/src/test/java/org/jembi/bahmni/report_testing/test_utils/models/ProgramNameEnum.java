package org.jembi.bahmni.report_testing.test_utils.models;

public enum ProgramNameEnum {
    HIV_PROGRAM_KEY("HIV_PROGRAM_KEY"),
    INDEX_TESTING_PROGRAM_KEY("INDEX_TESTING_PROGRAM_KEY"),
    HIV_DEFAULTERS_PROGRAM_KEY("HIV_DEFAULTERS_PROGRAM_KEY"),
    VL_EAC_PROGRAM_KEY("VL_EAC_PROGRAM_KEY"),
    TB_PROGRAM_KEY("TB_PROGRAM_KEY");

	private String value;

	ProgramNameEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
