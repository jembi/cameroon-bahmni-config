-- PECG Report

DROP FUNCTION IF EXISTS PECG_Indicator2;

DELIMITER $$
CREATE FUNCTION PECG_Indicator2(
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
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator3;

DELIMITER $$
CREATE FUNCTION PECG_Indicator3(
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
    patientHasStartedARVTreatmentDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientWithTherapeuticLinePickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator4;

DELIMITER $$
CREATE FUNCTION PECG_Indicator4(
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
    patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    IF (
        isOldPatient(pat.patient_id, p_startDate),
        patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0),
        patientWithTherapeuticLinePickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0)
    ) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator5;

DELIMITER $$
CREATE FUNCTION PECG_Indicator5(
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
    patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    IF (
        isOldPatient(pat.patient_id, p_startDate),
        patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 1),
        patientWithTherapeuticLinePickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 1)
    ) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator6;

DELIMITER $$
CREATE FUNCTION PECG_Indicator6(
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
    patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    IF (
        isOldPatient(pat.patient_id, p_startDate),
        patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 2),
        patientWithTherapeuticLinePickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 2)
    ) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator7;

DELIMITER $$
CREATE FUNCTION PECG_Indicator7(
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
    patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    IF (
        isOldPatient(pat.patient_id, p_startDate),
        patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 3),
        patientWithTherapeuticLinePickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 3)
    ) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator11;

DELIMITER $$
CREATE FUNCTION PECG_Indicator11(
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
    patientHasStartedARVTreatment12MonthsAgo(pat.patient_id, p_startDate, p_endDate) AND
    patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator12;

DELIMITER $$
CREATE FUNCTION PECG_Indicator12(
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
    patientHasStartedARVTreatment12MonthsAgo(pat.patient_id, p_startDate, p_endDate) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, 0) AND
    NOT patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0) AND
    getPatientMostRecentProgramOutcome(pat.patient_id, 'en', 'HIV_PROGRAM_KEY') <>  "Refused (Stopped) Treatment";
    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator13;

