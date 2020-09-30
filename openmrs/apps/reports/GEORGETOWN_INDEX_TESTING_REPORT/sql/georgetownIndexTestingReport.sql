SELECT
    CAST(@a:=@a+1 AS CHAR) as "Serial Number",
    getPatientIdentifier(p.patient_id) as "Unique Patient ID",
    getPatientBirthdate(p.patient_id) as "Date of Birth",
    getPatientAge(p.patient_id) as "Age",
    getPatientGender(p.patient_id) as "Sex",
    getFirstIndexRelationship(p.patient_id) as "Relation with index",
    getPatientMostRecentProgramTrackingStateValue(p.patient_id,"en","INDEX_TESTING_PROGRAM_KEY") as "Notified for Index case testing ?",
    DATE(getProgramAttributeValueWithinReportingPeriod(p.patient_id, "2000-01-01","2100-01-01", "c4e1106e-1644-45be-86c2-88392e73a507")) as "Date of Notification",
    getPatientMostRecentProgramAttributeCodedValue(p.patient_id, "19a7ef7b-5748-477b-a973-2f170e687624", "en") as "Notification Outcome",
    getPatientPhoneNumber(p.patient_id) as "Contact telephone",
    IF(getPatientHIVTestDate(p.patient_id) IS NOT NULL, "Yes", "") as "Tested for HIV ?",
    getPatientHIVTestDate(p.patient_id) as "HIV Test Date",
    getHIVResult(p.patient_id,"2000-01-01","2100-01-01") as "Test results",
    DATE(getProgramAttributeValueWithinReportingPeriod(p.patient_id, "2000-01-01","2100-01-01", "2dc1aafd-a708-11e6-91e9-0800270d80ce")) as "Date of Initiation",
    getPatientARTNumber(getFirstIndexID(p.patient_id)) as "Index Related ART Code",
    getPatientIdentifier(getFirstIndexID(p.patient_id)) as "Index Related Unique ID"
FROM patient p, (SELECT @a:= 0) AS a
WHERE patientIsContact(p.patient_id);