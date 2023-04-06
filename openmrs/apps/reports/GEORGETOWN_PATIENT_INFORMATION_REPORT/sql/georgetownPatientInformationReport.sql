SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getPatientARTNumber(p.patient_id) as "artCode",
    getFacilityName() as "facilityName",
    getPatientIdentifier(p.patient_id) as "uniquePatientId",
    patientAgeAtHivEnrollment(p.patient_id) as "ageAtEnrollment",
    getPatientBirthdate(p.patient_id) as "dateOfBirth",
    getPatientGender(p.patient_id) as "sex",
    getHivTestDate(p.patient_id, "2000-01-01", "2100-01-01") as "hivTestDate",
    getProgramAttributeDateValueFromAttributeAndProgramName(p.patient_id, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", "HIV_PROGRAM_KEY") as "dateArvInitiation",
    CONCAT(getPatientVillage(p.patient_id),",",getPatientPreciseLocation(p.patient_id)) as "address",
    getPatientRegion(p.patient_id) as "region",
    getPatientDivision(p.patient_id) as "division",
    getPatientSubDivision(p.patient_id) as "subDivision",
    getPatientVillage(p.patient_id) as "village",
    getPatientPhoneNumber(p.patient_id) as "contactTelephone",
    getPatientMostRecentProgramTrackingStateValue(p.patient_id,"en","HIV_PROGRAM_KEY") as "clinicalWhoStage",
    getFirstARVPrescribed(p.patient_id) as "regimentAtArtInitiation",
    getARVTherapeuticLineAtInitiation(p.patient_id) as "lineAtInitiation",
    concatenateARTDrugs(p.patient_id, getMostRecentArvPickupDateBeforeReportEndDate(p.patient_id, "#endDate#"), getMostRecentArvPickupDateBeforeReportEndDate(p.patient_id, "#endDate#"))as "currentRegimen",
    getPatientMostRecentProgramAttributeCodedValue(p.patient_id, "397b7bc7-13ca-4e4e-abc3-bf854904dce3", "en") as "currentLine",
    IF(patientIsEligibleForVL(p.patient_id), "Yes", "No") as "eligibilityForVl",
    getDateLatestARVRelatedVisit(p.patient_id) as "dateOfLastVisit",
    getDateMostRecentARVAppointment(p.patient_id) as "lastAppointmentDate",
    getPatientMostRecentProgramOutcome(p.patient_id, "en", "HIV_PROGRAM_KEY") as "hivOutcome",
    getPatientMostRecentProgramAttributeCodedValue(p.patient_id, "39202f47-a709-11e6-91e9-0800270d80ce", "en") as "reasonsForConsultation",
    IF(getPatientMostRecentProgramOutcome(p.patient_id, "en", "HIV_PROGRAM_KEY")="Transferred Out", "Yes", "No") as "transfertOut",
    IF(getObsCodedValue(p.patient_id, "211f0857-61a3-4049-9777-374c4a592453") IS NOT NULL, "True", "False") as "kp",
    getObsCodedValue(p.patient_id, "211f0857-61a3-4049-9777-374c4a592453") as "kpType",
    getPatientOccupation(p.patient_id) as "profession",
    getPatientMostRecentProgramAttributeCodedValue(p.patient_id, "0a51d8d0-c775-48a2-9ca2-42c269d00bc2", "en") as "preTrackingOutcome",
    getPatientMostRecentProgramAttributeCodedValue(p.patient_id, "caf6d807-861d-4393-9d6e-940b98fa712d", "en") as "trackingOutcome",
    getViralLoadTestDate(p.patient_id) as "lastViralLoadResultDate",
    getViralLoadTestResult(p.patient_id) as "lastViralLoadResult",
    getReasonLastVLExam(p.patient_id) as "reasonOfLastVL",
    getProgramAttributeValueWithinReportingPeriod(p.patient_id, "#startDate#", "#endDate#", "8bb0bdc0-aaf3-4501-8954-d1b17226075b", "HIV_PROGRAM_KEY") as "APS Name",
    getObsCodedValue(p.patient_id, "76a912af-702e-47a0-83c4-246900861296") as "disclosureStatus",
    getObsCodedValueInSectionByNames(p.patient_id, "Screened", "TB Form") as "tbScreening",
    getINHStartDate(p.patient_id) as "inhDispenseDate",
    getINHDuration(p.patient_id) as "inhDuration",
    getPatientMostRecentProgramAttributeCodedValue(p.patient_id,"12afc1d3-74ba-428f-9a77-3fde76a136e4", "en") as "artDSDModels"
FROM patient p, (SELECT @a:= 0) AS a
WHERE
    patientHasEnrolledIntoHivProgram(p.patient_id) = "Yes" AND
    patientHasStartedARVTreatmentDuringReportingPeriod(p.patient_id, "#startDate#", "#endDate#");