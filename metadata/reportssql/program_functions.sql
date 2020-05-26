
-- patientHasEnrolledIntoHivProgramDuringReportingPeriod

DROP FUNCTION IF EXISTS patientHasEnrolledIntoHivProgramDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledIntoHivProgramDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT
        TRUE INTO result
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE p.person_id = p_patientId
        AND p.voided = 0
        AND DATE(pp.date_enrolled) BETWEEN p_startDate AND p_endDate
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result );
END$$
DELIMITER ;

-- patientHasEnrolledIntoHivProgramDuringOrBeforeReportingPeriod

DROP FUNCTION IF EXISTS patientHasEnrolledIntoHivProgramDuringOrBeforeReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledIntoHivProgramDuringOrBeforeReportingPeriod(
    p_patientId INT(11),
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT
        TRUE INTO result
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE p.person_id = p_patientId
        AND p.voided = 0
        AND DATE(pp.date_enrolled) <= p_endDate
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result );
END$$
DELIMITER ;

-- getPatientARVStartDate

DROP FUNCTION IF EXISTS getPatientARVStartDate;

DELIMITER $$
CREATE FUNCTION getPatientARVStartDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    RETURN getPatientProgramTreatmentStartDate(p_patientId);
END$$
DELIMITER ;

-- getPatientMostRecentProgramAttributeCodedValue

DROP FUNCTION IF EXISTS getPatientMostRecentProgramAttributeCodedValue;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramAttributeCodedValue(
    p_patientId INT(11),
    p_uuidProgramAttribute VARCHAR(38),
    p_language VARCHAR(3)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);

    SELECT cn.name INTO result
    FROM patient_program_attribute ppa
        JOIN program_attribute_type pat ON pat.program_attribute_type_id = ppa.attribute_type_id AND pat.retired = 0
        JOIN patient_program pp ON ppa.patient_program_id = pp.patient_program_id AND pp.voided = 0
        JOIN concept c ON ppa.value_reference = c.concept_id
        JOIN concept_name cn ON cn.concept_id = c.concept_id AND cn.locale = p_language
    WHERE
        ppa.voided = 0 AND
        pp.patient_id = p_patientId AND
        pat.uuid = p_uuidProgramAttribute
    ORDER BY ppa.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getPatientMostRecentProgramAttributeValue

DROP FUNCTION IF EXISTS getPatientMostRecentProgramAttributeValue;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramAttributeValue(
    p_patientId INT(11),
    p_uuidProgramAttribute VARCHAR(38)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);

    SELECT ppa.value_reference INTO result
    FROM patient_program_attribute ppa
        JOIN program_attribute_type pat ON pat.program_attribute_type_id = ppa.attribute_type_id AND pat.retired = 0
        JOIN patient_program pp ON ppa.patient_program_id = pp.patient_program_id AND pp.voided = 0
    WHERE
        ppa.voided = 0 AND
        pp.patient_id = p_patientId AND
        pat.uuid = p_uuidProgramAttribute
    ORDER BY ppa.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getPatientProgramTreatmentStartDate

DROP FUNCTION IF EXISTS getPatientProgramTreatmentStartDate;

DELIMITER $$
CREATE FUNCTION getPatientProgramTreatmentStartDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;
    DECLARE uuidProgramTreatmentStartDate VARCHAR(38) DEFAULT "2dc1aafd-a708-11e6-91e9-0800270d80ce";

    SET result = getPatientMostRecentProgramAttributeValue(p_patientId, uuidProgramTreatmentStartDate);

    RETURN (result);
END$$
DELIMITER ;

-- getPatientMostRecentProgramOutcome

DROP FUNCTION IF EXISTS getPatientMostRecentProgramOutcome;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramOutcome(
    p_patientId INT(11),
    p_language VARCHAR(3),
    p_program VARCHAR(250)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);

    SELECT cn.name INTO result
    FROM patient_program pp
        JOIN program p ON pp.program_id = p.program_id AND p.retired = 0
        JOIN concept_name cn ON cn.concept_id = pp.outcome_concept_id AND cn.locale = p_language
    WHERE
        pp.voided = 0 AND
        pp.patient_id = p_patientId AND
        p.name = p_program
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getPatientMostRecentProgramAttributeCodedValueFromName

