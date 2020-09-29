
DROP FUNCTION IF EXISTS TREATMENT_Indicator1a;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator1a(
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
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasEnrolledIntoHivProgramDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientHasStartedARVTreatmentDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNewlyInitiatingART(pat.patient_id, p_startDate, p_endDate) AND
    patientIsPregnant(pat.patient_id) AND
    patientWithTherapeuticLinePickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);
    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator1b;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator1b(
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
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasEnrolledIntoHivProgramBefore(pat.patient_id, p_startDate) AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientAlreadyOnART(pat.patient_id, p_startDate) AND
    patientIsPregnant(pat.patient_id) AND
    patientOnARVOrHasPickedUpADrugWithinExtendedPeriod(pat.patient_id, p_startDate, p_endDate, 0, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);
    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator2;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator2(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1),
    p_minDuration INT(11),
    p_maxDuration INT(11)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasEnrolledIntoHivProgramDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    IF (
        isOldPatient(pat.patient_id, p_startDate),
        (patientOnARTDuringEntireReportingPeriodAndDurationBetween(pat.patient_id, p_startDate, p_endDate, p_minDuration, p_maxDuration) OR
            patientPickedARVDrugDuringReportingPeriodAndDurationBetween(pat.patient_id, p_startDate, p_endDate, p_minDuration, p_maxDuration)),
        patientPickedARVDrugDuringReportingPeriodAndDurationBetween(pat.patient_id, p_startDate, p_endDate, p_minDuration, p_maxDuration)
    ) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator3;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator3(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1),
    p_includeOnlyBreastfeeding TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    DECLARE uuidIsBreastfeeding VARCHAR(38) DEFAULT "242c9027-dc2d-42e6-869e-045e8a8b95cb";

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    (!p_includeOnlyBreastfeeding OR getProgramAttributeValueWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, uuidIsBreastfeeding) = 'true') AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientWasPrescribedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientHasTherapeuticLine(pat.patient_id, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator4a;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator4a(
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
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasEnrolledIntoHivProgram(pat.patient_id) = "Yes" AND
    patientHasTherapeuticLine(pat.patient_id, 0) AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_endDate) AND
    patientWasOnARVTreatmentByDate(pat.patient_id, p_startDate) AND
    patientIsLostToFollowUp(pat.patient_id, p_startDate, p_endDate) AND
    (
        patientHasProgramOutcomeDeadWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate)
        OR
        patientDeclaredDeadInTheRegisteredFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate)
    );

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator4d;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator4d(
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
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasEnrolledIntoHivProgram(pat.patient_id) = "Yes" AND
    patientHasTherapeuticLine(pat.patient_id, 0) AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_endDate) AND
    patientWasOnARVTreatmentByDate(pat.patient_id, p_startDate) AND
    patientIsLostToFollowUp(pat.patient_id, p_startDate, p_endDate) AND
    patientHasProgramOutcomeTransferredOutWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator4e;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator4e(
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
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasEnrolledIntoHivProgram(pat.patient_id) = "Yes" AND
    patientHasTherapeuticLine(pat.patient_id, 0) AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_endDate) AND
    patientWasOnARVTreatmentByDate(pat.patient_id, p_startDate) AND
    patientIsLostToFollowUp(pat.patient_id, p_startDate, p_endDate) AND
    patientHasProgramOutcomeRefusedTreatmentWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator4b;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator4b(
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
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasEnrolledIntoHivProgram(pat.patient_id) = "Yes" AND
    patientHasTherapeuticLine(pat.patient_id, 0) AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_endDate) AND
    patientWasOnARVTreatmentByDate(pat.patient_id, p_startDate) AND
    patientIsLostToFollowUp(pat.patient_id, p_startDate, p_endDate) AND
    patientHasStartedARVTreatmentAfter(pat.patient_id, TIMESTAMPADD(MONTH, -3, CURDATE()));

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator4c;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator4c(
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
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasEnrolledIntoHivProgram(pat.patient_id) = "Yes" AND
    patientHasTherapeuticLine(pat.patient_id, 0) AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_endDate) AND
    patientWasOnARVTreatmentByDate(pat.patient_id, p_startDate) AND
    patientIsLostToFollowUp(pat.patient_id, p_startDate, p_endDate) AND
    NOT patientHasStartedARVTreatmentAfter(pat.patient_id, TIMESTAMPADD(MONTH, -3, CURDATE()));

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator5a;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator5a(
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
    getPatientDateOfEnrolmentInProgram(pat.patient_id, "TB_PROGRAM_KEY") < p_endDate AND
    patientHasEnrolledIntoHivProgram(pat.patient_id) = "Yes" AND
    patientHasStartedARVTreatmentDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator5b;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator5b(
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
    getPatientDateOfEnrolmentInProgram(pat.patient_id, "TB_PROGRAM_KEY") < p_endDate AND
    patientHasEnrolledIntoHivProgram(pat.patient_id) = "Yes" AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator7a;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator7a(
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
    getPatientDateOfEnrolmentInProgram(pat.patient_id, "TB_PROGRAM_KEY") BETWEEN p_startDate AND p_endDate AND
    patientHasEnrolledIntoHivProgram(pat.patient_id) = "Yes" AND
    patientHasStartedARVTreatmentDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator7b;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator7b(
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
    getPatientDateOfEnrolmentInProgram(pat.patient_id, "TB_PROGRAM_KEY") BETWEEN p_startDate AND p_endDate AND
    patientHasEnrolledIntoHivProgram(pat.patient_id) = "Yes" AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$
DELIMITER ;

-- patientHasProgramOutcomeDeadWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHasProgramOutcomeDeadWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasProgramOutcomeDeadWithinReportingPeriod(
    p_patientId INT,
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE dead TINYINT(1) DEFAULT 0;
    DECLARE uuidDead VARCHAR(38) DEFAULT "bc1bdd23-0264-4831-8b13-1bdbc45f1763";

    SELECT TRUE INTO dead
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN concept c ON c.concept_id = pp.outcome_concept_id
    WHERE p.person_id = p_patientId
        AND p.voided = 0 
        AND c.uuid = uuidDead
        AND pp.date_completed BETWEEN p_startDate AND p_endDate;

    RETURN dead; 

END$$
DELIMITER ;

-- patientHasProgramOutcomeRefusedTreatmentWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHasProgramOutcomeRefusedTreatmentWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasProgramOutcomeRefusedTreatmentWithinReportingPeriod(
    p_patientId INT,
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE refusedTreatment TINYINT(1) DEFAULT 0;
    DECLARE uuidRefusedTreatment VARCHAR(38) DEFAULT "c53ea2a6-4d8f-4f3d-b6b1-f8eeda8864b4";

    SELECT TRUE INTO refusedTreatment
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN concept c ON c.concept_id = pp.outcome_concept_id
    WHERE p.person_id = p_patientId
        AND p.voided = 0 
        AND c.uuid = uuidRefusedTreatment
        AND pp.date_completed BETWEEN p_startDate AND p_endDate;

    RETURN refusedTreatment; 

END$$
DELIMITER ;

-- patientHasProgramOutcomeTransferredOutWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHasProgramOutcomeTransferredOutWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasProgramOutcomeTransferredOutWithinReportingPeriod(
    p_patientId INT,
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE refusedTreatment TINYINT(1) DEFAULT 0;
    DECLARE uuidTransferredOut VARCHAR(38) DEFAULT "b949cd75-97cb-4de2-9553-e6d335696f07";

    SELECT TRUE INTO refusedTreatment
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN concept c ON c.concept_id = pp.outcome_concept_id
    WHERE p.person_id = p_patientId
        AND p.voided = 0 
        AND c.uuid = uuidTransferredOut
        AND pp.date_completed BETWEEN p_startDate AND p_endDate;

    RETURN refusedTreatment; 

END$$
DELIMITER ;

-- patientDeclaredDeadInTheRegisteredFormWithinReportingPeriod

DROP FUNCTION IF EXISTS patientDeclaredDeadInTheRegisteredFormWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientDeclaredDeadInTheRegisteredFormWithinReportingPeriod(
    p_patientId INT,
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE dead TINYINT(1) DEFAULT 0;

    SELECT p.dead INTO dead
    FROM person p
    WHERE p.person_id = p_patientId AND p.voided = 0
        AND p.death_date BETWEEN p_startDate AND p_endDate;

    RETURN dead; 

END$$
DELIMITER ;

-- patientWasPrescribedARVDrugDuringReportingPeriod

DROP FUNCTION IF EXISTS patientWasPrescribedARVDrugDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientWasPrescribedARVDrugDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
    GROUP BY o.patient_id;

    RETURN (result );
END$$ 
DELIMITER ;

-- patientOnARTDuringEntireReportingPeriodAndDurationBetween

DROP FUNCTION IF EXISTS patientOnARTDuringEntireReportingPeriodAndDurationBetween;

DELIMITER $$
CREATE FUNCTION patientOnARTDuringEntireReportingPeriodAndDurationBetween(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_minDuration INT(11),
    p_maxDuration INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
        AND patientHasTherapeuticLine(p_patientId, 0)
        AND o.scheduled_date < p_startDate
        AND drugOrderIsDispensed(p_patientId, o.order_id)
        AND calculateTreatmentEndDate(
            o.scheduled_date,
            do.duration,
            c.uuid -- uuid of the duration unit concept
            ) >= p_endDate
        AND calculateTreatmentEndDate(
            o.scheduled_date,
            do.duration,
            c.uuid -- uuid of the duration unit concept
            ) BETWEEN timestampadd(MONTH, p_minDuration, o.scheduled_date) 
                AND timestampadd(DAY, -1, timestampadd(MONTH, p_maxDuration, o.scheduled_date))    
    GROUP BY o.patient_id;

    RETURN (result );
END$$ 
DELIMITER ;

-- patientPickedARVDrugDuringReportingPeriodAndDurationBetween

DROP FUNCTION IF EXISTS patientPickedARVDrugDuringReportingPeriodAndDurationBetween;

DELIMITER $$
CREATE FUNCTION patientPickedARVDrugDuringReportingPeriodAndDurationBetween(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_minDuration INT(11),
    p_maxDuration INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
        AND patientHasTherapeuticLine(p_patientId, 0)
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugOrderIsDispensed(p_patientId, o.order_id)
        AND calculateTreatmentEndDate(
            o.scheduled_date,
            do.duration,
            c.uuid -- uuid of the duration unit concept
            ) BETWEEN timestampadd(MONTH, p_minDuration, o.scheduled_date) 
                AND timestampadd(DAY, -1, timestampadd(MONTH, p_maxDuration, o.scheduled_date))
    GROUP BY o.patient_id;

    RETURN (result );
END$$ 
DELIMITER ;

-- getProgramAttributeValueWithinReportingPeriod

DROP FUNCTION IF EXISTS getProgramAttributeValueWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION getProgramAttributeValueWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_uuidProgramAttribute VARCHAR(38)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);

    SELECT ppa.value_reference INTO result
    FROM patient_program_attribute ppa
        JOIN program_attribute_type pat ON pat.program_attribute_type_id = ppa.attribute_type_id AND pat.retired = 0
        JOIN patient_program pp ON ppa.patient_program_id = pp.patient_program_id AND pp.voided = 0
    WHERE
        ppa.voided = 0 AND
        pp.patient_id = p_patientId AND
        pat.uuid = p_uuidProgramAttribute AND
        ppa.date_created BETWEEN p_startDate AND p_endDate
    ORDER BY ppa.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getMostRecentProgramAttributeDateCreated

DROP FUNCTION IF EXISTS getMostRecentProgramAttributeDateCreated;

DELIMITER $$
CREATE FUNCTION getMostRecentProgramAttributeDateCreated(
    p_patientId INT(11),
    p_uuidProgramAttribute VARCHAR(38)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT ppa.date_created INTO result
    FROM patient_program_attribute ppa
        JOIN program_attribute_type pat ON pat.program_attribute_type_id = ppa.attribute_type_id AND pat.retired = 0
        JOIN patient_program pp ON ppa.patient_program_id = pp.patient_program_id AND pp.voided = 0
    WHERE
        ppa.voided = 0 AND
        pp.patient_id = p_patientId AND
        pat.uuid = p_uuidProgramAttribute
    ORDER BY ppa.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientIsNewlyInitiatingART

DROP FUNCTION IF EXISTS patientIsNewlyInitiatingART;

DELIMITER $$
CREATE FUNCTION patientIsNewlyInitiatingART(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE isNewlyInitiatingART TINYINT(1) DEFAULT 0;
    DECLARE artStartedDuringReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuidARTStatus VARCHAR(38) DEFAULT "f961ec41-cd5d-4b45-91e0-0f5a408fea4b";
    DECLARE uuidNewlyInitiatingART VARCHAR(38) DEFAULT "31314c4c-c0b9-4b86-bd68-3449ff0ad20c";
    DECLARE uuidStartDate VARCHAR(38) DEFAULT "d986e715-14fd-4ae1-9ef2-7a60e3a6a54e";

    SELECT
        TRUE INTO isNewlyInitiatingART
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidARTStatus
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = uuidNewlyInitiatingART)
    LIMIT 1;

    SELECT
        TRUE INTO artStartedDuringReportingPeriod
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidStartDate
        AND cast(o.value_datetime AS DATE) BETWEEN p_startDate AND p_endDate
    LIMIT 1;

    RETURN (isNewlyInitiatingART && artStartedDuringReportingPeriod);
END$$
DELIMITER ;

-- patientPickedARVDrugDuringReportingPeriod

DROP FUNCTION IF EXISTS patientPickedARVDrugDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientPickedARVDrugDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    GROUP BY o.patient_id;

    RETURN (result );
END$$ 
DELIMITER ;

-- patientWasOnARVTreatmentByDate

DROP FUNCTION IF EXISTS patientWasOnARVTreatmentByDate;

DELIMITER $$
CREATE FUNCTION patientWasOnARVTreatmentByDate(
    p_patientId INT(11),
    p_date DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
        AND calculateTreatmentEndDate(
            o.scheduled_date,
            do.duration,
            c.uuid -- uuid of the duration unit concept
            ) >= p_date
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    GROUP BY o.patient_id;

    RETURN (result);
END$$ 
DELIMITER ;

-- patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod

DROP FUNCTION IF EXISTS patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(
    p_patientId INT(11),
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE enrolmentDate DATE DEFAULT getPatientProgramTreatmentStartDate(p_patientId);
    IF enrolmentDate IS NULL THEN
        RETURN 0;
    ELSE
        RETURN enrolmentDate <= p_endDate;
    END IF;
END$$
DELIMITER ;

-- patientAlreadyOnART

DROP FUNCTION IF EXISTS patientAlreadyOnART;

DELIMITER $$
CREATE FUNCTION patientAlreadyOnART(
    p_patientId INT(11),
    p_startDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE isAlreadyOnART TINYINT(1) DEFAULT 0;
    DECLARE artStartedBeforeReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuidARTStatus VARCHAR(38) DEFAULT "f961ec41-cd5d-4b45-91e0-0f5a408fea4b";
    DECLARE uuidAlreadyOnART VARCHAR(38) DEFAULT "6122279f-93a8-4e5a-ac5e-b347b60c989b";
    DECLARE uuidStartDate VARCHAR(38) DEFAULT "d986e715-14fd-4ae1-9ef2-7a60e3a6a54e";

    SELECT
        TRUE INTO isAlreadyOnART
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidARTStatus
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = uuidAlreadyOnART)
    LIMIT 1;

    SELECT
        TRUE INTO artStartedBeforeReportingPeriod
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidStartDate
        AND cast(o.value_datetime AS DATE) < p_startDate
    LIMIT 1;

    RETURN (isAlreadyOnART && artStartedBeforeReportingPeriod);
END$$
DELIMITER ;

-- patientHasStartedARVTreatmentBefore

DROP FUNCTION IF EXISTS patientHasStartedARVTreatmentBefore;

DELIMITER $$
CREATE FUNCTION patientHasStartedARVTreatmentBefore(
    p_patientId INT(11),
    p_startDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE enrolmentDate DATE DEFAULT getPatientProgramTreatmentStartDate(p_patientId);
    IF enrolmentDate IS NULL THEN
        RETURN 0;
    ELSE
        RETURN enrolmentDate < p_startDate;
    END IF;
END$$
DELIMITER ;

-- patientHasStartedARVTreatmentAfter

DROP FUNCTION IF EXISTS patientHasStartedARVTreatmentAfter;

DELIMITER $$
CREATE FUNCTION patientHasStartedARVTreatmentAfter(
    p_patientId INT(11),
    p_date DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE enrolmentDate DATE DEFAULT getPatientProgramTreatmentStartDate(p_patientId);
    IF enrolmentDate IS NULL THEN
        RETURN 0;
    ELSE
        RETURN enrolmentDate > p_date;
    END IF;
END$$
DELIMITER ;

-- patientHasStartedARVTreatmentBeforeExtendedEndDate

DROP FUNCTION IF EXISTS patientHasStartedARVTreatmentBeforeExtendedEndDate;

DELIMITER $$
CREATE FUNCTION patientHasStartedARVTreatmentBeforeExtendedEndDate(
    p_patientId INT(11),
    p_endDate DATE,
    p_extendedMonths INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE enrolmentDate DATE DEFAULT getPatientProgramTreatmentStartDate(p_patientId);
    IF enrolmentDate IS NULL THEN
        RETURN 0;
    ELSE
        RETURN timestampadd(MONTH, -p_extendedMonths, enrolmentDate) < p_endDate;
    END IF;
END$$
DELIMITER ;

-- retrieveTBScreeningDateAndResult

DROP PROCEDURE IF EXISTS retrieveTBScreeningDateAndResult;

DELIMITER $$
CREATE PROCEDURE retrieveTBScreeningDateAndResult(
    IN p_patientId INT(11),
    OUT p_screeningDate DATE,
    OUT p_screeningStatus VARCHAR(250)
    )
    DETERMINISTIC
    BEGIN
    DECLARE tbScreeningStatusUuid VARCHAR(38) DEFAULT '61931c8b-0637-40f9-97dc-07796431dd3b';

    SELECT DATE(o.date_created), cn.name INTO p_screeningDate, p_screeningStatus
    FROM obs o
        JOIN concept_name cn ON cn.concept_id = o.value_coded AND cn.locale = "en" AND cn.locale_preferred = 1
    WHERE
        o.voided = 0 AND
        o.person_id = p_patientId AND
        o.value_coded IS NOT NULL AND
        o.concept_id = (SELECT c.concept_id FROM concept c WHERE c.uuid = tbScreeningStatusUuid)
    ORDER BY o.date_created DESC
    LIMIT 1;

END$$ 
DELIMITER ;

-- getTBScreeningStatus

DROP FUNCTION IF EXISTS getTBScreeningStatus;

DELIMITER $$
CREATE FUNCTION getTBScreeningStatus(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE tbScreeningStatus VARCHAR(250);
    DECLARE tbScreeningDate DATE;
    
    CALL retrieveTBScreeningDateAndResult(p_patientId, tbScreeningDate, tbScreeningStatus);

    RETURN tbScreeningStatus;
END$$
DELIMITER ;

-- getTBScreeningStatusAtLastARVRefill

DROP FUNCTION IF EXISTS getTBScreeningStatusAtLastARVRefill;

DELIMITER $$
CREATE FUNCTION getTBScreeningStatusAtLastARVRefill(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE tbScreeningStatus VARCHAR(250);
    DECLARE tbScreeningDate DATE;
    DECLARE arvLatestRefillDate DATE;
    DECLARE patientEnrolledOnHIVProgram VARCHAR(3);
    DECLARE patientOnARVTreatment TINYINT(1);
    
    -- Get latest TB Screening status and date
    CALL retrieveTBScreeningDateAndResult(p_patientId, tbScreeningDate, tbScreeningStatus);

    -- Get date of latest refil
    SET arvLatestRefillDate = getLastArvPickupDate(p_patientId, '2000-01-01', '2100-01-01');
    
    -- Check if the patient is on HIV program
    SET patientEnrolledOnHIVProgram = patientHasEnrolledIntoHivProgram(p_patientId);

    -- Check if the patient is currently on ARV treatment
    SET patientOnARVTreatment = patientIsOnARVTreatment(p_patientId);

    IF (
        tbScreeningDate = arvLatestRefillDate AND
        patientEnrolledOnHIVProgram = 'Yes' AND
        patientOnARVTreatment) THEN
        RETURN tbScreeningStatus;
    ELSE
        RETURN NULL;
    END IF;

    RETURN result;
END$$
DELIMITER ;

-- patientHasStartedARVTreatmentDuringReportingPeriod

DROP FUNCTION IF EXISTS patientHasStartedARVTreatmentDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasStartedARVTreatmentDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE enrolmentDate DATE DEFAULT getPatientProgramTreatmentStartDate(p_patientId);
    IF enrolmentDate IS NULL THEN
        RETURN 0;
    ELSE
        RETURN enrolmentDate BETWEEN p_startDate AND p_endDate;
    END IF;
END$$
DELIMITER ;

-- getEacDate

DROP FUNCTION IF EXISTS getEacDate;

DELIMITER $$
CREATE FUNCTION getEacDate(
    p_patientId INT(11),
    p_eacNumber INT(11)
) RETURNS DATE
    DETERMINISTIC
BEGIN

    DECLARE result DATE;
    DECLARE uidAEC VARCHAR(38);
    DECLARE uuidEacDate VARCHAR(38) DEFAULT "377fdf0b-9259-4197-9cf1-697e513e92cb";
    DECLARE uuidEAC1 VARCHAR(38) DEFAULT "2d7b7d0f-d49b-4643-8b38-d5e952d2a7f1";
    DECLARE uuidEAC2 VARCHAR(38) DEFAULT "beb3b80d-1f5d-412d-941d-3842eb56b0f3";
    DECLARE uuidEAC3 VARCHAR(38) DEFAULT "010efc37-f82a-41c9-a348-2efee49476b9";
    DECLARE uuidEACSessionNumber VARCHAR(38) DEFAULT "80472b4d-e37b-46c9-9078-85e3a509af24";

    SET uidAEC = 
        CASE
                WHEN p_eacNumber = 1 THEN  uuidEAC1
                WHEN p_eacNumber = 2 THEN  uuidEAC2
                WHEN p_eacNumber = 3 THEN  uuidEAC3
            END;

    SELECT o.value_datetime INTO result
    FROM obs o
    WHERE
    o.voided = 0 AND
    o.person_id = p_patientId AND
    o.concept_id = (SELECT c.concept_id FROM concept c WHERE c.uuid = uuidEacDate) AND
    o.encounter_id IN
        (
            SELECT DISTINCT o2.encounter_id
            FROM obs o2
            WHERE 
                o2.voided = 0 AND
                o2.person_id = p_patientId AND
                o2.concept_id = (SELECT c.concept_id FROM concept c WHERE c.uuid = uuidEACSessionNumber) AND
                o2.value_coded = (SELECT c.concept_id FROM concept c WHERE c.uuid = uidAEC)
        )
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN result;
 
END$$
DELIMITER ;

-- getARVTherapeuticLineAtInitiation

DROP FUNCTION IF EXISTS getARVTherapeuticLineAtInitiation;

DELIMITER $$
CREATE FUNCTION getARVTherapeuticLineAtInitiation(
    p_patientId INT(11)
) RETURNS TEXT
    DETERMINISTIC
BEGIN

    DECLARE uuiTherapeuticLine VARCHAR(38) DEFAULT "a8bc4608-eaae-4610-a842-d83d6261ea49";
    DECLARE uuiARVProtocol VARCHAR(38) DEFAULT "cd278ad7-c9f3-4cd5-adc5-9150813ea95f";

    IF (patientAgeAtHivEnrollment(p_patientId) >= 15) THEN
        RETURN getObsCodedValue(p_patientId, uuiTherapeuticLine);
    ELSE
        RETURN getObsCodedValue(p_patientId, uuiARVProtocol);
    END IF;
 
END$$
DELIMITER ;

-- patientIsEligibleForVL

DROP FUNCTION IF EXISTS patientIsEligibleForVL;

DELIMITER $$
CREATE FUNCTION patientIsEligibleForVL(
    p_patientId INT(11)
) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    RETURN
        patientHasEnrolledIntoHivProgram(p_patientId) = "Yes" AND
        patientIsOnARVTreatment(p_patientId) AND
        patientIsNotDead(p_patientId) AND
        patientIsNotLostToFollowUp(p_patientId) AND
        patientIsNotTransferredOut(p_patientId) AND
        (
          (getViralLoadTestDate(p_patientId) IS NOT NULL AND timestampdiff(MONTH, getViralLoadTestDate(p_patientId), NOW()) >= 6 )
          OR
          (
            getPatientARVStartDate(p_patientId) IS NOT NULL AND
            timestampdiff(MONTH, getPatientARVStartDate(p_patientId), NOW()) >= 6 AND
            (getViralLoadTestDate(p_patientId) IS NULL OR timestampdiff(MONTH, getViralLoadTestDate(p_patientId), NOW()) >= 6)
            )
          OR
          (patientHasEnrolledInVlEacProgram(p_patientId) AND timestampdiff(MONTH, getViralLoadTestDate(p_patientId), NOW()) >= 3)
          OR
          (
            getViralLoadTestResult(p_patientId) IS NOT NULL AND
            getViralLoadTestResult(p_patientId) < 1000 AND
            getViralLoadTestDate(p_patientId) IS NOT NULL AND
            timestampdiff(MONTH, getViralLoadTestDate(p_patientId), NOW()) >= 12 AND
            patientOnTreatmentForOneYear(p_patientId)
          )
        );
 
END$$
DELIMITER ;
