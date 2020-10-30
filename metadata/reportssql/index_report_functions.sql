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

-- getNumberBiologicalChildrenOfIndex

DROP FUNCTION IF EXISTS getNumberBiologicalChildrenOfIndex;

DELIMITER $$
CREATE FUNCTION getNumberBiologicalChildrenOfIndex(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(r.relationship_id) INTO result
    FROM relationship r
        JOIN relationship_type rt ON r.relationship = rt.relationship_type_id  AND retired = 0
    WHERE r.voided = 0 AND
        getPatientRegistrationDate(r.person_b) BETWEEN p_startDate AND p_endDate AND
        r.person_a = p_patientId AND
        rt.b_is_to_a = "RELATIONSHIP_BIO_CHILD"
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getNumberBiologicalParentsOfIndex

DROP FUNCTION IF EXISTS getNumberBiologicalParentsOfIndex;

DELIMITER $$
CREATE FUNCTION getNumberBiologicalParentsOfIndex(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(r.relationship_id) INTO result
    FROM relationship r
        JOIN relationship_type rt ON r.relationship = rt.relationship_type_id  AND retired = 0
    WHERE r.voided = 0 AND
        getPatientRegistrationDate(r.person_a) BETWEEN p_startDate AND p_endDate AND
        r.person_b = p_patientId AND
        rt.b_is_to_a = "RELATIONSHIP_BIO_CHILD"
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;
DELIMITER ;

-- getNumberSiblingsOfIndex

DROP FUNCTION IF EXISTS getNumberSiblingsOfIndex;

DELIMITER $$
CREATE FUNCTION getNumberSiblingsOfIndex(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(r.relationship_id) INTO result
    FROM relationship r
        JOIN relationship_type rt ON r.relationship = rt.relationship_type_id  AND retired = 0
    WHERE r.voided = 0 AND
        rt.a_is_to_b = "RELATIONSHIP_SIBLING" AND
        (
            (
                getPatientRegistrationDate(r.person_a) BETWEEN p_startDate AND p_endDate AND
                r.person_b = p_patientId
            )
            OR
            (
                getPatientRegistrationDate(r.person_b) BETWEEN p_startDate AND p_endDate AND
                r.person_a = p_patientId
            )
        )
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

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

-- getPatientMostRecentContactTracer

DROP FUNCTION IF EXISTS getPatientMostRecentContactTracer;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentContactTracer(
    p_patientId INT(11)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);
    DECLARE uuidContactTracer VARCHAR(38) DEFAULT "d7246eea-5161-43e0-b840-d315c24cc95e";

    SET result = getPatientMostRecentProgramAttributeValue(p_patientId, uuidContactTracer);

    RETURN (result);
END$$
DELIMITER ;
