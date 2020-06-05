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

-- patientGenderIs

DROP FUNCTION IF EXISTS patientGenderIs;

DELIMITER $$
CREATE FUNCTION patientGenderIs(
    p_patientId INT(11),
    p_gender VARCHAR(1)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT p.gender = p_gender INTO result
    FROM person p
    WHERE p.person_id = p_patientId AND p.voided = 0;

    RETURN (result );
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

-- getPatientGenderFullname

DROP FUNCTION IF EXISTS getPatientGenderFullname;

DELIMITER $$
CREATE FUNCTION getPatientGenderFullname(
    p_patientId INT(11)) RETURNS VARCHAR(6)
    DETERMINISTIC
BEGIN
    DECLARE gender VARCHAR(50) DEFAULT getPatientGender(p_patientId);
    RETURN IF(gender = "m", "male", "female");
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

-- patientAgeIsBetween

DROP FUNCTION IF EXISTS patientAgeIsBetween;  

DELIMITER $$ 
CREATE FUNCTION patientAgeIsBetween(
    p_patientId INT(11),
    p_startAge INT(11),
    p_endAge INT(11),
    p_includeEndAge TINYINT(1)) RETURNS TINYINT(1) 
    DETERMINISTIC 
BEGIN 
    DECLARE result TINYINT(1) DEFAULT 0; 
    SELECT  
        IF (p_includeEndAge, 
            timestampdiff(YEAR, p.birthdate, CURDATE()) BETWEEN p_startAge AND p_endAge, 
            timestampdiff(YEAR, p.birthdate, CURDATE()) >= p_startAge
                AND timestampdiff(YEAR, p.birthdate, CURDATE()) < p_endAge
        ) INTO result
        FROM person p 
        WHERE p.person_id = p_patientId AND p.voided = 0;

    RETURN (result ); 
END$$ 
DELIMITER ;

-- patientAgeAtReportEndDateIsBetween

DROP FUNCTION IF EXISTS patientAgeAtReportEndDateIsBetween;

DELIMITER $$
CREATE FUNCTION patientAgeAtReportEndDateIsBetween(
    p_patientId INT(11),
    p_startAge INT(11),
    p_endAge INT(11),
    p_includeEndAge TINYINT(1),
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1);

    SELECT 
        IF (p_includeEndAge, 
            timestampdiff(YEAR, p.birthdate, p_endDate) BETWEEN p_startAge AND p_endAge, 
            timestampdiff(YEAR, p.birthdate, p_endDate) >= p_startAge
                AND timestampdiff(YEAR, p.birthdate, p_endDate) < p_endAge
        ) INTO result  
    FROM person p 
    WHERE p.voided = 0
        AND p.person_id = p_patientId
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getPatientRegistrationDate

DROP FUNCTION IF EXISTS getPatientRegistrationDate;

DELIMITER $$
CREATE FUNCTION getPatientRegistrationDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE registrationDate DATE;

    SELECT
        date_created INTO registrationDate
    FROM patient
    WHERE voided = 0
        AND patient_id = p_patientId;

    RETURN registrationDate;
END$$
DELIMITER ;

-- patientHasRegisteredWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHasRegisteredWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasRegisteredWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT
        TRUE INTO result
    FROM patient p
    WHERE p.patient_id = p_patientId
        AND p.voided = 0
        AND CAST(p.date_created AS DATE) BETWEEN p_startDate AND p_endDate;

    RETURN (result );
END$$
DELIMITER ;

-- patientIsAdult

DROP FUNCTION IF EXISTS patientIsAdult;

DELIMITER $$
CREATE FUNCTION patientIsAdult(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM person p
    WHERE p.person_id = p_patientId
    AND  timestampdiff(YEAR, p.birthdate, CURDATE()) >= 15
    AND p.voided = 0;

    RETURN result;
END$$
DELIMITER ;

-- getPatientAgeInMonthsAtDate

DROP FUNCTION IF EXISTS getPatientAgeInMonthsAtDate;

DELIMITER $$
CREATE FUNCTION getPatientAgeInMonthsAtDate(
    p_patientId INT(11),
    p_date DATE) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);

    SELECT 
        timestampdiff(MONTH, p.birthdate, p_date) INTO result 
    FROM person p 
    WHERE p.voided = 0
        AND p.person_id = p_patientId
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getPatientAgeAtFirstVisitInMonths

DROP FUNCTION IF EXISTS getPatientAgeAtFirstVisitInMonths;

DELIMITER $$
CREATE FUNCTION getPatientAgeAtFirstVisitInMonths(
    p_patientId INT(11)) RETURNS INT(11)
    DETERMINISTIC
BEGIN

    DECLARE result INT(11);
    DECLARE dateOfFirstVisit DATE;

    SELECT v.date_started INTO dateOfFirstVisit
    FROM visit v
    WHERE v.voided = 0 AND v.patient_id = p_patientId
    ORDER BY v.date_started ASC
    LIMIT 1;

    IF dateOfFirstVisit IS NOT NULL THEN
        RETURN getPatientAgeInMonthsAtDate(p_patientId, dateOfFirstVisit);
    ELSE
        RETURN NULL;
    END IF;
    
END$$ 

DELIMITER ;
