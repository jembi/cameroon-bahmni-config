SELECT
    @a:=@a+1 as "Serial Number",
    getPatientIndexTestingDateOffered(p.patient_id) as "Date of Service Offered",
    SUBSTRING(getPatientIndexTestingAccepted(p.patient_id),1,3) as "ICT Service Accepted ?",
    getPatientIndexTestingDateAccepted(p.patient_id) as "Date of Service accepted",
    getNumberOfContactsRelatedToIndex(p.patient_id) as "Number of Contact elicited",
    getNumberBiologicalChildrenOfIndex(p.patient_id, "#startDate#", "#endDate#") as "Number of Biological Children",
    getNumberBiologicalParentsOfIndex(p.patient_id, "#startDate#", "#endDate#") as "Number of Biological Parents",
    getNumberSiblingsOfIndex(p.patient_id, "#startDate#", "#endDate#") as "Number of Siblings"
FROM patient p, (SELECT @a:= 0) AS a
WHERE patientIsIndex(p.patient_id);