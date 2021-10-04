-- getNumberOfTherapeuticLineARVDispensed

DROP FUNCTION IF EXISTS getNumberOfTherapeuticLineARVDispensed;

-- exclude PA and AES dispensations
DELIMITER $$
CREATE FUNCTION getNumberOfTherapeuticLineARVDispensed(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_arvName VARCHAR(255),
    p_protocolLineNumber INT(11)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(DISTINCT o.order_id) INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept_name cn ON cn.concept_id = d.concept_id AND cn.locale = "en"
    WHERE o.voided = 0
        AND drugIsARV(d.concept_id)
        AND o.order_action <> "DISCONTINUE"
        AND o.date_stopped IS NULL
        AND cn.name = p_arvName
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugOrderIsDispensed(o.patient_id, o.order_id)
        AND patientHasTherapeuticLine(o.patient_id, p_protocolLineNumber)
        AND patientAgeIsBetween(o.patient_id, p_startAge, p_endAge, p_includeEndAge)
        AND NOT patientReasonForConsultationIsUnplannedAid(o.patient_id)
        AND IF (
            patientIsAdult(o.patient_id),
            NOT drugIsAdultProphylaxis(d.concept_id),
            NOT drugIsChildProphylaxis(d.concept_id));

    RETURN (result);
END$$ 
DELIMITER ;

-- getNumberOfNoneSpecifiedARVDispensed

DROP FUNCTION IF EXISTS getNumberOfNoneSpecifiedARVDispensed;

-- exclude therapeutic line entered, PA and AES dispensations (NONE in template)
DELIMITER $$
CREATE FUNCTION getNumberOfNoneSpecifiedARVDispensed(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_arvName VARCHAR(255)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(DISTINCT o.order_id) INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept_name cn ON cn.concept_id = d.concept_id AND cn.locale = "en"
    WHERE o.voided = 0
        AND drugIsARV(d.concept_id)
        AND cn.name = p_arvName
        AND o.order_action <> "DISCONTINUE"
        AND o.date_stopped IS NULL
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugOrderIsDispensed(o.patient_id, o.order_id)
        AND patientTherapeuticLineSpecified(o.patient_id) = "No"
        AND patientAgeIsBetween(o.patient_id, p_startAge, p_endAge, p_includeEndAge)
        AND NOT patientReasonForConsultationIsUnplannedAid(o.patient_id)
        AND IF (
            patientIsAdult(o.patient_id),
            NOT drugIsAdultProphylaxis(d.concept_id),
            NOT drugIsChildProphylaxis(d.concept_id));

    RETURN (result);
END$$ 
DELIMITER ;

-- getNumberOfAESAndPAARVDispensed

DROP FUNCTION IF EXISTS getNumberOfAESAndPAARVDispensed;

DELIMITER $$
CREATE FUNCTION getNumberOfAESAndPAARVDispensed(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_arvName VARCHAR(255)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(DISTINCT o.order_id) INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept_name cn ON cn.concept_id = d.concept_id AND cn.locale = "en"
    WHERE o.voided = 0
        AND drugIsARV(d.concept_id)
        AND cn.name = p_arvName
        AND o.order_action <> "DISCONTINUE"
        AND o.date_stopped IS NULL
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugOrderIsDispensed(o.patient_id, o.order_id)
        AND patientAgeIsBetween(o.patient_id, p_startAge, p_endAge, p_includeEndAge)
        AND patientReasonForConsultationIsUnplannedAid(o.patient_id)
        AND IF (
            patientIsAdult(o.patient_id),
            drugIsAdultProphylaxis(d.concept_id),
            drugIsChildProphylaxis(d.concept_id));

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS getNumberOfProphylaxisARVDispensed;

-- exclude PA
DELIMITER $$
CREATE FUNCTION getNumberOfProphylaxisARVDispensed(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_arvName VARCHAR(255)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(DISTINCT o.order_id) INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept_name cn ON cn.concept_id = d.concept_id AND cn.locale = "en"
    WHERE o.voided = 0
        AND IF (
            patientIsAdult(o.patient_id),
            drugIsAdultProphylaxis(d.concept_id),
            drugIsChildProphylaxis(d.concept_id))
        AND cn.name = p_arvName
        AND o.order_action <> "DISCONTINUE"
        AND o.date_stopped IS NULL
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugOrderIsDispensed(o.patient_id, o.order_id)
        AND patientAgeIsBetween(o.patient_id, p_startAge, p_endAge, p_includeEndAge)
        AND NOT patientReasonForConsultationIsUnplannedAid(o.patient_id);
            
    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS getNumberOfPunctualAidARVDispensed;

-- exclude AES
DELIMITER $$
CREATE FUNCTION getNumberOfPunctualAidARVDispensed(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_arvName VARCHAR(255)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(DISTINCT o.order_id) INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept_name cn ON cn.concept_id = d.concept_id AND cn.locale = "en"
    WHERE o.voided = 0
        AND patientReasonForConsultationIsUnplannedAid(o.patient_id)
        AND drugIsARV(d.concept_id)
        AND cn.name = p_arvName
        AND o.order_action <> "DISCONTINUE"
        AND o.date_stopped IS NULL
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugOrderIsDispensed(o.patient_id, o.order_id)
        AND patientAgeIsBetween(o.patient_id, p_startAge, p_endAge, p_includeEndAge)
        AND IF (
            patientIsAdult(o.patient_id),
            NOT drugIsAdultProphylaxis(d.concept_id),
            NOT drugIsChildProphylaxis(d.concept_id));

    RETURN (result);
END$$ 
DELIMITER ;

-- getNumberOfARVPrescribed

DROP FUNCTION IF EXISTS getNumberOfARVPrescribed;

DELIMITER $$
CREATE FUNCTION getNumberOfARVPrescribed(
    p_startDate DATE,
    p_endDate DATE,
    p_arvName VARCHAR(255)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(DISTINCT o.order_id) INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept_name cn ON cn.concept_id = d.concept_id AND cn.locale = "en"
    WHERE o.voided = 0
        AND drugIsARV(d.concept_id)
        AND cn.name = p_arvName
        AND o.order_action <> "DISCONTINUE"
        AND o.date_stopped IS NULL
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate;

    RETURN (result);
END$$ 
DELIMITER ;

-- getNumberOfARVDispensed

DROP FUNCTION IF EXISTS getNumberOfARVDispensed;

DELIMITER $$
CREATE FUNCTION getNumberOfARVDispensed(
    p_startDate DATE,
    p_endDate DATE,
    p_arvName VARCHAR(255)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(DISTINCT o.order_id) INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept_name cn ON cn.concept_id = d.concept_id AND cn.locale = "en"
    WHERE o.voided = 0
        AND drugIsARV(d.concept_id)
        AND cn.name = p_arvName
        AND o.order_action <> "DISCONTINUE"
        AND o.date_stopped IS NULL
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugOrderIsDispensed(o.patient_id, o.order_id);

    RETURN (result);
END$$ 
DELIMITER ;
