SELECT DISTINCT
    getPatientIdentifier(v.patient_id) as "Patient ID",
    getObsTextValue(v.patient_id, 'd1fb2520-75a1-4a79-9268-0d723b69719f') as "ID Collection",
    getFacilityName() as "FOSA",
    getPatientBirthdate(v.patient_id) as "DOB",
    getPatientAge(v.patient_id) as "age",
    getObsDatetimeValue(v.patient_id, '9169e24e-d0e1-4707-8686-123e677c2f4e') as "Initiation Date",
    getObsTextValue(v.patient_id, 'a67b3674-8320-4bee-a26a-f48fc2d7829b') as "Protocol",
    getObsDatetimeValue(v.patient_id, '8efd308d-5635-4618-9e7c-9d34aa805aa6') as "Sample Collection Date",
    getObsCodedValue(v.patient_id, '41e44aca-6985-4481-be6f-63216ffba7a7') as "Nature PLVT",
    getObsCodedValue(v.patient_id, '90675c25-8a4c-4e5a-bf41-fc41f03d593f') as "Quality",
    getObsCodedValue(v.patient_id, '0129a673-0f69-4584-8c7b-251e84af11ff') as "reason for collection",
    getObsCodedValue(v.patient_id, '7c055bd2-2a41-4c14-956a-8686d8eb08bf') as "Nature",
    getObsCodedValue(v.patient_id, 'f961ec41-cd5d-4b45-91e0-0f5a408fea4b') as "On ART",
    getObsCodedValue(v.patient_id, 'a8bc4608-eaae-4610-a842-d83d6261ea49') as "Line",
    getObsCodedValue(v.patient_id, '03dcf722-0616-47bf-8e50-5258e75149e3') as "Technique",
    getObsCodedValue(v.patient_id, '78f6e9aa-8282-4135-85f8-ade2b7f88455') as "Machine",
    getObsTextValue(v.patient_id, '7094d79a-85da-4491-8256-cee2ad08ddba') as "Prescriber",
    getObsTextValue(v.patient_id, '7094d79a-85da-4491-8256-cee2ad08ddba') as "Results",
    getObsNumericValue(v.patient_id, 'dbcf12b3-047d-47cf-a1af-95a77f4c8c0f') as "Value",
    getObsTextValue(v.patient_id, '24c50bee-cb17-44ee-b50a-e68372670ed1') as "Analyzed by",
    getObsTextValue(v.patient_id, '2361e271-ba80-4054-b9ff-254c62466bd8') as "Approved by"

FROM visit v
WHERE isFormFilledWithinReportingPeriod(v.patient_id, 'adf1fa68-336a-4c1f-b26e-8b77b305e487', "#startDate#", "#endDate#") = 1;