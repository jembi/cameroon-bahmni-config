SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getFacilityName() as "facilityName",
    getPatientIdentifier(p.patient_id) as "patientID",
    getPatientARTNumber(p.patient_id) as "artCode",
    getPatientAge(p.patient_id) as "age",
    getPatientGender(p.patient_id) as "sex",
    getPatientARTStatus(p.patient_id, "#startDate#", "#endDate#") as "patientStatus",
    getObsCodedValue(p.patient_id, "248e21db-98f8-49fc-b596-fe9042b013ac") as "kpType",
    CONCAT(getPatientVillage(p.patient_id),",",getPatientPreciseLocation(p.patient_id)) as "address",
    getPatientPhoneNumber(p.patient_id) as "contactPhone",
    getHIVTestDate(p.patient_id, "2000-01-01", "#endDate#") as "HIVTestDate",
    getPatientARVStartDate(p.patient_id) as "dateOfArtInitiation",
    getPatientMostRecentProgramTrackingStateValue(p.patient_id,"en","HIV_PROGRAM_KEY") as "clinicalWhoStage",
    getFirstARVPrescribed(p.patient_id) as "regimentAtArtInitiation",
    getARVTherapeuticLineAtInitiation(p.patient_id) as "lineAtInitiation",
    getPatientMostRecentProgramAttributeCodedValue(p.patient_id, "397b7bc7-13ca-4e4e-abc3-bf854904dce3", "en") as "currentRegimen",
    getDateSecondMostRecentARVAppointmentBeforeOrEqualToDate(p.patient_id, "#endDate#") as "lastAppointmentDate",
    getViralLoadTestDate(p.patient_id) as "lastVLSampleCollectionDate",
    getViralLoadTestResult(p.patient_id) as "VLResultValue",
    getEacDate(p.patient_id, 1) as "DateEAC1",
    getEacDate(p.patient_id, 2) as "DateEAC2",
    getEacDate(p.patient_id, 3) as "DateEAC3",
    getProgramAttributeValueWithinReportingPeriod(p.patient_id, "2000-01-01", "2100-12-31", "8bb0bdc0-aaf3-4501-8954-d1b17226075b", "HIV_PROGRAM_KEY") as "APSInCharge"
FROM patient p, (SELECT @a:= 0) AS a
WHERE
    getViralLoadTestDate(p.patient_id) BETWEEN "#startDate#" AND "#endDate#";