DROP FUNCTION IF EXISTS getPatientMostRecentProgramAttributeCodedValueFromName;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramAttributeCodedValueFromName(
    p_patientId INT(11),
    p_programAttributeName VARCHAR(255),
    p_language VARCHAR(3)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE uuidProgramAttribute VARCHAR(38);

    SELECT pat.uuid INTO uuidProgramAttribute
    FROM program_attribute_type pat
    WHERE pat.name = p_programAttributeName
    LIMIT 1;

    RETURN getPatientMostRecentProgramAttributeCodedValue(p_patientId, uuidProgramAttribute, p_language);
END$$
DELIMITER ;

-- getPatientMostRecentProgramAttributeValueFromName

DROP FUNCTION IF EXISTS getPatientMostRecentProgramAttributeValueFromName;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramAttributeValueFromName(
    p_patientId INT(11),
    p_programAttributeName VARCHAR(255)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SELECT ppa.value_reference INTO result
    FROM patient_program_attribute ppa
        JOIN program_attribute_type pat ON pat.program_attribute_type_id = ppa.attribute_type_id AND pat.retired = 0
        JOIN patient_program pp ON ppa.patient_program_id = pp.patient_program_id AND pp.voided = 0
    WHERE
        ppa.voided = 0 AND
        pp.patient_id = p_patientId AND
        pat.name = p_programAttributeName
    ORDER BY ppa.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getPatientDateOfEnrolmentInProgram

DROP FUNCTION IF EXISTS getPatientDateOfEnrolmentInProgram;

DELIMITER $$
CREATE FUNCTION getPatientDateOfEnrolmentInProgram(
    p_patientId INT(11),
    p_program VARCHAR(50)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT
        pp.date_enrolled INTO result
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE p.person_id = p_patientId
        AND p.voided = 0
        AND pro.name = p_program
    ORDER BY pp.date_enrolled DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientHasEnrolledIntoHivProgramBefore

DROP FUNCTION IF EXISTS patientHasEnrolledIntoHivProgramBefore;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledIntoHivProgramBefore(
    p_patientId INT(11),
    p_date DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT
        TRUE INTO result
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE p.person_id = p_patientId
        AND p.voided = 0
        AND DATE(pp.date_enrolled) < p_date
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result );
END$$
DELIMITER ;

-- patientHasEnrolledIntoHivProgram

DROP FUNCTION IF EXISTS patientHasEnrolledIntoHivProgram;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledIntoHivProgram(
    p_patientId INT(11)) RETURNS VARCHAR(3)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(3) DEFAULT "No";

    SELECT
        "Yes" INTO result
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE p.person_id = p_patientId
        AND p.voided = 0
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result);
END$$
DELIMITER ;

-- patientTherapeuticLineSpecified

DROP FUNCTION IF EXISTS patientTherapeuticLineSpecified;

DELIMITER $$
CREATE FUNCTION patientTherapeuticLineSpecified(
    p_patientId INT(11)) RETURNS VARCHAR(3)
    DETERMINISTIC
BEGIN

    IF patientHasTherapeuticLine(p_patientId, 0) = 1 THEN
        RETURN 'Yes';
    ELSE
        RETURN 'No';
    END IF;

END$$
DELIMITER ;

-- patientHasTherapeuticLine
-- This is a util function to avoid duplicating the SQL code on 
-- patientHasTherapeuticLineFirstLine, patientHasTherapeuticLineSecondLine and patientHasTherapeuticLineThirdLine

DROP FUNCTION IF EXISTS _patientHasTherapeuticLine;

DELIMITER $$
CREATE FUNCTION _patientHasTherapeuticLine(
    p_patientId INT(11),
    p_uuidConceptARVLineNumber VARCHAR(38)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE uuidTherapeuticLine VARCHAR(38) DEFAULT "397b7bc7-13ca-4e4e-abc3-bf854904dce3";
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM patient_program_attribute ppa
    JOIN program_attribute_type pat ON ppa.attribute_type_id = pat.program_attribute_type_id AND pat.retired = 0
    JOIN patient_program pp ON ppa.patient_program_id = pp.patient_program_id AND pp.voided = 0
    JOIN concept c ON ppa.value_reference = c.concept_id
    WHERE ppa.voided = 0
        AND pp.patient_id = p_patientId
        AND pat.uuid = uuidTherapeuticLine
        AND c.uuid = p_uuidConceptARVLineNumber
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientHasTherapeuticLineFirstLine

DROP FUNCTION IF EXISTS patientHasTherapeuticLineFirstLine;

DELIMITER $$
CREATE FUNCTION patientHasTherapeuticLineFirstLine(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE p_uuidConceptFirstLine VARCHAR(38) DEFAULT "9d928a3f-95cb-487f-96ef-86cf960503a9";

    RETURN _patientHasTherapeuticLine(p_patientId, p_uuidConceptFirstLine);
END$$
DELIMITER ;

-- patientHasTherapeuticLineSecondLine

DROP FUNCTION IF EXISTS patientHasTherapeuticLineSecondLine;

DELIMITER $$
CREATE FUNCTION patientHasTherapeuticLineSecondLine(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE p_uuidConceptSecondLine VARCHAR(38) DEFAULT "d0ee855d-f0b4-49d2-be02-1d1457d5c8bf";

    RETURN _patientHasTherapeuticLine(p_patientId, p_uuidConceptSecondLine);
END$$
DELIMITER ;

-- patientHasTherapeuticLineThirdLine

DROP FUNCTION IF EXISTS patientHasTherapeuticLineThirdLine;

DELIMITER $$
CREATE FUNCTION patientHasTherapeuticLineThirdLine(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE p_uuidConceptThirdLine VARCHAR(38) DEFAULT "d1661aa5-9a4f-4b31-b816-6973aa604289";

    RETURN _patientHasTherapeuticLine(p_patientId, p_uuidConceptThirdLine);
END$$
DELIMITER ;

-- patientHasTherapeuticLine

DROP FUNCTION IF EXISTS patientHasTherapeuticLine;

DELIMITER $$
CREATE FUNCTION patientHasTherapeuticLine(
    p_patientId INT(11),
    p_protocolLineNumber INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE result TINYINT(1);
    
    IF p_protocolLineNumber = 1 THEN
        SET result = patientHasTherapeuticLineFirstLine(p_patientId);
    ELSEIF p_protocolLineNumber = 2 THEN
        SET result = patientHasTherapeuticLineSecondLine(p_patientId);
    ELSEIF p_protocolLineNumber = 3 THEN
        SET result = patientHasTherapeuticLineThirdLine(p_patientId);
    ELSE
        SET result =  
            patientHasTherapeuticLineFirstLine(p_patientId) OR
            patientHasTherapeuticLineSecondLine(p_patientId) OR
            patientHasTherapeuticLineThirdLine(p_patientId);
    END IF;

    RETURN (result);

END$$
DELIMITER ;

-- patientHasNotBeenEnrolledIntoHivProgram

DROP FUNCTION IF EXISTS patientHasNotBeenEnrolledIntoHivProgram;

DELIMITER $$
CREATE FUNCTION patientHasNotBeenEnrolledIntoHivProgram(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE hivProgramFound TINYINT(1) DEFAULT 0;

    SELECT
        TRUE INTO hivProgramFound
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE p.person_id = p_patientId
        AND p.voided = 0
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (!hivProgramFound);
END$$
DELIMITER ;

-- arvInitiationDateSpecified

DROP FUNCTION IF EXISTS arvInitiationDateSpecified;

DELIMITER $$
CREATE FUNCTION arvInitiationDateSpecified(
    p_patientId INT(11)) RETURNS VARCHAR(3)
    DETERMINISTIC
BEGIN
    IF getPatientProgramTreatmentStartDate(p_patientId) IS NOT NULL THEN
        RETURN "Yes";
    ELSE
        RETURN "No";
    END IF;
END$$
DELIMITER ;