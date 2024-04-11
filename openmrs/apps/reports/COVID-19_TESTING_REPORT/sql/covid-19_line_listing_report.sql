
    SELECT
    CAST(@a:=@a+1 AS CHAR) as "serialNumber",
    getPatientARTNumber(p.patient_id) as "ARTCode",
    getFacilityName() as "facilityName",
    getPatientIdentifier(p.patient_id) as "patientID",
    patientAgeAtHivEnrollment(p.patient_id) as "ageAtEnrollment",
    getPatientBirthdate(p.patient_id) as "dateOfBirth",
    getPatientGender(p.patient_id) as "sex",
    getPatientARVStartDate(p.patient_id) as "dateOfARVInitiation",
    CONCAT(getPatientVillage(p.patient_id),",",getPatientPreciseLocation(p.patient_id)) as "address",
    getPatientPhoneNumber(p.patient_id) as "contactTelephone",
    getPatientMostRecentProgramTrackingStateValue(p.patient_id,"en","HIV_PROGRAM_KEY") as "clinicalWhoStage",
    getObsDatetimeValueInSection(p.patient_id, "1d4a6dc4-c478-4021-982b-62e3c84f7857", "c10a9ed0-1992-4118-8f6f-2311663f2bc2") as "dateBaseLineAssessment",
    getPatientEntryPointAndModality(p.patient_id) as "testingEntryPointAndModality",
    getObsCodedValueInSectionByNames(p.patient_id,"Population","Covid-19 Vaccination Form") as "population",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Has the client been sensitized","Covid-19 Vaccination Form") LIKE "Yes%", "Yes", "No") as "clientHasBeenSensitized",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Has the client been screened for Covid-19","Covid-19 Vaccination Form") LIKE "Yes%", "Yes", "No") as "clientHasBeenScreenedForCovid-19",
    REPLACE(getObsCodedValuesInSectionByNames(p.patient_id,"Signs and symptoms","Covid-19 Vaccination Form"), ' full name', '') as "signsAndSymptoms",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Is the person to be vaccinated sick today","Covid-19 Vaccination Form") LIKE "Yes%", "Yes", "No") as "personToBeVaccinatedSickToday",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Has the person with symptoms tested for COVID-19","Covid-19 Vaccination Form") LIKE "Yes%", "Yes", "No") as "personWithSymptomsTestedForCovid-19",
    getObsCodedValueInSectionByNames(p.patient_id,"What is the outcome of the test","Covid-19 Vaccination Form") as "outcomeOfTheTest",
    REPLACE(getObsCodedValuesInSectionByNames(p.patient_id,"Covid-19 Risk factors","Covid-19 Vaccination Form"), ' full name', '') as "riskFactors",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Has the person to be vaccinated ever received a dose of COVID-19 vaccine","Covid-19 Vaccination Form") LIKE "Yes%", "Yes", "No") as "personToBeVaccinatedEverReceivedADoseOfCovid-19",
    getObsCodedValueInSectionByNames(p.patient_id,"COVID-19 vaccine dose","Covid-19 Vaccination Form") as "doseReceivedOfTheCOVID-19Vaccine",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Have you had an AEFI after receiving the COVID-19 vaccine","Covid-19 Vaccination Form") LIKE "Yes%", "Yes", "No") as "haveYouHadAnAEFIAfterReceivingTheCOVID-19Vaccine",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Is the person eligible for the vaccine","PATIENT STATE") LIKE "Yes%", "Yes", "No") as "isThePersonEligibleForTheVaccine",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Has the vaccine been offered to the person eligible","PATIENT STATE") LIKE "Yes%", "Yes", "No") as "hasTheVaccineBeenOfferedToThePersonEligible",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Did the person eligible accept to be vaccinated","Covid-19 Vaccination Form") LIKE "Yes%", "Yes", "No") as "didThePersonEligibleAcceptToBeVaccinated",    
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Has the client taken an appointment for vaccination","PATIENT STATE") LIKE "Yes%", "Yes", "No") as "hasTheClientTakenAnAppointmentForVaccination",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"as the person referred/linked to vaccination","PATIENT STATE") LIKE "Yes%", "Yes", "No") as "wasThePersonReferred/LinkedToVaccination",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Was the person vaccinated","Covid-19 Vaccination Form") LIKE "Yes%", "Yes", "No") as "wasThePersonVaccinated",
    IF(getObsCodedValueInSectionByNames(p.patient_id,"Was the person vaccinated after an appointment","PATIENT STATE") LIKE "Yes%", "Yes", "No") as "wasThePersonVaccinatedAfterAnAppointment",
    getObsCodedValueInSectionByNames(p.patient_id,"What vaccine did they receive","Covid-19 Vaccination Form") as "whatVaccineDidTheyReceive",
    getObsCodedValueInSectionByNames(p.patient_id,"What dose of COVID-19 vaccine has the person received","Covid-19 Vaccination Form") as "whatDoseOfCOVID-19VaccineHasThePersonReceived"
FROM patient p
JOIN person_name pn ON pn.person_id = p.patient_id
JOIN patient_identifier pi ON pi.patient_id = p.patient_id
JOIN person per ON per.person_id = p.patient_id, (SELECT @a:= 0) AS a
WHERE getObsDatetimeValueInSection(p.patient_id, "1d4a6dc4-c478-4021-982b-62e3c84f7857", "c10a9ed0-1992-4118-8f6f-2311663f2bc2") BETWEEN "#startDate#" AND "#endDate#"
GROUP BY p.patient_id;