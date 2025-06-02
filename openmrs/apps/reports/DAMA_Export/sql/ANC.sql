SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getPatientBirthdate(p.patient_id) as "dateOfBirth",
    getDateFirstANCVisit(p.patient_id) as "dateOfAncVisit",
    getPatientANCNumber(p.patient_id) as "pregnancyId",
    CONCAT(pn.given_name, ' ', pn.family_name) AS 'Name of Client',
    getPatientEmergencyContactName(patient_id) as 'Name of Mother',
    CONCAT(getPatientVillage(p.patient_id),",",getPatientPreciseLocation(p.patient_id)) as "address",
    getPatientPhoneNumber(p.patient_id) as "Client Telephone",
    getPatientEmergencyContact(patient_id) as 'Contact Telephone',
    getPatientAgeInYearsAtDate(p.patient_id,"#endDate#") as "ANC08",
    getPatientMatrimonialStatus(p.patient_id) as 'Marital Status',
    
    "NumberOfPregnancies",
    "NumberOfDeliveries",
    "NumberOfPrematurities",
    "NumberOfAbortions",
    "NumberOfChildren",
    "LMP",
    getObsNumericValue(p.patient_id,"5c5352a7-7a99-4ea5-8ca4-ff8d882f5c20") as "FundalHeight",
    getObsNumericValue(p.patient_id,"84af6048-592a-433f-be20-18c9594fcb3f") as "PregnancyAge",
    getObsDatetimeValueInSection(p.patient_id,"47cffd8e-d84f-471f-8468-1e8f951c56c1", "f9ca8b2d-d89f-493e-a531-9ee815597569") as "EDD",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Councelling done","Pregnancy Status at 1st Visit")LIKE "Yes%", "Yes", "No") as "CounselingAtANCEnrolment",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"HIV Tested","Prior to ANC Enrolment") LIKE "Yes%", "Yes", "No") as "PriorHIVTestDone",
    getObsDatetimeValueInSection(p.patient_id,"c6c08cdc-18dc-4f42-809c-959621bc9a6c", "d6cc3709-ffa0-42eb-b388-d7def4df30cf") as "HIVTestDateAtEnrolment",
    getObsCodedValueInSectionByNames(p.patient_id,"HTC, Result","Partners HIV status") as "HIVTestResultsOfPartner",
    IF(getObsCodedValue(p.patient_id, "f0447183-d13f-463d-ad0f-1f45b99d97cc") LIKE "Yes%", "Yes", "No") as "TBScreening",
    getObsCodedValue(p.patient_id, "61931c8b-0637-40f9-97dc-07796431dd3b") as "tbScreeningResult",
    getObsCodedValue(p.patient_id, "3dce13a8-c7e5-45ec-a6f0-8050fd4a2ca2") as "TBOutcome",
    getObsCodedValueInSectionByNames(p.patient_id,"ART, Status","ARVs / ART") as "ARVStatus",
    getObsCodedValueInSectionByNames(p.patient_id,"HIVTC, Mothers ARV Regimen","ARVs / ART") as "ARVRegimen",
    getObsDatetimeValueInSection(p.patient_id,"d986e715-14fd-4ae1-9ef2-7a60e3a6a54e", "89b1cd66-c33a-4ef4-b208-5d86502f14ec") as "ARVStartDate",
    getObsNumericValue(p.patient_id,"ae4e6b70-b8ce-4672-b41b-e9bdd31fe4f8") as "NumberOfTabs",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"HIV Tested","Partners HIV status") LIKE "Yes%", "Yes", "No") as "PartnerTested",
    getObsCodedValueInSectionByNames(p.patient_id,"HTC, Result","Partners HIV status") as "PartnerTestResults",
    getObsDatetimeValueInSection(p.patient_id,"c6c08cdc-18dc-4f42-809c-959621bc9a6c", "96d8c90a-7d81-49d9-940f-b8706e7f6afe") as "PartnerTestDate",
    getDateFirstANCVisit(p.patient_id) as "ANCDate",
    IF(getObsCodedValueInSectionByNames(p.patient_id, 'Anti-tetanus toxoid (ATT)', 'LLIN/Medication received') = 'Number, 1', 'True', 'False') AS "Tetanus1",
    IF(getObsCodedValueInSectionByNames(p.patient_id, 'Anti-tetanus toxoid (ATT)', 'LLIN/Medication received') = 'Number, 2', 'True', 'False') AS "Tetanus2",
    IF(getObsCodedValueInSectionByNames(p.patient_id, 'Anti-tetanus toxoid (ATT)', 'LLIN/Medication received') = 'Number, 3', 'True', 'False') AS "Tetanus3",
    IF(getObsCodedValueInSectionByNames(p.patient_id, 'Anti-tetanus toxoid (ATT)', 'LLIN/Medication received') = 'Number, 4', 'True', 'False') AS "Tetanus4",
    IF(getObsCodedValueInSectionByNames(p.patient_id, 'Anti-tetanus toxoid (ATT)', 'LLIN/Medication received') = 'Number, 5', 'True', 'False') AS "Tetanus5",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Long lasting insecticide net (LLIN)","LLIN/Medication received") LIKE "Yes%", "Yes", "No") as "InsecticideNet",
    IF(getObsCodedValueInSectionByNames(p.patient_id, 'Malaria IPT', 'LLIN/Medication received') = 'Number, 1', 'True', 'False') AS "malaria1",
    IF(getObsCodedValueInSectionByNames(p.patient_id, 'Malaria IPT', 'LLIN/Medication received') = 'Number, 2', 'True', 'False') AS "malaria2",
    IF(getObsCodedValueInSectionByNames(p.patient_id, 'Malaria IPT', 'LLIN/Medication received') = 'Number, 3', 'True', 'False') AS "malaria3",
    IF(getObsCodedValueInSectionByNames(p.patient_id, 'Malaria IPT', 'LLIN/Medication received') = 'Number, 4', 'True', 'False') AS "malaria4",
    IF(getObsCodedValueInSectionByNames(p.patient_id, 'Malaria IPT', 'LLIN/Medication received') = 'Number, 5', 'True', 'False') AS "malaria5",
    IF(getObsCodedValueInSectionByNames(p.patient_id, 'Malaria IPT', 'LLIN/Medication received') = 'Not Applicable', 'True', 'False') AS "MalariaNA",
    CASE 
        WHEN getObsCodedValueInSectionByNames(p.patient_id, 'Received Cotrimoxazole', 'LLIN/Medication received') LIKE 'Yes%' THEN 'Yes'
        WHEN getObsCodedValueInSectionByNames(p.patient_id, 'Received Cotrimoxazole', 'LLIN/Medication received') LIKE 'Not Applicable%' THEN 'Not Applicable'
        ELSE 'No'
    END AS "Cotrimoxazole",
    getObsDatetimeValueInSection(p.patient_id,"c6c08cdc-18dc-4f42-809c-959621bc9a6c", "130e05df-8283-453b-a611-d4f884fac8e0") as "ANC13PriorTestDate",
    getObsCodedValueInSectionByNames(p.patient_id,"HTC, Result","Prior to ANC Enrolment") as "ANC13PriorTestResult",
    getObsCodedValueInSectionByNames(p.patient_id,"HTC, Result","Prior to ANC Enrolment") as "ANC13PriorTestRepeated",
    getObsDatetimeValueInSection(p.patient_id,"541d9f7b-f622-4ebc-a3a3-50c970d4cce0", "130e05df-8283-453b-a611-d4f884fac8e0") as "ANC13PriorRepeatTestDate",
    getObsCodedValueInSectionByNames(p.patient_id,"Repeat Test Result","Prior to ANC Enrolment") as "ANC13PriorRepeatTestResults",
    CASE 
        WHEN getObsCodedValueInSectionByNames(p.patient_id, 'HIV Tested', 'At ANC Enrolment') LIKE 'Yes%' THEN 'Yes'
        WHEN getObsCodedValueInSectionByNames(p.patient_id, 'HIV Tested', 'At ANC Enrolment') LIKE 'Unknown%' THEN 'Unknown'
        WHEN getObsCodedValueInSectionByNames(p.patient_id, 'HIV Tested', 'At ANC Enrolment') LIKE 'Refused%' THEN 'Refused'
        WHEN getObsCodedValueInSectionByNames(p.patient_id, 'HIV Tested', 'At ANC Enrolment') LIKE 'Stock%' THEN 'Stock Out'
        ELSE 'No'
    END AS "ANC13TestedAtEnrollment",
    getObsCodedValueInSectionByNames(p.patient_id,"Repeat Test done if (P)","At ANC Enrolment") as "ANC13RepeatTestDone",
    getObsDatetimeValueInSection(p.patient_id,"541d9f7b-f622-4ebc-a3a3-50c970d4cce0", "d6cc3709-ffa0-42eb-b388-d7def4df30cf") as "ANC13RepeatTestDate",
    getObsCodedValueInSectionByNames(p.patient_id,"Repeat Test Result","At ANC Enrolment") as "ANC13RepeatTestResult",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Fe/Folate","Medications received") LIKE 'Yes%', 'Yes', 'No' ) as "MedicationFeFolate",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Other Medications received","Medications received") Like 'Yes%', 'Yes', 'No') as "MedicationOther",
    
    getNumericLabTestResult(p.patient_id,4252) as "HBSAntigen",
    "HB",
    "UrineSugar",
    getObsCodedValueInSectionByNames(p.patient_id,"Albumin (Urine)","Laboratory tests and results") as "AlbuminUria",
    "Eletrophresis",
    "BloodGroup",
    "RhesisFactor",
    "MP",
    "True" AS "IsFirstANCDoneInThisFacility",
    "ANC" AS "EntryPoint",
    getPatientARTNumber(p.patient_id) AS "BaselineReference",
   "28122NW00775716QRTMT" AS "TestingCounselorCode",
    getPatientAgeInYearsAtDate(p.patient_id,"#endDate#") as "ANC08",
   "ClientReceivedInFacility" AS "True",
    getPatientOccupation(p.patient_id) as "profession",
    getPatientCNINumber(p.patient_id) as 'NIC',
    IF(getObsCodedValueInSectionByNames(p.patient_id,"HIV Tested","Prior to ANC Enrolment") LIKE "Yes%", "Yes", "No") as "KnownHIVCase"

    FROM patient p
    JOIN person_name pn ON pn.person_id = p.patient_id
    CROSS JOIN (SELECT @a:= 0) AS a
WHERE
  p.voided = 0
  AND getDateFirstANCVisit(p.patient_id) BETWEEN "#startDate#" AND "#endDate#";
