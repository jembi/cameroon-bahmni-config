-- HIVTMI Report

DROP FUNCTION IF EXISTS HIVTMI_Indicator1;

DELIMITER $$
CREATE FUNCTION HIVTMI_Indicator1(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE

RETURN (result);
END$$
DELIMITER ;