SELECT
    CAST(@a:=@a+1 AS CHAR) as "Serial Number",
    getFacilityName() as "Facility Name",
    getPatientIdentifier(p.patient_id) as "Unique Patient ID",
    getPatientGender(p.patient_id) as "Sex",
    getPatientBirthdate(p.patient_id) as "Birth Date",
    getObsCodedValue(p.patient_id, "dfd8d6ba-0598-49fd-bcbf-def9b7ddb046") as "Date of Birth notification",
    getObsCodedValue(p.patient_id, "faa26470-f27a-4e1c-9cb3-635144fab88c") as "Place of Birth",
    getObsCodedValue(p.patient_id, "874d8740-7160-4b6a-a537-714f9c69a5db") as "Rank of Birth",
    getObsCodedValue(p.patient_id, "ab0db2f0-d514-4d22-85df-94fd3518ed7e") as "Declarant's Name",
    getObsCodedValue(p.patient_id, "0bbe4b60-8782-436f-ab30-3d21d556ba35") as "Relation",
    getObsCodedValue(p.patient_id, "ab0db2f0-d514-4d22-85df-94fd3518ed7e") as "Phone"
    FROM patient p, (SELECT @a:= 0) AS a
WHERE
    getObsCodedValue(p.patient_id, "dfd8d6ba-0598-49fd-bcbf-def9b7ddb046") BETWEEN "#startDate#" AND "#endDate#";