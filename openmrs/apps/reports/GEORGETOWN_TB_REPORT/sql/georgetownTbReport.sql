SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getPatientIdentifier(p.patient_id) as "uniquePatientId",
    getPatientBirthdate(p.patient_id) as "dateOfBirth",
    getPatientAge(p.patient_id) as "age",
    getPatientGender(p.patient_id) as "sex",
    getPatientPhoneNumber(p.patient_id) as "telephone",
    getDateTBPosDiagnose(p.patient_id) as "dateTBPosDiag",
    getProgramAttributeDateValueFromAttributeAndProgramName(p.patient_id, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", "TB_PROGRAM_KEY") as "dateOfTxTbStart",
    getHIVTestDate(p.patient_id,"2000-01-01","2100-01-01") as "dateOfHivTesting",
    getHIVResult(p.patient_id,"2000-01-01","2100-01-01") as "hivTestingResult",
    getProgramAttributeDateValueFromAttributeAndProgramName(p.patient_id, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", "HIV_PROGRAM_KEY") as "dateOfInitiation"
FROM patient p, (SELECT @a:= 0) AS a
WHERE
    getDateTBPosDiagnose(p.patient_id) IS NOT NULL AND
    getObsCodedValue(p.patient_id, "f0447183-d13f-463d-ad0f-1f45b99d97cc") LIKE "Yes%";