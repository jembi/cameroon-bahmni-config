
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

-- patientHasEnrolledIntoProgramDuringReportingPeriod

DROP FUNCTION IF EXISTS patientHasEnrolledIntoProgramDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledIntoProgramDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_program VARCHAR(250)) RETURNS TINYINT(1)
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
        AND pro.name = p_program
    GROUP BY pro.name;

    RETURN (result );
END$$
DELIMITER ;

-- getMostRecentProgramEnrollmentDate

DROP FUNCTION IF EXISTS getMostRecentProgramEnrollmentDate;

DELIMITER $$
CREATE FUNCTION getMostRecentProgramEnrollmentDate(
    p_patientId INT(11),
    p_program VARCHAR(250)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT
        pp.date_enrolled INTO result
    FROM patient_program pp
        JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE pp.patient_id = p_patientId
        AND pp.voided = 0
        AND pro.name = p_program
    ORDER BY pp.date_enrolled DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getMostRecentProgramCompletionDate

DROP FUNCTION IF EXISTS getMostRecentProgramCompletionDate;

DELIMITER $$
CREATE FUNCTION getMostRecentProgramCompletionDate(
    p_patientId INT(11),
    p_program VARCHAR(250)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT
        pp.date_completed INTO result
    FROM patient_program pp
        JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE pp.patient_id = p_patientId
        AND pp.voided = 0
        AND pro.name = p_program
    ORDER BY pp.date_completed DESC
    LIMIT 1;

    RETURN (result);
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
    RETURN getPatientProgramTreatmentStartDate(p_patientId, "HIV_PROGRAM_KEY");
END$$
DELIMITER ;

-- getPatientTBStartDate

DROP FUNCTION IF EXISTS getPatientTBStartDate;

DELIMITER $$
CREATE FUNCTION getPatientTBStartDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    RETURN getPatientProgramTreatmentStartDate(p_patientId, "TB_PROGRAM_KEY");
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

-- getPatientMostRecentProgramAttributeValueInProgram

DROP FUNCTION IF EXISTS getPatientMostRecentProgramAttributeValueInProgram;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramAttributeValueInProgram(
    p_patientId INT(11),
    p_uuidProgramAttribute VARCHAR(38),
    p_program VARCHAR(250)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);

    SELECT ppa.value_reference INTO result
    FROM patient_program_attribute ppa
        JOIN program_attribute_type pat ON pat.program_attribute_type_id = ppa.attribute_type_id AND pat.retired = 0
        JOIN patient_program pp ON ppa.patient_program_id = pp.patient_program_id AND pp.voided = 0
        JOIN program p ON p.program_id = pp.program_id AND p.retired = 0
    WHERE
        ppa.voided = 0 AND
        pp.patient_id = p_patientId AND
        pat.uuid = p_uuidProgramAttribute AND
        p.name = p_program
    ORDER BY ppa.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getPatientProgramTreatmentStartDate

DROP FUNCTION IF EXISTS getPatientProgramTreatmentStartDate;

DELIMITER $$
CREATE FUNCTION getPatientProgramTreatmentStartDate(
    p_patientId INT(11),
    p_program VARCHAR(250)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;
    DECLARE uuidProgramTreatmentStartDate VARCHAR(38) DEFAULT "2dc1aafd-a708-11e6-91e9-0800270d80ce";

    SET result = getPatientMostRecentProgramAttributeValueInProgram(p_patientId, uuidProgramTreatmentStartDate, p_program);

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

-- getProgramOutcomeDateDuringTheReportingPeriod

DROP FUNCTION IF EXISTS getProgramOutcomeDateDuringTheReportingPeriod;

DELIMITER $$
CREATE FUNCTION getProgramOutcomeDateDuringTheReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_program VARCHAR(250)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT
        pp.date_enrolled INTO result
    FROM patient_program pp
        JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE pp.patient_id = p_patientId
        AND pp.voided = 0
        AND pro.name = p_program
    ORDER BY pp.date_enrolled DESC
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

-- getMostRecentProgramAttributeValueFromAttributeAndProgramName

DROP FUNCTION IF EXISTS getMostRecentProgramAttributeValueFromAttributeAndProgramName;

DELIMITER $$
CREATE FUNCTION getMostRecentProgramAttributeValueFromAttributeAndProgramName(
    p_patientId INT(11),
    p_programAttributeName VARCHAR(255),
    p_programName VARCHAR(255)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SELECT ppa.value_reference INTO result
    FROM patient_program_attribute ppa
        JOIN program_attribute_type pat ON pat.program_attribute_type_id = ppa.attribute_type_id AND pat.retired = 0
        JOIN patient_program pp ON ppa.patient_program_id = pp.patient_program_id AND pp.voided = 0
        JOIN program p ON p.program_id = pp.program_id  AND p.retired = 0
    WHERE
        ppa.voided = 0 AND
        pp.patient_id = p_patientId AND
        pat.name = p_programAttributeName AND
        p.name = p_programName
    ORDER BY ppa.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getPatientMostRecentProgramAttributeDateValueFromName

DROP FUNCTION IF EXISTS getPatientMostRecentProgramAttributeDateValueFromName;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramAttributeDateValueFromName(
    p_patientId INT(11),
    p_programAttributeName VARCHAR(255)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SET result = getPatientMostRecentProgramAttributeValueFromName(p_patientId, p_programAttributeName);

    IF (result IS NOT NULL) THEN
        RETURN DATE(result);
    ELSE
        RETURN NULL;
    END IF;
END$$
DELIMITER ;

-- getProgramAttributeDateValueFromAttributeAndProgramName

DROP FUNCTION IF EXISTS getProgramAttributeDateValueFromAttributeAndProgramName;

DELIMITER $$
CREATE FUNCTION getProgramAttributeDateValueFromAttributeAndProgramName(
    p_patientId INT(11),
    p_programAttributeName VARCHAR(255),
    p_programName VARCHAR(255)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SET result = getMostRecentProgramAttributeValueFromAttributeAndProgramName(p_patientId, p_programAttributeName, p_programName);

    IF (result IS NOT NULL) THEN
        RETURN DATE(result);
    ELSE
        RETURN NULL;
    END IF;
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
    IF getPatientProgramTreatmentStartDate(p_patientId, "HIV_PROGRAM_KEY") IS NOT NULL THEN
        RETURN "Yes";
    ELSE
        RETURN "No";
    END IF;
END$$
DELIMITER ;

-- getPatientMostRecentProgramTrackingStateValue

DROP FUNCTION IF EXISTS getPatientMostRecentProgramTrackingStateValue;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramTrackingStateValue(
    p_patientId INT(11),
    p_language VARCHAR(3),
    p_programName VARCHAR(250)
    ) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);

    SELECT cn.name INTO result
    FROM patient_state ps
        JOIN program_workflow_state pws ON ps.state = pws.program_workflow_state_id AND pws.retired = 0
        JOIN concept_name cn ON pws.concept_id = cn.concept_id AND cn.locale=p_language
        JOIN patient_program pp ON pp.patient_program_id = ps.patient_program_id AND pp.voided = 0
        JOIN program p ON p.program_id = pp.program_id AND p.retired = 0
    WHERE
        pp.patient_id = p_patientId AND
        p.name = p_programName
    ORDER BY ps.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getPatientMostRecentProgramTrackingDateValue

DROP FUNCTION IF EXISTS getPatientMostRecentProgramTrackingDateValue;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramTrackingDateValue(
    p_patientId INT(11),
    p_program VARCHAR(38)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT pp.date_enrolled INTO result
    FROM patient_program pp
        JOIN program p ON p.program_id = pp.program_id AND p.retired = 0
    WHERE
        pp.voided = 0 AND
        pp.patient_id = p_patientId AND
        p.name = p_program
    ORDER BY pp.date_enrolled DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getOtherReasonsOfDefaulting

DROP FUNCTION IF EXISTS getOtherReasonsOfDefaulting;

DELIMITER $$
CREATE FUNCTION getOtherReasonsOfDefaulting(
    p_patientId INT(11)) RETURNS TEXT
    DETERMINISTIC
BEGIN
    DECLARE result TEXT;

    SELECT GROUP_CONCAT(pat.name) INTO result
    FROM patient_program_attribute ppa
        JOIN patient_program pp ON ppa.patient_program_id = pp.patient_program_id AND pp.voided = 0
        JOIN program_attribute_type pat ON ppa.attribute_type_id = pat.program_attribute_type_id AND pat.retired = 0
    WHERE
        ppa.voided = 0 AND
        pp.patient_id = p_patientId AND
        ppa.value_reference = "true" AND
        ppa.patient_program_id = (
            SELECT pp.patient_program_id
            FROM patient_program pp
            WHERE pp.patient_id = p_patientId AND pp.program_id = (
                SELECT p.program_id
                FROM program p
                WHERE `name` = "HIV_DEFAULTERS_PROGRAM_KEY"
                LIMIT 1)
            ORDER BY pp.date_created DESC
            LIMIT 1)
    ORDER BY pp.date_enrolled DESC
    LIMIT 1;

    SET result = REPLACE(result, "PROGRAM_MANAGEMENT_701_STIGMA", "Stigma");
    SET result = REPLACE(result, "PROGRAM_MANAGEMENT_702_LONG_DISTANCE", "Long Distance");
    SET result = REPLACE(result, "PROGRAM_MANAGEMENT_703_COST_OF_TRANSPORT", "Cost of Transport");
    SET result = REPLACE(result, "PROGRAM_MANAGEMENT_704_SIDE_EFFECTS_OF_ARVS", "Side effects of ARVs");
    SET result = REPLACE(result, "PROGRAM_MANAGEMENT_705_COST_OF_SERVICES", "Cost of services");
    SET result = REPLACE(result, "PROGRAM_MANAGEMENT_706_STAFF_ATTITUDE", "Staff attitude");
    SET result = REPLACE(result, "PROGRAM_MANAGEMENT_707_TRADITIONAL_BELIEFS", "Traditional Beliefs");
    SET result = REPLACE(result, "PROGRAM_MANAGEMENT_708_RELIGIOUS_BELIEFS", "Religious beliefs");
    SET result = REPLACE(result, "PROGRAM_MANAGEMENT_709_DENIAL", "Denial");
    SET result = REPLACE(result, "PROGRAM_MANAGEMENT_710_INCONVENIENT_SERVICE_HOURS", "Inconvenient service hours");
    SET result = REPLACE(result, "PROGRAM_MANAGEMENT_711_TRAVEL", "Travel");
    SET result = REPLACE(result, "PROGRAM_MANAGEMENT_712_FEELS_HEALTHY", "Feels healthy");
    SET result = REPLACE(result, "PROGRAM_MANAGEMENT_713_INSECURITY", "Insecurity");

    RETURN (result);
END$$
DELIMITER ;

-- getDefaulterStageThatIsHomeVisit

DROP FUNCTION IF EXISTS getDefaulterStageThatIsHomeVisit;

DELIMITER $$
CREATE FUNCTION getDefaulterStageThatIsHomeVisit(
    p_patientId INT(11)) RETURNS VARCHAR(20)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(20);

    SELECT cn.name INTO result
    FROM patient_state ps
        JOIN patient_program pp ON pp.patient_program_id = ps.patient_program_id AND pp.voided = 0
        JOIN program p ON p.program_id = pp.program_id AND p.retired = 0
        JOIN program_workflow_state pws ON pws.program_workflow_state_id = ps.state AND pws.retired = 0
        JOIN concept_name cn ON cn.concept_id = pws.concept_id AND cn.voided = 0 AND cn.locale = 'en' AND cn.locale_preferred = 1
    WHERE
        ps.voided = 0 AND
        pp.patient_id = p_patientId AND
        p.name = 'HIV_DEFAULTERS_PROGRAM_KEY'
    ORDER BY ps.start_date DESC
    LIMIT 1;

    IF (result = 'Home visit') THEN
        RETURN result;
    ELSE
        RETURN null;
    END IF;
END$$
DELIMITER ;
