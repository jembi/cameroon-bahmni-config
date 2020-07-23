-- drugIsARV

DROP FUNCTION IF EXISTS drugIsARV;

DELIMITER $$
CREATE FUNCTION drugIsARV(
    p_drugConceptId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE uuidARVDrugsSet VARCHAR(38) DEFAULT "9e7f1f61-216f-44bb-b5bb-35c9a0d9d9ba";

    SELECT TRUE INTO result
    FROM concept_set cs
    INNER JOIN concept c ON c.concept_id = cs.concept_set AND c.retired = 0
    WHERE c.uuid = uuidARVDrugsSet
        AND cs.concept_id = p_drugConceptId
    LIMIT 1;

    return result;
END$$
DELIMITER ;

-- drugIsChildProphylaxis

DROP FUNCTION IF EXISTS drugIsChildProphylaxis;

DELIMITER $$
CREATE FUNCTION drugIsChildProphylaxis(
    p_drugConceptId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE childProphylaxisUuid VARCHAR(38) DEFAULT "fa7e7514-146b-4add-92ee-95d6e03315e0";
    return _drugIsARV(p_drugConceptId, childProphylaxisUuid);
END$$
DELIMITER ;

-- drugIsAdultProphylaxis

DROP FUNCTION IF EXISTS drugIsAdultProphylaxis;

DELIMITER $$
CREATE FUNCTION drugIsAdultProphylaxis(
    p_drugConceptId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE adultProphylaxisUuid VARCHAR(38) DEFAULT "48990aed-5d90-4165-8d56-6e03e9914951";
    return _drugIsARV(p_drugConceptId, adultProphylaxisUuid);
END$$
DELIMITER ;

-- _drugIsARV

DROP FUNCTION IF EXISTS _drugIsARV;

DELIMITER $$
CREATE FUNCTION _drugIsARV(
    p_drugConceptId INT(11),
    p_orderLineUuid VARCHAR(38)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM concept_set cs
    INNER JOIN concept c ON c.concept_id = cs.concept_set AND c.retired = 0
    WHERE c.uuid = p_orderLineUuid
        AND cs.concept_id = p_drugConceptId
    LIMIT 1;

    return result;
END$$
DELIMITER ;

-- drugOrderIsDispensed

DROP FUNCTION IF EXISTS drugOrderIsDispensed;

DELIMITER $$
CREATE FUNCTION drugOrderIsDispensed(
    p_patientId INT(11),
    p_orderId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE drugDispensed TINYINT(1) DEFAULT 0;
    DECLARE retrospectiveDrugEntry TINYINT(1) DEFAULT 0;
    DECLARE uuidDispensedConcept VARCHAR(38) DEFAULT 'ff0d6d6a-e276-11e4-900f-080027b662ec';

    SELECT TRUE INTO drugDispensed
    FROM obs o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND o.order_id = p_orderId
        AND c.uuid = uuidDispensedConcept;

    SELECT TRUE INTO retrospectiveDrugEntry
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON c.concept_id = do.duration_units AND retired = 0
    WHERE o.voided = 0
        AND o.patient_id = p_patientId
        AND o.order_id = p_orderId
        AND o.date_created > calculateTreatmentEndDate(
            o.scheduled_date,
            do.duration,
            c.uuid);

    RETURN (drugDispensed OR retrospectiveDrugEntry); 
END$$ 

DELIMITER ; 

-- patientHasAtLeastOneArvDrugPrescribed

DROP FUNCTION IF EXISTS patientHasAtLeastOneArvDrugPrescribed;

DELIMITER $$
CREATE FUNCTION patientHasAtLeastOneArvDrugPrescribed(
    p_patientId INT(11)) RETURNS VARCHAR(3)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(3) DEFAULT "No";

    SELECT "Yes" INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
    GROUP BY o.patient_id;

    RETURN (result);
END$$
DELIMITER ;

-- patientLatestArvDrugWasDispensed

DROP FUNCTION IF EXISTS patientLatestArvDrugWasDispensed;

DELIMITER $$
CREATE FUNCTION patientLatestArvDrugWasDispensed(
    p_patientId INT(11)) RETURNS VARCHAR(3)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(3) DEFAULT "No";

    SELECT "Yes" INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    GROUP BY o.patient_id;

    RETURN (result);
END$$
DELIMITER ;

-- getLastArvPickupDate

DROP FUNCTION IF EXISTS getLastArvPickupDate;

DELIMITER $$
CREATE FUNCTION getLastArvPickupDate(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT o.scheduled_date INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugIsARV(d.concept_id)
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    ORDER BY o.scheduled_date DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getDurationMostRecentArvTreatment

DROP FUNCTION IF EXISTS getDurationMostRecentArvTreatment;

DELIMITER $$
CREATE FUNCTION getDurationMostRecentArvTreatment(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11);

    SELECT calculateDurationInDays(do.duration,c.uuid) INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept c ON c.concept_id = do.duration_units AND c.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugIsARV(d.concept_id)
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    ORDER BY o.scheduled_date DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getLocationOfArvRefill

DROP FUNCTION IF EXISTS getLocationOfArvRefill;

DELIMITER $$
CREATE FUNCTION getLocationOfArvRefill(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);

    SELECT l.name INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided = 0
        JOIN `location` l ON l.location_id = e.location_id AND l.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND o.date_created BETWEEN p_startDate AND p_endDate
        AND drugIsARV(d.concept_id)
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN 
      CASE
            WHEN result LIKE "LOCATION_COMMUNITY%" THEN "Community"
            WHEN result IS NOT NULL THEN "Facility"
            ELSE NULL
        END;
END$$
DELIMITER ;

-- calculateDurationInDays

DROP FUNCTION IF EXISTS calculateDurationInDays;

DELIMITER $$
CREATE FUNCTION calculateDurationInDays(
    p_duration INT(11),
    p_uuidDurationUnit VARCHAR(38)) RETURNS INT(11)
    DETERMINISTIC
BEGIN

    DECLARE result INT(11);
    DECLARE uuidMinute VARCHAR(38) DEFAULT '33bc78b1-8a92-11e4-977f-0800271c1b75';
    DECLARE uuidHour VARCHAR(38) DEFAULT 'bb62c684-3f10-11e4-adec-0800271c1b75';
    DECLARE uuidDay VARCHAR(38) DEFAULT '9d7437a9-3f10-11e4-adec-0800271c1b75';
    DECLARE uuidWeek VARCHAR(38) DEFAULT 'bb6436e3-3f10-11e4-adec-0800271c1b75';
    DECLARE uuidMonth VARCHAR(38) DEFAULT 'bb655344-3f10-11e4-adec-0800271c1b75';

    IF p_uuidDurationUnit = uuidMinute THEN
        RETURN p_duration / 1440;
    ELSEIF p_uuidDurationUnit = uuidHour THEN
        RETURN p_duration / 24;
    ELSEIF p_uuidDurationUnit = uuidDay THEN
        RETURN p_duration;
    ELSEIF p_uuidDurationUnit = uuidWeek THEN
        RETURN p_duration * 7;
    ELSEIF p_uuidDurationUnit = uuidMonth THEN
        RETURN p_duration * 30;
    END IF;

    RETURN (result); 
END$$ 

DELIMITER ; 

-- getInfantARVProphylaxis

DROP FUNCTION IF EXISTS getInfantARVProphylaxis;

DELIMITER $$
CREATE FUNCTION getInfantARVProphylaxis(
    p_patientId INT(11),
    p_drugName VARCHAR(50),
    p_startDate DATE,
    p_endDate DATE) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SELECT d.name INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugIsChildProphylaxis(d.concept_id)
        AND d.name LIKE CONCAT('%', p_drugName, '%')
    ORDER BY o.scheduled_date DESC
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getDateOfInfantARVProphylaxis

DROP FUNCTION IF EXISTS getDateOfInfantARVProphylaxis;

DELIMITER $$
CREATE FUNCTION getDateOfInfantARVProphylaxis(
    p_patientId INT(11),
    p_drugName VARCHAR(50),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT o.scheduled_date INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugIsChildProphylaxis(d.concept_id)
        AND d.name LIKE CONCAT('%', p_drugName, '%')
    ORDER BY o.scheduled_date DESC
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- drugOrderIsARefill

DROP FUNCTION IF EXISTS drugOrderIsARefill;

DELIMITER $$
CREATE FUNCTION drugOrderIsARefill(
    p_patientId INT(11),
    p_drugId INT(11),
    p_orderId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM drug_order do
    JOIN orders o ON do.order_id = o.order_id AND o.voided = 0
    WHERE o.patient_id = p_patientId
        AND do.drug_inventory_id = p_drugId
        AND do.order_id < p_orderId
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;


-- getDifferentiatedARTDeliveryModelAtLastRefill

DROP FUNCTION IF EXISTS getDifferentiatedARTDeliveryModelAtLastRefill;

DELIMITER $$
CREATE FUNCTION getDifferentiatedARTDeliveryModelAtLastRefill(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS VARCHAR(100)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(100);
    DECLARE locationLastRefill VARCHAR(250);

    SELECT l.name INTO locationLastRefill
    FROM drug_order do
        JOIN orders o ON o.order_id = do.order_id  AND o.voided = 0
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided = 0
        JOIN `location` l ON e.location_id = l.location_id AND l.retired = 0
    WHERE o.patient_id = p_patientId
        AND o.date_created BETWEEN p_startDate AND p_endDate
        AND drugIsARV(d.concept_id)
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN 
      CASE
            WHEN locationLastRefill = "LOCATION_COMMUNITY_HOME" THEN "Community Home"
            WHEN locationLastRefill = "LOCATION_COMMUNITY_MOBILE" THEN "Community Mobile"
            WHEN locationLastRefill IS NOT NULL THEN "Facility"
            ELSE NULL
        END;

    RETURN result;
END$$
DELIMITER ;

-- getDateInitiatedTPT

DROP FUNCTION IF EXISTS getDateInitiatedTPT;

DELIMITER $$
CREATE FUNCTION getDateInitiatedTPT(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TEXT
    DETERMINISTIC
BEGIN
    DECLARE result TEXT;

    SELECT GROUP_CONCAT(DISTINCT DATE_FORMAT(o.scheduled_date, "%d-%b-%Y")) INTO result
    FROM drug_order do
        JOIN orders o ON o.order_id = do.order_id  AND o.voided = 0
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND (d.name LIKE "INH%" OR
            d.name IN(
                "Rifampicine + Isoniazide 60mg+30mg",
                "Rifampicine + Isoniazide 150mg+75mg",
                "Rifampicine + Isoniazide 300mg+150mg"))
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    ORDER BY o.scheduled_date DESC;

    RETURN result;
    
END$$
DELIMITER ;

-- getLastARVPrescribed

DROP FUNCTION IF EXISTS getLastARVPrescribed;

DELIMITER $$
CREATE FUNCTION getLastARVPrescribed(
    p_patientId INT(11)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);

    SELECT d.name INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
    ORDER BY o.scheduled_date DESC
    LIMIT 1;
    
    RETURN result;
END$$
DELIMITER ;

-- patientIsOnARVTreatment

DROP FUNCTION IF EXISTS patientIsOnARVTreatment;

DELIMITER $$
CREATE FUNCTION patientIsOnARVTreatment(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1);

    SELECT calculateTreatmentEndDate(
            o.scheduled_date,
            do.duration,
            c.uuid) >= CURRENT_DATE() INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept c ON c.concept_id = do.duration_units AND c.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
    ORDER BY o.scheduled_date DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientOnTreatmentForOneYear

DROP FUNCTION IF EXISTS patientOnTreatmentForOneYear;

DELIMITER $$
CREATE FUNCTION patientOnTreatmentForOneYear(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE totalDurationInDays INT(11);

    SELECT SUM(calculateDurationInDays(do.duration,c.uuid)) INTO totalDurationInDays
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept c ON c.concept_id = do.duration_units AND c.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id);

    IF totalDurationInDays IS NOT NULL AND (totalDurationInDays >= 365) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END$$
DELIMITER ;
