SELECT
    getPatientIdentifier(v.patient_id),
    getPatientFullName(v.patient_id),
    getPatientAge(v.patient_id),
    getPatientBirthdate(v.patient_id),
    getPatientGender(v.patient_id),
    DATE(v.date_created),
    REPLACE(vt.name, 'VISIT_TYPE_', '' ),
    DATE(v.date_started),
    DATE(v.date_stopped),
    getServicesUsedDuringVisit(v.visit_id),
    getPatientPhoneNumber(v.patient_id),
    getPatientEmergencyContact(v.patient_id),
    getPatientPreciseLocation(v.patient_id),
    getPatientVillage(v.patient_id),
    getPatientCanton(v.patient_id),
    getPatientSubDivision(v.patient_id),
    getPatientDivision(v.patient_id),
    getPatientRegion(v.patient_id),
    getPatientEducation(v.patient_id),
    getPatientOccupation(v.patient_id),
    getPatientMatrimonialStatus(v.patient_id),
    getPatientANCNumber(v.patient_id),
    getPatientARTNumber(v.patient_id),
    getPatientCNINumber(v.patient_id),
    getPatientARVStartDate(v.patient_id),
    getViralLoadTestDate(v.patient_id),
    getViralLoadTestResult(v.patient_id),
    getListOfActiveARVDrugs(v.patient_id, '#startDate#', '#endDate#')
FROM visit v
    JOIN visit_type vt ON v.visit_type_id = vt.visit_type_id
WHERE
    v.date_started BETWEEN '#startDate#' AND '#endDate#';