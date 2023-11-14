SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getFacilityName() as "facilityName",
    getPatientIdentifier(p.patient_id) as "uniquePatientID",
    getPatientGender(p.patient_id) as "sex",
    getPatientBirthdate(p.patient_id) as "birthDate",
    getObsDatetimeValue(p.patient_id, "dfd8d6ba-0598-49fd-bcbf-def9b7ddb046") as "dateOfBirthnotification",
    getObsTextValue(p.patient_id, "faa26470-f27a-4e1c-9cb3-635144fab88c")  as "placeOfBirth",
    getObsNumericValue(p.patient_id, "874d8740-7160-4b6a-a537-714f9c69a5db") as "rankOfBirth",
    getObsTextValue(p.patient_id, "deaedc5b-df3d-4b16-9c8e-8273204d06ed") as "declarantsName",
    getObsTextValue(p.patient_id, "0bbe4b60-8782-436f-ab30-3d21d556ba35") as "relation",
    getObsTextValue(p.patient_id,"7e919f25-0e0f-43e3-ad5b-1672edde58aa") as "phone"
    FROM patient p, (SELECT @a:= 0) AS a
WHERE
    getObsDatetimeValue(p.patient_id, "dfd8d6ba-0598-49fd-bcbf-def9b7ddb046") BETWEEN "#startDate#" AND "#endDate#";