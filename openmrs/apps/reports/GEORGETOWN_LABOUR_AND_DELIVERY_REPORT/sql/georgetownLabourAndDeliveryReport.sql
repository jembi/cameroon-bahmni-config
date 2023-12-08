SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getFacilityName() as "facilityName",
    getPatientIdentifier(r.person_a) as "patientID",
    getPatientAgeInYearsAtDate(r.person_a, NOW()) as "age",
    getObsDatetimeValueInSection(r.person_b, "0da273f6-92ee-4ddb-8a37-5e18cdc35441", "85177a85-f412-42eb-a81e-22f2d8eab1ef") as "dateOfDelivery",
    CONCAT(getPatientPreciseLocation(r.person_b),", ",getPatientVillage(r.person_b)) as "address",
    getPatientPhoneNumber(r.person_b) as "contactTelephone",
    IF(getObsCodedValue(r.person_b, "235ce45c-0b24-40cb-9d49-72de6566f36e") IS NOT NULL, "Yes", "No") as "HIVTestedBeforeDelivery?",
    getPatientBirthdate(r.person_a) as "dateOfBirth",
    getObsCodedValueInSectionByNames(r.person_b, "L&D_Test result", "L&D_Before") as "resultOfHIVTestDoneBeforeDelivery",
    getObsDatetimeValue(r.person_b, "0da273f6-92ee-4ddb-8a37-5e18cdc35441") as "dateOfHIVTestDuringDelivery",
    getObsCodedValueInSectionByNames(r.person_b, "L&D_Test result", "HIV testing in the delivery room or postpartum") as "resultOfHIVTestDuringDelivery",
    getObsDatetimeValue(r.person_b, "d986e715-14fd-4ae1-9ef2-7a60e3a6a54e") as "dateOfARTInitiation",
    getObsCodedValueInSectionByNames(r.person_b, "L&D_Status", "ART status during pregnancy") as "ARVStatus",
    getObsCodedValueInSectionByNames(r.person_b, "L&D_Protocol","ART status during pregnancy") as "ARVRegimen",
    getObsCodedValueInSectionByNames(r.person_b, "Type of delivery","L&D_Delivery") as "deliveryMode",
    getObsCodedValueInSectionByNames(r.person_b, "Gender", "L&D_Outcome  at birth and care of the newborn") as "sexOfNewborn",
    getObsCodedValueInSectionByNames(r.person_b, "WEIGHT", "L&D_Outcome  at birth and care of the newborn") as "weightOfInfantAtBirth",
    getObsCodedValueInSectionByNames(r.person_b, "Prophylaxis ARV","L&D_Outcome  at birth and care of the newborn") as "ARVProphylaxis",
    getObsCodedValueInSectionByNames(r.person_b, "Prophylaxis ARV Protocol","L&D_Outcome  at birth and care of the newborn") as "prophylaxisARVProtocol"
FROM (SELECT @a:= 0) AS a, relationship r
                               JOIN relationship_type rt ON rt.relationship_type_id = r.relationship AND rt.a_is_to_b = "RELATIONSHIP_BIO_MOTHER"
                               JOIN patient_identifier pi ON pi.patient_id = r.person_a AND pi.preferred = 1
WHERE
        getPatientBirthdate(r.person_a) BETWEEN "#startDate#" AND "#endDate#";