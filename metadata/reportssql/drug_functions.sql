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
