SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getFacilityName() as "facilityName",
    getPatientIdentifier(p.patient_id) as "uniquePatientID",
    getPatientAge(p.patient_id) as "age",
    getPatientBirthdate(p.patient_id) as "birthDate",
    getPatientGender(p.patient_id) as "sex",
    CONCAT(getPatientVillage(p.patient_id),", ",getPatientPreciseLocation(p.patient_id)) as "Address",
    getPatientPhoneNumber(p.patient_id) as "contactTelephone",
    getHIVTestDate(p.patient_id, "2000-01-01","2100-01-01") as "HIVTestDate",
    getPatientARVStartDate(p.patient_id) as "dateOfARTInitiation",
    getObsDatetimeValue(p.patient_id, "c5b20e93-56c8-45e5-b65b-2b42ee49ecb0") as "referralDate",
    getObsCodedValue(p.patient_id, "cb654311-dac9-45e0-afc0-3c78ed432ea1") as "referralService",
    getObsCodedValue(p.patient_id, "2c45dfd3-5942-4b92-b440-e7dba02624df") as "whyToTransfer?",
    getObsCodedValue(p.patient_id, "982f8e67-f28c-444a-a739-d9f4051f96fc") as "howUrgent",
    getObsTextValue(p.patient_id, "d8a7d14b-74e9-4069-b689-270436134e1d") as "referredBy"
FROM patient p, (SELECT @a:= 0) AS a
WHERE
    getObsDatetimeValue(p.patient_id, "c5b20e93-56c8-45e5-b65b-2b42ee49ecb0") BETWEEN "#startDate#" AND "#endDate#";