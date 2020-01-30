SELECT
    patient_id as 'ID',
    getPatientFullName(patient_id) as 'Name',
    getPatientAge(patient_id) as 'Age',
    getPatientBirthdate(patient_id) as 'Birthdate',
    getPatientGender(patient_id) as 'Gender',
    getPatientPhoneNumber(patient_id) as 'Phone Nr.',
    getPatientEmergencyContact(patient_id) as 'Emergency Contact',
    getPatientANCNumber(patient_id) as 'ANC Nr.',
    getPatientARTNumber(patient_id) as 'ART Nr.',
    getPatientCNINumber(patient_id) as 'NIC',
    getViralLoadTestDate(patient_id) as 'Vital Load Exam Date',
    getViralLoadTestResult(patient_id) as 'Vital Load Exam Result',
    getPatientARVStartDate(patient_id) as 'ARV Start Date',
    getListOfActiveARVDrugs(patient_id, '#startDate#', '#endDate#') as 'Used ARV Protocols whilst on treatment' 
FROM patient
WHERE
    patientHasEnrolledIntoHivProgram(patient_id) = "Yes" AND
    patientHasTherapeuticLine(patient_id, 0) AND
    patientHasStartedARVTreatmentBefore(patient_id, '#endDate#') AND
    patientWasOnARVTreatmentByDate(patient_id, '#startDate#') AND
    patientIsLostToFollowUp(patient_id, '#startDate#', '#endDate#') AND
    patientIsNotDead(patient_id) AND
    patientIsNotTransferredOut(patient_id);