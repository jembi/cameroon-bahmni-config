SELECT
    CAST(@a:=@a+1 AS CHAR) as "Serial Number",
    getPatientIdentifier(p.patient_id) as "Patient ID",
    getPatientARTNumber(p.patient_id) as "ART Code",
    getPatientBirthdate(p.patient_id) as "Date of birth",
    getPatientAge(p.patient_id) as "Age",
    getPatientGender(p.patient_id) as "Sex",
    DATE(getProgramAttributeValueWithinReportingPeriod(p.patient_id, "#startDate#", "#endDate#", "9b4b2dd5-bc5e-44b9-ad95-333a7bbfee3c", "HIV_DEFAULTERS_PROGRAM_KEY")) as "Date patient was reached",
    getProgramAttributeValueWithinReportingPeriod(p.patient_id, "#startDate#", "#endDate#", "8bb0bdc0-aaf3-4501-8954-d1b17226075b", "HIV_DEFAULTERS_PROGRAM_KEY") as "APS Name",
    getPatientMostRecentProgramAttributeCodedValue(p.patient_id, "0a51d8d0-c775-48a2-9ca2-42c269d00bc2", "en") as "Pre-tracking Outcome",
    getMostRecentProgramAttributeDateCreated(p.patient_id, "0a51d8d0-c775-48a2-9ca2-42c269d00bc2") as "Date of Pre-tracking Outcome",
    getPatientMostRecentProgramTrackingStateValue(p.patient_id,"en","HIV_DEFAULTERS_PROGRAM_KEY") as "Call Number",
    getDefaulterStageThatIsHomeVisit(p.patient_id) as "Home Visit Number",
    getPatientMostRecentProgramAttributeCodedValue(p.patient_id, "caf6d807-861d-4393-9d6e-940b98fa712d", "en") as "Call or Home Visit Outcome",
    getPatientMostRecentProgramOutcome(p.patient_id, "en", "HIV_DEFAULTERS_PROGRAM_KEY") as "Tracking Outcome",
    getProgramAttributeValueWithinReportingPeriod(p.patient_id, "#startDate#", "#endDate#", "404b652e-6002-4371-8427-3e9e84cdf454", "HIV_DEFAULTERS_PROGRAM_KEY") as "Other tracking outcomes",
    getOtherReasonsOfDefaulting(p.patient_id) as "Reason for defaulting",
    getProgramAttributeValueWithinReportingPeriod(p.patient_id, "#startDate#", "#endDate#", "37a86762-3eae-4c00-a004-6589407d0de1", "HIV_DEFAULTERS_PROGRAM_KEY") as "Other reasons for defaulting",
    DATE(getProgramAttributeValueWithinReportingPeriod(p.patient_id, "#startDate#", "#endDate#", "b04fb0b8-3a1c-46fa-bf83-922513016b6b", "HIV_DEFAULTERS_PROGRAM_KEY")) as "Date promised to return"
FROM patient p, (SELECT @a:= 0) AS a
WHERE patientHasEnrolledInDefaulterProgram(p.patient_id);