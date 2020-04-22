DROP FUNCTION IF EXISTS Index_Indicator1a;

DELIMITER $$
CREATE FUNCTION Index_Indicator1a(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    DECLARE uuidIndexTestingDateOffered VARCHAR(38) DEFAULT "836fe9d4-96f1-4fea-9ad8-35bd06e0ee05";

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeAtReportEndDateIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge, p_endDate) AND
    getPatientIndexTestingDateOffered(pat.patient_id) IS NOT NULL AND
    getObsLocation(pat.patient_id, uuidIndexTestingDateOffered) NOT IN ("LOCATION_COMMUNITY_HOME", "LOCATION_COMMUNITY_MOBILE");

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Index_Indicator1b;

DELIMITER $$
CREATE FUNCTION Index_Indicator1b(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    DECLARE uuidIndexTestingDateOffered VARCHAR(38) DEFAULT "836fe9d4-96f1-4fea-9ad8-35bd06e0ee05";

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeAtReportEndDateIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge, p_endDate) AND
    getPatientIndexTestingDateOffered(pat.patient_id) IS NOT NULL AND
    getObsLocation(pat.patient_id, uuidIndexTestingDateOffered) IN ("LOCATION_COMMUNITY_HOME", "LOCATION_COMMUNITY_MOBILE");

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

DROP FUNCTION IF EXISTS Index_Indicator1c;

DELIMITER $$
CREATE FUNCTION Index_Indicator1c(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeAtReportEndDateIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge, p_endDate) AND
    getPatientRegistrationDate(pat.patient_id) BETWEEN p_startDate AND p_endDate AND
    patientWithIndexPartner(pat.patient_id);

    RETURN (result);
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS Index_Indicator1d;

-- Number of biological parents for index patient

DELIMITER $$
CREATE FUNCTION Index_Indicator1d(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeAtReportEndDateIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge, p_endDate) AND
    getPatientRegistrationDate(pat.patient_id) BETWEEN p_startDate AND p_endDate AND
    patientWithIndexChild(pat.patient_id);

    RETURN (result);
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS Index_Indicator1e;

-- Number of children for index patient

DELIMITER $$
CREATE FUNCTION Index_Indicator1e(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeAtReportEndDateIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge, p_endDate) AND
    getPatientRegistrationDate(pat.patient_id) BETWEEN p_startDate AND p_endDate AND
    patientWithIndexParent(pat.patient_id);

    RETURN (result);
END$$
DELIMITER ;

-- getPatientIndexTestingDateOffered

DROP FUNCTION IF EXISTS getPatientIndexTestingDateOffered;

DELIMITER $$
CREATE FUNCTION getPatientIndexTestingDateOffered(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE uuidIndexTestingDateOffered VARCHAR(38) DEFAULT "836fe9d4-96f1-4fea-9ad8-35bd06e0ee05";
    RETURN getObsDatetimeValue(p_patientId, uuidIndexTestingDateOffered);
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

-- getPatientIndexTestingDateAccepted

DROP FUNCTION IF EXISTS getPatientIndexTestingDateAccepted;

DELIMITER $$
CREATE FUNCTION getPatientIndexTestingDateAccepted(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE uuidIndexTestingDateAccepted VARCHAR(38) DEFAULT "e7a002be-8afc-48b1-a81b-634e37f2961c";
    RETURN getObsDatetimeValue(p_patientId, uuidIndexTestingDateAccepted);
END$$
DELIMITER ;

-- patientWithIndexPartner

DROP FUNCTION IF EXISTS patientWithIndexPartner;

DELIMITER $$
CREATE FUNCTION patientWithIndexPartner(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM relationship r
        JOIN person pIndex ON (r.person_a = p_patientId AND r.person_b = pIndex.person_id) OR
            (r.person_a = pIndex.person_id AND r.person_b = p_patientId)
        JOIN relationship_type rt ON r.relationship = rt.relationship_type_id  AND retired = 0
    WHERE r.voided = 0 AND
        getPatientIndexTestingDateAccepted(pIndex.person_id) IS NOT NULL AND
        rt.a_is_to_b = "RELATIONSHIP_PARTNER"
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- patientWithIndexChild

DROP FUNCTION IF EXISTS patientWithIndexChild;

DELIMITER $$
CREATE FUNCTION patientWithIndexChild(
    p_parent INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM relationship r
        JOIN person pIndexChild ON r.person_a = pIndexChild.person_id AND r.person_b = p_parent
        JOIN relationship_type rt ON r.relationship = rt.relationship_type_id  AND retired = 0
    WHERE r.voided = 0 AND
        getPatientIndexTestingDateAccepted(pIndexChild.person_id) IS NOT NULL AND
        (rt.b_is_to_a = "RELATIONSHIP_BIO_CHILD")
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- patientWithIndexParent

DROP FUNCTION IF EXISTS patientWithIndexParent;

DELIMITER $$
CREATE FUNCTION patientWithIndexParent(
    p_child INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM relationship r
        JOIN person pIndexParent ON r.person_b = pIndexParent.person_id AND r.person_a = p_child
        JOIN relationship_type rt ON r.relationship = rt.relationship_type_id  AND retired = 0
    WHERE r.voided = 0 AND
        getPatientIndexTestingDateAccepted(pIndexParent.person_id) IS NOT NULL AND
        (rt.b_is_to_a = "RELATIONSHIP_BIO_CHILD")
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;
