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
    0 as "ART Appointment Scheduled?",
    0 as "ART Dispensary Appointment Scheduled?",
    0 as "Testing Entry Point and Modality Specified?",
    0 as "Informed Consent Specified?",
    0 as "HIV Test Date Specified?",
    0 as "Final Test Result Specified?",
    0 as "Index Testing offered?",
    0 as "Index Testing Accepted?",
    0 as "Viral Load Exam Done?",
    0 as "CD4 Exam Done?",
    0 as "Nr. Of ART Visits",
    0 as "Nr. Of ART Dispensary Visits",
    0 as "Date of Last ART or ART Dispensary Visit",
    0 as "Patient with HIV - Initial Form - Date Last Modified",
    0 as "Patient with HIV - Follow Up Form - Date Last Modified",
    0 as "Manual Lab Results Form - Date Last Modified",
    0 as "Child Exposed to HIV Form - Date Last Modified",
    0 as "Child Exposed to HIV Follow Up Form - Date Last Modified",
    0 as "ANC Initial Form - Date Last Modified",
    0 as "ANC Follow Up Form - Date Last Modified",
    0 as "HIV Testing and Counselling Form - Date Last Modified",
    0 as "History and Examination Form - Date Last Modified",
    0 as "System and Physical Exams Form - Date Last Modified"
FROM patient pat
	JOIN person_name pn ON pn.person_id = pat.patient_id
    JOIN person per ON per.person_id = pat.patient_id
    JOIN patient_identifier pi ON pi.patient_id = pat.patient_id,
    (SELECT @row_number:=0) AS t
WHERE
   (
       patientHasRegisteredWithinReportingPeriod(pat.patient_id, "#startDate#","#endDate#") = TRUE AND
       (
            patientHasEnrolledIntoHivProgram(pat.patient_id) = "No" OR
            arvInitiationDateSpecified(pat.patient_id) = "No" OR
            patientHasAtLeastOneArvDrugPrescribed(pat.patient_id) = "No" OR
            patientLatestArvDrugWasDispensed(pat.patient_id) = "No" OR
            patientTherapeuticLineSpecified(pat.patient_id) = "No"
       ) AND 
       (
            patientHasEnrolledIntoHivProgram(pat.patient_id) = "Yes" OR
            arvInitiationDateSpecified(pat.patient_id) = "Yes" OR
            patientHasAtLeastOneArvDrugPrescribed(pat.patient_id) = "Yes" OR
            patientLatestArvDrugWasDispensed(pat.patient_id) = "Yes" OR
            patientTherapeuticLineSpecified(pat.patient_id) = "Yes"
       )
   );
	