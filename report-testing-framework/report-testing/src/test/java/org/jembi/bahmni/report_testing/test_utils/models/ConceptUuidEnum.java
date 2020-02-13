package org.jembi.bahmni.report_testing.test_utils.models;

public enum ConceptUuidEnum {
    YES("78763e68-104e-465d-8ce3-35f9edfb083d"),
    NO("f9f633a5-1544-4c44-9394-a7f746a12dff"),
    POSITIVE("7acfafa4-f19b-485e-97a7-c9e002dbe37a"),
    NEGATIVE("718b4589-2a11-4355-b8dc-aa668a93e098"),

    // Testing and counseling form
    HIV_TESTED_BEFORE("f8f78cc6-8453-416a-ade2-237d67a59829"),
    HIV_TEST_DATE("c6c08cdc-18dc-4f42-809c-959621bc9a6c"),
    HTC_HIV_TEST("b70dfca0-db21-4533-8c08-4626ff0de265"),
    FINAL_RESULT("3a8a6fa1-3845-481e-9502-fea47c2d1d1d"),
    FINAL_TEST_RESULT("41e48d08-2235-47d5-af12-87a009057603"),
    TESTING_ENTRY_POINT_AND_MODALITY("bc43179d-00b4-4712-a5d6-4dabd4230888"),
    TESTING_ENTRY_POINT_AND_MODALITY_INDEX("077c61a1-3f3b-4f58-ba20-ae325c6ed6bd"),
    TESTING_ENTRY_POINT_AND_MODALITY_IMPATIENT("30dcc74a-5554-482f-a5a0-9f6fb3c2a556"),
    HIV_TESTING_AND_COUNSELING("6bfd85ce-22c8-4b54-af0e-ab0af24240e3");

	private String value;

	ConceptUuidEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
