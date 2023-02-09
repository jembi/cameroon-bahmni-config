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

DROP FUNCTION IF EXISTS HIVTMI_Indicator2;

DELIMITER $$
CREATE FUNCTION HIVTMI_Indicator2(
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
  getObsCodedValue(pat.patient_id, "55d59198-1d83-45db-9e92-dc3b9af25ca6") = "True" AND
  getObsCodedValueInSectionByNames(pat.patient_id, "Final Test Result", "Final Result") IS NOT NULL;

RETURN (result);
END$$
DELIMITER ;

-- Number of people tested in the month - desegregate by entry point

DROP FUNCTION IF EXISTS HIVTMI_Indicator1_disaggregated_by_entry_point;

DELIMITER $$
CREATE FUNCTION HIVTMI_Indicator1_disaggregated_by_entry_point(
  p_startDate DATE,
  p_endDate DATE,
  entryPoints TEXT) RETURNS INT(11)
                                    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
  COUNT(DISTINCT pat.patient_id) INTO result
FROM
  patient pat
WHERE
  getObsDatetimeValueInSection(pat.patient_id, "c6c08cdc-18dc-4f42-809c-959621bc9a6c", "d6cc3709-ffa0-42eb-b388-d7def4df30cf") BETWEEN p_startDate AND p_endDate AND
  getObsCodedValueInSectionByNames(pat.patient_id, "Final Test Result", "Final Result") IS NOT NULL AND
  FIND_IN_SET(getObsCodedValue(pat.patient_id, "bc43179d-00b4-4712-a5d6-4dabd4230888"), entryPoints) > 0;

RETURN (result);
END$$
DELIMITER ;
