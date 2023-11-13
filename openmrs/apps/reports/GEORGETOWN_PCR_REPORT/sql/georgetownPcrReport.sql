SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getPatientIdentifier(r.person_a) as "uniquePatientId",
    getPatientARTNumber(r.person_a) as "MotherARTCode",
    getPatientBirthdate(r.person_a) as "dateOfBirth",
    getObsCodedValue(r.person_a, "09894da7-41c1-4996-a9d2-ecaca1af5bfb") as "placeOfBirth",
    getPatientAgeInMonthsAtDate(r.person_a, NOW()) as "ageInMonths",
    getPatientIdentifier(r.person_b) as "motherId",
    CONCAT(getPatientPreciseLocation(r.person_b),", ",getPatientVillage(r.person_b)) as "mothersAddress",
    getPatientPhoneNumber(r.person_b) as "mothersContact",
    getMostRecentTestResultDate(r.person_a,"a5239a85-6f75-4882-9b9b-60168e54b7da","9bb7b360-3790-4e1a-8aca-0d1341663040") as "resultDatePcr",
    getTestResultWithinReportingPeriod(r.person_a,"2000-01-01","2100-01-01","a5239a85-6f75-4882-9b9b-60168e54b7da","9bb7b360-3790-4e1a-8aca-0d1341663040") as "pcrResult",
	getProgramAttributeDateValueFromAttributeAndProgramName(r.person_a, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", "HIV_PROGRAM_KEY") as "artInitiationDate",
    getObsCodedValue(r.person_a, "9644653a-b9af-11ed-afa1-0242ac120002") as "CTXAt6Weeks",
    getObsCodedValue(r.person_a, "0b9b6e25-e0fe-4c65-b9af-2fd5f6cbb150") as "ModeOfFeeding",
    getObsCodedValue(r.person_a, "7b7fe0c1-067a-42ac-bd9d-effec7855637") as "rapidTest1Result",
    getObsDatetimeValue(r.person_a, "0a6d0b1a-5738-4c7d-a545-e3e8f4b41e50") as "rapidTest1Date" ,
    getObsCodedValue(r.person_a, "ab130794-8e13-4a1b-9e5c-7304ec32ecfd") as "rapidTest2Result",
    getObsDatetimeValue(r.person_a, "7fb31336-0e50-4f9e-9a2e-5fe865a89e0a") as "rapidTest2Date",
    getObsCodedValue(r.person_a, "96beef20-ef5f-46c0-8c30-1db32eede732") as "DateOfHEIFinalOutcome",
    getObsCodedValue(r.person_a, "9a4267a6-b9b7-11ed-afa1-0242ac120002") as "HEIFinalOutcome",
    getObsCodedValue(r.person_a, "3447254f-501f-4b07-815c-cd0f6da98158") as "reasonOfNonInitiation",
    getProgramAttributeDateValueFromAttributeAndProgramName(r.person_a, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", "HIV_PROGRAM_KEY") as "dateOfInitiation"
FROM (SELECT @a:= 0) AS a, relationship r
    JOIN relationship_type rt ON rt.relationship_type_id = r.relationship AND rt.a_is_to_b = "RELATIONSHIP_BIO_MOTHER"
    JOIN patient_identifier pi ON pi.patient_id = r.person_a AND pi.preferred = 1
WHERE
    getPatientAgeInMonthsAtDate(r.person_a, NOW()) <= 24 AND
    patientHasEnrolledIntoHivProgram(r.person_b) = "Yes";