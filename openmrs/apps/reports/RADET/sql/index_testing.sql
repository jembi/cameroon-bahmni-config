SELECT getPatientIdentifier(p.patient_id) as "Contacts (Contact nr/Child nr) ",
	getPatientIndexTestingDateAccepted(getFirstIndexID(p.patient_id)) as "Date of Contact elicitation from Index/ Date de sollicitation du contact à partir de l'index",
	getPatientBirthdate(p.patient_id) as "Date of birth (Date de naissance)",
	"" as "Current Age (Âge actuel)",
	"" as "Age (in months  for less than 5yrs) / Âge (en mois pour moins de 5 ans) ",
	"" as "Age Groups (Les groupes d'âge )",
	getPatientGenderFullname(p.patient_id) as "Sex",
	getPatientARTNumber(getFirstIndexID(p.patient_id)) as "Index Case Code (ART Code/ Testing Code*)",
	getIndexType(getFirstIndexID(p.patient_id)) as "Type of Index Case/ type de cas index",
	getFirstIndexRelationship(p.patient_id) as "Index Classification / Classification de l'indice",
	getTestingEntryPoint(p.patient_id) as "HTS Entry/ entrée  (Testing Modality/ modalités de test)",
	getPatientMostRecentProgramAttributeValueFromName(p.patient_id, 'PROGRAM_MANAGEMENT_2_NOTIFICATION_DATE') as "Date of contact notification / Date de notification de contact",
	getPatientMostRecentProgramAttributeCodedValueFromName(p.patient_id, 'PROGRAM_MANAGEMENT_1_NOTIFICATION_METHOD', 'en') as "Method of contact notification/ Méthode de notification de contact",
	getPatientMostRecentProgramAttributeCodedValueFromName(p.patient_id, 'PROGRAM_MANAGEMENT_3_NOTIFICATION_OUTCOME', 'en') as "Outcomes of notifictaion / Résultats de la notification",
	"N/A" as "HTS Client ID (EID or HEI Number)",
	getHIVTestDate(p.patient_id, "2010-01-01", "#endDate#") as "Actual date of visit for HTS/ Date réelle de visite pour HTS (EID Sample Collected date/Échantillon EID Date de collecte)  (dd-MMM-yyyy)",
	getHIVResult(p.patient_id, "2010-01-01", "#endDate#") as "HTS Results/ Résultats HTS ",
	getTestedLocation(p.patient_id) as "Location of testing/ emplacement des tests",
	getPatientDateOfEnrolmentInProgram(p.patient_id, "HIV_PROGRAM_KEY") as "Date Enrolled to HIV care / Date d'inscription aux soins du VIH (dd-MMM-yyyy)",
	patientHasEnrolledIntoHivProgram(p.patient_id) as "Linked to ART / Lié à ART",
	getPatientARTNumber(p.patient_id) as "Client ART Unique ID/Patient Unique ID/ART TARV",
	getPatientARVStartDate(p.patient_id) as "ART Start Date/ Date de début de l'ART (dd-MMM-yyyy)",
	getFacilityName() as "Name of Facility where Treatment is provided/ Nom de l'établissement où le traitement est dispensé",
	"N/A" as "Reasons for Non-Linkage/ Raisons du non-couplage",
	getDaysBetweenHIVPosAndEnrollment(p.patient_id) as "Time to Enrolment (days)",
	getDaysBetweenHIVPosAndART(p.patient_id) as "Time to ART Initiation (days)",
	getPatientIndexTestingDateOffered(p.patient_id) as "Date offered ICT / Date offerte ICT",
	getPatientIndexTestingDateAccepted(p.patient_id) as "Date accepted ICT / Date d'acceptation",
	getNumberOfContactsRelatedToIndex(p.patient_id) as "No of contacts elicited/ Nombre de contacts obtenus",
	getNumberOfEnrolledContactsRelatedToIndex(p.patient_id) as "No of contacts notified / Nombre de contacts notifiés",
	getNumberOfHIVTestedContactsRelatedToIndex(p.patient_id) as "No of contacts tested for HIV/ Nombre de contacts testés pour le VIH",
	getNumberOfHIVPosContactsRelatedToIndex(p.patient_id) as "No of contacts tested HIV positive/ Nombre de contacts testés séropositifs",
	getPatientMostRecentContactTracer(p.patient_id) as "APS"
	FROM patient p
		WHERE patientIsContact(p.patient_id);