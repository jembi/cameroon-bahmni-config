SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getPatientIdentifier(r.person_a) as "uniquePatientId",
    getPatientBirthdate(r.person_a) as "dateOfBirth",
    getPatientAgeInMonthsAtDate(r.person_a, NOW()) as "ageInMonths",
    getPatientIdentifier(r.person_b) as "motherId",
    CONCAT(getPatientPreciseLocation(r.person_b),", ",getPatientVillage(r.person_b)) as "mothersAddress",
    getPatientPhoneNumber(r.person_b) as "mothersContact",
    getMostRecentTestResultDate(r.person_a,"a5239a85-6f75-4882-9b9b-60168e54b7da","9bb7b360-3790-4e1a-8aca-0d1341663040") as "resultDatePcr",
    getTestResultWithinReportingPeriod(r.person_a,"2000-01-01","2100-01-01","a5239a85-6f75-4882-9b9b-60168e54b7da","9bb7b360-3790-4e1a-8aca-0d1341663040") as "pcrResult",
	getProgramAttributeDateValueFromAttributeAndProgramName(r.person_a, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", "HIV_PROGRAM_KEY") as "artInitiationDate",
    getObsCodedValue(r.person_a, "3447254f-501f-4b07-815c-cd0f6da98158") as "reasonOfNonInitiation"
FROM (SELECT @a:= 0) AS a, relationship r
    JOIN relationship_type rt ON rt.relationship_type_id = r.relationship AND rt.a_is_to_b = "RELATIONSHIP_BIO_MOTHER"
    JOIN patient_identifier pi ON pi.patient_id = r.person_a AND pi.preferred = 1
WHERE getPatientAgeInMonthsAtDate(r.person_a, NOW()) <= 24;