-- getPatientGenderFullname

DROP FUNCTION IF EXISTS getPatientGenderFullname;

DELIMITER $$
CREATE FUNCTION getPatientGenderFullname(
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
        RETURN 'Index Case New HTS POS and initiated on treatment within a month';
    ELSEIF (viralLoadResult > 1000) THEN
        RETURN 'Index Case virally unsuppressed client';
    ELSEIF (daysBetweenHIVPosAndART > 30 AND daysBetweenHIVPosAndART <= 180) THEN
        RETURN 'Index Case Old HTS POS and initiated on treatment within 2 - 5 months';
    ELSEIF (daysBetweenHIVPosAndART > 180 AND daysBetweenHIVPosAndART <= 365) THEN
        RETURN 'Index Case Old HTS POS and initiated on treatment within 6 - 12 months';
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

