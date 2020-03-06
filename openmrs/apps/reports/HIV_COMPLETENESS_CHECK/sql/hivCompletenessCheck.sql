SELECT
    (@row_number:=@row_number + 1) as "Nr.",
    pn.given_name as "First Name",
    pn.family_name as "Last Name",
    UPPER(per.gender) as "Gender",
    per.birthdate as "Date of Birth",
    pi.identifier as "Patient Identifier",
    patientHasEnrolledIntoHivProgram(pat.patient_id) as "Enrolled into HIV Program?",
    arvInitiationDateSpecified(pat.patient_id) as "ARV Initiation Date Specified?",
    patientHasAtLeastOneArvDrugPrescribed(pat.patient_id) as "Has at least one ARV drug prescribed?",
    patientLatestArvDrugWasDispensed(pat.patient_id) as "Latest ARV drug was dispensed?",
    patientTherapeuticLineSpecified(pat.patient_id) as "Therapeutic Line Specified?",
    patientHasScheduledAnAppointmentDuringReportingPeriod(pat.patient_id,"#startDate#","#endDate#","APPOINTMENT_SERVICE_ART_KEY") as "ART Appointment Scheduled?",
    patientHasScheduledAnAppointmentDuringReportingPeriod(pat.patient_id,"#startDate#","#endDate#","APPOINTMENT_SERVICE_ART_DISPENSARY_KEY") as "ART Dispensary Appointment Scheduled?",
    getPatientEntryPointAndModality(pat.patient_id) as "Testing Entry Point and Modality Specified?",
    getPatientInformedConsent(pat.patient_id) as "Informed Consent Specified?",
    getPatientHIVTestDate(pat.patient_id) as "HIV Test Date Specified?",
    getPatientHIVFinalTestResult(pat.patient_id) as "Final Test Result Specified?",
    getPatientIndexTestingOffered(pat.patient_id) as "Index Testing offered?",
    getPatientIndexTestingAccepted(pat.patient_id) as "Index Testing Accepted?",
    patientHadALeastOneViralLoadExam(pat.patient_id) as "Viral Load Exam Done?",
    patientHadACD4Exam(pat.patient_id) as "CD4 Exam Done?",
    getNumberOfVisits(pat.patient_id,"#startDate#","#endDate#","LOCATION_ART") as "Nr. Of ART Visits",
    getNumberOfVisits(pat.patient_id,"#startDate#","#endDate#","LOCATION_ART_DISPENSATION") as "Nr. Of ART Dispensary Visits",
    getDateLatestARTOrARTDispensaryVisit(pat.patient_id) as "Date of Last ART or ART Dispensary Visit",
    getPatientHivInitialFormLastModificationDate(pat.patient_id) as "Patient with HIV - Initial Form - Date Last Modified",
    getPatientHivFollowUpFormLastModificationDate(pat.patient_id) as "Patient with HIV - Follow Up Form - Date Last Modified",
    getPatientLabResultLastModificationDate(pat.patient_id) as "Manual Lab Results Form - Date Last Modified",
    getPatientChildExposedLastModificationDate(pat.patient_id) as "Child Exposed to HIV Form - Date Last Modified",
    getPatientChildExposedFollowUpLastModificationDate(pat.patient_id) as "Child Exposed to HIV Follow Up Form - Date Last Modified",
    getPatientANCInitialLastModificationDate(pat.patient_id) as "ANC Initial Form - Date Last Modified",
    getPatientANCFollowUpLastModificationDate(pat.patient_id) as "ANC Follow Up Form - Date Last Modified",
    getPatientHIVTestingAndCounsellingLastModificationDate(pat.patient_id) as "HIV Testing and Counselling Form - Date Last Modified",
    getPatientHistoryAndExaminationLastModificationDate(pat.patient_id) as "History and Examination Form - Date Last Modified",
    getPatientSystemAndPhysicalExamLastModificationDate(pat.patient_id) as "System and Physical Exams Form - Date Last Modified"
FROM patient pat
	JOIN person_name pn ON pn.person_id = pat.patient_id
    JOIN person per ON per.person_id = pat.patient_id
    JOIN patient_identifier pi ON pi.patient_id = pat.patient_id,
    (SELECT @row_number:=0) AS t
WHERE
    pi.preferred = 1 AND
    patientHadAHivRelatedVisitWithinReportingPeriod(pat.patient_id, "#startDate#","#endDate#");