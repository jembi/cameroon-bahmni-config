
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

-- getNumberOfHIVTestedContactsRelatedToIndex

DROP FUNCTION IF EXISTS getNumberOfHIVTestedContactsRelatedToIndex;

DELIMITER $$
CREATE FUNCTION getNumberOfHIVTestedContactsRelatedToIndex(
    p_patientId INT(11)) RETURNS INT(1)
    DETERMINISTIC
BEGIN
    DECLARE result INT(1) DEFAULT 0;

    SELECT count(DISTINCT pat.patient_id) INTO result
    FROM patient pat
    WHERE pat.voided = 0 AND
        patientsAreRelated(p_patientId, pat.patient_id) AND
        patientIsNotDead(pat.patient_id) AND
        getHIVResult(pat.patient_id, "2000-01-01", "2050-01-01") IS NOT NULL;

    RETURN (result);
END$$
DELIMITER ;

-- getNumberOfHIVPosContactsRelatedToIndex

DROP FUNCTION IF EXISTS getNumberOfHIVPosContactsRelatedToIndex;

DELIMITER $$
CREATE FUNCTION getNumberOfHIVPosContactsRelatedToIndex(
    p_patientId INT(11)) RETURNS INT(1)
    DETERMINISTIC
BEGIN
    DECLARE result INT(1) DEFAULT 0;

    SELECT count(DISTINCT pat.patient_id) INTO result
    FROM patient pat
    WHERE pat.voided = 0 AND
        patientsAreRelated(p_patientId, pat.patient_id) AND
        patientIsNotDead(pat.patient_id) AND
        getHIVResult(pat.patient_id, "2000-01-01", "2050-01-01") = "Positive";

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

-- getFirstIndexID

DROP FUNCTION IF EXISTS getFirstIndexID;

DELIMITER $$
CREATE FUNCTION getFirstIndexID(
    p_contactPatientId INT(11)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11);

    SELECT p.patient_id INTO result
    FROM patient p
    WHERE patientsAreRelated(p_contactPatientId, p.patient_id) AND
        patientIsIndex(p.patient_id)
    ORDER BY p.date_created ASC 
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

    RETURN (REPLACE(REPLACE(result, 'RELATIONSHIP_', '' ), '_', ' '));
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
    JOIN person pIndex ON (r.person_a = p_contactId AND r.person_b = pIndex.person_id AND patientIsIndex(r.person_b)) OR
            (r.person_a = pIndex.person_id AND r.person_b = p_contactId AND patientIsIndex(r.person_a))
    WHERE r.voided = 0
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

-- getNumberSexualContactsOfIndex

DROP FUNCTION IF EXISTS getNumberSexualContactsOfIndex;

DELIMITER $$
CREATE FUNCTION getNumberSexualContactsOfIndex(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT count(r.relationship_id) INTO result
    FROM relationship r
        JOIN relationship_type rt ON r.relationship = rt.relationship_type_id  AND retired = 0
    WHERE r.voided = 0 AND
        rt.a_is_to_b = "RELATIONSHIP_PARTNER" AND
        (r.person_b = p_patientId OR r.person_a = p_patientId)
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

-- getIndexType

DROP FUNCTION IF EXISTS getIndexType;

DELIMITER $$
CREATE FUNCTION getIndexType(
    p_patientId INT(11)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE daysBetweenHIVPosAndART INT(11) DEFAULT getDaysBetweenHIVPosAndART(p_patientId);
    DECLARE viralLoadResult INT(11) DEFAULT getViralLoadTestResult(p_patientId);

    IF (daysBetweenHIVPosAndART > 0 AND daysBetweenHIVPosAndART <= 30) THEN
        RETURN 'Index Case New HTS POS and initiated on treatment this month';
    ELSEIF (viralLoadResult > 1000) THEN
        RETURN 'Index Case virally unsuppressed clients';
    ELSEIF (daysBetweenHIVPosAndART > 30 AND daysBetweenHIVPosAndART <= 180) THEN
        RETURN 'Index Case Old HTS POS and initiated on treatment within the 2 - 5 months';
    ELSEIF (daysBetweenHIVPosAndART > 180 AND daysBetweenHIVPosAndART <= 365) THEN
        RETURN 'Index Case Old HTS POS and initiated on treatment within the 6 - 12 months';
    END IF;

    RETURN '';
END$$
DELIMITER ;
