SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getPatientARTNumber(p.patient_id) as "ArtCode",
    getFacilityName() as "facilityName",
    getPatientIdentifier(p.patient_id) as "uniquePatientID",
    getPatientAge(p.patient_id) as "ageAtEnrollment",
    getPatientBirthdate(p.patient_id) as "birthDate",
    getPatientGender(p.patient_id) as "sex",
    IF(getProgramAttributeValueWithinReportingPeriod(p.patient_id, "#startDate#", "#endDate#", "242c9027-dc2d-42e6-869e-045e8a8b95cb", "HIV_PROGRAM_KEY")="true","Yes","No") as "PatientIsBreastfeeding",
    getPatientHIVTestDate(p.patient_id) as "HIV Test Date",
    getPatientARVStartDate(p.patient_id) as "dateOfArtInitiation",
    CONCAT(getPatientVillage(p.patient_id),",",getPatientPreciseLocation(p.patient_id)) as "address",
    getPatientPhoneNumber(p.patient_id) as "contactTelephone",
    getPatientMostRecentProgramTrackingStateValue(p.patient_id,"en","HIV_PROGRAM_KEY") as "clinicalWhoStage",
    getFirstARVPrescribed(p.patient_id) as "regimentAtArtInitiation",
    getARVTherapeuticLineAtInitiation(p.patient_id) as "lineAtInitiation",
    getPatientMostRecentProgramAttributeCodedValue(p.patient_id, "397b7bc7-13ca-4e4e-abc3-bf854904dce3", "en") as "currentLine",
    getLastARVDispensed(p.patient_id,"2000-01-01", "#endDate#") as "lastARTDispensed",
    getDurationMostRecentArvTreatmentInDays(p.patient_id,"2000-01-01", "#endDate#") as "numberOdDaysDispensed",
    getARTAppointmentOnOrAfterDate(p.patient_id, COALESCE(GREATEST("#startDate#", getLastArvPickupDate(p.patient_id, "2000-01-01", "#endDate#")),"#startDate#")) as "lastAppointmentDate",
    getPatientMostRecentProgramAttributeCodedValue(p.patient_id, "39202f47-a709-11e6-91e9-0800270d80ce", "en") as "reasonForARTDispensation",
    IF(getObsCodedValue(p.patient_id, "248e21db-98f8-49fc-b596-fe9042b013ac") IS NOT NULL, "True", "False") as "kp",
    getObsCodedValue(p.patient_id, "248e21db-98f8-49fc-b596-fe9042b013ac") as "kpType",
    getViralLoadTestDate(p.patient_id) as "lastVLSampleCollectionDate",
    getViralLoadTestResult(p.patient_id) as "result",
    getProgramAttributeValueWithinReportingPeriod(p.patient_id, "#startDate#", "#endDate#", "8bb0bdc0-aaf3-4501-8954-d1b17226075b", "HIV_PROGRAM_KEY") as "apsInCharge"
FROM patient p, (SELECT @a:= 0) AS a
WHERE
    (
        patientHasStartedARVTreatmentDuringReportingPeriod(p.patient_id, "#startDate#", "#endDate#")
        AND
        getLastArvPickupDate(p.patient_id, "#startDate#", "#endDate#") IS NOT NULL
    );