-- getObsCodedValue

DROP FUNCTION IF EXISTS getObsCodedValue;

DELIMITER $$
CREATE FUNCTION getObsCodedValue(
    p_patientId INT(11),
    p_conceptUuid VARCHAR(38)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SELECT
        cn.name INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
        JOIN concept_name cn ON o.value_coded = cn.concept_id AND cn.locale='en'
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = p_conceptUuid
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getObsTextValue

DROP FUNCTION IF EXISTS getObsTextValue;

DELIMITER $$
CREATE FUNCTION getObsTextValue(
    p_patientId INT(11),
    p_conceptUuid VARCHAR(38)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SELECT o.value_text INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = p_conceptUuid
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getObsCodedValueInSectionByNames

DROP FUNCTION IF EXISTS getObsCodedValueInSectionByNames;

DELIMITER $$
CREATE FUNCTION getObsCodedValueInSectionByNames(
    p_patientId INT(11),
    p_questionName VARCHAR(250),
    p_sectionName VARCHAR(250)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);

    SELECT
        cn_answer.name INTO result
    FROM obs o
        JOIN concept_name cn_question ON o.concept_id = cn_question.concept_id
        JOIN concept_name cn_answer ON o.value_coded = cn_answer.concept_id        
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND cn_question.name = p_questionName
        AND cn_question.locale='en' AND cn_question.concept_name_type = 'FULLY_SPECIFIED'
        AND cn_answer.locale='en' AND cn_answer.concept_name_type = 'FULLY_SPECIFIED'
        AND p_sectionName = (SELECT concept_name.name
            FROM obs
                JOIN concept_name ON obs.concept_id = concept_name.concept_id
            WHERE obs.voided = 0
                AND obs.obs_id = o.obs_group_id
                AND concept_name.locale='en' AND concept_name.concept_name_type = 'FULLY_SPECIFIED')
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getObsCodedValuesInSectionByNames for multi-select concepts

DROP FUNCTION IF EXISTS getObsCodedValuesInSectionByNames;

DELIMITER $$
CREATE FUNCTION getObsCodedValuesInSectionByNames(
    p_patientId INT(11),
    p_questionName VARCHAR(250),
    p_sectionName VARCHAR(250)) RETURNS VARCHAR(1024)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(1024);

    SELECT
        GROUP_CONCAT(DISTINCT cn_answer.name ORDER BY o.date_created DESC SEPARATOR ', ') INTO result
    FROM obs o
        JOIN concept_name cn_question ON o.concept_id = cn_question.concept_id
        JOIN concept_name cn_answer ON o.value_coded = cn_answer.concept_id        
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND cn_question.name = p_questionName
        AND cn_question.locale='en' AND cn_question.concept_name_type = 'FULLY_SPECIFIED'
        AND cn_answer.locale='en' AND cn_answer.concept_name_type = 'FULLY_SPECIFIED'
        AND p_sectionName = (SELECT concept_name.name
            FROM obs
                JOIN concept_name ON obs.concept_id = concept_name.concept_id
            WHERE obs.voided = 0
                AND obs.obs_id = o.obs_group_id
                AND concept_name.locale='en' AND concept_name.concept_name_type = 'FULLY_SPECIFIED');

    RETURN (result);
END$$
DELIMITER ;

-- getObsCodedShortNameValue

DROP FUNCTION IF EXISTS getObsCodedShortNameValue;

DELIMITER $$
CREATE FUNCTION getObsCodedShortNameValue(
    p_patientId INT(11),
    p_conceptUuid VARCHAR(38)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SELECT
        cn.name INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
        JOIN concept_name cn ON o.value_coded = cn.concept_id AND cn.locale='en' AND cn.concept_name_type = "SHORT"
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = p_conceptUuid
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getObsYesNoValueWithDate

DROP FUNCTION IF EXISTS getObsYesNoValueWithDate;

DELIMITER $$
CREATE FUNCTION getObsYesNoValueWithDate(
    p_patientId INT(11),
    p_conceptUuid VARCHAR(38)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);
    DECLARE resultDate DATE;

    SELECT
        cn.name INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
        JOIN concept_name cn ON o.value_coded = cn.concept_id AND cn.locale='en'
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = p_conceptUuid
    ORDER BY o.date_created DESC
    LIMIT 1;

    IF (result = "True") THEN
        SET result = "Yes";
    ELSEIF (result = "False") THEN
        SET result = "No";
    END IF;

    IF (result IS NOT NULL) THEN
        SET resultDate = getObsCreatedDate(p_patientId, p_conceptUuid);
        RETURN CONCAT(result, " (", DATE_FORMAT(resultDate, "%d-%b-%Y"), ")");
    ELSE
        RETURN NULL;
    END IF;
END$$
DELIMITER ;

-- getObsCreatedDate

DROP FUNCTION IF EXISTS getObsCreatedDate;

DELIMITER $$
CREATE FUNCTION getObsCreatedDate(
    p_patientId INT(11),
    p_conceptUuid VARCHAR(38)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT
        o.date_created INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = p_conceptUuid
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getObsDatetimeValueInSection

DROP FUNCTION IF EXISTS getObsDatetimeValueInSection;

DELIMITER $$
CREATE FUNCTION getObsDatetimeValueInSection(
    p_patientId INT(11),
    p_conceptUuid VARCHAR(38),
    p_conceptUidParentSection VARCHAR(38)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT
        o.value_datetime INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = p_conceptUuid
        AND p_conceptUidParentSection = (
            SELECT concept.uuid
            FROM obs
                JOIN concept ON obs.concept_id = concept.concept_id
            WHERE obs.voided = 0
                AND obs.obs_id = o.obs_group_id
            LIMIT 1
        )
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getObsDatetimeValue

DROP FUNCTION IF EXISTS getObsDatetimeValue;

DELIMITER $$
CREATE FUNCTION getObsDatetimeValue(
    p_patientId INT(11),
    p_conceptUuid VARCHAR(38)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT
        o.value_datetime INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = p_conceptUuid
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getObsNumericValue

DROP FUNCTION IF EXISTS getObsNumericValue;

DELIMITER $$
CREATE FUNCTION getObsNumericValue(
    p_patientId INT(11),
    p_conceptUuid VARCHAR(38)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11);

    SELECT
        o.value_numeric INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = p_conceptUuid
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getObsLastModifiedDate

DROP FUNCTION IF EXISTS getObsLastModifiedDate;

DELIMITER $$
CREATE FUNCTION getObsLastModifiedDate(
    p_patientId INT(11),
    p_conceptUuid VARCHAR(38)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT
        o.obs_datetime INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = p_conceptUuid
    ORDER BY o.obs_datetime DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getObsLocation

DROP FUNCTION IF EXISTS getObsLocation;

DELIMITER $$
CREATE FUNCTION getObsLocation(
    p_patientId INT(11),
    p_conceptUuid VARCHAR(38)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SELECT
        l.name INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
        JOIN location l ON o.location_id = l.location_id AND l.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = p_conceptUuid
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getMostRecentDateObservation

DROP FUNCTION IF EXISTS getMostRecentDateObservation;

DELIMITER $$
CREATE FUNCTION getMostRecentDateObservation(
    p_patientId INT(11),
    p_conceptName VARCHAR(255)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT o.value_datetime INTO result
    FROM obs o
    JOIN concept_name cn ON cn.concept_id = o.concept_id
    WHERE o.person_id = p_patientId
        AND o.voided = 0
        AND cn.name = p_conceptName
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;


-- getMostRecentTextObservation

DROP FUNCTION IF EXISTS getMostRecentTextObservation;

DELIMITER $$
CREATE FUNCTION getMostRecentTextObservation(
    p_patientId INT(11),
    p_conceptName VARCHAR(255)) RETURNS TEXT
    DETERMINISTIC
BEGIN
    DECLARE result TEXT;

    SELECT o.value_text INTO result
    FROM obs o
    JOIN concept_name cn ON cn.concept_id = o.concept_id
    WHERE o.person_id = p_patientId
        AND o.voided = 0
        AND cn.name = p_conceptName
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getMostRecentCodedObservation

DROP FUNCTION IF EXISTS getMostRecentCodedObservation;

DELIMITER $$
CREATE FUNCTION getMostRecentCodedObservation(
    p_patientId INT(11),
    p_conceptName VARCHAR(255),
    p_language VARCHAR(3)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SELECT cn2.name INTO result
    FROM obs o
    JOIN concept_name cn ON cn.concept_id = o.concept_id
    JOIN concept_name cn2 ON cn2.concept_id = o.value_coded
    WHERE o.person_id = p_patientId
        AND o.voided = 0
        AND cn.name = p_conceptName
        AND cn2.locale = p_language
        AND cn2.concept_name_type = "FULLY_SPECIFIED"
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getMostRecentShortNameCodedObservation

DROP FUNCTION IF EXISTS getMostRecentShortNameCodedObservation;

DELIMITER $$
CREATE FUNCTION getMostRecentShortNameCodedObservation(
    p_patientId INT(11),
    p_conceptName VARCHAR(255),
    p_language VARCHAR(3)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SELECT cn2.name INTO result
    FROM obs o
    JOIN concept_name cn ON cn.concept_id = o.concept_id
    JOIN concept_name cn2 ON cn2.concept_id = o.value_coded
    WHERE o.person_id = p_patientId
        AND o.voided = 0
        AND cn.name = p_conceptName
        AND cn2.locale = p_language
        AND cn2.concept_name_type = "SHORT"
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getObservationTextValueWithinPeriod

DROP FUNCTION IF EXISTS getObservationTextValueWithinPeriod;

DELIMITER $$
CREATE FUNCTION getObservationTextValueWithinPeriod(
  p_patientId INT(11),
  p_startDate DATE,
  p_endDate DATE,
  conceptUuid VARCHAR(38)
    ) RETURNS VARCHAR(255)
  DETERMINISTIC
BEGIN
    DECLARE observationTextValueWithinPeriod VARCHAR(250);

    SELECT name INTO observationTextValueWithinPeriod
    FROM (
        SELECT MAX(o.date_created), cn.name
        FROM obs o
            JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
            JOIN concept_name cn ON cn.concept_id = o.value_coded AND cn.locale ='en'
        WHERE o.voided = 0
            AND o.person_id = p_patientId
            AND o.concept_id = (SELECT co.concept_id FROM concept co WHERE co.uuid = conceptUuid)
            AND o.date_created BETWEEN p_startDate AND p_endDate
        GROUP BY o.person_id
    ) t;

    RETURN (observationTextValueWithinPeriod);
END$$
DELIMITER ;
