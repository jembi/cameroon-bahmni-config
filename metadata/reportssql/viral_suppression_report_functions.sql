-- Viral suppression report

DROP FUNCTION IF EXISTS viralSuppression_Indicator1c;

DELIMITER $$
CREATE FUNCTION viralSuppression_Indicator1c(
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
    patientHasStartedARVTreatmentBeforeExtendedEndDate(pat.patient_id, p_endDate, 3) AND
    patientWasOnARVTreatmentByDate(pat.patient_id, p_endDate) AND
    mostRecentNotDocumentedViralLoadExamIsBelow(pat.patient_id, p_endDate, 1000) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);
    RETURN (result);
END$$ 
DELIMITER ; 

DROP FUNCTION IF EXISTS viralSuppression_Indicator1a;

DELIMITER $$
CREATE FUNCTION viralSuppression_Indicator1a(
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
    patientHasStartedARVTreatmentBeforeExtendedEndDate(pat.patient_id, p_endDate, 3) AND
    patientWasOnARVTreatmentByDate(pat.patient_id, p_endDate) AND
    mostRecentRoutineViralLoadExamIsBelow(pat.patient_id, p_endDate, 1000) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);
    RETURN (result);
END$$ 
DELIMITER ; 

DROP FUNCTION IF EXISTS viralSuppression_Indicator1b;

DELIMITER $$
CREATE FUNCTION viralSuppression_Indicator1b(
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
    patientHasStartedARVTreatmentBeforeExtendedEndDate(pat.patient_id, p_endDate, 3) AND
    patientWasOnARVTreatmentByDate(pat.patient_id, p_endDate) AND
    mostRecentTargetedViralLoadExamIsBelow(pat.patient_id, p_endDate, 1000) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);
    RETURN (result);
END$$
DELIMITER ;
