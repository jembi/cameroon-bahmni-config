package org.jembi.bahmni.report_testing.test_utils.models;

public enum ConceptEnum {
    HTC_HIV_TEST("b70dfca0-db21-4533-8c08-4626ff0de265"),
    HIV_TEST_DATE("c6c08cdc-18dc-4f42-809c-959621bc9a6c"),
    FINAL_RESULT("3a8a6fa1-3845-481e-9502-fea47c2d1d1d"),
    FINAL_TEST_RESULT("41e48d08-2235-47d5-af12-87a009057603"),
    POSITIVE("7acfafa4-f19b-485e-97a7-c9e002dbe37a"),
    INDEX_TESTING_OFFERED("533f4c86-1324-4260-bce5-0f872a556963"),
    DATE_INDEX_TESTING_OFFERED("836fe9d4-96f1-4fea-9ad8-35bd06e0ee05"),
    INDEX_TESTING_ACCEPTED("78d13812-cd29-4214-9a58-a8710fd69cff"),
    TRUE("78763e68-104e-465d-8ce3-35f9edfb083d"),
    YES("a2065636-5326-40f5-aed6-0cc2cca81ccc"),
    NO("b497171e-0410-4d8d-bbd4-7e1a8f8b504e"),
    DATE_BASELINE_ASSESSMENT("1d4a6dc4-c478-4021-982b-62e3c84f7857"),
    SCREENED("f0447183-d13f-463d-ad0f-1f45b99d97cc"),
    MTB_CONFIRMATION("c4bbc310-2e01-4c6d-be90-decc1b91a800"),
    MTB_BACTERIOLOGICALLY_CONFIRMED("41bde817-b2e0-4f58-88be-f875e7b31eed"),
    MTB_NOT_CONFIRMED("c1e4f600-2cdd-4ce0-a687-af76e9e20721"),
    TB_FORM("3804e2cc-dd14-4879-88d2-94391853f7fb"),
    DATE_INDEX_TESTING_ACCEPTED("e7a002be-8afc-48b1-a81b-634e37f2961c"),
    HIV_TESTING_AND_COUNSELING("6bfd85ce-22c8-4b54-af0e-ab0af24240e3"),
    ACCEPTED_TESTING("6bcd6f00-5232-11ea-8d77-2e728ce88125"),
    REFUSED_TESTING("6bcd71bc-5232-11ea-8d77-2e728ce88125"),
    NOTIFICATION_1("7209dfe2-5233-11ea-8d77-2e728ce88125"),
    INITIAL_TREATMENT_PHASE("9f75f5b9-83fc-4db2-8129-fb648e2d68b2"),
    WHO_STAGE_1("491d6883-3078-47b9-b8d0-872641bd9d27");

    private String value;

    ConceptEnum(String value) {
        this.value = value;
    }

    public String toString() {
        return value;
    }
}
