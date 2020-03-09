-- getPatientIdentifier

DROP FUNCTION IF EXISTS getPatientIdentifier;

DELIMITER $$
CREATE FUNCTION getPatientIdentifier(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);

    SELECT 
        pi.identifier INTO result 
    FROM patient_identifier pi 
    WHERE pi.voided = 0
        AND pi.patient_id = p_patientId
        AND pi.preferred = true
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getPatientFullName

DROP FUNCTION IF EXISTS getPatientFullName;

DELIMITER $$
CREATE FUNCTION getPatientFullName(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);

    SELECT 
        CONCAT(pn.family_name, ' ', pn.given_name) INTO result 
    FROM person_name pn 
    WHERE pn.voided = 0
        AND pn.person_id = p_patientId
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getPatientAge

DROP FUNCTION IF EXISTS getPatientAge;

DELIMITER $$
CREATE FUNCTION getPatientAge(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);

    SELECT 
        timestampdiff(YEAR, p.birthdate, NOW()) INTO result 
    FROM person p 
    WHERE p.voided = 0
        AND p.person_id = p_patientId
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getPatientBirthdate

DROP FUNCTION IF EXISTS getPatientBirthdate;

DELIMITER $$
CREATE FUNCTION getPatientBirthdate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT 
        p.birthdate INTO result 
    FROM person p 
    WHERE p.voided = 0
        AND p.person_id = p_patientId
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getPatientGender

DROP FUNCTION IF EXISTS getPatientGender;

DELIMITER $$
CREATE FUNCTION getPatientGender(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);

    SELECT 
        p.gender INTO result 
    FROM person p 
    WHERE p.voided = 0
        AND p.person_id = p_patientId
    LIMIT 1;

    RETURN result;
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

-- getPatientAttribueValue

DROP FUNCTION IF EXISTS getPatientAttribueValue;

DELIMITER $$
CREATE FUNCTION getPatientAttribueValue(
    p_patientId INT(11),
    p_attributeName VARCHAR(50)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);

    SELECT 
        pa.value INTO result 
    FROM person_attribute pa
    JOIN person_attribute_type pat ON pa.person_attribute_type_id = pat.person_attribute_type_id
    WHERE pa.voided = 0
        AND pat.name = p_attributeName
        AND pa.person_id = p_patientId
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getPatientPhoneNumber

DROP FUNCTION IF EXISTS getPatientPhoneNumber;

