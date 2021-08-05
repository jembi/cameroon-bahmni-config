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
        AND c.uuid = uuidDispensedConcept
    LIMIT 1;

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
            c.uuid)
    LIMIT 1;

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

    SELECT DATE(o.scheduled_date) INTO result
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

-- getMostRecentArvPickupDateBeforeReportEndDate

DROP FUNCTION IF EXISTS getMostRecentArvPickupDateBeforeReportEndDate;

DELIMITER $$
CREATE FUNCTION getMostRecentArvPickupDateBeforeReportEndDate(
    p_patientId INT(11),
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT DATE(o.scheduled_date) INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND o.scheduled_date <= p_endDate
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

    SELECT calculateDurationInDays(o.scheduled_date, do.duration,c.uuid) INTO result
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

-- getDurationMostRecentArvTreatmentInMonths

DROP FUNCTION IF EXISTS getDurationMostRecentArvTreatmentInMonths;

DELIMITER $$
CREATE FUNCTION getDurationMostRecentArvTreatmentInMonths(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11);

    SELECT calculateDurationInMonths(o.scheduled_date, do.duration,c.uuid) INTO result
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

-- getDurationMostRecentArvTreatmentInDays

DROP FUNCTION IF EXISTS getDurationMostRecentArvTreatmentInDays;

DELIMITER $$
CREATE FUNCTION getDurationMostRecentArvTreatmentInDays(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11);

    SELECT calculateDurationInDays(o.scheduled_date, do.duration,c.uuid) INTO result
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

-- getUnderAMonthDurationMostRecentArvTreatmentInDays

DROP FUNCTION IF EXISTS getUnderAMonthDurationMostRecentArvTreatmentInDays;

DELIMITER $$
CREATE FUNCTION getUnderAMonthDurationMostRecentArvTreatmentInDays(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11);
    DECLARE uuidDay VARCHAR(38) DEFAULT '9d7437a9-3f10-11e4-adec-0800271c1b75';

    SELECT calculateDurationInDays(o.scheduled_date, do.duration,c.uuid) INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept c ON c.concept_id = do.duration_units AND c.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugIsARV(d.concept_id)
        AND drugOrderIsDispensed(p_patientId, o.order_id)
        AND calculateDurationInMonths(o.scheduled_date, do.duration,c.uuid) = 0
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
    p_startDate DATE,
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
        RETURN timestampdiff(DAY, p_startDate, timestampadd(MONTH, p_duration, p_startDate));
    END IF;

    RETURN (result); 
END$$ 
DELIMITER ;

-- calculateDurationInMonths

DROP FUNCTION IF EXISTS calculateDurationInMonths;

DELIMITER $$
CREATE FUNCTION calculateDurationInMonths(
    p_startDate DATE,
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
        RETURN timestampdiff(MONTH, p_startDate, timestampadd(MINUTE, p_duration, p_startDate));
    ELSEIF p_uuidDurationUnit = uuidHour THEN
        RETURN timestampdiff(MONTH, p_startDate, timestampadd(HOUR, p_duration, p_startDate));
    ELSEIF p_uuidDurationUnit = uuidDay THEN
        RETURN timestampdiff(MONTH, p_startDate, timestampadd(DAY, p_duration, p_startDate));
    ELSEIF p_uuidDurationUnit = uuidWeek THEN
        RETURN timestampdiff(MONTH, p_startDate, timestampadd(WEEK, p_duration, p_startDate));
    ELSEIF p_uuidDurationUnit = uuidMonth THEN
        RETURN p_duration;
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

-- retrieveINHStartAndEndDate

DROP PROCEDURE IF EXISTS retrieveINHStartAndEndDate;

DELIMITER $$
CREATE PROCEDURE retrieveINHStartAndEndDate(
    IN p_index INT(11),
    IN p_patientId INT(11),
    IN p_endDate DATE,
    OUT p_inhStartDate DATE,
    OUT p_inhEndDate DATE)
BEGIN

    SELECT
        DATE(o.scheduled_date),
        DATE(calculateTreatmentEndDate(
            o.scheduled_date,
            do.duration,
            c.uuid
        )) INTO p_inhStartDate, p_inhEndDate
    FROM drug_order do
        JOIN orders o ON o.order_id = do.order_id  AND o.voided = 0
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept c ON c.concept_id = do.duration_units AND c.retired = 0
    WHERE o.patient_id = p_patientId
        AND calculateTreatmentEndDate(
            o.scheduled_date,
            do.duration,
            c.uuid) <= p_endDate
        AND d.name LIKE "INH%"
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    ORDER BY o.scheduled_date DESC
    LIMIT p_index, 1;

END$$
DELIMITER ;

-- selectINHFollowUpReport

DROP PROCEDURE IF EXISTS selectINHFollowUpReport;

DELIMITER $$
CREATE PROCEDURE selectINHFollowUpReport(
    IN p_startDate DATE,
    IN p_endDate DATE)
BEGIN

    DECLARE bDone INT;
    DECLARE bDone2 INT;
    DECLARE patientId INT(11);
    DECLARE serialNumber INT(11) DEFAULT 0;
    DECLARE uniquePatientId VARCHAR(50);
    DECLARE artCode VARCHAR(50);
    DECLARE age INT(11);
    DECLARE dateOfBirth DATE;
    DECLARE sex VARCHAR(1);
    DECLARE dateOfARTInitiation DATE;
    DECLARE inhStartDate DATE;
    DECLARE inhEndDate DATE;
    DECLARE inhFullCourseStartDate DATE;
    DECLARE inhFullCourseEndDate DATE;
    DECLARE courseDuration INT(11);
    DECLARE _index INT(11);


    DECLARE mainQueryCursor CURSOR FOR
    SELECT
        p.patient_id,
        getPatientIdentifier(p.patient_id) as "Unique Patient ID",
        getPatientARTNumber(p.patient_id) as "ART Code",
        getPatientAge(p.patient_id) as "Age",
        getPatientBirthdate(p.patient_id) as "Date of Birth",
        getPatientGender(p.patient_id) as "Sex",
        DATE(getProgramAttributeValueWithinReportingPeriod(p.patient_id, "2000-01-01", "2100-01-01", "2dc1aafd-a708-11e6-91e9-0800270d80ce", "HIV_PROGRAM_KEY")) as "Date of ART Initiation"
    FROM patient p;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

    DROP TEMPORARY TABLE IF EXISTS tblResults;
    CREATE TEMPORARY TABLE IF NOT EXISTS tblResults  (
        serialNumber INT(11),
        uniquePatientId VARCHAR(50),
        artCode VARCHAR(50),
        age INT(11),
        dateOfBirth DATE,
        sex VARCHAR(1),
        dateOfARTInitiation DATE,
        inhStartDate DATE,
        inhEndDate DATE
    );

    OPEN mainQueryCursor;

    SET bDone = 0;
    REPEAT
        FETCH mainQueryCursor INTO patientId,uniquePatientId,artCode,age,dateOfBirth,sex,dateOfARTInitiation;

        SET courseDuration = 0;
        SET _index = 0;

        REPEAT
            CALL retrieveINHStartAndEndDate(_index, patientId, p_endDate, inhStartDate, inhEndDate);

            IF inhStartDate IS NOT NULL AND inhEndDate IS NOT NULL THEN
                IF (courseDuration = 0) THEN
                    SET inhFullCourseEndDate = inhEndDate;
                END IF;

                SET courseDuration = courseDuration + timestampdiff(MONTH, inhStartDate, timestampadd(DAY, 1,inhEndDate));
                
                IF (courseDuration >= 6) THEN
                    SET inhFullCourseStartDate = inhStartDate;
                    SET serialNumber = serialNumber + 1;
                    INSERT INTO tblResults VALUES (serialNumber, uniquePatientId, artCode, age, dateOfBirth, sex, dateOfARTInitiation, inhFullCourseStartDate, inhFullCourseEndDate);
                    SET courseDuration = 0;
                END IF; 
                
            END IF;

            SET _index = _index + 1;
        UNTIL inhStartDate IS NULL END REPEAT;

    UNTIL bDone END REPEAT;
    CLOSE mainQueryCursor;

    SELECT DISTINCT * FROM tblResults;
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

-- getLastARVDispensed

DROP FUNCTION IF EXISTS getLastARVDispensed;

DELIMITER $$
CREATE FUNCTION getLastARVDispensed(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS VARCHAR(250)
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
        AND drugOrderIsDispensed(o.patient_id, o.order_id)
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
    ORDER BY o.scheduled_date DESC
    LIMIT 1;
    
    RETURN result;
END$$
DELIMITER ;

-- getFirstARVPrescribed

DROP FUNCTION IF EXISTS getFirstARVPrescribed;

DELIMITER $$
CREATE FUNCTION getFirstARVPrescribed(
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
        AND drugOrderIsDispensed(o.patient_id, o.order_id)
    ORDER BY o.scheduled_date ASC
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

-- getActiveARVWithLowestDispensationPeriod

DROP FUNCTION IF EXISTS getActiveARVWithLowestDispensationPeriod;

DELIMITER $$
CREATE FUNCTION getActiveARVWithLowestDispensationPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TEXT
    DETERMINISTIC
BEGIN
    DECLARE result TEXT;
    
    SELECT d.name INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
        AND treatmentIsWithinReportingPeriod(
            p_startDate,
            p_endDate,
            o.scheduled_date,
            calculateTreatmentEndDate(
                o.scheduled_date,
                do.duration,
                c.uuid)
            )
    ORDER BY calculateDurationInDays(o.scheduled_date,do.duration,c.uuid) ASC,
        o.scheduled_date DESC
    LIMIT 1;
    RETURN result;
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

    SELECT SUM(calculateDurationInDays(o.scheduled_date,do.duration,c.uuid)) INTO totalDurationInDays
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

-- retrieveRegimenSwitchARVandDate

DROP PROCEDURE IF EXISTS retrieveRegimenSwitchARVandDate;

DELIMITER $$
CREATE PROCEDURE retrieveRegimenSwitchARVandDate(
    IN p_patientId INT(11),
    IN p_startDate DATE,
    IN p_endDate DATE,
    OUT p_regimen VARCHAR(250),
    OUT p_previousRegimen VARCHAR(250),
    OUT p_switchDate DATE
    )
    DETERMINISTIC
    proc_retrieve_regimen_switch_and_date:BEGIN

    DECLARE currentRegimen VARCHAR(250);
    DECLARE previousRegimen VARCHAR(250);
    DECLARE switchDate DATE;

    SELECT d.name, MIN(o.date_created) INTO currentRegimen, switchDate
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND DATE(o.date_created) BETWEEN p_startDate AND p_endDate
        AND drugIsARV(d.concept_id)
        AND drugOrderIsDispensed(o.patient_id, o.order_id)
    GROUP BY d.name
    ORDER BY o.date_created DESC
    LIMIT 1;

    IF (currentRegimen IS NULL) THEN
        LEAVE proc_retrieve_regimen_switch_and_date;
    END IF;

    SELECT d.name INTO previousRegimen
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND DATE(o.date_created) BETWEEN p_startDate AND p_endDate
        AND drugIsARV(d.concept_id)
        AND drugOrderIsDispensed(o.patient_id, o.order_id)
        AND d.name <> currentRegimen
    ORDER BY o.date_created DESC
    LIMIT 1;

    IF (previousRegimen IS NULL) THEN
        LEAVE proc_retrieve_regimen_switch_and_date;
    END IF;

    SET p_regimen = currentRegimen;
    SET p_switchDate = switchDate;
    SET p_previousRegimen = previousRegimen;

END$$ 
DELIMITER ;

-- getRegimenSwitch

DROP FUNCTION IF EXISTS getRegimenSwitch;

DELIMITER $$
CREATE FUNCTION getRegimenSwitch(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN

    DECLARE regimen VARCHAR(250);
    DECLARE previousRegimen VARCHAR(250);
    DECLARE switchDate DATE;

    CALL retrieveRegimenSwitchARVandDate(p_patientId, p_startDate, p_endDate, regimen, previousRegimen, switchDate);

    RETURN regimen;

END$$
DELIMITER ;

-- getPreviousRegimen

DROP FUNCTION IF EXISTS getPreviousRegimen;

DELIMITER $$
CREATE FUNCTION getPreviousRegimen(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN

    DECLARE regimen VARCHAR(250);
    DECLARE previousRegimen VARCHAR(250);
    DECLARE switchDate DATE;

    CALL retrieveRegimenSwitchARVandDate(p_patientId, p_startDate, p_endDate, regimen, previousRegimen, switchDate);

    RETURN previousRegimen;

END$$
DELIMITER ;

-- getRegimenSwitchDate

DROP FUNCTION IF EXISTS getRegimenSwitchDate;

DELIMITER $$
CREATE FUNCTION getRegimenSwitchDate(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN

    DECLARE regimen VARCHAR(250);
    DECLARE previousRegimen VARCHAR(250);
    DECLARE switchDate DATE;

    CALL retrieveRegimenSwitchARVandDate(p_patientId, p_startDate, p_endDate, regimen, previousRegimen, switchDate);

    RETURN switchDate;

END$$
DELIMITER ;

-- getNewARVRegimenAfterDate

DROP FUNCTION IF EXISTS getNewARVRegimenAfterDate;

DELIMITER $$
CREATE FUNCTION getNewARVRegimenAfterDate(
    p_patientId INT(11),
    p_date DATE) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE regimen VARCHAR(250);
    DECLARE previousRegimen VARCHAR(250);
    DECLARE switchDate DATE;
    CALL retrieveRegimenSwitchARVandDate(p_patientId, p_date, '2050-01-01', regimen, previousRegimen, switchDate);

    RETURN regimen;
END$$
DELIMITER ;

-- getDateNewARVRegimenAfterDate

DROP FUNCTION IF EXISTS getDateNewARVRegimenAfterDate;

DELIMITER $$
CREATE FUNCTION getDateNewARVRegimenAfterDate(
    p_patientId INT(11),
    p_date DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE regimen VARCHAR(250);
    DECLARE previousRegimen VARCHAR(250);
    DECLARE switchDate DATE;
    CALL retrieveRegimenSwitchARVandDate(p_patientId, p_date, '2050-01-01', regimen, previousRegimen, switchDate);

    RETURN switchDate;
END$$
DELIMITER ;

-- getDateNextVLExam

DROP FUNCTION IF EXISTS getDateNextVLExam;

DELIMITER $$
CREATE FUNCTION getDateNextVLExam(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;
    DECLARE testDate DATE;
    DECLARE testResult INT(11);
    DECLARE arvStartDate DATE;
    DECLARE eacDate DATE;
    DECLARE viralLoadIndication VARCHAR(50);

    CALL retrieveViralLoadTestDateAndResult(p_patientId, testDate, testResult, viralLoadIndication);
    SET arvStartDate = getPatientARVStartDate(p_patientId);
    SET eacDate = getPatientMostRecentProgramAttributeValueFromName(p_patientId, 'PROGRAM_MANAGEMENT_1_EAC_DATE');

    IF (testResult IS NOT NULL AND testDate IS NOT NULL AND testResult <= 1000) THEN
        SET result = timestampadd(MONTH, 12, testDate);
    ELSEIF (testResult IS NOT NULL AND eacDate IS NOT NULL AND testResult > 1000) THEN
        SET result = timestampadd(MONTH, 3, eacDate);
    ELSEIF (
        (arvStartDate IS NOT NULL AND testResult IS NOT NULL AND testResult <= 1000) OR 
        (arvStartDate IS NOT NULL AND testResult IS NULL)) THEN
        SET result = timestampadd(MONTH, 6, arvStartDate);
    END IF;

    RETURN result;
END$$
DELIMITER ;

-- getDatesCompletionTPTCourses

DROP FUNCTION IF EXISTS getDatesCompletionTPTCourses;

DELIMITER $$
CREATE FUNCTION getDatesCompletionTPTCourses(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TEXT
    DETERMINISTIC
BEGIN
    DECLARE inhDates TEXT;
    DECLARE threeHpDates TEXT;
    DECLARE oneHpDates TEXT;
    DECLARE result TEXT DEFAULT NULL;
    
    SELECT GROUP_CONCAT(
            CONCAT(' ', DATE_FORMAT(o.scheduled_date, "%d-%b-%Y"),
            ' to ',
            DATE_FORMAT(calculateTreatmentEndDate(
                o.scheduled_date,
                do.duration,
                c.uuid), "%d-%b-%Y"), ' ')) INTO inhDates
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept c ON c.concept_id = do.duration_units AND c.retired = 0
    WHERE o.voided = 0
        AND o.patient_id = p_patientId
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND d.name IN ('INH 100mg','INH 300mg')
    GROUP BY o.patient_id
    HAVING SUM(calculateDurationInDays(o.scheduled_date,do.duration,c.uuid)) >= 180;
    
    SELECT GROUP_CONCAT(
            CONCAT(' ', DATE_FORMAT(o.scheduled_date, "%d-%b-%Y"),
            ' to ',
            DATE_FORMAT(calculateTreatmentEndDate(
                o.scheduled_date,
                do.duration,
                c.uuid), "%d-%b-%Y"), ' ')) INTO threeHpDates
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept c ON c.concept_id = do.duration_units AND c.retired = 0
    WHERE o.voided = 0
        AND o.patient_id = p_patientId
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND d.name IN ('Rifampicine + Isoniazide 60mg+30mg','Rifampicine + Isoniazide 150mg+75mg','Rifampicine + Isoniazide 300mg+150mg')
    GROUP BY o.patient_id
    HAVING SUM(calculateDurationInDays(o.scheduled_date,do.duration,c.uuid)) >= 120;
    
    SELECT GROUP_CONCAT(
            CONCAT(' ', DATE_FORMAT(o.scheduled_date, "%d-%b-%Y"),
            ' to ',
            DATE_FORMAT(calculateTreatmentEndDate(
                o.scheduled_date,
                do.duration,
                c.uuid), "%d-%b-%Y"), ' ')) INTO oneHpDates
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept c ON c.concept_id = do.duration_units AND c.retired = 0
    WHERE o.voided = 0
        AND o.patient_id = p_patientId
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND d.name = 'Rifampicine + Isoniazide 60mg+30mg'
    GROUP BY o.patient_id
    HAVING SUM(calculateDurationInDays(o.scheduled_date,do.duration,c.uuid)) >= 90;

    IF (inhDates IS NOT NULL) THEN
        SET result = inhDates;
    END IF;

    IF (threeHpDates IS NOT NULL) THEN
        IF (result IS NULL) THEN
            SET result = threeHpDates;
        ELSE
            SET result = CONCAT(result,',',threeHpDates);
        END IF;
    END IF;

    IF (oneHpDates IS NOT NULL) THEN
        IF (result IS NULL) THEN
            SET result = oneHpDates;
        ELSE
            SET result = CONCAT(result,',',oneHpDates);
        END IF;
    END IF;

    RETURN result;
    
END$$
DELIMITER ;


-- patientHasBeenPrescribedDrug

DROP FUNCTION IF EXISTS patientHasBeenPrescribedDrug;

DELIMITER $$
CREATE FUNCTION patientHasBeenPrescribedDrug(
    p_patientId INT(11),
    p_drugName VARCHAR(250),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.voided = 0
        AND o.patient_id = p_patientId
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND d.name LIKE CONCAT("%",p_drugName,"%")
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;
