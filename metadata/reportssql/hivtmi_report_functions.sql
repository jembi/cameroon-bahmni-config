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
  patientGenderIs(pat.patient_id, p_gender) AND 
  patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
  getObsDatetimeValueInSection(pat.patient_id, "c6c08cdc-18dc-4f42-809c-959621bc9a6c", "b70dfca0-db21-4533-8c08-4626ff0de265") BETWEEN p_startDate AND p_endDate AND 
  getObsCodedValueInSectionByNames(pat.patient_id, "Final Test Result", "Final Result") IS NOT NULL;

RETURN (result);
END$$
DELIMITER ;