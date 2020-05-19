
-- getFacilityName

DROP FUNCTION IF EXISTS getFacilityName;

DELIMITER $$
CREATE FUNCTION getFacilityName() RETURNS VARCHAR(38)
    DETERMINISTIC
BEGIN
    RETURN (SELECT address1 from location where name = "LOCATION_HOSPITAL");
END$$
DELIMITER ;

-- getServicesUsedDuringVisit

DROP FUNCTION IF EXISTS getServicesUsedDuringVisit;

DELIMITER $$
CREATE FUNCTION getServicesUsedDuringVisit(
    p_visit_id INT(11)) RETURNS TEXT
    DETERMINISTIC
BEGIN
    DECLARE result TEXT;

    SELECT REPLACE(GROUP_CONCAT(DISTINCT loc.name), 'LOCATION_', '' ) INTO result
    FROM encounter e
    JOIN location loc ON e.location_id = loc.location_id
    WHERE e.voided = 0 AND
    e.visit_id = p_visit_id;

    RETURN result;
END$$
DELIMITER ;

-- getViralLoadTestDate

DROP FUNCTION IF EXISTS getViralLoadTestDate;

DELIMITER $$
CREATE FUNCTION getViralLoadTestDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE testDate DATE;
    DECLARE testResult INT(11);

    CALL retrieveViralLoadTestDateAndResult(p_patientId, testDate, testResult);

    RETURN testDate;
END$$
DELIMITER ;

-- getViralLoadTestResult

DROP FUNCTION IF EXISTS getViralLoadTestResult;

DELIMITER $$
CREATE FUNCTION getViralLoadTestResult(
    p_patientId INT(11)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE testDate DATE;
    DECLARE testResult INT(11);

    CALL retrieveViralLoadTestDateAndResult(p_patientId, testDate, testResult);

    RETURN testResult;
END$$
DELIMITER ;

-- treatmentIsWithinReportingPeriod

DROP FUNCTION IF EXISTS treatmentIsWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION treatmentIsWithinReportingPeriod(
    p_startDate DATE,
    p_endDate DATE,
    p_treatmentStartDate DATE,
    p_treatmentEndDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    IF (
        p_treatmentStartDate BETWEEN p_startDate AND p_endDate
        OR p_treatmentEndDate BETWEEN p_startDate AND p_endDate
        OR (p_treatmentStartDate <= p_startDate AND p_treatmentEndDate >= p_endDate)
    ) THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;

END$$
DELIMITER ;

-- getListOfActiveARVDrugs

DROP FUNCTION IF EXISTS getListOfActiveARVDrugs;

DELIMITER $$
CREATE FUNCTION getListOfActiveARVDrugs(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TEXT
    DETERMINISTIC
BEGIN
    DECLARE result TEXT;

    SELECT GROUP_CONCAT(DISTINCT d.name) INTO result
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
        AND drugOrderIsDispensed(p_patientId, o.order_id);

    RETURN result;
END$$
DELIMITER ;
