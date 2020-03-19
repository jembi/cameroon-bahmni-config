
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
    getPatientDateOfEnrollementInProgram(pat.patient_id, "TB_PROGRAM_KEY") < p_endDate AND
    patientHasEnrolledIntoHivProgram(pat.patient_id) = "Yes" AND
    patientHasStartedARVTreatmentDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$
DELIMITER ;

-- getPatientDateOfEnrollementInProgram

DROP FUNCTION IF EXISTS getPatientDateOfEnrollementInProgram;

DELIMITER $$
CREATE FUNCTION getPatientDateOfEnrollementInProgram(
    p_patientId INT(11),
    p_program VARCHAR(50)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE DEFAULT 0;

    SELECT
        pp.date_enrolled INTO result
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE p.person_id = p_patientId
        AND p.voided = 0
        AND pro.name = p_program
    ORDER BY pp.date_enrolled DESC
    LIMIT 1;

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

-- getPatientMostRecentProgramAttributeValue

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
