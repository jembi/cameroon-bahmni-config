-- PECG Report

DROP FUNCTION IF EXISTS PECG_Indicator1;

DELIMITER $$
CREATE FUNCTION PECG_Indicator1(
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
    getARTAppointmentOnOrAfterDate(pat.patient_id, p_startDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

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
    patientHasStartedARVTreatmentDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    getARTAppointmentOnOrAfterDate(pat.patient_id, p_startDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

-- PECG_Indicator4;
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
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientHasTherapeuticLineFirstLine(pat.patient_id) AND
    getARTAppointmentOnOrAfterDate(pat.patient_id, p_startDate) AND
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
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientHasTherapeuticLineSecondLine(pat.patient_id) AND
    getARTAppointmentOnOrAfterDate(pat.patient_id, p_startDate) AND
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
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientHasTherapeuticLineThirdLine(pat.patient_id) AND
    getARTAppointmentOnOrAfterDate(pat.patient_id, p_startDate) AND
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
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasChangedLineProtocol(pat.patient_id) AND
    getLastARVProtocolInPreviousMonth(pat.patient_id, p_startDate) IN ("1st line", "1st substituted line") AND
    getNewARVProtocol(pat.patient_id, p_endDate) = "2nd line" AND
    getARTAppointmentOnOrAfterDate(pat.patient_id, p_startDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotDefaulterBasedOnDays(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotTransferredOut(pat.patient_id) AND 
    NOT patientReasonForConsultationIsUnplannedAid(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator8;

DELIMITER $$
CREATE FUNCTION PECG_Indicator8(
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
    patientHadTBExaminationDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator9;

DELIMITER $$
CREATE FUNCTION PECG_Indicator9(
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
    getARTAppointmentOnOrAfterDate(pat.patient_id, p_startDate) AND
    patientHasBeenPrescribedDrug(pat.patient_id, "INH","#startDate#", "#endDate#") = "Yes" AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND
    patientIsNotDefaulterBasedOnDays(pat.patient_id, p_startDate, p_endDate) AND
    NOT patientReasonForConsultationIsUnplannedAid(pat.patient_id);

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
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, 0) AND
    getARTAppointmentOnOrAfterDate(pat.patient_id, p_startDate) AND
    patientOnARVOrHasPickedUpADrugWithinExtendedPeriod(pat.patient_id, p_startDate, p_endDate, 0, 0) AND
    patientHadTBExaminationDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDefaulterBasedOnDays(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND
    NOT patientReasonForConsultationIsUnplannedAid(pat.patient_id);

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
    getARTAppointmentOnOrAfterDate(pat.patient_id, p_startDate) AND
    patientHadTBExaminationDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    getObsCodedValue(pat.patient_id, "61931c8b-0637-40f9-97dc-07796431dd3b") = "Suspected / Probable" AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND
    NOT patientReasonForConsultationIsUnplannedAid(pat.patient_id);

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
    getARTAppointmentOnOrAfterDate(pat.patient_id, p_startDate) AND
    patientHadTBExaminationDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    getObsCodedValue(pat.patient_id, "61931c8b-0637-40f9-97dc-07796431dd3b") = "Suspected / Probable" AND
    getObsCodedValue(pat.patient_id, "63ac8070-fc26-4121-a05e-11e5a6b56ad0") IN ("Yes","Yes full name") AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND
    NOT patientReasonForConsultationIsUnplannedAid(pat.patient_id);

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
    getARTAppointmentOnOrAfterDate(pat.patient_id, p_startDate) AND
    patientHadTBExaminationDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    getObsCodedValue(pat.patient_id, "61931c8b-0637-40f9-97dc-07796431dd3b") = "Suspected / Probable" AND
    getObsCodedValue(pat.patient_id, "63ac8070-fc26-4121-a05e-11e5a6b56ad0") = "Yes" AND
    getObsCodedValue(pat.patient_id, "6ab25a03-6ac3-45f1-aa04-af54186411e0") = "Positive" AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND
    NOT patientReasonForConsultationIsUnplannedAid(pat.patient_id);

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
    patientWithTherapeuticLinePickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientHadTBExaminationDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    getObsCodedValue(pat.patient_id, "61931c8b-0637-40f9-97dc-07796431dd3b") = "Suspected / Probable" AND
    getObsCodedValue(pat.patient_id, "63ac8070-fc26-4121-a05e-11e5a6b56ad0") = "Yes" AND
    getObsCodedValue(pat.patient_id, "6ab25a03-6ac3-45f1-aa04-af54186411e0") = "Positive" AND
    getObsCodedValue(pat.patient_id, "3dce13a8-c7e5-45ec-a6f0-8050fd4a2ca2") = "Initiated treatment" AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND
    patientIsNotDefaulterBasedOnDays(pat.patient_id, p_startDate, p_endDate) AND 
    NOT patientReasonForConsultationIsUnplannedAid(pat.patient_id);

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
    getPatientMostRecentProgramOutcome(pat.patient_id, 'en', 'HIV_PROGRAM_KEY') = "Dead" AND
    getMostRecentProgramCompletionDate(pat.patient_id, 'HIV_PROGRAM_KEY') BETWEEN p_startDate AND p_endDate;

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator16;

DELIMITER $$
CREATE FUNCTION PECG_Indicator16(
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
    patientDidntCollectARV(pat.patient_id, p_startDate, p_endDate, 0, 0) AND
    patientIsNotDefaulterFor1Month(pat.patient_id, p_startDate, p_endDate) AND
    patientHasScheduledAnARTAppointment(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientIsNotDead(pat.patient_id) AND
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
    patientIsNotDefaulterFor2Month(pat.patient_id, p_startDate, p_endDate) AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientDidntCollectARV(pat.patient_id, p_startDate, p_endDate, 0, 0) AND
    patientHasScheduledAnARTAppointment(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id);

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
    patientIsNotDefaulterBasedOnDays(pat.patient_id, p_startDate, p_endDate) AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientDidntCollectARV(pat.patient_id, p_startDate, p_endDate, 0, -1) AND
    patientHasScheduledAnARTAppointment(pat.patient_id, p_startDate, p_endDate, -1) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

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
    patientReasonForConsultationIsTransferIn(pat.patient_id) AND
    getObsTextValue(pat.patient_id, "39296a1c-bd96-404e-976a-5186da7c4690") = "In Cameroon" AND
    getObsDatetimeValue(pat.patient_id, "c5b20e93-56c8-45e5-b65b-2b42ee49ecb0") BETWEEN p_startDate AND p_endDate AND
    patientIsNotDead(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

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
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasEnrolledIntoHivProgramDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientReasonForConsultationIsTransferIn(pat.patient_id) AND
    getObsTextValue(pat.patient_id, "39296a1c-bd96-404e-976a-5186da7c4690") = "Outside Cameroon" AND
    getObsDatetimeValue(pat.patient_id, "c5b20e93-56c8-45e5-b65b-2b42ee49ecb0") BETWEEN p_startDate AND p_endDate AND
    patientIsNotDead(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator21;

DELIMITER $$
CREATE FUNCTION PECG_Indicator21(
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
    patientHasEnrolledIntoHivProgram(pat.patient_id) AND
    getPatientMostRecentProgramOutcome(pat.patient_id, 'en', 'HIV_PROGRAM_KEY') = "Transferred Out" AND
    getProgramOutcomeDateDuringTheReportingPeriod(pat.patient_id, p_startDate, p_endDate, 'HIV_PROGRAM_KEY') AND
    patientTransferredInCountry(pat.patient_id) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;


DROP FUNCTION IF EXISTS PECG_Indicator22;

DELIMITER $$
CREATE FUNCTION PECG_Indicator22(
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
    patientHasEnrolledIntoHivProgramDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientTransferredOutOfTheCountry(pat.patient_id) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator23;

DELIMITER $$
CREATE FUNCTION PECG_Indicator23(
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
    patientHasReturnedToTreatmentWithinTheReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator24;

DELIMITER $$
CREATE FUNCTION PECG_Indicator24(
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
        RETURN 0;-- Accidents of Exposure (AES)



-- Punctual Aid (PA)
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
        AND c.uuid = uuidPatientLostToFollowUp
    LIMIT 1;

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
    DECLARE conceptIdTransferredOut INT;

    DECLARE uuidPatientTransferredOut VARCHAR(38) DEFAULT "b949cd75-97cb-4de2-9553-e6d335696f07";
    SELECT concept_id INTO conceptIdTransferredOut FROM concept WHERE uuid = uuidPatientTransferredOut;

    SELECT pp.outcome_concept_id = conceptIdTransferredOut INTO patientTransferedOut
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    WHERE p.person_id = p_patientId
        AND p.voided = 0 
    ORDER BY pp.patient_program_id DESC
    LIMIT 1;

    RETURN COALESCE(!patientTransferedOut, 1); 

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
    ORDER BY pp.patient_program_id DESC
    LIMIT 1;
    RETURN (patientIsUnplannedAid );
END$$
DELIMITER ;

-- patientReasonForConsultationIsTransferIn

DROP FUNCTION IF EXISTS patientReasonForConsultationIsTransferIn;

DELIMITER $$
CREATE FUNCTION patientReasonForConsultationIsTransferIn(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN 
    DECLARE patientIsTransferIn TINYINT(1) DEFAULT 0;

    DECLARE uuidPatientIsTransferIn VARCHAR(38) DEFAULT "cf180299-f6e2-4b08-8b80-2e9125a97230";

    SELECT TRUE INTO patientIsTransferIn
    FROM  patient_program pp  
    JOIN patient_program_attribute ppt ON ppt.patient_program_id = pp.patient_program_id
    JOIN concept c ON c.concept_id = ppt.value_reference
    WHERE  ppt.voided = 0 AND p_patientId = pp.patient_id
        AND c.uuid = uuidPatientIsTransferIn
    ORDER BY pp.patient_program_id DESC
    LIMIT 1;
    RETURN (patientIsTransferIn );
END$$
DELIMITER ;

-- patientTransferredInCountry

DROP FUNCTION IF EXISTS patientTransferredInCountry;

DELIMITER $$
CREATE FUNCTION patientTransferredInCountry(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN 
    DECLARE transferredInCountry TINYINT(1) DEFAULT 0;

    DECLARE uuidTransferredInCountry VARCHAR(38) DEFAULT "4382de10-74f9-11ef-b864-0242ac120002";

    SELECT TRUE INTO transferredInCountry
    FROM  patient_program pp  
    JOIN patient_program_attribute ppt ON ppt.patient_program_id = pp.patient_program_id
    JOIN concept c ON c.concept_id = ppt.value_reference
    WHERE  ppt.voided = 0 AND p_patientId = pp.patient_id
        AND c.uuid = uuidTransferredInCountry
    ORDER BY pp.patient_program_id DESC
    LIMIT 1;
    RETURN (transferredInCountry);

END$$
DELIMITER ;

-- patientTransferredOutOfTheCountry

DROP FUNCTION IF EXISTS patientTransferredOutOfTheCountry;

DELIMITER $$
CREATE FUNCTION patientTransferredOutOfTheCountry(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN 
    DECLARE transferredOutOfCountry TINYINT(1) DEFAULT 0;

    DECLARE uuidTransferredOutOfCountry VARCHAR(38) DEFAULT "5bd2c4fc-a3e5-40fc-b394-a2881599e707";

    SELECT TRUE INTO transferredOutOfCountry
    FROM  patient_program pp  
    JOIN patient_program_attribute ppt ON ppt.patient_program_id = pp.patient_program_id
    JOIN concept c ON c.concept_id = ppt.value_reference
    WHERE  ppt.voided = 0 AND p_patientId = pp.patient_id
        AND c.uuid = uuidTransferredOutOfCountry
    ORDER BY pp.patient_program_id DESC
    LIMIT 1;
    RETURN (transferredOutOfCountry);

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
    DECLARE tbScreenedUuid VARCHAR(38) DEFAULT "f0447183-d13f-463d-ad0f-1f45b99d97cc";
    DECLARE tbScreenedDateUuid VARCHAR(38) DEFAULT "1d4a6dc4-c478-4021-982b-62e3c84f7857";
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

-- patientHasChangedLineProtocol

DROP FUNCTION IF EXISTS patientHasChangedLineProtocol;

DELIMITER $$
CREATE FUNCTION patientHasChangedLineProtocol(
  p_patientId INT(11)) RETURNS TINYINT(1)
DETERMINISTIC
BEGIN
  DECLARE patientChangedProtocolLineFromAdultFUForm TINYINT(1) DEFAULT getMostRecentObsBooleanValue(p_patientId, "0e86e2e4-d6e6-45af-9a60-496639e1c5e3");
  DECLARE possibleTherapeuticChangeFromChildFUForm VARCHAR(256) DEFAULT getObsCodedValue(p_patientId, "2f02df8b-3745-4864-8bf6-ccbf831c020c");
  
  IF(patientChangedProtocolLineFromAdultFUForm OR possibleTherapeuticChangeFromChildFUForm = "Changing ART") THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END$$
DELIMITER ;

-- getMostRecentObsBooleanValue

DROP FUNCTION IF EXISTS getMostRecentObsBooleanValue;

DELIMITER $$
CREATE FUNCTION getMostRecentObsBooleanValue(
  p_patientId INT(11),
  conceptUuid VARCHAR(38)
  ) RETURNS TINYINT(1)
DETERMINISTIC
BEGIN

    DECLARE mostRecentObsValue VARCHAR(250);

    SELECT name INTO mostRecentObsValue
    FROM (
        SELECT MAX(o.obs_datetime), cn.name
        FROM obs o
            JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
            JOIN concept_name cn ON cn.concept_id = o.value_coded AND cn.locale ='en'
        WHERE o.voided = 0
            AND o.person_id = p_patientId
            AND o.concept_id = (SELECT co.concept_id FROM concept co WHERE co.uuid = conceptUuid)
        GROUP BY o.person_id
    ) t ;

    IF(mostRecentObsValue = 'Yes') THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
END$$
DELIMITER ;

-- getLastARVProtocolInPreviousMonth

DROP FUNCTION IF EXISTS getLastARVProtocolInPreviousMonth;

DELIMITER $$
CREATE FUNCTION getLastARVProtocolInPreviousMonth(
  p_patientId INT(11),
  p_startDate DATE
    ) RETURNS VARCHAR(250)
DETERMINISTIC
BEGIN

    DECLARE result VARCHAR(250);

    SELECT cn2.name INTO result
    FROM obs o
    JOIN concept_name cn ON cn.concept_id = o.concept_id
    JOIN concept_name cn2 ON cn2.concept_id = o.value_coded
    JOIN concept c ON cn.concept_id = c.concept_id
    WHERE o.person_id = p_patientId
        AND o.voided = 0
        AND c.uuid = "93abe599-63f4-4a94-9614-1d7d824e1e82"
        AND cn2.locale = "en"
        AND cn2.concept_name_type = "FULLY_SPECIFIED"
        AND 
            (
                SELECT o2.value_datetime
                FROM obs o2
                WHERE
                    o2.person_id = o.person_id
                    AND o2.concept_id = (SELECT concept_id FROM concept WHERE uuid="a4cfd327-403b-4cf6-aec2-e96ae2b68fb2")
                    AND o2.voided = 0
                ORDER BY o2.value_datetime DESC
                LIMIT 1
            ) BETWEEN p_startDate AND TIMESTAMPADD(DAY, 30, p_startDate)
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getNewARVProtocol

DROP FUNCTION IF EXISTS getNewARVProtocol;

DELIMITER $$
CREATE FUNCTION getNewARVProtocol(
  p_patientId INT(11),
  p_endDate DATE
    ) RETURNS VARCHAR(250)
DETERMINISTIC
BEGIN

    DECLARE result VARCHAR(250);

    SELECT cn2.name INTO result
    FROM obs o
    JOIN concept_name cn ON cn.concept_id = o.concept_id
    JOIN concept_name cn2 ON cn2.concept_id = o.value_coded
    JOIN concept c ON cn.concept_id = c.concept_id
    WHERE o.person_id = p_patientId
        AND o.voided = 0
        AND c.uuid = "880dad2e-d582-4f81-a52d-68488897328f"
        AND cn2.locale = "en"
        AND cn2.concept_name_type = "FULLY_SPECIFIED"
        AND 
            (
                SELECT o2.value_datetime
                FROM obs o2
                WHERE
                    o2.person_id = o.person_id
                    AND o2.concept_id = (SELECT concept_id FROM concept WHERE uuid="a4cfd327-403b-4cf6-aec2-e96ae2b68fb2")
                    AND o2.voided = 0
                ORDER BY o2.value_datetime DESC
                LIMIT 1
            ) <= p_endDate
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;



