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
