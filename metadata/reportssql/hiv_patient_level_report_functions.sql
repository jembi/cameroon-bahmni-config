-- getRadetPatientGender

DROP FUNCTION IF EXISTS getRadetPatientGender;

DELIMITER $$
CREATE FUNCTION getRadetPatientGender(
    p_patientId INT(11)) RETURNS VARCHAR(6)
    DETERMINISTIC
BEGIN
    DECLARE gender VARCHAR(50) DEFAULT getPatientGender(p_patientId);
    RETURN IF(gender = "m", "Male", "Female");
END$$
DELIMITER ;

-- getRadetFirstIndexRelationship

DROP FUNCTION IF EXISTS getRadetFirstIndexRelationship;

DELIMITER $$
CREATE FUNCTION getRadetFirstIndexRelationship(
    p_patientId INT(11)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE relationship VARCHAR(50) DEFAULT getFirstIndexRelationship(p_patientId);

    IF (relationship = "RELATIONSHIP_SPOUSE") THEN
        RETURN "SPOUSE";
    ELSEIF (relationship = "RELATIONSHIP_PARTNER") THEN
        RETURN "Sexual contact (other than Spouse)";
    ELSEIF (relationship = "RELATIONSHIP_BIO_CHILD") THEN
        RETURN "Biological child of index case <15 years";
    ELSEIF (relationship = "RELATIONSHIP_BIO_MOTHER" OR relationship = "RELATIONSHIP_BIO_FATHER") THEN
        RETURN "Biological parent of an index child";
    ELSEIF (relationship = "RELATIONSHIP_SIBLING") THEN
        RETURN "Sibling of index case <15 years";
    ELSE
        RETURN "Other";
    END IF;
END$$
DELIMITER ;

-- getRadetDefaulterNotificationMethod

DROP FUNCTION IF EXISTS getRadetDefaulterNotificationMethod;

DELIMITER $$
CREATE FUNCTION getRadetDefaulterNotificationMethod(
    p_patientId INT(11)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE method VARCHAR(50) DEFAULT getPatientMostRecentProgramAttributeCodedValueFromName(p_patientId, 'PROGRAM_MANAGEMENT_1_NOTIFICATION_METHOD', 'en');

    IF (method = "By index") THEN
        RETURN "Index";
    ELSEIF (method = "By service provider") THEN
        RETURN "Service provider";
    ELSEIF (method = "Contract") THEN
        RETURN method;
    ELSEIF (method = "Dual Notification") THEN
        RETURN method;
    ELSEIF (method = "Security risk (not recommended)") THEN
        RETURN method;
    ELSE
        RETURN "";
    END IF;
END$$
DELIMITER ;

-- getRadetDefaulterNotificationOutcome

DROP FUNCTION IF EXISTS getRadetDefaulterNotificationOutcome;

DELIMITER $$
CREATE FUNCTION getRadetDefaulterNotificationOutcome(
    p_patientId INT(11)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE outcome VARCHAR(50) DEFAULT getPatientMostRecentProgramAttributeCodedValueFromName(p_patientId, 'PROGRAM_MANAGEMENT_3_NOTIFICATION_OUTCOME', 'en');

    IF (outcome = "Refused Testing") THEN
        RETURN "RT= Refused Testing";
    ELSEIF (outcome = "Accepted Testing") THEN
        RETURN "AT  =  Accepted Testing";
    ELSEIF (outcome = "Positive, on TX") THEN
        RETURN "PT= Positive, on Tx";
    ELSEIF (outcome = "Positive, NOT on TX") THEN
        RETURN "PXT=  Positive, NOT on TX";
    ELSE
        RETURN "";
    END IF;
END$$
DELIMITER ;

-- getRadetTestedLocation

DROP FUNCTION IF EXISTS getRadetTestedLocation;

DELIMITER $$
CREATE FUNCTION getRadetTestedLocation(
    p_patientId INT(11)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE testedLocation VARCHAR(50) DEFAULT getTestedLocation(p_patientId);

    IF (testedLocation LIKE "Community%") THEN
        RETURN "Community/Communauté";
    ELSE RETURN "Facility/FOSA";
    END IF;

END$$
DELIMITER ;

-- getRadetIndexType

DROP FUNCTION IF EXISTS getRadetIndexType;

DELIMITER $$
CREATE FUNCTION getRadetIndexType(
    p_patientId INT(11)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE daysBetweenHIVPosAndART INT(11) DEFAULT getDaysBetweenHIVPosAndART(p_patientId);
    DECLARE viralLoadResult INT(11) DEFAULT getViralLoadTestResult(p_patientId);

    IF (daysBetweenHIVPosAndART > 0 AND daysBetweenHIVPosAndART <= 30) THEN
        RETURN 'Index Case New HTS POS and initiated on treatment this month';
    ELSEIF (viralLoadResult > 1000) THEN
        RETURN 'Index Case virally unsuppressed clients';
    ELSEIF (daysBetweenHIVPosAndART > 30 AND daysBetweenHIVPosAndART <= 180) THEN
        RETURN 'Index Case Old HTS POS and initiated on treatment within the 2 - 5 months';
    ELSEIF (daysBetweenHIVPosAndART > 180 AND daysBetweenHIVPosAndART <= 365) THEN
        RETURN 'Index Case Old HTS POS and initiated on treatment within the 6 - 12 months';
    END IF;

    RETURN '';
END$$
DELIMITER ;

-- getRadetPointOfEntry

DROP FUNCTION IF EXISTS getRadetPointOfEntry;

DELIMITER $$
CREATE FUNCTION getRadetPointOfEntry(
    p_patientId INT(11)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE pointOfEntry INT(11) DEFAULT getTestingEntryPoint(p_patientId);
    DECLARE testedLocation INT(11) DEFAULT getRadetTestedLocation(p_patientId);

    IF (pointOfEntry = "Emergency") THEN
        RETURN "PITC Emergency (Urgences)";
    ELSEIF (pointOfEntry = "Index" AND testedLocation LIKE "Facility%") THEN
        RETURN "Index testing (Facility) (Depistage par cas index ou dans le FOSA)";
    ELSEIF (pointOfEntry = "Index" AND testedLocation LIKE "Community%") THEN
        RETURN "Index testing (Community) (Depistage par cas index en  communaute)";
    ELSEIF (pointOfEntry = "Inpatient") THEN
        RETURN "PITC Inpatient (Hospitalisations)";
    ELSEIF (pointOfEntry = "Labor and delivery") THEN
        RETURN "PITC PMTCT (Post ANC1: L&D/BF) (Salle d'accouchement, Femmes allaitantes)";
    ELSEIF (pointOfEntry = "Malnutrition") THEN
        RETURN "PITC Malnutrition";
    ELSEIF (pointOfEntry = "Other PITC") THEN
        RETURN "Other PITC (autres portes d'entrée eg: Opthalmologie, dentiste, Diabetologie)";
    ELSEIF (pointOfEntry = "Paediatric") THEN
        RETURN "PITC Pediatrics >12months old (Pediatrie >12months old)";
    ELSEIF (pointOfEntry = "PMTCT [ANC1-Only]") THEN
        RETURN "PITC PMTCT (ANC1 Only) (CPN1 uniquement)";
    ELSEIF (pointOfEntry = "STI") THEN
        RETURN "PITC STI (Infectiologie)";
    ELSEIF (pointOfEntry = "TB") THEN
        RETURN "PITC TB (Tuberculose)";
    ELSEIF (pointOfEntry = "VCT" AND testedLocation LIKE "Facility%") THEN
        RETURN "VCT (Facility) (Depistage Volontaire ou dans la FOSA)";
    ELSEIF (pointOfEntry = "VCT" AND testedLocation LIKE "Community%") THEN
        RETURN "VCT (Community) (Depistage Volontaire en communaute)";
    ELSE
        RETURN "";
    END IF;
    RETURN '';
END$$
DELIMITER ;

-- getRadetLocationOfArvRefill

DROP FUNCTION IF EXISTS getRadetLocationOfArvRefill;

DELIMITER $$
CREATE FUNCTION getRadetLocationOfArvRefill(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE locationOfRefill VARCHAR(250) DEFAULT getLocationOfArvRefill(p_patientId, p_startDate, p_endDate);

    IF (locationOfRefill IS NULL) THEN
        RETURN NULL;
    ELSEIF (locationOfRefill LIKE "LOCATION_COMMUNITY%") THEN
        RETURN "Community/Communauté";
    ELSE
        RETURN "Facility/FOSA";
    END IF;
END$$
DELIMITER ;

-- getRadetViralLoadIndication

DROP FUNCTION IF EXISTS getRadetViralLoadIndication;

DELIMITER $$
CREATE FUNCTION getRadetViralLoadIndication(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE viralLoadIndication VARCHAR(50) DEFAULT getViralLoadIndication(p_patientId);

    RETURN
        CASE
            WHEN viralLoadIndication = "Routine Viral Load" THEN "Routine monitoring"
            WHEN viralLoadIndication = "Targeted Viral Load" THEN "Targeted monitoring"
            ELSE NULL
        END;

END$$
DELIMITER ;

-- getRadetViralLoadTestDate

DROP FUNCTION IF EXISTS getRadetViralLoadTestDate;

DELIMITER $$
CREATE FUNCTION getRadetViralLoadTestDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE testDate DATE;
    DECLARE testResult INT(11);
    DECLARE viralLoadIndication VARCHAR(50);

    CALL retrieveViralLoadTestDateAndResult(p_patientId, testDate, testResult, viralLoadIndication);

    IF (viralLoadIndication = "Routine Viral Load" OR viralLoadIndication = "Targeted Viral Load") THEN
        RETURN testDate;
    ELSE
        RETURN NULL;
    END IF;
END$$
DELIMITER ;

-- getRadetViralLoadTestResult

DROP FUNCTION IF EXISTS getRadetViralLoadTestResult;

DELIMITER $$
CREATE FUNCTION getRadetViralLoadTestResult(
    p_patientId INT(11)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE testDate DATE;
    DECLARE testResult INT(11);
    DECLARE viralLoadIndication VARCHAR(50);

    CALL retrieveViralLoadTestDateAndResult(p_patientId, testDate, testResult, viralLoadIndication);

    IF (viralLoadIndication = "Routine Viral Load" OR viralLoadIndication = "Targeted Viral Load") THEN
        RETURN testResult;
    ELSE
        RETURN NULL;
    END IF;
END$$
DELIMITER ;

-- getRadetFacilityName

DROP FUNCTION IF EXISTS getRadetFacilityName;

DELIMITER $$
CREATE FUNCTION getRadetFacilityName() RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE facility VARCHAR(255) DEFAULT getFacilityName();

    IF (facility IS NULL) THEN
        RETURN NULL;
    ELSEIF (facility LIKE "LOCATION_COMMUNITY%") THEN
        RETURN "At home or Other place";
    ELSE
        RETURN "This facility";
    END IF;
END$$
DELIMITER ;

-- getRadetRiskGroup

DROP FUNCTION IF EXISTS getRadetRiskGroup;

DELIMITER $$
CREATE FUNCTION getRadetRiskGroup(
    p_patientId INT(11)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE riskGroup VARCHAR(255) DEFAULT getMostRecentCodedObservation(p_patientId,"HTC, Risk Group","en");

    RETURN
        CASE
            WHEN riskGroup = "MSM and Transgenders" THEN "MSM"
            WHEN riskGroup = "People Who Inject Drugs" THEN "PWID"
            WHEN riskGroup = "Sex Worker " THEN "FSW"
            WHEN riskGroup = "MSM and Transgenders" THEN "MSM"
            ELSE NULL
        END;

END$$
DELIMITER ;

-- radetPatientIsPregnant

DROP FUNCTION IF EXISTS radetPatientIsPregnant;

DELIMITER $$
CREATE FUNCTION radetPatientIsPregnant(
    p_patientId INT(11)
    ) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE isPregnant VARCHAR(255) DEFAULT patientIsPregnant(p_patientId);

    IF (isPregnant) THEN
        RETURN "Pregnant";
    ELSE
        RETURN "Not Pregnant";
    END IF;
END$$
DELIMITER ;
