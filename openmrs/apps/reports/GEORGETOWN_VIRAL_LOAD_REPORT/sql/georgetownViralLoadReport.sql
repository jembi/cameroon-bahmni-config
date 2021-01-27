SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getPatientARTNumber(v.patient_id) as "artCode",
    getPatientIdentifier(v.patient_id) as "uniquePatientId",
    getFacilityName() as "healthFacility",
    DATE(getProgramAttributeValueWithinReportingPeriod(v.patient_id, "2000-01-01","2100-01-01", "2dc1aafd-a708-11e6-91e9-0800270d80ce")) as "artStartDate",
    getPatientAge(v.patient_id) as "age",
    getPatientGender(v.patient_id) as "sex",
    getPatientPhoneNumber(v.patient_id) as "telephone",
    CONCAT(getPatientPreciseLocation(v.patient_id), ", ", getPatientVillage(v.patient_id)) as "address",
    getListOfActiveARVDrugs(v.patient_id, '#startDate#', '#endDate#') as "treatmentRegimen",
    "N/A" as "lineAtTheMomentOfVL",
    getDateOfVLEligibility(v.patient_id) as "eligibilityDate",
    "N/A" as "sampleCollectionDate",
    getViralLoadTestDate(v.patient_id) as "resultDate",
    getViralLoadTestResult(v.patient_id) as "vlResult",
    getDateVLResultGivenToPatient(v.patient_id) as "dateResultGivenToPatient",
    getReasonLastVLExam(v.patient_id) as "reasonVLRequest",
    IF(getMostRecentProgramEnrollmentDate(v.patient_id, "VL_EAC_PROGRAM_KEY") IS NOT NULL, "Yes", "No") as "eacDone",
    getMostRecentProgramEnrollmentDate(v.patient_id, "VL_EAC_PROGRAM_KEY") as "eacStartDate",
    getMostRecentProgramCompletionDate(v.patient_id, "VL_EAC_PROGRAM_KEY") as "eacEndDate",
    getPatientMostRecentProgramTrackingStateValue(v.patient_id, "en", "VL_EAC_PROGRAM_KEY") as "numberOfEacDone"
FROM visit v, (SELECT @a:= 0) AS a
WHERE getViralLoadTestResult(v.patient_id) IS NOT NULL AND
    v.date_started BETWEEN "#startDate#" AND "#endDate#";