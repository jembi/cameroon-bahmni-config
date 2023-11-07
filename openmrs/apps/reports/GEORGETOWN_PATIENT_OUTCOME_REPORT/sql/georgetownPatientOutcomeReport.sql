SELECT
    CAST(@a:=@a+1 AS CHAR) as "Serial Number",
    getPatientARTNumber(p.patient_id) as "ArtCode",
    getFacilityName() as "facilityName",
    getPatientIdentifier(p.patient_id) as "uniquePatientID",
    getPatientAge(p.patient_id) as "ageAtEnrollment",
    getPatientBirthdate(p.patient_id) as "birthDate",
    getPatientGender(p.patient_id) as "sex",
    getPatientHIVTestDate(p.patient_id) as "HIVTestDate",
    getPatientARVStartDate(p.patient_id) as "dateOfArtInitiation",
    CONCAT(getPatientVillage(p.patient_id),",",getPatientPreciseLocation(p.patient_id)) as "address",
    getPatientPhoneNumber(p.patient_id) as "contactTelephone",
    getPatientMostRecentProgramTrackingStateValue(p.patient_id,"en","HIV_PROGRAM_KEY") as "clinicalWhoStage",
    getFirstARVPrescribed(p.patient_id) as "regimentAtArtInitiation",
    getARVTherapeuticLineAtInitiation(p.patient_id) as "lineAtInitiation",
    getPatientMostRecentProgramAttributeCodedValue(p.patient_id, "397b7bc7-13ca-4e4e-abc3-bf854904dce3", "en") as "currentLine",
    getARTAppointmentOnOrAfterDate(p.patient_id, COALESCE(GREATEST("#startDate#", getLastArvPickupDate(p.patient_id, "2000-01-01", "#endDate#")),"#startDate#")) as "dateOfLastVisit",
    getDateSecondMostRecentARVAppointmentBeforeOrEqualToDate(p.patient_id, "#endDate#") as "lastAppointmentDate",
    getPatientMostRecentProgramOutcome(p.patient_id, "en", "HIV_PROGRAM_KEY") as "patientOutcome",
    getObsCodedValue(p.patient_id, "67d7ed45-8c77-4cce-8bc2-03ea5d15490f") as "outcomeDate",
    IF(getObsCodedValue(p.patient_id, "211f0857-61a3-4049-9777-374c4a592453") IS NOT NULL, "True", "False") as "KP",
    getObsCodedValue(p.patient_id, "211f0857-61a3-4049-9777-374c4a592453") as "KPType",
    getObsCodedValue(p.patient_id, "c221869a-3f10-11e4-adec-0800271c1b75") as "profession",
    getObsCodedValue(p.patient_id, "30e1c728-f008-4dd1-ab34-2c34a00fd3a5") as "reasonOfDeath",
    getProgramAttributeValueWithinReportingPeriod(p.patient_id, "#startDate#", "#endDate#", "8bb0bdc0-aaf3-4501-8954-d1b17226075b", "HIV_PROGRAM_KEY") as "apsInCharge"
FROM patient p, (SELECT @a:= 0) AS a
WHERE
    getProgramAttributeDateValueFromAttributeAndProgramName(p.patient_id, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", "HIV_PROGRAM_KEY") BETWEEN "#startDate#" AND "#endDate#";