SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getFacilityName() as "Facility Name",
    getPatientIdentifier(p.patient_id) as "uniquePatientId",
    getPatientBirthdate(p.patient_id) as "dateOfBirth",
    getPatientAge(p.patient_id) as "age",
    getPatientGender(p.patient_id) as "sex",
    getPatientPhoneNumber(p.patient_id) as "telephone",
    getMostRecentCodedObservation(p.patient_id,"Method of confirmation","en") as "Type of Exam",
    getDateTBPosDiagnose(p.patient_id) as "dateTBPosDiag",
    getMostRecentCodedObservation(p.patient_id,"TB Diagnostic Result","en") as "tbDiagnosticResult",
    getMostRecentDateObservation(p.patient_id,"MDR-TB diagnosis date") as "tbDiagnosticDate",
    getProgramAttributeDateValueFromAttributeAndProgramName(p.patient_id, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", "TB_PROGRAM_KEY") as "dateOfTxTbStart",
    getHIVTestDate(p.patient_id,"2000-01-01","2100-01-01") as "dateOfHivTesting",
    getHIVResult(p.patient_id,"2000-01-01","2100-01-01") as "hivTestingResult",
    getProgramAttributeDateValueFromAttributeAndProgramName(p.patient_id, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", "HIV_PROGRAM_KEY") as "dateOfInitiation",
    getProgramAttributeValueWithinReportingPeriod(p.patient_id, "#startDate#", "#endDate#", "8bb0bdc0-aaf3-4501-8954-d1b17226075b", "TB_PROGRAM_KEY") as "APS Name"
FROM patient p, (SELECT @a:= 0) AS a
WHERE
    getDateTBPosDiagnose(p.patient_id) IS NOT NULL AND
    getObsCodedValue(p.patient_id, "61931c8b-0637-40f9-97dc-07796431dd3b") = "Suspected / Probable";