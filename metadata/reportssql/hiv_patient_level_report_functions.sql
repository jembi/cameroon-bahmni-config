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
