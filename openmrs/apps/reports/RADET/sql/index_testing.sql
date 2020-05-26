SELECT getPatientIdentifier(p.patient_id) as "Contacts (Contact nr/Child nr) ",
	getObsDatetimeValue(p.patient_id, "e7a002be-8afc-48b1-a81b-634e37f2961c") as "Date of Contact elicitation from Index/ Date de sollicitation du contact à partir de l'index",
	getPatientBirthdate(p.patient_id) as "Date of birth (Date de naissance)",
	"" as "Current Age (Âge actuel)",
	"" as "Age (in months  for less than 5yrs) / Âge (en mois pour moins de 5 ans) ",
	"" as "Age Groups (Les groupes d'âge )",
	getPatientGender(p.patient_id) as "Sex",
	getPatientARTNumber(p.patient_id) as "Index Case Code (ART Code/ Testing Code*)",
	getFirstIndexRelationship(p.patient_id) as "Type of Index Case/ type de cas index",
	0 as "Index Classification / Classification de l'indice",
	getObsCodedShortNameValue(p.patient_id, "bc43179d-00b4-4712-a5d6-4dabd4230888") as "HTS Entry/ entrée  (Testing Modality/ modalités de test)",
	getPatientMostRecentProgramAttributeValueFromName(p.patient_id, 'PROGRAM_MANAGEMENT_2_NOTIFICATION_DATE') as "Date of contact notification / Date de notification de contact",
	getPatientMostRecentProgramAttributeCodedValueFromName(p.patient_id, 'PROGRAM_MANAGEMENT_1_NOTIFICATION_METHOD', 'en') as "Method of contact notification/ Méthode de notification de contact",
	getPatientMostRecentProgramAttributeCodedValueFromName(p.patient_id, 'PROGRAM_MANAGEMENT_3_NOTIFICATION_OUTCOME', 'en') as "Outcomes of notifictaion / Résultats de la notification",
	"N/A" as "HTS Client ID (EID or HEI Number)",
	getHIVTestDate(p.patient_id, "2000-01-01", "#endDate#") as "Actual date of visit for HTS/ Date réelle de visite pour HTS (EID Sample Collected date/Échantillon EID Date de collecte)  (dd-MMM-yyyy)",
	getHIVResult(p.patient_id, "2000-01-01", "#endDate#") as "HTS Results/ Résultats HTS ",
	getObsLocation(p.patient_id, "e7a002be-8afc-48b1-a81b-634e37f2961c") as "Location of testing/ emplacement des tests",
	getPatientDateOfEnrolmentInProgram(p.patient_id, "HIV_PROGRAM_KEY") as "Date Enrolled to HIV care / Date d'inscription aux soins du VIH (dd-MMM-yyyy)",
	IF(getPatientDateOfEnrolmentInProgram(p.patient_id, "HIV_PROGRAM_KEY"), "Yes", "No") as "Linked to ART / Lié à ART",
	getPatientARTNumber(getFirstIndexID(p.patient_id)) as "Client ART Unique ID/Patient Unique ID/ART TARV",
	getPatientARVStartDate(getFirstIndexID(p.patient_id)) as "ART Start Date/ Date de début de l'ART (dd-MMM-yyyy)",
	getFacilityName() as "Name of Facility where Treatment is provided/ Nom de l'établissement où le traitement est dispensé",
	"N/A" as "Reasons for Non-Linkage/ Raisons du non-couplage",
	"N/A" as "Time to Enrolment (days)",
	"N/A" as "Time to ART Initiation (days)",
	getObsDatetimeValue(getFirstIndexID(p.patient_id), "836fe9d4-96f1-4fea-9ad8-35bd06e0ee05") as "Date offered ICT / Date offerte ICT",
	getObsDatetimeValue(getFirstIndexID(p.patient_id), "e7a002be-8afc-48b1-a81b-634e37f2961c") as "Date accepted ICT / Date d'acceptation",
	getNumberOfContactsRelatedToIndex(getFirstIndexID(p.patient_id)) as "No of contacts elicited/ Nombre de contacts obtenus",
	getNumberOfEnrolledContactsRelatedToIndex(getFirstIndexID(p.patient_id)) as "No of contacts notified / Nombre de contacts notifiés",
	0 as "No of contacts tested for HIV/ Nombre de contacts testés pour le VIH",
	0 as "No of contacts tested HIV positive/ Nombre de contacts testés séropositifs",
	"N/A" as "APS"
	FROM patient p
		WHERE patientIsContact(p.patient_id);