SELECT getPatientDateOfEnrolmentInProgram(p.patient_id, "HIV_PROGRAM_KEY") AS "Enrollment Date/Date de l'inscription",
	getPatientARTNumber(p.patient_id) as "Patient Unique ID/ART №",
	getPatientGender(p.patient_id) as "Sex",
	getPatientBirthdate(p.patient_id) as "Date of birth / (Date de naissance)",
	"" as "Current Age (Âge actuel)",
	"" as "Age Groups (Les groupes d'âge )",
	getPatientARVStartDate(p.patient_id) as "ART Start Date/ Date de début de l'ART  (dd-MMM-yyyy)",
	"" as "Age at Start of ART (Years)",
	"" as "Age at Start of ART (Months) Enter for Under-5s ",
	getLastArvPickupDate(p.patient_id, "2010-01-01", "#endDate#") as "Last ARV Pickup Date / Dernière date de prise en charge des ARV",
	getDurationMostRecentArvTreatment(p.patient_id, "2010-01-01", "#endDate#") as "Days of ARV Refill / Jours de recharge ARV",
	getLocationOfArvRefill(p.patient_id, "2010-01-01", "#endDate#") as "Location of ARV refill / Emplacement de la recharge d'ARV",
	"N/A" as "Differentiated ART delivery model at last ARV refil",
	"N/A" as "Date eligible for Community ART dispensations (CAD)/ Date admissible aux dispensations de ART communautaire",
	"N/A" as "Date newly enrolled in Community ART dispensations / Date à laquelle vous vous êtes nouvellement inscrit aux dispensations de ART communautaire",
	"N/A" as "Next ART Pickup date/ Prochaine date de prise en charge ART",
	"N/A" as "Regimen Line at ART Start/ Ligne de régime à ART Start",
	"N/A" as "Regimen at ART Start/ Régime chez ART Start", 
	getPatientMostRecentProgramAttributeCodedValue(p.patient_id, "397b7bc7-13ca-4e4e-abc3-bf854904dce3", "en") as "Current Regimen Line/ Ligne de régime actuelle",
	getListOfActiveARVDrugs(p.patient_id, '#startDate#', '#endDate#') as "Current ART Regimen/ Régime d'ART actuel",
	"N/A" as "Regimen Switch/ Commutateur de régime",
	"N/A" as "Date of Regimen switch  (limit only to the current reporting month)",
	patientIsPregnant(p.patient_id) as "Pregnancy Status/ Statut de grossesse",
	getMostRecentCodedObservation(p.patient_id,"HTC, Risk Group","en") as "KP Status",
	getViralLoadTestResult(p.patient_id) as "Current Viral Load / Charge virale actuelle (c/ml)",
	getViralLoadTestDate(p.patient_id) as "Date of Current Viral Load / Date de la charge virale actuelle (dd-mmm-yyyy)",
	"N/A" as "Viral Load Indication/ Indication de la charge virale",
	"N/A" as "Date of next Viral Load / Date de la prochaine charge virale (dd-mmm-yyyy)",
	"N/A" as "Date of EAC 1  (dd-mmm-yyyy)",
	"N/A" as "Date of EAC 2  (dd-mmm-yyyy)",
	"N/A" as "TB screening status at Last ARV Refill / Statut de dépistage de la tuberculose lors de la dernière recharge d'ARV",
	"N/A" as "Date initiated  TPT/ Date de lancement du TPT",
	"N/A" as "Date completed full course TPT/ Date de fin du cours complet TPT",
	"N/A" as "Date of EAC 3 (dd/mm/yy)",
	getPatientMostRecentProgramOutcome(p.patient_id, "en", "HIV_PROGRAM_KEY") as "Current ART Status (Active, LTFU, Dead, Transferred Out, Stopped)",
	getStatusOfMissedAppointment(p.patient_id) as "Status of Missed appointment / Statut de rendez-vous manqué",
	"N/A" as "Psychosocial Agents (Retention APS)"
FROM patient p
WHERE getPatientARVStartDate(p.patient_id) IS NOT NULL OR getLastArvPickupDate(p.patient_id, "2010-01-01", "#endDate#") IS NOT NULL;