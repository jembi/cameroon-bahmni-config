SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getFacilityName() as "facilityName",
    getPatientIdentifier(p.patient_id) as "patientId",
    getDateFirstANCVisit(p.patient_id) as "dateOfAncVisit",
    getPatientANCNumber(p.patient_id) as "pregnancyId",
    getPatientBirthdate(p.patient_id) as "dateOfBirth",
    getPatientAgeInYearsAtDate(p.patient_id, getDateFirstANCVisit(p.patient_id)) as "ageAtFirstAnc",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"HIV Tested","Prior to ANC Enrolment") LIKE "Yes%", "Yes", "No") as "hivTestedBeforeAnc1",
    getObsCodedValueInSectionByNames(p.patient_id,"HTC, Result","Prior to ANC Enrolment") as "resultHivTestDoneBeforeAnc1",
    getObsDatetimeValueInSection(p.patient_id,"c6c08cdc-18dc-4f42-809c-959621bc9a6c", "d6cc3709-ffa0-42eb-b388-d7def4df30cf") as "dateOfTestAtAnc1",
    getObsCodedValueInSectionByNames(p.patient_id,"HTC, Result","At ANC Enrolment") as "resultTestAtAnc1",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"HTC, Result","At ANC Enrolment") IS NOT NULL, "Yes", "No") as "resultReceived",
    DATE(getProgramAttributeValueWithinReportingPeriod(p.patient_id, "2000-01-01","2100-01-01", "2dc1aafd-a708-11e6-91e9-0800270d80ce", "HIV_PROGRAM_KEY")) as "dateArtInitiation",
    getObsCodedValue(p.patient_id, "f961ec41-cd5d-4b45-91e0-0f5a408fea4b") as "arvStatus",
    getListOfActiveARVDrugs(p.patient_id, '#startDate#', '#endDate#') as "arvRegiment",
    IF(getObsCodedValue(p.patient_id, "f0447183-d13f-463d-ad0f-1f45b99d97cc") LIKE "Yes%", "Yes", "No") as "screenForTB",
    getObsCodedValue(p.patient_id, "61931c8b-0637-40f9-97dc-07796431dd3b") as "tbScreeningResult",
    IF(getObsCodedValue(p.patient_id, "5159ab7a-fdba-47bf-8ed1-4999c019bdb0") LIKE "Yes%", "Yes", "No") as "cotrim",
    IF(getObsCodedValue(p.patient_id, "18173a35-3c14-4282-a4fd-24e5ed395376") LIKE "Yes%", "Yes", "No") as "milda",
    IF(getObsCodedValue(p.patient_id, "56d1c828-b0c7-4253-98f6-f1023974983d") IS NOT NULL, "Yes", "No") as "vat"
FROM patient p, (SELECT @a:= 0) AS a
WHERE
  p.voided = 0
  AND getObsDatetimeValue(p.patient_id, "57d91463-1b95-4e4d-9448-ee4e88c53cb9") IS NOT NULL
  AND getDateFirstANCVisit(p.patient_id) BETWEEN "#startDate#" AND "#endDate#";