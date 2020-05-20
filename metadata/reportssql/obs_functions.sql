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
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;
