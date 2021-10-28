SELECT DISTINCT
    '' as "serialNumber",
    getPatientARTNumber(v.patient_id) as "artCode",
    getPatientIdentifier(v.patient_id) as "uniquePatientId",
    getFacilityName() as "healthFacility",
    DATE(getProgramAttributeValueWithinReportingPeriod(v.patient_id, "2000-01-01","2100-01-01", "2dc1aafd-a708-11e6-91e9-0800270d80ce", "HIV_PROGRAM_KEY")) as "artStartDate",
    getPatientMostRecentProgramOutcome(v.patient_id, "en", "HIV_PROGRAM_KEY") as "artStatus",
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
    getPatientMostRecentProgramTrackingStateValue(v.patient_id, "en", "VL_EAC_PROGRAM_KEY") as "numberOfEacDone",
    getProgramAttributeValueWithinReportingPeriod(v.patient_id, "#startDate#", "#endDate#", "8bb0bdc0-aaf3-4501-8954-d1b17226075b", "VL_EAC_PROGRAM_KEY") as "APS Name"
FROM visit v
WHERE getViralLoadTestResult(v.patient_id) IS NOT NULL AND
    patientHasEnrolledIntoHivProgram(v.patient_id) = "Yes" AND
    patientHadViralLoadTestDuringReportingPeriod(v.patient_id, "#startDate#", "#endDate#");