SELECT
    getPatientANCNumber(p.patient_id) as "ANC ID",
	getObsDatetimeValue(p.patient_id, "57d91463-1b95-4e4d-9448-ee4e88c53cb9") as "ANC/PMTCT Date (dd-MMM-yyyy)",
	getPatientBirthdate(p.patient_id) as "Date of birth (Date de naissance)",
	"" as "Current Age (Âge actuel)",
	"" as "Age (in months  for less than 5yrs) / Âge (en mois pour moins de 5 ans) ",
	"" as "Age Groups (Les groupes d'âge )",
	"N/A" as "HTS Client ID",
	getDateOfPositiveHIVResult(p.patient_id, "2010-01-01", "#endDate#") as "Date of HIV Positive / Date de séropositivité",
	getPatientARTNumber(p.patient_id) as "Patient Unique ID/ART №/TARV № ",
	getPatientARVStartDate(p.patient_id) as "ART Start Date/ Date de début de l'ART  (dd-MMM-yyyy)",
	"N/A" as "Date of Delivery/ Date de livraison",
	"N/A" as "Place of delivery / Lieu de livraison",
	"N/A" as "Post Natal Health visit / Visite de santé post-natale",
	getLastArvPickupDate(p.patient_id, "2010-01-01", "#endDate#") as "Last ARV Pickup Date / Dernière date de prise en charge des ARV",
	getDurationMostRecentArvTreatment(p.patient_id, "2010-01-01", "#endDate#") as "Days of ARV Refill / Jours de recharge ARV",
	getLocationOfArvRefill(p.patient_id, "2010-01-01", "#endDate#") as "Location of ARV refill / Emplacement de la recharge d'ARV",
	"N/A" as "Differentiated ART delivery model at Last ARV refill ",
	"N/A" as "TB screening status at Last ARV Refill / Statut de dépistage de la tuberculose",
	getViralLoadTestResult(p.patient_id) as "Current Viral Load/ Charge virale actuelle  (c/ml)",
	getViralLoadTestDate(p.patient_id) as "Date of Current Viral Load / Date de la charge virale actuelle (dd-mmm-yyyy)",
	"N/A" as "Viral Load Indication/ Indication de la charge virale",
	"N/A" as "Maternal Outcome/ Résultat maternel",
	"N/A" as "Status of Missed appointment / Statut de rendez-vous manqué",
	"N/A" as "Child ID",
	"N/A" as "Child Date of birth (Date de naissance)",
	"N/A" as "Infant ARV Prophylaxis",
	"N/A" as "Date of Infant ARV Prophylaxis",
	"N/A" as "Infant CTX",
	"N/A" as "Date of Infant CTX",
	"N/A" as "Test type ",
	"N/A" as "Date of EID Sample Collected",
	"N/A" as "Date of EID Sample Sent",
	"N/A" as "Date EID Result Received at Facility ",
	"N/A" as "Date Caregiver Given EID Result",
	"N/A" as "EID Result ",
	"N/A" as "Month of Health Facility Visits when infant is seen at facility / Mois des visites dans un établissement de santé lorsqu'un nourrisson est vu dans un établissement",
	"N/A" as "Visit status / Statut de la visite",
	"N/A" as "Infant Outcome at 18 Months/ Résultat infantile à 18 mois",
	getPatientARVStartDate(p.patient_id) as "Date of ART initiation (If HIV-positive) / Date d'initiation du ART (si HIV positif)",
	"N/A" as "Child ART Code",
	getFacilityName() as "Health Facility/  Établissement de santé",
	"N/A" as "Psychosocial Agents (Retention APS)"
FROM patient p;