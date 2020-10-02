SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getPatientARTNumber(p.patient_id) as "artCode",
    getPatientIdentifier(p.patient_id) as "uniquePatientId",
    getFacilityName() as "healthFacility",
    DATE(getProgramAttributeValueWithinReportingPeriod(p.patient_id, "2000-01-01","2100-01-01", "2dc1aafd-a708-11e6-91e9-0800270d80ce")) as "artStartDate",
    getPatientAge(p.patient_id) as "age",
    getPatientGender(p.patient_id) as "sex",
    getPatientPhoneNumber(p.patient_id) as "telephone",
    CONCAT(getPatientPreciseLocation(p.patient_id), ", ", getPatientVillage(p.patient_id)) as "address",
    getListOfActiveARVDrugs(p.patient_id, '#startDate#', '#endDate#') as "treatmentRegimen",
    "N/A" as "lineAtTheMomentOfVL",
    getDateOfVLEligibility(p.patient_id) as "eligibilityDate",
    "N/A" as "sampleCollectionDate",
    getViralLoadTestDate(p.patient_id) as "resultDate",
    getViralLoadTestResult(p.patient_id) as "vlResult",
    getDateVLResultGivenToPatient(p.patient_id) as "dateResultGivenToPatient",
    getReasonLastVLExam(p.patient_id) as "reasonVLRequest",
    IF(getMostRecentProgramEnrollmentDate(p.patient_id, "VL_EAC_PROGRAM_KEY") IS NOT NULL, "Yes", "No") as "eacDone",
    getMostRecentProgramEnrollmentDate(p.patient_id, "VL_EAC_PROGRAM_KEY") as "eacStartDate",
    getMostRecentProgramCompletionDate(p.patient_id, "VL_EAC_PROGRAM_KEY") as "eacEndDate",
    getPatientMostRecentProgramTrackingStateValue(p.patient_id, "en", "VL_EAC_PROGRAM_KEY") as "numberOfEacDone"
FROM patient p, (SELECT @a:= 0) AS a
WHERE getDateOfVLEligibility(p.patient_id) BETWEEN "#startDate#" AND "#endDate#";