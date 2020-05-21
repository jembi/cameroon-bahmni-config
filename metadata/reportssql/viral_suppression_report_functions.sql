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

-- mostRecentNotDocumentedViralLoadExamIsBelow

DROP FUNCTION IF EXISTS mostRecentNotDocumentedViralLoadExamIsBelow;

DELIMITER $$
CREATE FUNCTION mostRecentNotDocumentedViralLoadExamIsBelow(
    p_patientId INT(11),
    p_endDate DATE,
    p_examResult INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE uuidNotDocumentedViralLoadExam VARCHAR(38) DEFAULT "9ee140e0-c7ce-11e9-a32f-2a2ae2dbcce4";
    DECLARE uuidNotDocumentedViralLoadExamDate VARCHAR(38) DEFAULT "ac4797de-c891-11e9-a32f-2a2ae2dbcce4";

    return mostRecentViralLoadExamIsBelow(uuidNotDocumentedViralLoadExam, uuidNotDocumentedViralLoadExamDate, p_patientId, p_endDate, p_examResult);

END$$ 
DELIMITER ;

-- mostRecentRoutineViralLoadExamIsBelow

DROP FUNCTION IF EXISTS mostRecentRoutineViralLoadExamIsBelow;

DELIMITER $$
CREATE FUNCTION mostRecentRoutineViralLoadExamIsBelow(
    p_patientId INT(11),
    p_endDate DATE,
    p_examResult INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE uuidRoutineViralLoadExam VARCHAR(38) DEFAULT "4d80e0ce-5465-4041-9d1e-d281d25a9b50";
    DECLARE uuidRoutineViralLoadExamDate VARCHAR(38) DEFAULT "cac6bf44-f671-4f85-ab76-71e7f099d3cb";

    return mostRecentViralLoadExamIsBelow(uuidRoutineViralLoadExam, uuidRoutineViralLoadExamDate, p_patientId, p_endDate, p_examResult);

END$$ 
DELIMITER ;

-- mostRecentTargetedViralLoadExamIsBelow

DROP FUNCTION IF EXISTS mostRecentTargetedViralLoadExamIsBelow;

DELIMITER $$
CREATE FUNCTION mostRecentTargetedViralLoadExamIsBelow(
    p_patientId INT(11),
    p_endDate DATE,
    p_examResult INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE uuidTargetedViralLoadExam VARCHAR(38) DEFAULT "9ee13e38-c7ce-11e9-a32f-2a2ae2dbcce4";
    DECLARE uuidTargetedViralLoadExamDate VARCHAR(38) DEFAULT "ac479522-c891-11e9-a32f-2a2ae2dbcce4";

    return mostRecentViralLoadExamIsBelow(uuidTargetedViralLoadExam, uuidTargetedViralLoadExamDate, p_patientId, p_endDate, p_examResult);

END$$ 
DELIMITER ;

-- mostRecentViralLoadExamIsBelow

DROP FUNCTION IF EXISTS mostRecentViralLoadExamIsBelow;

DELIMITER $$
CREATE FUNCTION mostRecentViralLoadExamIsBelow(
    p_uuidViralLoadExam VARCHAR(38),
    p_uuidViralLoadExamDate VARCHAR(38),
    p_patientId INT(11),
    p_endDate DATE,
    p_examResult INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE testDateFromForm DATE;
    DECLARE testDateFromOpenElis DATE;
    DECLARE useFormResult TINYINT(1) DEFAULT 0;
    DECLARE testResultFromForm INT(11);
    DECLARE testResultFromOpenElis INT(11);
    DECLARE encounterIdOfFormResult INT(11);

    -- Read and store latest test date and result from form "LAB RESULTS - ADD MANUALLY" that is before p_endDate
    SELECT
        o.value_datetime, o.encounter_id
        INTO testDateFromForm, encounterIdOfFormResult
    FROM obs o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.order_id IS NULL
        AND o.value_datetime IS NOT NULL
        AND o.value_datetime < p_endDate
        AND o.person_id = p_patientId
        AND c.uuid = p_uuidViralLoadExamDate
    ORDER BY o.value_datetime DESC
    LIMIT 1;

    SELECT o.value_numeric INTO testResultFromForm
    FROM obs o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.encounter_id = encounterIdOfFormResult
        AND o.order_id IS NULL
        AND o.value_numeric IS NOT NULL
        AND o.person_id = p_patientId
        AND c.uuid = p_uuidViralLoadExam
    ORDER BY o.obs_id DESC
    LIMIT 1;

    -- read and store latest test date and result from elis that is before p_endDate
    SELECT
        o.obs_datetime, o.value_numeric
        INTO testDateFromOpenElis, testResultFromOpenElis
    FROM obs o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.order_id IS NOT NULL
        AND o.value_numeric IS NOT NULL
        AND o.person_id = p_patientId
        AND c.uuid = p_uuidViralLoadExam
        AND o.obs_datetime < p_endDate
    ORDER BY o.obs_datetime DESC
    LIMIT 1;

    -- return 0 if both dates are null
    IF (testDateFromForm IS NULL AND testDateFromOpenElis IS NULL) THEN
        RETURN 0;
    END IF;

    -- decide which result to use
    IF (testDateFromOpenElis IS NULL OR (testDateFromForm IS NOT NULL AND testDateFromForm > testDateFromOpenElis)) THEN
        SET useFormResult = 1;
    END IF;

    -- verify if result < p_examResult
    IF (useFormResult) THEN
        return testResultFromForm < p_examResult;
    ELSE
        return testResultFromOpenElis < p_examResult;
    END IF;

END$$ 
DELIMITER ;
