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

    IF (testedLocation = "Community home" OR testedLocation = "Community mobile") THEN
        RETURN "Community/Communauté";
    ELSE RETURN "Facility/FOSA";
    END IF;

END$$
DELIMITER ;