DELIMITER $$
CREATE FUNCTION PECG_Indicator13(
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
    patientHasStartedARVTreatment12MonthsAgo(pat.patient_id, p_startDate, p_endDate) AND
    patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientHadViralLoadTest3MonthsBeforeOrAfterReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator15;

DELIMITER $$
CREATE FUNCTION PECG_Indicator15(
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
    patientHasStartedARVTreatment12MonthsAgo(pat.patient_id, p_startDate, p_endDate) AND
    patientOnARVOrHasPickedUpADrugWithinExtendedPeriod(pat.patient_id, p_startDate, p_endDate, 0, 3) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator17;

DELIMITER $$
CREATE FUNCTION PECG_Indicator17(
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
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientDidntCollectARV(pat.patient_id, p_startDate, p_endDate, 0, 0) AND
    patientHasScheduledAnARTAppointment(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator18;

DELIMITER $$
CREATE FUNCTION PECG_Indicator18(
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
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientDidntCollectARV(pat.patient_id, p_startDate, p_endDate, 0, -1) AND
    patientHasScheduledAnARTAppointment(pat.patient_id, p_startDate, p_endDate, -1) AND
    patientWithTherapeuticLinePickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_DATA_COLLECTION;

DELIMITER $$
CREATE FUNCTION PECG_DATA_COLLECTION(
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
    patientHasEnrolledIntoHivProgramDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    IF (
        isOldPatient(pat.patient_id, p_startDate),
        patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0),
        patientWithTherapeuticLinePickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0)
    ) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator14;

DELIMITER $$
CREATE FUNCTION PECG_Indicator14(
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
    patientHasStartedARVTreatment12MonthsAgo(pat.patient_id, p_startDate, p_endDate) AND
    patientOnARVOrHasPickedUpADrugWithinExtendedPeriod(pat.patient_id, p_startDate, p_endDate, 0, 3) AND
    patientIsVirallySuppressed3MonthsBeforeOrAfterReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

-- Accidents of Exposure (AES)

DROP FUNCTION IF EXISTS PECG_Indicator20;

DELIMITER $$
CREATE FUNCTION PECG_Indicator20(
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
    patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasNotBeenEnrolledIntoHivProgram(pat.patient_id) AND
    patientHasPickedProphylaxisDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

-- Punctual Aid (PA)

DROP FUNCTION IF EXISTS PECG_Indicator19;

DELIMITER $$
CREATE FUNCTION PECG_Indicator19(
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
    patientReasonForConsultationIsUnplannedAid(pat.patient_id) AND
    patientPickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ; 

DROP FUNCTION IF EXISTS PECG_Indicator10;

DELIMITER $$
CREATE FUNCTION PECG_Indicator10(
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
    patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    patientOnARVOrHasPickedUpADrugWithinExtendedPeriod(pat.patient_id, p_startDate, p_endDate, 0, 0) AND
    patientHadTBExaminationDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

-- isOldPatient

DROP FUNCTION IF EXISTS isOldPatient;

DELIMITER $$
CREATE FUNCTION isOldPatient(
    p_patientId INT(11),
    p_startDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    
    SELECT TRUE INTO result
    FROM patient_program pp
    JOIN person p ON p.person_id = p_patientId AND p.voided = 0
    JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE DATE(pp.date_enrolled) < p_startDate
        AND pp.patient_id = p.person_id
        AND pp.voided = 0
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result);
END$$
DELIMITER ;

-- patientHadViralLoadTest3MonthsBeforeOrAfterReportingPeriod

DROP FUNCTION IF EXISTS patientHadViralLoadTest3MonthsBeforeOrAfterReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHadViralLoadTest3MonthsBeforeOrAfterReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1);
    DECLARE testDate DATE;
    DECLARE testResult DATE;
    DECLARE viralLoadIndication VARCHAR(50);

    -- retrieve the test date
    CALL retrieveViralLoadTestDateAndResult(p_patientId, testDate, testResult, viralLoadIndication);

    -- if the test date is null, return FALSE (because the patient didn't have a viral load test)
    IF testDate IS NULL THEN
        RETURN 0;
    END IF;

    -- return true if the viral load test date is 3 months before or after the reporting period
    IF timestampdiff(MONTH, testDate, p_startDate) BETWEEN 0 AND 3 OR timestampdiff(MONTH, p_endDate, testDate) BETWEEN 0 AND 3 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;

END$$ 
DELIMITER ;

-- patientIsVirallySuppressed3MonthsBeforeOrAfterReportingPeriod

DROP FUNCTION IF EXISTS patientIsVirallySuppressed3MonthsBeforeOrAfterReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientIsVirallySuppressed3MonthsBeforeOrAfterReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1);
    DECLARE testDate DATE;
    DECLARE testResult INT(11);
    DECLARE viralLoadIndication VARCHAR(50);

    -- retrieve the test date
    CALL retrieveViralLoadTestDateAndResult(p_patientId, testDate, testResult, viralLoadIndication);

    -- if the test date is null, return FALSE (because the patient didn't have a viral load test)
    IF testDate IS NULL THEN
        RETURN 0;
    END IF;

    -- return true if the viral load test date is 3 months before or after the reporting period
    IF (timestampdiff(MONTH, testDate, p_startDate) BETWEEN 0 AND 3
        OR
        timestampdiff(MONTH, p_endDate, testDate) BETWEEN 0 AND 3)
        AND
        testResult < 1000 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;

END$$ 
DELIMITER ;

-- retrieveViralLoadTestDateAndResult

DROP PROCEDURE IF EXISTS retrieveViralLoadTestDateAndResult;

DELIMITER $$
CREATE PROCEDURE retrieveViralLoadTestDateAndResult(
    IN p_patientId INT(11),
    OUT p_testDate DATE,
    OUT p_testResult INT(11),
    OUT p_viralLoadIndication VARCHAR(50)
    )
    DETERMINISTIC
proc_vital_load:BEGIN
    DECLARE routineViralLoadTestDateUuid VARCHAR(38) DEFAULT 'cac6bf44-f671-4f85-ab76-71e7f099d3cb';
    DECLARE routineViralLoadTestUuid VARCHAR(38) DEFAULT '4d80e0ce-5465-4041-9d1e-d281d25a9b50';
    DECLARE targetedViralLoadTestDateUuid VARCHAR(38) DEFAULT 'ac479522-c891-11e9-a32f-2a2ae2dbcce4';
    DECLARE targetedViralLoadTestUuid VARCHAR(38) DEFAULT '9ee13e38-c7ce-11e9-a32f-2a2ae2dbcce4';
    DECLARE notDocumentedViralLoadTestDateUuid VARCHAR(38) DEFAULT 'ac4797de-c891-11e9-a32f-2a2ae2dbcce4';
    DECLARE notDocumentedViralLoadTestUuid VARCHAR(38) DEFAULT '9ee140e0-c7ce-11e9-a32f-2a2ae2dbcce4';
    DECLARE testDate DATE;
    DECLARE testDateFromForm DATE;
    DECLARE testDateFromOpenElis DATE;
    DECLARE useFormResult TINYINT(1);

    -- Read and store latest test date from form "LAB RESULTS - ADD MANUALLY"
    SELECT o.value_datetime INTO testDateFromForm
    FROM obs o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.order_id IS NULL
        AND o.value_datetime IS NOT NULL
        AND o.person_id = p_patientId
        AND (c.uuid = routineViralLoadTestDateUuid OR c.uuid = targetedViralLoadTestDateUuid OR c.uuid = notDocumentedViralLoadTestDateUuid)
    ORDER BY o.value_datetime DESC, o.obs_datetime DESC
    LIMIT 1;

    -- read and store latest test date from elis
    SELECT o.obs_datetime INTO testDateFromOpenElis
    FROM obs o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.order_id IS NOT NULL
        AND o.value_numeric IS NOT NULL
        AND o.person_id = p_patientId
        AND (c.uuid = routineViralLoadTestUuid OR c.uuid = targetedViralLoadTestUuid OR c.uuid = notDocumentedViralLoadTestUuid)
    ORDER BY o.obs_datetime DESC
    LIMIT 1;

    -- if both dates are null, return NULL
    IF (testDateFromForm IS NULL AND testDateFromOpenElis IS NULL) THEN
        SET p_testDate = NULL;
        SET p_testResult = NULL;
        LEAVE proc_vital_load;
    END IF;

    -- select the test date to use
    IF (testDateFromForm IS NULL) THEN -- if date from form is null, use date from elis as test date
        SET testDate = testDateFromOpenElis;
        SET useFormResult = 0;
    ELSEIF (testDateFromOpenElis IS NULL) THEN -- else if date from elis is null, use date from form
        SET testDate = testDateFromForm;
        SET useFormResult = 1;
    ELSE -- if date from form and date from openelis are both not null, use the date from elis
        SET testDate = testDateFromOpenElis;
        SET useFormResult = 0;
    END IF;

    SET p_testDate = testDate;

    IF (useFormResult) THEN
        SELECT o.value_numeric, cn.name INTO p_testResult, p_viralLoadIndication
        FROM obs o
        JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
        JOIN concept_name cn ON cn.concept_id = c.concept_id AND cn.locale="en"
        WHERE o.voided = 0
            AND o.order_id IS NULL
            AND o.value_numeric IS NOT NULL
            AND o.person_id = p_patientId
            AND (c.uuid = routineViralLoadTestUuid OR c.uuid = targetedViralLoadTestUuid OR c.uuid = notDocumentedViralLoadTestUuid)
        ORDER BY o.obs_datetime DESC
        LIMIT 1;
    ELSE
        SELECT o.value_numeric, cn.name  INTO p_testResult, p_viralLoadIndication
        FROM obs o
        JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
        JOIN concept_name cn ON cn.concept_id = c.concept_id AND cn.locale="en"
        WHERE o.voided = 0
            AND o.order_id IS NOT NULL
            AND o.value_numeric IS NOT NULL
            AND o.person_id = p_patientId
            AND (c.uuid = routineViralLoadTestUuid OR c.uuid = targetedViralLoadTestUuid OR c.uuid = notDocumentedViralLoadTestUuid)
        ORDER BY o.obs_datetime DESC
        LIMIT 1;
    END IF;

END$$ 
DELIMITER ;

-- patientHasPickedProphylaxisDuringReportingPeriod

DROP FUNCTION IF EXISTS patientHasPickedProphylaxisDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasPickedProphylaxisDuringReportingPeriod(
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
        AND IF (
            patientIsAdult(p_patientId),
            drugIsAdultProphylaxis(d.concept_id),
            drugIsChildProphylaxis(d.concept_id))
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND o.order_action <> "DISCONTINUE"
        AND o.date_stopped IS NULL
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    GROUP BY o.patient_id;

    RETURN (result);
END$$ 
DELIMITER ;

-- patientIsNotDead

DROP FUNCTION IF EXISTS patientIsNotDead;

DELIMITER $$
CREATE FUNCTION patientIsNotDead(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT p.dead INTO result
    FROM person p
    WHERE p.person_id = p_patientId AND p.voided = 0;

    RETURN (!result );

END$$
DELIMITER ;

-- patientIsNotLostToFollowUp

DROP FUNCTION IF EXISTS patientIsNotLostToFollowUp;

DELIMITER $$
CREATE FUNCTION patientIsNotLostToFollowUp(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN 
    DECLARE patientLostToFollowUp TINYINT(1) DEFAULT 0;

    DECLARE uuidPatientLostToFollowUp VARCHAR(38) DEFAULT "7ca4f879-4862-4cd5-84b3-e1ead8ff54ff";

    SELECT TRUE INTO patientLostToFollowUp
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN concept c ON c.concept_id = pp.outcome_concept_id
    WHERE p.person_id = p_patientId AND p.voided = 0
        AND c.uuid = uuidPatientLostToFollowUp;

    RETURN (!patientLostToFollowUp );
END$$
DELIMITER ;

-- patientIsNotTransferredOut

DROP FUNCTION IF EXISTS patientIsNotTransferredOut;

DELIMITER $$
CREATE FUNCTION patientIsNotTransferredOut(
    p_patientId INT) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE patientTransferedOut TINYINT(1) DEFAULT 0;

    DECLARE uuidPatientTransferredOut VARCHAR(38) DEFAULT "c614b7a3-9ffa-4047-8c20-f42e6a347deb";

    SELECT TRUE INTO patientTransferedOut
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN concept c ON c.concept_id = pp.outcome_concept_id
    WHERE p.person_id = p_patientId
        AND p.voided = 0 
        AND c.uuid = uuidPatientTransferredOut;

    RETURN (!patientTransferedOut); 

END$$
DELIMITER ;

-- patientReasonForConsultationIsUnplannedAid

DROP FUNCTION IF EXISTS patientReasonForConsultationIsUnplannedAid;

DELIMITER $$
CREATE FUNCTION patientReasonForConsultationIsUnplannedAid(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN 
    DECLARE patientIsUnplannedAid TINYINT(1) DEFAULT 0;

    DECLARE uuidPatientIsUnplannedAid VARCHAR(38) DEFAULT "17a3b24b-e107-49fe-8b0d-69c3b7e60f4c";

    SELECT TRUE INTO patientIsUnplannedAid
    FROM  patient_program pp  
    JOIN patient_program_attribute ppt ON ppt.patient_program_id = pp.patient_program_id
    JOIN concept c ON c.concept_id = ppt.value_reference
    WHERE  ppt.voided = 0 AND p_patientId = pp.patient_id
        AND c.uuid = uuidPatientIsUnplannedAid
    LIMIT 1;
    RETURN (patientIsUnplannedAid );
END$$
DELIMITER ;

-- patientWithTherapeuticLinePickedARVDrugDuringReportingPeriod

DROP FUNCTION IF EXISTS patientWithTherapeuticLinePickedARVDrugDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientWithTherapeuticLinePickedARVDrugDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_protocolLineNumber INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    RETURN
        patientPickedARVDrugDuringReportingPeriod(p_patientId, p_startDate, p_endDate)
        AND
        patientHasTherapeuticLine(p_patientId, p_protocolLineNumber);
END$$ 
DELIMITER ;

-- patientDidntCollectARV
DROP FUNCTION IF EXISTS patientDidntCollectARV;

DELIMITER $$
CREATE FUNCTION patientDidntCollectARV(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_protocolLineNumber INT(11),
    p_monthOffset INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE drugNotDispensed TINYINT(1) DEFAULT 0;
    DECLARE drugNotOrdered TINYINT(1) DEFAULT 1;

    SELECT TRUE INTO drugNotDispensed
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
        AND o.order_action <> "DISCONTINUE"
        AND o.date_stopped IS NULL
        AND patientHasTherapeuticLine(p_patientId, p_protocolLineNumber)
        AND o.scheduled_date BETWEEN TIMESTAMPADD(MONTH,p_monthOffset,p_startDate) AND TIMESTAMPADD(MONTH,p_monthOffset,p_endDate)
        AND !drugOrderIsDispensed(p_patientId, o.order_id)
    GROUP BY o.patient_id;

    SELECT FALSE INTO drugNotOrdered
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
        AND patientHasTherapeuticLine(p_patientId, p_protocolLineNumber)
        AND o.order_action <> "DISCONTINUE"
        AND o.date_stopped IS NULL
        AND o.scheduled_date BETWEEN TIMESTAMPADD(MONTH,p_monthOffset,p_startDate) AND TIMESTAMPADD(MONTH,p_monthOffset,p_endDate)
    GROUP BY o.patient_id;

    RETURN (drugNotDispensed OR drugNotOrdered);
END$$ 
DELIMITER ;

-- patientHasStartedARVTreatment12MonthsAgo

DROP FUNCTION IF EXISTS patientHasStartedARVTreatment12MonthsAgo;

DELIMITER $$
CREATE FUNCTION patientHasStartedARVTreatment12MonthsAgo(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE enrolmentDate DATE DEFAULT getPatientProgramTreatmentStartDate(p_patientId, "HIV_PROGRAM_KEY");
    IF enrolmentDate IS NULL THEN
        RETURN 0;
    ELSE
        RETURN timestampadd(YEAR, 1, enrolmentDate) BETWEEN p_startDate AND p_endDate;
    END IF;
END$$ 
DELIMITER ;

-- patientOnARVOrHasPickedUpADrugWithinExtendedPeriod

DROP FUNCTION IF EXISTS patientOnARVOrHasPickedUpADrugWithinExtendedPeriod;

DELIMITER $$
CREATE FUNCTION patientOnARVOrHasPickedUpADrugWithinExtendedPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_protocolLineNumber INT(11),
    p_extended_months INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE extended_startDate DATE;
    DECLARE extended_endDate DATE;
    SET extended_startDate = timestampadd(MONTH, -p_extended_months, p_startDate);
    SET extended_endDate = timestampadd(MONTH, p_extended_months, p_endDate);

    RETURN
        patientWasOnARVTreatmentDuringEntireReportingPeriod(p_patientId, extended_startDate, extended_endDate, p_protocolLineNumber)
        OR
        patientWithTherapeuticLinePickedARVDrugDuringReportingPeriod(p_patientId, extended_startDate, extended_endDate, p_protocolLineNumber);
END$$ 
DELIMITER ;

-- patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod

DROP FUNCTION IF EXISTS patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_protocolLineNumber INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    RETURN
        patientWasOnARVTreatmentDuringEntireReportingPeriod(p_patientId, p_startDate, p_endDate, p_protocolLineNumber)
        OR
        patientWithTherapeuticLinePickedARVDrugDuringReportingPeriod(p_patientId, p_startDate, p_endDate, p_protocolLineNumber);
END$$ 
DELIMITER ;

-- patientWasOnARVTreatmentDuringEntireReportingPeriod

DROP FUNCTION IF EXISTS patientWasOnARVTreatmentDuringEntireReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientWasOnARVTreatmentDuringEntireReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_protocolLineNumber INT(11)) RETURNS TINYINT(1)
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
        AND patientHasTherapeuticLine(p_patientId, p_protocolLineNumber)
        AND o.scheduled_date < p_startDate
        AND o.order_action <> "DISCONTINUE"
        AND o.date_stopped IS NULL
        AND calculateTreatmentEndDate(
            o.scheduled_date,
            do.duration,
            c.uuid -- uuid of the duration unit concept
            ) >= p_endDate
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    GROUP BY o.patient_id;

    RETURN (result );
END$$ 
DELIMITER ;

-- patientHadTBExaminationDuringReportingPeriod

DROP FUNCTION IF EXISTS patientHadTBExaminationDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHadTBExaminationDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE tbScreenedUuid VARCHAR(38) DEFAULT "b5e95e00-b0bc-411b-993b-50ace78cdaf6";
    DECLARE tbScreenedDateUuid VARCHAR(38) DEFAULT "55185e73-e634-4dfc-8ec0-02086e8c54d0";
    DECLARE yesFullNameUuid VARCHAR(38) DEFAULT "8f864633-beb0-4bd7-a75c-703affdcd93d";
    DECLARE tbScreened TINYINT(1) DEFAULT 0;
    DECLARE tbScreenedDate DATE;

    SELECT
        TRUE INTO tbScreened
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = tbScreenedUuid
        AND o.value_coded IS NOT NULL
    GROUP BY c.uuid
    ORDER BY o.obs_datetime DESC;

    SELECT
        o.value_datetime INTO tbScreenedDate
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = tbScreenedDateUuid
        AND o.value_datetime IS NOT NULL
    GROUP BY c.uuid
    ORDER BY o.value_datetime DESC;

    IF tbScreened AND tbScreenedDate BETWEEN p_startDate AND p_endDate THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;

END$$
DELIMITER ;
