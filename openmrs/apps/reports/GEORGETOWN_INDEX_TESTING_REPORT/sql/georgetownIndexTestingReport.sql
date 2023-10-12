SELECT DISTINCT
    '' as "Serial Number",
    getFacilityName() as "Facility Name",
    getPatientIdentifier(p.patient_id) as "Unique Patient ID",
    getPatientBirthdate(p.patient_id) as "Date of Birth",
    getPatientAge(p.patient_id) as "Age",
    getPatientGender(p.patient_id) as "Sex",
    CONCAT(getPatientVillage(p.patient_id),",",getPatientPreciseLocation(p.patient_id)) as "Address",
    getFirstIndexRelationship(p.patient_id) as "Relation with index",
    getPatientMostRecentProgramTrackingStateValue(p.patient_id,"en","INDEX_TESTING_PROGRAM_KEY") as "Notified for Index case testing ?",
    getHistoricalDateOfNotification(ppah.patient_program_id, ppah.date_created) as "Date of Notification",
    getNotificationOutcome(ppah.patient_program_id, ppah.date_created) as "Notification Outcome",
    getPatientPhoneNumber(p.patient_id) as "Contact telephone",
    IF(getHIVTestDate(p.patient_id,"2000-01-01","2100-01-01") IS NOT NULL, "Yes", "") as "Tested for HIV ?",
    getHIVTestDate(p.patient_id,"2000-01-01","2100-01-01") as "HIV Test Date",
    getHIVResult(p.patient_id,"2000-01-01","2100-01-01") as "Test results",
    DATE(getProgramAttributeValueWithinReportingPeriod(p.patient_id, "2000-01-01","2100-01-01", "2dc1aafd-a708-11e6-91e9-0800270d80ce", "HIV_PROGRAM_KEY")) as "Date of Initiation",
    getPatientARTNumber(getFirstIndexID(p.patient_id)) as "Index Related ART Code",
    getPatientIdentifier(getFirstIndexID(p.patient_id)) as "Index Related Unique ID",
    getProgramAttributeValueWithinReportingPeriod(p.patient_id, "#startDate#", "#endDate#", "d7246eea-5161-43e0-b840-d315c24cc95e", "INDEX_TESTING_PROGRAM_KEY") as "APS Name"
FROM patient p
    LEFT JOIN patient_program pp ON pp.patient_id = p.patient_id
    LEFT JOIN patient_program_attribute_history ppah ON ppah.patient_program_id = pp.patient_program_id
    LEFT JOIN program_attribute_type pat ON pat.program_attribute_type_id = ppah.attribute_type_id
        AND pat.name IN ("PROGRAM_MANAGEMENT_2_NOTIFICATION_DATE", "PROGRAM_MANAGEMENT_3_NOTIFICATION_OUTCOME")
WHERE
    patientIsContact(p.patient_id) AND
    (
        getHIVTestDate(p.patient_id,"#startDate#", "#endDate#") IS NOT NULL OR
        patientHasEnrolledIntoProgramDuringReportingPeriod(p.patient_id,"#startDate#", "#endDate#","INDEX_TESTING_PROGRAM_KEY")
    )
ORDER BY ppah.date_created DESC;