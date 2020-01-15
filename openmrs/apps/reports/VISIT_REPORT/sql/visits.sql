SELECT
    getPatientIdentifier(v.patient_id) as 'ID',
    getPatientFullName(v.patient_id) as 'Name',
    getPatientAge(v.patient_id) as 'Age',
    getPatientBirthdate(v.patient_id) as 'Birthdate',
    getPatientGender(v.patient_id) as 'Gender',
    DATE(v.date_created) as 'Created',
    REPLACE(vt.name, 'VISIT_TYPE_', '' ) as 'Visit Type',
    DATE(v.date_started) as 'Started',
    DATE(v.date_stopped) as 'Stopped',
    getServicesUsedDuringVisit(v.visit_id) as 'Services',
    getPatientPhoneNumber(v.patient_id) as 'Phone Nr.',
    getPatientEmergencyContact(v.patient_id) as 'Emergency Contact',
    getPatientPreciseLocation(v.patient_id) as 'Precise Location',
    getPatientVillage(v.patient_id) as 'Village',
    getPatientCanton(v.patient_id) as 'Canton',
    getPatientSubDivision(v.patient_id) as 'Sub Division',
    getPatientDivision(v.patient_id) as 'Division',
    getPatientRegion(v.patient_id) as 'Region',
    getPatientEducation(v.patient_id) as 'Edu Level',
    getPatientOccupation(v.patient_id) as 'Occupation',
    getPatientMatrimonialStatus(v.patient_id) as 'Marital Status',
    getPatientANCNumber(v.patient_id) as 'ANC Nr.',
    getPatientARTNumber(v.patient_id) as 'ART Nr.',
    getPatientCNINumber(v.patient_id) as 'NIC',
    getPatientARVStartDate(v.patient_id) as 'ARV Start Date',
    getViralLoadTestDate(v.patient_id) as 'Viral Load Test Date',
    getViralLoadTestResult(v.patient_id) as 'Viral Load Test Result',
    getListOfActiveARVDrugs(v.patient_id, '#startDate#', '#endDate#') as 'Active Drugs'
FROM visit v
    JOIN visit_type vt ON v.visit_type_id = vt.visit_type_id
WHERE
    v.date_started BETWEEN '#startDate#' AND '#endDate#';