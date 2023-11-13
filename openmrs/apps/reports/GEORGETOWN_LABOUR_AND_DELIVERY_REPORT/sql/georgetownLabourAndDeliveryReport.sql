SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getFacilityName() as "facilityName",
    getPatientIdentifier(r.person_a) as "patientID",
    getPatientAgeInYearsAtDate(r.person_a, NOW()) as "age",
    getObsDatetimeValue(r.person_b, "7b88e743-c39f-44cb-8181-9c4eadcf2e12") as "dateOfDelivery",
    CONCAT(getPatientPreciseLocation(r.person_b),", ",getPatientVillage(r.person_b)) as "address",
    getPatientPhoneNumber(r.person_b) as "contactTelephone",
    getObsCodedValue(r.person_b, "235ce45c-0b24-40cb-9d49-72de6566f36e") as "HIVTestedBeforeDelivery?",
    getPatientBirthdate(r.person_a) as "dateOfBirth",
    getObsCodedValue(r.person_b, "d7b99d69-a262-4fdd-b46c-e47919ae13df") as "resultOfHIVTestDoneBeforeDelivery",
    getObsCodedValue(r.person_b, "") as "dateOfHIVTestDuringDelivery",
    getObsCodedValue(r.person_b, "d7b99d69-a262-4fdd-b46c-e47919ae13df") as "resultOfHIVTestDuringDelivery",
    getObsCodedValue(r.person_b, "3f41c8e5-ce72-4395-83a3-61248b0e83bd") as "dateOfARTInitiation",
    getObsCodedValue(r.person_b, "1c6106f6-f82e-48e3-8965-0618a267c939") as "ARVStatus",
    getObsCodedValue(r.person_b, "3f41c8e5-ce72-4395-83a3-61248b0e83bd") as "ARVRegimen",
    getObsCodedValue(r.person_b, "4618c38e-89a8-453e-ba03-45c123e313ce") as "deliveryMode",
    getObsCodedValue(r.person_b, "37fc1352-009c-4290-b740-265a77f29bbb") as "sexOfNewborn",
    getObsCodedValue(r.person_b, "d88caa84-c4d7-4001-ba8d-208b71250de7") as "weightOfInfantAtBirth",
    getObsCodedValue(r.person_b, "8241fe28-aee1-4782-8cff-3faf2e314a68") as "ARVProphylaxis",
    getObsCodedValue(r.person_b, "aec53b28-e957-492e-8421-244dff836076") as "prophylaxisARVProtocol"
FROM (SELECT @a:= 0) AS a, relationship r
                               JOIN relationship_type rt ON rt.relationship_type_id = r.relationship AND rt.a_is_to_b = "RELATIONSHIP_BIO_MOTHER"
                               JOIN patient_identifier pi ON pi.patient_id = r.person_a AND pi.preferred = 1
WHERE
        getPatientBirthdate(r.person_a) BETWEEN "#startDate#" AND "#endDate#";