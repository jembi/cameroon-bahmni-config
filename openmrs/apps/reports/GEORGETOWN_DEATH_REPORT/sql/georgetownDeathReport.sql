SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getFacilityName() as "facilityName",
    getPatientIdentifier(p.patient_id) as "uniquePatientID",
    getPatientAge(p.patient_id) as "age",
    getPatientBirthdate(p.patient_id) as "birthDate",
    getPatientGender(p.patient_id) as "sex",
    CONCAT(getPatientVillage(p.patient_id),",",getPatientPreciseLocation(p.patient_id)) as "address",
    getPatientPhoneNumber(p.patient_id) as "contactTelephone",
    IF(getProgramAttributeValueWithinReportingPeriod(p.patient_id, "#startDate#", "#endDate#", "242c9027-dc2d-42e6-869e-045e8a8b95cb", "HIV_PROGRAM_KEY")="true","Yes","No") as "PatientIsBreastfeeding",
    getObsDatetimeValue(p.patient_id, "67d7ed45-8c77-4cce-8bc2-03ea5d15490f") as "dateOfDeathNotification",
    getObsCodedValue(p.patient_id, "6ea73229-7399-41ae-a6e5-68942a354956") as "PlaceOfDeath",
    getObsCodedValue(p.patient_id, "30e1c728-f008-4dd1-ab34-2c34a00fd3a5") as "reasonOfDeath",
    IF(getPatientARVStartDate(p.patient_id) IS NOT NULL, "Yes", "No") as "onART",
    getPatientARVStartDate(p.patient_id) as "dateOfArtInitiation",
    getLastARVDispensed(p.patient_id,"2000-01-01", "#endDate#") as "lastARTAppointmentDate",
    patientLatestArvDrugWasDispensed(p.patient_id) as "regimen",
    IF(getObsCodedValue(p.patient_id, "248e21db-98f8-49fc-b596-fe9042b013ac") IS NOT NULL, "True", "False") as "kp",
    getObsCodedValue(p.patient_id, "248e21db-98f8-49fc-b596-fe9042b013ac") as "kpType",
    getViralLoadTestResult(p.patient_id) as "Last VL result",
    getViralLoadTestDate(p.patient_id) as "lastVLSampleCollectionDate",
    getProgramAttributeValueWithinReportingPeriod(p.patient_id, "#startDate#", "#endDate#", "8bb0bdc0-aaf3-4501-8954-d1b17226075b", "HIV_PROGRAM_KEY") as "apsInCharge"
FROM patient p, (SELECT @a:= 0) AS a
WHERE
    getObsDatetimeValue(p.patient_id, "67d7ed45-8c77-4cce-8bc2-03ea5d15490f") BETWEEN "#startDate#" AND "#endDate#";