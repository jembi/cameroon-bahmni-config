SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    "N/A" as "drugSource",
    getPatientARTNumber(v.patient_id) as "existingArtCode",
    DATE(v.date_started) as "visitDate",
    getPatientBirthdate(v.patient_id) as "dateOfBirth",
    getPatientAge(v.patient_id) as "age",
    getPatientGender(v.patient_id) as "sex",
    getProgramAttributeDateValueFromAttributeAndProgramName(v.patient_id, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", "HIV_PROGRAM_KEY") as "artStartDate",
    getPatientPhoneNumber(v.patient_id) as "telephone",
    getDateMostRecentARVAppointment(v.patient_id) as "nextAppointmentDate",
    getListOfActiveARVDrugs(v.patient_id, "#startDate#", "#endDate#") as "arvRegimen",
    IF(patientHasBeenPrescribedDrug(v.patient_id, "Cotrimoxazole","#startDate#", "#endDate#"),"Yes","No") as "cotrim",
    IF(getObsCodedValue(v.patient_id, "f0447183-d13f-463d-ad0f-1f45b99d97cc") LIKE "Yes%", "Yes", "No") as "tbScreening",
    getTBScreeningStatus(v.patient_id) as "tbScreeningResult",
    IF(patientHasBeenPrescribedDrug(v.patient_id, "INH","#startDate#", "#endDate#"),"Yes","No") as "inh",
    getHIVResult(v.patient_id, "2000-01-01", "2100-01-01") as "patientStatus",
    getPatientMostRecentProgramAttributeCodedValue(v.patient_id, "397b7bc7-13ca-4e4e-abc3-bf854904dce3", "en") as "treatmentLine",
    getDurationMostRecentArvTreatmentInMonths(v.patient_id, "2000-01-01", "2100-01-01") as "numberOfMonthsDispensed",
    getPatientMostRecentProgramOutcome(v.patient_id, "en", "HIV_PROGRAM_KEY") as "previousOutcome",
    getPreviousRegimen(v.patient_id, "2000-01-01", "2100-01-01") as "previousRegimen",
    IF(getPreviousRegimen(v.patient_id, "2000-01-01", "2100-01-01") IS NOT NULL, "Yes", "No") as "switchedLine",
    "N/A" as "reasonOfSwitchLine"
FROM (SELECT @a:= 0) AS a, visit v
    JOIN visit_type vt ON v.visit_type_id = vt.visit_type_id
WHERE
    vt.name = "VISIT_TYPE_OPD" AND
    v.date_started BETWEEN "#startDate#" AND "#endDate#";