DELIMITER $$
CREATE FUNCTION getPatientPhoneNumber(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    RETURN getPatientAttribueValue(p_patientId, 'PERSON_ATTRIBUTE_TYPE_PHONE_NUMBER');
END$$
DELIMITER ;

-- getPatientEmergencyContact

DROP FUNCTION IF EXISTS getPatientEmergencyContact;

DELIMITER $$
CREATE FUNCTION getPatientEmergencyContact(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    RETURN getPatientAttribueValue(p_patientId, 'emergencyContactNumber');
END$$
DELIMITER ;

-- getPatientPreciseLocation

DROP FUNCTION IF EXISTS getPatientPreciseLocation;

DELIMITER $$
CREATE FUNCTION getPatientPreciseLocation(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);

    SELECT 
        pa.address1 INTO result 
    FROM person_address pa
    WHERE pa.voided = 0
        AND pa.person_id = p_patientId
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getPatientVillage

DROP FUNCTION IF EXISTS getPatientVillage;

DELIMITER $$
CREATE FUNCTION getPatientVillage(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);

    SELECT 
        pa.city_village INTO result 
    FROM person_address pa
    WHERE pa.voided = 0
        AND pa.person_id = p_patientId
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getPatientCanton

DROP FUNCTION IF EXISTS getPatientCanton;

DELIMITER $$
CREATE FUNCTION getPatientCanton(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);

    SELECT 
        pa.address2 INTO result 
    FROM person_address pa
    WHERE pa.voided = 0
        AND pa.person_id = p_patientId
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getPatientSubDivision

DROP FUNCTION IF EXISTS getPatientSubDivision;

DELIMITER $$
CREATE FUNCTION getPatientSubDivision(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);

    SELECT 
        pa.address3 INTO result 
    FROM person_address pa
    WHERE pa.voided = 0
        AND pa.person_id = p_patientId
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getPatientDivision

DROP FUNCTION IF EXISTS getPatientDivision;

DELIMITER $$
CREATE FUNCTION getPatientDivision(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);

    SELECT 
        pa.county_district INTO result 
    FROM person_address pa
    WHERE pa.voided = 0
        AND pa.person_id = p_patientId
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getPatientRegion

DROP FUNCTION IF EXISTS getPatientRegion;

DELIMITER $$
CREATE FUNCTION getPatientRegion(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);

    SELECT 
        pa.state_province INTO result 
    FROM person_address pa
    WHERE pa.voided = 0
        AND pa.person_id = p_patientId
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getPatientCodeAttributeValue
DROP FUNCTION IF EXISTS getPatientCodeAttributeValue;

DELIMITER $$
CREATE FUNCTION getPatientCodeAttributeValue(
    p_patientId INT(11),
    p_attributeName VARCHAR(50)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);

    SELECT 
        cn.name INTO result 
    FROM person_attribute pa
    JOIN person_attribute_type pat ON pa.person_attribute_type_id = pat.person_attribute_type_id
    JOIN concept_name cn ON cn.concept_id = pa.value
    WHERE pa.voided = 0
        AND pat.name = p_attributeName
        AND pa.person_id = p_patientId
        AND cn.locale = 'fr'
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getPatientEducation
DROP FUNCTION IF EXISTS getPatientEducation;

DELIMITER $$
CREATE FUNCTION getPatientEducation(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    RETURN getPatientCodeAttributeValue(p_patientId, 'education');
END$$
DELIMITER ;

-- getPatientOccupation
DROP FUNCTION IF EXISTS getPatientOccupation;

DELIMITER $$
CREATE FUNCTION getPatientOccupation(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    RETURN getPatientCodeAttributeValue(p_patientId, 'occupation');
END$$
DELIMITER ;

-- getPatientMatrimonialStatus
DROP FUNCTION IF EXISTS getPatientMatrimonialStatus;

DELIMITER $$
CREATE FUNCTION getPatientMatrimonialStatus(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    RETURN getPatientCodeAttributeValue(p_patientId, 'matrimonialStatus');
END$$
DELIMITER ;

-- getPatientIdentifierValue
DROP FUNCTION IF EXISTS getPatientIdentifierValue;

DELIMITER $$
CREATE FUNCTION getPatientIdentifierValue(
    p_patientId INT(11),
    p_identifierType VARCHAR(50)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);

    SELECT
        pi.identifier INTO result
    FROM patient_identifier pi
    JOIN patient_identifier_type pit ON pit.patient_identifier_type_id = pi.identifier_type
    WHERE pi.voided = 0
        AND pi.patient_id = p_patientId
        AND pit.name = p_identifierType
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getPatientANCNumber
DROP FUNCTION IF EXISTS getPatientANCNumber;

DELIMITER $$
CREATE FUNCTION getPatientANCNumber(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    RETURN getPatientIdentifierValue(p_patientId, 'REGISTRATION_IDTYPE_4_ANC_KEY');
END$$
DELIMITER ;

-- getPatientARTNumber
DROP FUNCTION IF EXISTS getPatientARTNumber;

DELIMITER $$
CREATE FUNCTION getPatientARTNumber(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE artNumber VARCHAR(50);
    SET artNumber = getPatientIdentifierValue(p_patientId, 'REGISTRATION_IDTYPE_3_ART_KEY');
    IF (artNumber IS NOT NULL) THEN
        return artNumber;
    ELSE
        return getPatientProgramARTNumber(p_patientId);
    END IF;
END$$
DELIMITER ;

-- getPatientCNINumber
DROP FUNCTION IF EXISTS getPatientCNINumber;

DELIMITER $$
CREATE FUNCTION getPatientCNINumber(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    RETURN getPatientIdentifierValue(p_patientId, 'REGISTRATION_IDTYPE_1_CNI_KEY');
END$$
DELIMITER ;

-- getPatientARVStartDate

DROP FUNCTION IF EXISTS getPatientARVStartDate;

DELIMITER $$
CREATE FUNCTION getPatientARVStartDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;
    DECLARE uuidARVStartDate VARCHAR(38) DEFAULT "e3f9c7ee-aa3e-4224-9d18-42e09b095ac6";

    SELECT
        o.value_datetime INTO result
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidARVStartDate
    ORDER BY o.obs_id DESC
    LIMIT 1;

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

    SELECT GROUP_CONCAT(d.name) INTO result
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
