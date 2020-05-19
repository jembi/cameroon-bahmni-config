SELECT 0 as "ANC ID",
	0 as "ANC/PMTCT Date (dd-MMM-yyyy)",
	getPatientBirthdate(p.patient_id) as "Date of birth (Date de naissance)",
	"" as "Current Age (Âge actuel)",
	"" as "Age (in months  for less than 5yrs) / Âge (en mois pour moins de 5 ans) ",
	"" as "Age Groups (Les groupes d'âge )",
	0 as "HTS Client ID",
	0 as "Date of HIV Positive / Date de séropositivité",
	getPatientARTNumber(p.patient_id) as "Patient Unique ID/ART №/TARV № ",
	getPatientARVStartDate(p.patient_id) as "ART Start Date/ Date de début de l'ART  (dd-MMM-yyyy)",
	0 as "Date of Delivery/ Date de livraison",
	0 as "Place of delivery / Lieu de livraison",
	0 as "Post Natal Health visit / Visite de santé post-natale",
	0 as "Last ARV Pickup Date / Dernière date de prise en charge des ARV",
	0 as "Days of ARV Refill / Jours de recharge ARV",
	0 as "Location of ARV refill / Emplacement de la recharge d'ARV",
	0 as "Differentiated ART delivery model at Last ARV refill ",
	0 as "TB screening status at Last ARV Refill / Statut de dépistage de la tuberculose",
	0 as "Current Viral Load/ Charge virale actuelle  (c/ml)",
	0 as "Date of Current Viral Load / Date de la charge virale actuelle (dd-mmm-yyyy)",
	0 as "Viral Load Indication/ Indication de la charge virale",
	0 as "Maternal Outcome/ Résultat maternel",
	0 as "Status of Missed appointment / Statut de rendez-vous manqué",
	0 as "Child ID",
	0 as "Child Date of birth (Date de naissance)",
	0 as "Infant ARV Prophylaxis",
	0 as "Date of Infant ARV Prophylaxis",
	0 as "Infant CTX",
	0 as "Date of Infant CTX",
	0 as "Test type ",
	0 as "Date of EID Sample Collected",
	0 as "Date of EID Sample Sent",
	0 as "Date EID Result Received at Facility ",
	0 as "Date Caregiver Given EID Result",
	0 as "EID Result ",
	0 as "Month of Health Facility Visits when infant is seen at facility / Mois des visites dans un établissement de santé lorsqu'un nourrisson est vu dans un établissement",
	0 as "Visit status / Statut de la visite",
	0 as "Infant Outcome at 18 Months/ Résultat infantile à 18 mois",
	0 as "Date of ART initiation (If HIV-positive) / Date d'initiation du ART (si HIV positif)",
	0 as "Child ART Code",
	0 as "Health Facility/  Établissement de santé",
	"ANC form" as "Psychosocial Agents (Retention APS)"
	FROM patient p;