-- HIVTMI Report
-- Number of people tested in the month
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

-- Number of people tested in the month - desegregate by single entry point
DROP FUNCTION IF EXISTS HIVTMI_Indicator1_disaggregated_by_single_entry_point;

DELIMITER $$
CREATE FUNCTION HIVTMI_Indicator1_disaggregated_by_single_entry_point(
  p_startDate DATE,
  p_endDate DATE,
  disgCodedValue VARCHAR(256)) RETURNS INT(11)
DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
  COUNT(DISTINCT pat.patient_id) INTO result
FROM
  patient pat
WHERE
  getObsDatetimeValueInSection(pat.patient_id, "c6c08cdc-18dc-4f42-809c-959621bc9a6c", "b70dfca0-db21-4533-8c08-4626ff0de265") BETWEEN p_startDate AND p_endDate AND
  getObsCodedValueInSectionByNames(pat.patient_id, "Final Test Result", "Final Result") IS NOT NULL AND
  getObsCodedValue(pat.patient_id, "bc43179d-00b4-4712-a5d6-4dabd4230888") = disgCodedValue;

RETURN (result);
END$$
DELIMITER ;

-- Number of people tested in the month - desegregate by two entry point
DROP FUNCTION IF EXISTS HIVTMI_Indicator1_disaggregated_by_two_entry_point;

DELIMITER $$
CREATE FUNCTION HIVTMI_Indicator1_disaggregated_by_two_entry_point(
  p_startDate DATE,
  p_endDate DATE,
  disgCodedValue1 VARCHAR(256),
  disgCodedValue2 VARCHAR(256)) RETURNS INT(11)
DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
  COUNT(DISTINCT pat.patient_id) INTO result
FROM
  patient pat
WHERE
  getObsDatetimeValueInSection(pat.patient_id, "c6c08cdc-18dc-4f42-809c-959621bc9a6c", "b70dfca0-db21-4533-8c08-4626ff0de265") BETWEEN p_startDate AND p_endDate AND
  getObsCodedValueInSectionByNames(pat.patient_id, "Final Test Result", "Final Result") IS NOT NULL AND
  getObsCodedValue(pat.patient_id, "bc43179d-00b4-4712-a5d6-4dabd4230888") IN(disgCodedValue1, disgCodedValue2);

RETURN (result);
END$$
DELIMITER ;

-- Number of people tested in the month - desegregate by other entry point
DROP FUNCTION IF EXISTS HIVTMI_Indicator1_disaggregated_by_other_entry_point;

DELIMITER $$
CREATE FUNCTION HIVTMI_Indicator1_disaggregated_by_other_entry_point(
  p_startDate DATE,
  p_endDate DATE
  ) RETURNS INT(11)
DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
  COUNT(DISTINCT pat.patient_id) INTO result
FROM
  patient pat
WHERE
  getObsDatetimeValueInSection(pat.patient_id, "c6c08cdc-18dc-4f42-809c-959621bc9a6c", "b70dfca0-db21-4533-8c08-4626ff0de265") BETWEEN p_startDate AND p_endDate AND
  getObsCodedValueInSectionByNames(pat.patient_id, "Final Test Result", "Final Result") IS NOT NULL AND
  getObsCodedValue(pat.patient_id, "bc43179d-00b4-4712-a5d6-4dabd4230888") IN ("Malnutrition", "OPD", "Other PITC", "STI", "VMMC", "Laboratory", "Community Testing-Outreach", "Community Testing-Satellite Site", "Treatment Unit (UPEC)", "Partners of PW", "Partners of BFW", "PITC (Outpatient Department, casuality)");
RETURN (result);
END$$
DELIMITER ;

-- Number of people tested in the month - desegregate by ANC entry point
DROP FUNCTION IF EXISTS HIVTMI_Indicator1_disaggregated_by_anc_entry_point;

DELIMITER $$
CREATE FUNCTION HIVTMI_Indicator1_disaggregated_by_anc_entry_point(
  p_startDate DATE,
  p_endDate DATE
) RETURNS INT(11)
             DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
  COUNT(DISTINCT pat.patient_id) INTO result
FROM
  patient pat
WHERE
  getObsDatetimeValueInSection(pat.patient_id, "c6c08cdc-18dc-4f42-809c-959621bc9a6c", "b70dfca0-db21-4533-8c08-4626ff0de265") BETWEEN p_startDate AND p_endDate AND
  getObsCodedValueInSectionByNames(pat.patient_id, "Final Test Result", "Final Result") IS NOT NULL AND
    getObsCodedValue(pat.patient_id, "bc43179d-00b4-4712-a5d6-4dabd4230888") IN("PMTCT [ANC1-Only]", "PMTCT [Post ANC1]", "Other testing at ANC");
RETURN (result);
END$$
DELIMITER ;