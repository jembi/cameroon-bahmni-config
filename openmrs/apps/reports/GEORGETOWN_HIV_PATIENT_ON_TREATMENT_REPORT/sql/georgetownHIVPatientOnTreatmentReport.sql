SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getPatientARTNumber(pat.patient_id) as "existingArtCode",
    getFacilityName() as "facilityName",
    getPatientIdentifier(pat.patient_id) as "uniquePatientID",
    getPatientAgeInYearsAtDate(pat.patient_id,"#endDate#") as "age",
    getPatientBirthdate(pat.patient_id) as "dateOfBirth",
    getPatientGender(pat.patient_id) as "sex",
    getPatientHIVTestDate(pat.patient_id) as "hivTestDate",
    getProgramAttributeDateValueFromAttributeAndProgramName(pat.patient_id, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", "HIV_PROGRAM_KEY") as "artStartDate",
    CONCAT(getPatientVillage(pat.patient_id),",",getPatientPreciseLocation(pat.patient_id)) as "address",
    getPatientPhoneNumber(pat.patient_id) as "telephone",
    getPatientMostRecentProgramTrackingStateValue(pat.patient_id,"en","HIV_PROGRAM_KEY") as "clinicalWhoStage",
    getFirstARVPrescribed(pat.patient_id) as "regimentAtArtInitiation",
    getARVTherapeuticLineAtInitiation(pat.patient_id) as "lineAtInitiation",
    getActiveARVWithLowestDispensationPeriod(pat.patient_id, "2000-01-01", "2100-01-01") as "currentRegimen",
    getPatientMostRecentProgramAttributeCodedValue(pat.patient_id, "397b7bc7-13ca-4e4e-abc3-bf854904dce3", "en") as "currentLine",
    IF(patientIsEligibleForVL(pat.patient_id), "Yes", "No") as "eligibilityForVl",
    getDateLatestARVRelatedVisit(pat.patient_id) as "dateOfLastVisit",
    getDateMostRecentARVAppointment(pat.patient_id) as "lastAppointmentDate",
    getPatientANCStatus(pat.patient_id) as "newOrAlreadyEnrolled",
    getPregnancyStatus(pat.patient_id) as "patientIsPregnant",
    IF(getProgramAttributeValueWithinReportingPeriod(pat.patient_id, "#startDate#", "#endDate#", "242c9027-dc2d-42e6-869e-045e8a8b95cb")="true","Yes","No") as "patientIsBreastfeeding",
    IF(getObsCodedValue(pat.patient_id, "f0447183-d13f-463d-ad0f-1f45b99d97cc") LIKE "Yes%", "Yes", "No") as "tbScreening",
    getTBScreeningStatus(pat.patient_id) as "tbScreeningResult",
    IF(patientHasBeenPrescribedDrug(pat.patient_id, "INH","#startDate#", "#endDate#"),"Yes","No") as "inh",
    getProgramAttributeDateValueFromAttributeAndProgramName(pat.patient_id, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", "TB_PROGRAM_KEY") as "dateOfTxTbStart",
    getLastArvPickupDate(pat.patient_id,"#startDate#", "#endDate#") as "lastARVDispenseDate",
    getLastARVDispensed(pat.patient_id,"#startDate#", "#endDate#") as "getLastARVDispensed",
    getDurationMostRecentArvTreatmentInDays(pat.patient_id,"#startDate#", "#endDate#") as "durationMostRecentArv",
    getPatientMostRecentProgramAttributeCodedValue(pat.patient_id, "39202f47-a709-11e6-91e9-0800270d80ce", "en") as "reasonForInitiation",
    IF(patientIsNotTransferredOut(pat.patient_id),"No","Yes") as "patientIsTransferedOut",
    IF(getObsCodedValue(pat.patient_id, "211f0857-61a3-4049-9777-374c4a592453") IS NOT NULL, "True", "False") as "kp",
    getObsCodedValue(pat.patient_id, "211f0857-61a3-4049-9777-374c4a592453") as "kpType",
    getViralLoadTestDate(pat.patient_id) as "lastViralLoadResultDate",
    getViralLoadTestResult(pat.patient_id) as "lastViralLoadResult",
    getReasonLastVLExam(pat.patient_id) as "reasonOfLastVL"
FROM (SELECT @a:= 0) AS a, patient pat
WHERE
    (
        (
            patientHasStartedARVTreatmentDuringReportingPeriod(pat.patient_id, "#startDate#", "#endDate#") AND
            patientWasPrescribedARVDrugDuringReportingPeriod(pat.patient_id,"#startDate#", "#endDate#")
        )
        OR
        (
            patientHasStartedARVTreatmentBefore(pat.patient_id, "#startDate#") AND
            patientPrescribedARTDuringPartOfReportingPeriod(pat.patient_id, "#startDate#")
        )
    ) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotDead(pat.patient_id) AND
    (
        patientIsNotTransferredOut(pat.patient_id) OR
        patientPrescribedARTDuringPartOfReportingPeriod(pat.patient_id, "#startDate#")
    );