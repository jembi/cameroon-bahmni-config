SELECT
    getPatientIndexTestingDateAccepted() as "date",
    getPatientFullName(p.patient_id) as "name",
    getPatientARTNumber(p.patient_id) as "ARTCode",
    getProgramAttributeDateValueFromAttributeAndProgramName(p.patient_id, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", "HIV_PROGRAM_KEY") as "ARTStartDate",
    getPatientPhoneNumber(p.patient_id) as "contactTelephone",
    CONCAT(getPatientVillage(p.patient_id),",",getPatientPreciseLocation(p.patient_id)) as "address",
    getPatientBirthdate(p.patient_id) as "birthDate",
    getPatientGender(p.patient_id) as "sex",
    getObsDatetimeValueInSection(p.patient_id, "c6c08cdc-18dc-4f42-809c-959621bc9a6c", "b70dfca0-db21-4533-8c08-4626ff0de265") as "dateOfTest",
    " " as "siteCode",
    getProgramAttributeDateValueFromAttributeAndProgramName(p.patient_id, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", "HIV_PROGRAM_KEY") as "transDate",
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getPatientARTNumber(p.patient_id) as "ARTCode" as "baselineCode",
    IF(getObsCodedValue(p.patient_id, "248e21db-98f8-49fc-b596-fe9042b013ac") IS NOT NULL, "Yes", "No") as "isKPType",
    getObsCodedValue(p.patient_id, "248e21db-98f8-49fc-b596-fe9042b013ac") as "KPType",
    " " as "isIDP",
    " " as "indexTracerCode",
    " " as "positivePatientReference",
    getObsCodedValue(p.patient_id, "533f4c86-1324-4260-bce5-0f872a556963") as "wasOfferedIndexServices",
    getObsDatetimeValueInSection(p.patient_id, "e7a002be-8afc-48b1-a81b-634e37f2961c", "3a8a6fa1-3845-481e-9502-fea47c2d1d1d") as "dateOfferedIndexIndexTesting",
    getObsCodedValue(p.patient_id, "78d13812-cd29-4214-9a58-a8710fd69cff") as "acceptedICTServices",
    " " as "IPVScreened",
    IF(getProgramAttributeValueWithinReportingPeriod(p.patient_id, "#startDate#", "#endDate#", "242c9027-dc2d-42e6-869e-045e8a8b95cb", "HIV_PROGRAM_KEY")="true","Yes","No") as "isBreastFeeding",
    " " as "syncDate"
FROM patient p,(SELECT @a:= 0) AS a
WHERE
    getPatientIndexTestingDateAccepted() BETWEEN "#startDate#" AND "#endDate#";
  
