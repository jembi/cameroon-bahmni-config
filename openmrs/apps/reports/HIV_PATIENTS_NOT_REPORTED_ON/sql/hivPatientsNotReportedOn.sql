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
    patientTherapeuticLineSpecified(pat.patient_id) as "Therapeutic Line Specified?"
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
	