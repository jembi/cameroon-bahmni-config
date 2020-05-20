
-- patientIsIndex

DROP FUNCTION IF EXISTS patientIsIndex;

DELIMITER $$
CREATE FUNCTION patientIsIndex(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE hivIndexAcceptedConceptUuid VARCHAR(38) DEFAULT "78d13812-cd29-4214-9a58-a8710fd69cff";

    SELECT TRUE INTO result
    FROM obs
    WHERE person_id = p_patientId AND obs.voided = 0 AND
        obs.concept_id = (select concept_id from concept where uuid = hivIndexAcceptedConceptUuid) AND
        obs.value_coded=1 -- concept "Yes"
    GROUP BY person_id;

    RETURN (result);
END$$
DELIMITER ;

-- getNumberOfContactsRelatedToIndex

DROP FUNCTION IF EXISTS getNumberOfContactsRelatedToIndex;

DELIMITER $$
CREATE FUNCTION getNumberOfContactsRelatedToIndex(
    p_patientId INT(11)) RETURNS INT(1)
    DETERMINISTIC
BEGIN
    DECLARE result INT(1) DEFAULT 0;

    SELECT count(DISTINCT pat.patient_id) INTO result
    FROM patient pat
    WHERE pat.voided = 0 AND
        patientsAreRelated(p_patientId, pat.patient_id) AND
        patientIsNotDead(pat.patient_id);

    RETURN (result);
END$$
DELIMITER ;

-- getNumberOfEnrolledContactsRelatedToIndex

DROP FUNCTION IF EXISTS getNumberOfEnrolledContactsRelatedToIndex;

DELIMITER $$
CREATE FUNCTION getNumberOfEnrolledContactsRelatedToIndex(
    p_patientId INT(11)) RETURNS INT(1)
    DETERMINISTIC
BEGIN
    DECLARE result INT(1) DEFAULT 0;

    SELECT count(DISTINCT pat.patient_id) INTO result
    FROM patient pat
    WHERE pat.voided = 0 AND
        patientsAreRelated(p_patientId, pat.patient_id) AND
        patientIsNotDead(pat.patient_id) AND
        patientHasEnrolledIntoIndexProgram(pat.patient_id);

    RETURN (result);
END$$
DELIMITER ;

-- getFirstIndexName

DROP FUNCTION IF EXISTS getFirstIndexName;

DELIMITER $$
CREATE FUNCTION getFirstIndexName(
    p_contactPatientId INT(11)) RETURNS TEXT
    DETERMINISTIC
BEGIN
    DECLARE result TEXT DEFAULT '';

    SELECT concat(pn.given_name," ", ifnull(pn.family_name,'')) INTO result
    FROM person_name pn
    WHERE pn.voided = 0 AND
        patientsAreRelated(p_contactPatientId, pn.person_id) AND
        patientIsIndex(pn.person_id)
        ORDER BY pn.date_created ASC 
        LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;


-- getFirstIndexRelationship

DROP FUNCTION IF EXISTS getFirstIndexRelationship;

DELIMITER $$
CREATE FUNCTION getFirstIndexRelationship(
    p_contactPatientId INT(11)) RETURNS TEXT
    DETERMINISTIC
BEGIN
    DECLARE result TEXT DEFAULT '';

    SELECT getRelationshipNameBetweenPatients(p_contactPatientId, pnIndex.person_id) INTO result
    FROM person_name pnIndex
    WHERE pnIndex.voided = 0 AND
        patientsAreRelated(p_contactPatientId, pnIndex.person_id) AND
        patientIsIndex(pnIndex.person_id)
        ORDER BY pnIndex.date_created ASC 
        LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientIsContact

DROP FUNCTION IF EXISTS patientIsContact;

DELIMITER $$
CREATE FUNCTION patientIsContact(
    p_contactId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM relationship r
    JOIN person pIndex ON (r.person_a = p_contactId AND r.person_b = pIndex.person_id) OR
            (r.person_a = pIndex.person_id AND r.person_b = p_contactId)
    WHERE 
        patientIsIndex(pIndex.person_id)
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientsAreRelated

DROP FUNCTION IF EXISTS patientsAreRelated;

DELIMITER $$
CREATE FUNCTION patientsAreRelated(
    p_patientIdA INT(11),
    p_patientIdB INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM relationship 
    WHERE relationship.voided = 0 AND
        ((relationship.person_a = p_patientIdA AND relationship.person_b = p_patientIdB) OR
            (relationship.person_a = p_patientIdB AND relationship.person_b = p_patientIdA))
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getRelationshipNameBetweenPatients

DROP FUNCTION IF EXISTS getRelationshipNameBetweenPatients;

DELIMITER $$
CREATE FUNCTION getRelationshipNameBetweenPatients(
    p_patientIdA INT(11),
    p_patientIdB INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50) DEFAULT "";

    SELECT rt.a_is_to_b INTO result
    FROM relationship r
    JOIN relationship_type rt ON r.relationship = rt.relationship_type_id
    WHERE r.voided = 0 AND
        ((r.person_a = p_patientIdA AND r.person_b = p_patientIdB) OR
            (r.person_a = p_patientIdB AND r.person_b = p_patientIdA))
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientHasEnrolledIntoIndexProgram

DROP FUNCTION IF EXISTS patientHasEnrolledIntoIndexProgram;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledIntoIndexProgram(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT
        TRUE INTO result
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE p.person_id = p_patientId
        AND p.voided = 0
        AND pro.name = "INDEX_TESTING_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result);
END$$
DELIMITER ;

-- getTestedLocation

DROP FUNCTION IF EXISTS getTestedLocation;

DELIMITER $$
CREATE FUNCTION getTestedLocation(
    p_patientId INT(11)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SELECT l.name INTO result
    FROM obs o
    JOIN concept_name cn ON cn.concept_id = o.concept_id
    JOIN location l ON o.location_id = l.location_id
    WHERE o.person_id = p_patientId
        AND o.voided = 0
        AND cn.name = 'Final Test Result'
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;
