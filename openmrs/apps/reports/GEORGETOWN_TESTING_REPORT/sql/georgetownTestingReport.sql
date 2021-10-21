SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getPatientIdentifier(p.patient_id) as "uniquePatientId",
    getFacilityName() as "healthFacility",
    getPatientPhoneNumber(p.patient_id) as "telOfClient",
    CONCAT(getPatientPreciseLocation(p.patient_id), ", ", getPatientVillage(p.patient_id)) as "clientsAddress",
    getPatientAge(p.patient_id) as "age",
    getPatientBirthdate(p.patient_id) as "dateOfBirth",
    getPatientGender(p.patient_id) as "sex",
    IF(getObsCodedValue(p.patient_id, "5b2e5a44-b55b-4436-9948-67143841ee27") = "True", "Yes","No") as "hivScreeningTool",
    IF(wasHIVTestDoneInANCVisitWithinRepPeriod(p.patient_id, "#startDate#", "#endDate#"), "Yes", patientEligibleForHIVTesting(p.patient_id)) as "eligibleForTesting",
    getHIVTestDate(p.patient_id,"#startDate#", "#endDate#") as "dateOfHivTesting",
    getHIVResult(p.patient_id,"#startDate#", "#endDate#") as "result",
    DATE(getProgramAttributeValueWithinReportingPeriod(p.patient_id, "2000-01-01", "2100-12-31", "2dc1aafd-a708-11e6-91e9-0800270d80ce", "HIV_PROGRAM_KEY")) as "dateOfArtInitiation",
    getObsCodedValue(p.patient_id, "3447254f-501f-4b07-815c-cd0f6da98158") as "reasonOfNonInitiation",
    IF(wasHIVTestDoneInANCVisitWithinRepPeriod(p.patient_id, "#startDate#", "#endDate#"),"PMTCT [ANC1-only]",getTestingEntryPointWithinRepPeriod(p.patient_id)) as "facilityEntryPoint",
    getHIVTestDate(p.patient_id,"#startDate#", "#endDate#") as "dateFinalResultProvidedToPatient",
    getObsTextValue(p.patient_id, "2af46f9c-d572-4362-aa14-43d72eacb2aa") as "APS Tester Name"
FROM patient p, (SELECT @a:= 0) AS a
WHERE getHIVTestDate(p.patient_id, "#startDate#", "#endDate#") IS NOT NULL;