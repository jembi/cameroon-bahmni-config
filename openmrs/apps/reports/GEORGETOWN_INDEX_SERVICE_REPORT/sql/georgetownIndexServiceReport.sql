SELECT
    CAST(@a:=@a+1 AS CHAR) as "Serial Number",
    getFacilityName() as "facilityName",
	getPatientARTNumber(p.patient_id) as "artCode",
	getPatientAge(p.patient_id) as "age",
	getPatientBirthdate(p.patient_id) as "dateOfBirth",
	getPatientGender(p.patient_id) as "sex",
	getProgramAttributeDateValueFromAttributeAndProgramName(p.patient_id, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", "HIV_PROGRAM_KEY") as "artStartDate",
	getViralLoadTestResult(p.patient_id) as "lastViralLoadResult",
    getPatientIndexTestingDateOffered(p.patient_id) as "Date of Service Offered",
    SUBSTRING(getPatientIndexTestingAccepted(p.patient_id),1,3) as "ICT Service Accepted ?",
    getPatientIndexTestingDateAccepted(p.patient_id) as "Date of Service accepted",
    getIndexType(getFirstIndexID(p.patient_id)) as "Type of Index Case",
    getNumberOfContactsRelatedToIndex(p.patient_id) as "Number of Contact elicited",
    getNumberBiologicalChildrenOfIndex(p.patient_id, "#startDate#", "#endDate#") as "Number of Biological Children",
    getNumberBiologicalParentsOfIndex(p.patient_id, "#startDate#", "#endDate#") as "Number of Biological Parents",
    getNumberSiblingsOfIndex(p.patient_id, "#startDate#", "#endDate#") as "Number of Siblings",
    getNumberSexualContactsOfIndex(p.patient_id) as "Number of Sexual Contact",
    getObsTextValue(p.patient_id, "2af46f9c-d572-4362-aa14-43d72eacb2aa") as "APS Tester Name"
FROM patient p, (SELECT @a:= 0) AS a
WHERE
    getPatientHIVFinalTestResult(p.patient_id) LIKE "Positive%"  AND
    getPatientIndexTestingDateOffered(p.patient_id) IS NOT NULL AND
    getPatientIndexTestingDateOffered(p.patient_id) BETWEEN "#startDate#" AND "#endDate#";