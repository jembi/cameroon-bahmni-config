-- Testing Report

DROP FUNCTION IF EXISTS Testing_Indicator1;

DELIMITER $$
CREATE FUNCTION Testing_Indicator1(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1),
    p_hivResult VARCHAR(8),
    p_testingEntryPoint VARCHAR(50)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE uuidCounselingForm VARCHAR(38) DEFAULT "6bfd85ce-22c8-4b54-af0e-ab0af24240e3";

    DECLARE uuidHIVTestFinalResult VARCHAR(38) DEFAULT "41e48d08-2235-47d5-af12-87a009057603";
    DECLARE uuidHIVTestSection VARCHAR(38) DEFAULT "b70dfca0-db21-4533-8c08-4626ff0de265";

    SELECT
        COUNT(DISTINCT pat.patient_id) INTO result
    FROM patient pat
    WHERE
        (
            SELECT p.gender = p_gender
            FROM person p
            WHERE p.person_id = pat.patient_id AND p.voided = 0
        ) AND
        (
            (
                SELECT
                    cn.name = p_hivResult
                FROM obs o
                    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
                    JOIN concept_name cn ON o.value_coded = cn.concept_id AND cn.locale='en'
                WHERE o.voided = 0
                    AND o.person_id = pat.patient_id
                    AND c.uuid = uuidHIVTestFinalResult
                    AND o.date_created BETWEEN p_startDate AND p_endDate
                ORDER BY o.date_created DESC
                LIMIT 1
            ) AND
            getObsDatetimeValueInSection(pat.patient_id, uuidHIVTestDate, uuidHIVTestSection) BETWEEN p_startDate AND p_endDate
            AND getObsDatetimeValueInSection(pat.patient_id, uuidHIVTestDate, uuidHIVTestSection) IS NOT NULL
        ) AND
        getTestingEntryPoint(pat.patient_id) = p_testingEntryPoint AND
        patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$ 
DELIMITER ;

-- Testing Report

DROP FUNCTION IF EXISTS Testing_Indicator;

DELIMITER $$
CREATE FUNCTION Testing_Indicator(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1),
    p_hivResult VARCHAR(8),
    p_testingEntryPoint VARCHAR(50)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT
        COUNT(DISTINCT pat.patient_id) INTO result
    FROM
        patient pat
    WHERE
        patientGenderIs(pat.patient_id, p_gender) AND
        (getPatientPreviousHIVTestDateFromCounselingForm(pat.patient_id) < TIMESTAMPADD(MONTH, -3, CURDATE()) OR getPatientPreviousHIVTestDateFromCounselingForm(pat.patient_id) IS NULL) AND
        patientHIVFinalTestResultIsWithinReportingPeriod(pat.patient_id, p_hivResult, p_startDate, p_endDate) AND
        getTestingEntryPoint(pat.patient_id) = p_testingEntryPoint AND
        patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator4a;

DELIMITER $$
CREATE FUNCTION Testing_Indicator4a(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    DECLARE uuidHIVTestResultPositive VARCHAR(38) DEFAULT "7acfafa4-f19b-485e-97a7-c9e002dbe37a";

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientHIVTestResultWithinReportingPeriodIs(pat.patient_id, p_startDate, p_endDate, uuidHIVTestResultPositive, 1) AND
    patientHadANCVisitWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND 
    patientGenderIs(pat.patient_id, 'F') AND
    (
        patientHIVDatePriorToEnrolOnANCForm3MOrLessBeforeReportEndDate(pat.patient_id, p_startDate, p_endDate) 
        OR
        (
            patientHIVDatePriorToEnrolOnANCFormMoreThan3MBeforeReportEndDate(pat.patient_id, p_startDate, p_endDate) AND
            patientHIVRetestPosPriorToEnrolOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
            NOT patientAlreadyOnARTOnANCFormBeforeReportEndDate(pat.patient_id, p_endDate) 
        )
        OR
        (
            patientHIVDatePriorToEnrolOnANCFormMoreThan3MBeforeReportEndDate(pat.patient_id, p_startDate, p_endDate) AND
            patientAlreadyOnARTOnANCFormBeforeReportEndDate(pat.patient_id, p_endDate)
        )
    );

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator4b;

DELIMITER $$
CREATE FUNCTION Testing_Indicator4b(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    DECLARE uuidHIVTestResultPositive VARCHAR(38) DEFAULT "7acfafa4-f19b-485e-97a7-c9e002dbe37a";

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientHIVTestResultWithinReportingPeriodIs(pat.patient_id, p_startDate, p_endDate, uuidHIVTestResultPositive, 0) AND
    NOT patientHIVTestResultWithinReportingPeriodIs(pat.patient_id, p_startDate, p_endDate, uuidHIVTestResultPositive, 1) AND
    patientDateOfFirstANCVisitOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND 
    patientGenderIs(pat.patient_id, 'F');

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator4c;

DELIMITER $$
CREATE FUNCTION Testing_Indicator4c(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    DECLARE uuidHIVTestResultPositive VARCHAR(38) DEFAULT "7acfafa4-f19b-485e-97a7-c9e002dbe37a";
    DECLARE uuidHIVTestResultNegative VARCHAR(38) DEFAULT "718b4589-2a11-4355-b8dc-aa668a93e098";

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientHIVTestResultWithinReportingPeriodIs(pat.patient_id, p_startDate, p_endDate, uuidHIVTestResultNegative, 0) AND
    NOT patientHIVTestResultWithinReportingPeriodIs(pat.patient_id, p_startDate, p_endDate, uuidHIVTestResultPositive, 1) AND
    patientDateOfFirstANCVisitOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND 
    patientGenderIs(pat.patient_id, 'F');

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator4d;

DELIMITER $$
CREATE FUNCTION Testing_Indicator4d(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    DECLARE uuidHIVTestResultNegative VARCHAR(38) DEFAULT "718b4589-2a11-4355-b8dc-aa668a93e098";

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientHIVTestResultWithinReportingPeriodIs(pat.patient_id, p_startDate, p_endDate, uuidHIVTestResultNegative, 1) AND
    patientNotEligibleForHIVRetestOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientDateOfFirstANCVisitOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND 
    patientGenderIs(pat.patient_id, 'F');

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator2;

DELIMITER $$
CREATE FUNCTION Testing_Indicator2(
    p_startDate DATE,
    p_endDate DATE,
    p_startAgeInMonths INT(11),
    p_endAgeInMonths INT (11),
    p_includeStartAge TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    getDateOfVirologicTest(pat.patient_id, p_startDate, p_endDate) IS NOT NULL AND
    patientAgeAtVirologicHIVTestIsBetween(pat.patient_id, p_startAgeInMonths, p_endAgeInMonths, p_startDate, p_endDate, p_includeStartAge) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator3a;

DELIMITER $$
CREATE FUNCTION Testing_Indicator3a(
    p_startDate DATE,
    p_endDate DATE,
    p_startAgeInMonths INT(11),
    p_endAgeInMonths INT (11),
    p_includeStartAge TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientHadAPositiveVirologicHIVTestResultDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientMostRecentVirologicHIVTestResultIsPositive(pat.patient_id) AND
    NOT patientHasEnrolledIntoHivProgramBefore(pat.patient_id, getDateOfVirologicTest(pat.patient_id, p_startDate, p_endDate)) AND
    NOT patientHasStartedARVTreatmentBefore(pat.patient_id, getDateOfVirologicTest(pat.patient_id, p_startDate, p_endDate)) AND
    NOT patientWasOnARVTreatmentByDate(pat.patient_id, getDateOfVirologicTest(pat.patient_id, p_startDate, p_endDate)) AND
    patientAgeAtVirologicHIVTestIsBetween(pat.patient_id, p_startAgeInMonths, p_endAgeInMonths, p_startDate, p_endDate, p_includeStartAge) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator3b;

DELIMITER $$
CREATE FUNCTION Testing_Indicator3b(
    p_startDate DATE,
    p_endDate DATE,
    p_startAgeInMonths INT(11),
    p_endAgeInMonths INT (11),
    p_includeStartAge TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientHadAPositiveVirologicHIVTestResultDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientMostRecentVirologicHIVTestResultIsPositive(pat.patient_id) AND
    patientHasEnrolledIntoHivProgramBefore(pat.patient_id, getDateOfVirologicTest(pat.patient_id, p_startDate, p_endDate)) AND
    patientHasTherapeuticLine(pat.patient_id, 0) AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, getDateOfVirologicTest(pat.patient_id, p_startDate, p_endDate)) AND
    patientWasOnARVTreatmentByDate(pat.patient_id, getDateOfVirologicTest(pat.patient_id, p_startDate, p_endDate)) AND
    patientAgeAtVirologicHIVTestIsBetween(pat.patient_id, p_startAgeInMonths, p_endAgeInMonths, p_startDate, p_endDate, p_includeStartAge) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator5;

DELIMITER $$
CREATE FUNCTION Testing_Indicator5(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1),
    p_testingEntryPoint VARCHAR(50)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT
        COUNT(DISTINCT pat.patient_id) INTO result
    FROM
        patient pat
    WHERE
        patientGenderIs(pat.patient_id, p_gender) AND
        (getPatientPreviousHIVTestDateFromCounselingForm(pat.patient_id) > TIMESTAMPADD(MONTH, -1, CURDATE()) OR getPatientPreviousHIVTestDateFromCounselingForm(pat.patient_id) IS NULL) AND
        patientHIVFinalTestResultIsWithinReportingPeriod(pat.patient_id, 'POSITIVE', p_startDate, p_endDate) AND
        getTestingEntryPoint(pat.patient_id) = p_testingEntryPoint AND
        patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator5j;

DELIMITER $$
CREATE FUNCTION Testing_Indicator5j(
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
        patientHadActiveVLTestLessThanAMonthAgoWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
        patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TESTING_Indicator6a;

DELIMITER $$
CREATE FUNCTION TESTING_Indicator6a(
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    DECLARE uuidPcrAlereQTest VARCHAR(38) DEFAULT "a5239a85-6f75-4882-9b9b-60168e54b7da";
    DECLARE uuidPcrAlereQTestDate VARCHAR(38) DEFAULT "9bb7b360-3790-4e1a-8aca-0d1341663040";

    SELECT
        COUNT(DISTINCT pat.patient_id) INTO result
    FROM
        patient pat
    WHERE
        getPatientAgeInMonthsAtDate(pat.patient_id, p_endDate) <= 18 AND
        getTestResultWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, uuidPcrAlereQTest, uuidPcrAlereQTestDate) = "Positive";

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TESTING_Indicator6b;

DELIMITER $$
CREATE FUNCTION TESTING_Indicator6b(
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    DECLARE uuidPcrAlereQTest VARCHAR(38) DEFAULT "a5239a85-6f75-4882-9b9b-60168e54b7da";
    DECLARE uuidPcrAlereQTestDate VARCHAR(38) DEFAULT "9bb7b360-3790-4e1a-8aca-0d1341663040";

    SELECT
        COUNT(DISTINCT pat.patient_id) INTO result
    FROM
        patient pat
    WHERE
        getPatientAgeInMonthsAtDate(pat.patient_id, p_endDate) <= 18 AND
        getTestResultWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, uuidPcrAlereQTest, uuidPcrAlereQTestDate) = "Negative";

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TESTING_Indicator6c;

DELIMITER $$
CREATE FUNCTION TESTING_Indicator6c(
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    DECLARE uuidPcrAlereQTest VARCHAR(38) DEFAULT "a5239a85-6f75-4882-9b9b-60168e54b7da";
    DECLARE uuidPcrAlereQTestDate VARCHAR(38) DEFAULT "9bb7b360-3790-4e1a-8aca-0d1341663040";

    SELECT
        COUNT(DISTINCT pat.patient_id) INTO result
    FROM
        patient pat
    WHERE
        getPatientAgeInMonthsAtDate(pat.patient_id, p_endDate) >= 18 AND
        (
            (
                patientAttendedHIVRelatedAppointmentWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
                getTestResultWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, uuidPcrAlereQTest, uuidPcrAlereQTestDate) IS NULL
            )
            OR
            (
                patientIsLostToFollowUp(pat.patient_id, p_startDate, p_endDate) AND
                NOT patientAttendedHIVRelatedAppointmentWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate)
            )
        );

    RETURN (result);
END$$ 
DELIMITER ;


DROP FUNCTION IF EXISTS Testing_Indicator7ab;

DELIMITER $$
CREATE FUNCTION Testing_Indicator7ab(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1),
    p_checkDateAccepted TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT
        COUNT(DISTINCT pat.patient_id) INTO result
    FROM
        patient pat
    WHERE
        patientGenderIs(pat.patient_id, p_gender) AND
        wasIndexDateWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, p_checkDateAccepted) AND
        patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator7c;

DELIMITER $$
CREATE FUNCTION Testing_Indicator7c(
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
        patientIsContact(pat.patient_id) AND
        getPatientRegistrationDate(pat.patient_id) BETWEEN p_startDate AND p_endDate AND
        patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator7de;

DELIMITER $$
CREATE FUNCTION Testing_Indicator7de(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1),
    p_hivResult VARCHAR(8)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT
        COUNT(DISTINCT pat.patient_id) INTO result
    FROM
        patient pat
    WHERE
        patientGenderIs(pat.patient_id, p_gender) AND
        patientIsContact(pat.patient_id) AND
        getPatientRegistrationDate(pat.patient_id) BETWEEN p_startDate AND p_endDate AND
        patientHIVFinalTestResultIsWithinReportingPeriod(pat.patient_id, p_hivResult, p_startDate, p_endDate) AND
        patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator7f;

DELIMITER $$
CREATE FUNCTION Testing_Indicator7f(
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
        patientIsContact(pat.patient_id) AND
        getPatientRegistrationDate(pat.patient_id) BETWEEN p_startDate AND p_endDate AND
        getPatientHIVDateFromCounsellingForm(pat.patient_id) < getPatientRegistrationDate(pat.patient_id) AND
        getPatientHIVResultFromCounsellingForm(pat.patient_id) = "Positive" AND
        patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator8a;

DELIMITER $$
CREATE FUNCTION Testing_Indicator8a(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE uuidHIVTestingAndCounsellingForm VARCHAR(38) DEFAULT "6bfd85ce-22c8-4b54-af0e-ab0af24240e3";

    SELECT
        COUNT(DISTINCT pat.patient_id) INTO result
    FROM
        patient pat
    WHERE
        patientGenderIs(pat.patient_id, p_gender) AND
        patientHasEnrolledIntoTBProgramDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
        getObsDatetimeValueInSection(pat.patient_id, uuidHIVTestDate, uuidHIVTestingAndCounsellingForm) < p_startDate AND
        getPatientHIVResultFromCounsellingForm(pat.patient_id) = "Positive" AND
        patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator8b;

DELIMITER $$
CREATE FUNCTION Testing_Indicator8b(
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
        patientHasEnrolledIntoTBProgramDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
        patientHIVFinalTestResultIsWithinReportingPeriod(pat.patient_id, "Positive", p_startDate, p_endDate) AND
        patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator8c;

DELIMITER $$
CREATE FUNCTION Testing_Indicator8c(
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
        patientHasEnrolledIntoTBProgramDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
        patientHIVFinalTestResultIsWithinReportingPeriod(pat.patient_id, "Negative", p_startDate, p_endDate) AND
        patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    return (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator8d;

DELIMITER $$
CREATE FUNCTION Testing_Indicator8d(
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
        patientHasEnrolledIntoTBProgramDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
        patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$ 
DELIMITER ;

-- patientAttendedHIVRelatedAppointmentWithinReportingPeriod

DROP FUNCTION IF EXISTS patientAttendedHIVRelatedAppointmentWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientAttendedHIVRelatedAppointmentWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE appointmentDate DATE;
    DECLARE mostRecentHIVRelatedVisit DATE;

    SELECT pa.start_date_time INTO appointmentDate
    FROM patient_appointment pa
    JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
    WHERE pa.voided = 0
        AND pa.patient_id = p_patientId
        AND pa.start_date_time BETWEEN p_startDate AND p_endDate
        AND aps.name IN ("APPOINTMENT_SERVICE_OPD_KEY", "APPOINTMENT_SERVICE_ART_KEY", "APPOINTMENT_SERVICE_ART_DISPENSARY_KEY")
    GROUP BY pa.patient_id;

    IF appointmentDate IS NULL THEN
        RETURN 0;
    END IF;

    SET mostRecentHIVRelatedVisit = getDateMostRecentHIVRelatedEncounterExcludingANC(p_patientId);

    IF mostRecentHIVRelatedVisit IS NOT NULL AND mostRecentHIVRelatedVisit >= appointmentDate THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END$$
DELIMITER ;

-- getDateMostRecentHIVRelatedEncounterExcludingANC

DROP FUNCTION IF EXISTS getDateMostRecentHIVRelatedEncounterExcludingANC;

DELIMITER $$
CREATE FUNCTION getDateMostRecentHIVRelatedEncounterExcludingANC(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT e.encounter_datetime INTO result
    FROM encounter e
    JOIN `location` loc ON loc.location_id = e.location_id
    WHERE e.voided = 0
        AND e.patient_id = p_patientId
        AND loc.name IN (
            "LOCATION_ART",
            "LOCATION_ART_DISPENSATION",
            "LOCATION_OPD"
        )
    ORDER BY e.encounter_datetime DESC
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;

-- getTestResultWithinReportingPeriod

DROP FUNCTION IF EXISTS getTestResultWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION getTestResultWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_testUuid VARCHAR(38),
    p_testDateUuid VARCHAR(38)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE testResult VARCHAR(50);
    DECLARE testDate DATE;

    CALL retrieveTestDateAndResultWithinReportingPeriod(p_patientId, p_startDate, p_endDate, p_testUuid, p_testDateUuid, testDate, testResult);

    RETURN testResult;
END$$
DELIMITER ;

-- getTestDateWithinReportingPeriod

DROP FUNCTION IF EXISTS getTestDateWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION getTestDateWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_testUuid VARCHAR(38),
    p_testDateUuid VARCHAR(38)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE testResult VARCHAR(50);
    DECLARE testDate DATE;

    CALL retrieveTestDateAndResultWithinReportingPeriod(p_patientId, p_startDate, p_endDate, p_testUuid, p_testDateUuid, testDate, testResult);

    RETURN testDate;
END$$
DELIMITER ;

-- retrieveTestDateAndResultWithinReportingPeriod

DROP PROCEDURE IF EXISTS retrieveTestDateAndResultWithinReportingPeriod;

DELIMITER $$
CREATE PROCEDURE retrieveTestDateAndResultWithinReportingPeriod(
    IN p_patientId INT(11),
    IN p_startDate DATE,
    IN p_endDate DATE,
    IN p_testUuid VARCHAR(38),
    IN p_testDateUuid VARCHAR(38),
    OUT p_testDate DATE,
    OUT p_testResult VARCHAR(50)
    )
    DETERMINISTIC
    proc_test_date_and_result:BEGIN

    DECLARE encounterId INT(11);

    -- retrieve the test result from OpenElis
    SELECT cn.name, o.date_created INTO p_testResult, p_testDate
    FROM obs o
        JOIN concept_name cn ON o.value_coded = cn.concept_id AND cn.locale = "en"
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND o.order_id IS NOT NULL
        AND o.concept_id = (SELECT c.concept_id FROM concept c WHERE c.uuid = p_testUuid LIMIT 1)
        AND o.date_created BETWEEN p_startDate AND p_endDate
    ORDER BY o.date_created DESC
    LIMIT 1;

    IF (p_testResult IS NOT NULL) THEN
        LEAVE proc_test_date_and_result;
    END IF;

    -- retrieve the test result from the lab form
    SELECT o.encounter_id, o.value_datetime INTO encounterId, p_testDate
    FROM obs o
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND o.order_id IS NULL
        AND o.concept_id = (SELECT c.concept_id FROM concept c WHERE c.uuid = p_testDateUuid LIMIT 1)
        AND o.value_datetime BETWEEN p_startDate AND p_endDate
    ORDER BY o.value_datetime DESC, o.date_created DESC
    LIMIT 1;

    SELECT cn.name INTO p_testResult
    FROM obs o
        JOIN concept_name cn ON o.value_coded = cn.concept_id AND cn.locale = "en"
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND o.order_id IS NULL
        AND o.concept_id = (SELECT c.concept_id FROM concept c WHERE c.uuid = p_testUuid LIMIT 1)
        AND o.encounter_id = encounterId
    ORDER BY o.date_created DESC
    LIMIT 1;    

END$$ 
DELIMITER ;

-- patientHasEnrolledIntoTBProgramDuringReportingPeriod

DROP FUNCTION IF EXISTS patientHasEnrolledIntoTBProgramDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledIntoTBProgramDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
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
        AND pp.date_enrolled BETWEEN p_startDate AND p_endDate
        AND pro.name = "TB_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result );
END$$
DELIMITER ;

-- getPatientHIVDateFromCounsellingForm

DROP FUNCTION IF EXISTS getPatientHIVDateFromCounsellingForm;

DELIMITER $$
CREATE FUNCTION getPatientHIVDateFromCounsellingForm(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE testDate DATE;
    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE uuidCounsellingForm VARCHAR(38) DEFAULT "6bfd85ce-22c8-4b54-af0e-ab0af24240e3";

    SELECT
        value_datetime INTO testDate
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestDate
        AND uuidCounsellingForm = (
            SELECT concept.uuid
            FROM obs
            JOIN concept ON concept.concept_id = obs.concept_id
            WHERE obs.obs_id = o.obs_group_id
            LIMIT 1
            )
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN testDate;
END$$
DELIMITER ;

-- getDateOfPositiveHIVResult

DROP FUNCTION IF EXISTS getDateOfPositiveHIVResult;

DELIMITER $$
CREATE FUNCTION getDateOfPositiveHIVResult(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE testDate DATE;
    DECLARE testResult VARCHAR(50);

    CALL retrieveHIVTestDateAndResult(p_patientId, p_startDate, p_endDate, testDate, testResult);

    IF (testResult = "Positive") THEN
        RETURN testDate;
    ELSE
        RETURN null;
    END IF;

END$$
DELIMITER ;

-- getHIVTestDate

DROP FUNCTION IF EXISTS getHIVTestDate;

DELIMITER $$
CREATE FUNCTION getHIVTestDate(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE testDate DATE;
    DECLARE testResult VARCHAR(50);

    CALL retrieveHIVTestDateAndResult(p_patientId, p_startDate, p_endDate, testDate, testResult);

    RETURN testDate;

END$$
DELIMITER ;

-- getHIVResult

DROP FUNCTION IF EXISTS getHIVResult;

DELIMITER $$
CREATE FUNCTION getHIVResult(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE testDate DATE;
    DECLARE testResult VARCHAR(50);

    CALL retrieveHIVTestDateAndResult(p_patientId, p_startDate, p_endDate, testDate, testResult);

    RETURN testResult;

END$$
DELIMITER ;

-- retrieveHIVTestDateAndResult

DROP PROCEDURE IF EXISTS retrieveHIVTestDateAndResult;

DELIMITER $$
CREATE PROCEDURE retrieveHIVTestDateAndResult(
    IN p_patientId INT(11),
    IN p_startDate DATE,
    IN p_endDate DATE,
    OUT p_hivTestDate DATE,
    OUT p_hivTestResult VARCHAR(50)
    )
    DETERMINISTIC
    proc_hiv_test_date_and_result:BEGIN

    DECLARE hivTestDateUuid VARCHAR(38) DEFAULT 'c6c08cdc-18dc-4f42-809c-959621bc9a6c';
    DECLARE htcResultUuid VARCHAR(38) DEFAULT '85dadffe-5714-4210-8632-6fb51ef593b6';
    DECLARE finalTestResultUuid VARCHAR(38) DEFAULT '41e48d08-2235-47d5-af12-87a009057603';

    DECLARE priorAncVisitUuid VARCHAR(38) DEFAULT '130e05df-8283-453b-a611-d4f884fac8e0';
    DECLARE atAncVisitUuid VARCHAR(38) DEFAULT 'd6cc3709-ffa0-42eb-b388-d7def4df30cf';
    DECLARE sectionHivTestUuid VARCHAR(38) DEFAULT 'b70dfca0-db21-4533-8c08-4626ff0de265';

    DECLARE testDateFromANCForm DATE;
    DECLARE testResultFromANCForm VARCHAR(50);
    DECLARE obsGroupIdAnc INT(11);

    DECLARE testDateFromHTCForm DATE;
    DECLARE testResultFromHTCForm VARCHAR(50);
    DECLARE encounterIdHTC INT(11);

    -- read the test date and result from ANC form
    SELECT o.obs_group_id, o.value_datetime INTO obsGroupIdAnc, testDateFromANCForm
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.value_datetime IS NOT NULL
        AND c.uuid = hivTestDateUuid
        AND o.person_id = p_patientId
        AND 
            (
                SELECT concept.uuid
                FROM obs
                    JOIN concept ON obs.concept_id = concept.concept_id
                WHERE obs.voided = 0
                    AND obs.obs_id = o.obs_group_id
                LIMIT 1
            ) IN (priorAncVisitUuid, atAncVisitUuid)
        AND o.value_datetime BETWEEN p_startDate AND p_endDate
    ORDER BY o.value_datetime DESC
    LIMIT 1;

    SELECT cn.name INTO testResultFromANCForm
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id
        JOIN concept_name cn ON cn.concept_id = o.value_coded
    WHERE o.voided = 0
        AND o.obs_group_id = obsGroupIdAnc
        AND c.uuid = htcResultUuid
        AND cn.locale='en' AND cn.concept_name_type = 'FULLY_SPECIFIED'
    LIMIT 1;

    -- read the test date AND result from HTC form
    SELECT o.value_datetime, o.encounter_id INTO testDateFromHTCForm, encounterIdHTC
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.value_datetime IS NOT NULL
        AND c.uuid = hivTestDateUuid
        AND o.person_id = p_patientId
        AND
            (
                SELECT concept.uuid
                FROM obs
                    JOIN concept ON obs.concept_id = concept.concept_id
                WHERE obs.voided = 0
                    AND obs.obs_id = o.obs_group_id
                LIMIT 1
            ) =  sectionHivTestUuid
        AND o.value_datetime BETWEEN p_startDate AND p_endDate
    ORDER BY o.value_datetime DESC
    LIMIT 1;

    SELECT cn.name INTO testResultFromHTCForm
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id
        JOIN concept_name cn ON cn.concept_id = o.value_coded
    WHERE o.voided = 0
        AND o.encounter_id = encounterIdHTC
        AND c.uuid = finalTestResultUuid
        AND cn.locale='en' AND cn.concept_name_type = 'FULLY_SPECIFIED'
    LIMIT 1;

    -- return the ANC result if the patient is pregnant and the ANC result is available
    IF ((testDateFromHTCForm IS NULL AND testDateFromANCForm IS NOT null) || testDateFromANCForm > testDateFromHTCForm) THEN
        SET p_hivTestResult = testResultFromANCForm;
        SET p_hivTestDate = testDateFromANCForm;
    ELSE 
        SET p_hivTestResult = testResultFromHTCForm;
        SET p_hivTestDate = testDateFromHTCForm;
    END IF;

END$$ 
DELIMITER ;

-- getPatientHIVResultFromCounsellingForm

DROP FUNCTION IF EXISTS getPatientHIVResultFromCounsellingForm;

DELIMITER $$
CREATE FUNCTION getPatientHIVResultFromCounsellingForm(
    p_patientId INT(11)) RETURNS VARCHAR(8)
    DETERMINISTIC
BEGIN
    DECLARE testResult VARCHAR(8);
    DECLARE uuidHIVTestResult VARCHAR(38) DEFAULT "659ed086-730d-4ac4-910e-fea4c6507512";

    SELECT
        cn.name INTO testResult
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
        JOIN concept_name cn ON cn.concept_id = o.value_coded AND locale = "en"
    WHERE o.voided = 0
        AND o.value_coded Is NOT NULL
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestResult
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN testResult;
END$$
DELIMITER ;

-- getPriorToANCEnrolmentObsGroupId

DROP FUNCTION IF EXISTS getPriorToANCEnrolmentObsGroupId;

DELIMITER $$
CREATE FUNCTION getPriorToANCEnrolmentObsGroupId(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE priorToANCEnrolmentObsGroupId INT(11) DEFAULT NULL;
    DECLARE uuidPriorToANCEnrolment VARCHAR(38) DEFAULT "130e05df-8283-453b-a611-d4f884fac8e0";

    SELECT
        o.obs_id INTO priorToANCEnrolmentObsGroupId
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidPriorToANCEnrolment
        AND o.obs_datetime BETWEEN p_startDate AND p_endDate
        LIMIT 1;
    RETURN priorToANCEnrolmentObsGroupId;
END$$
DELIMITER ;

-- patientHadANCVisitWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHadANCVisitWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHadANCVisitWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT
        TRUE INTO result
    FROM encounter e
    JOIN location loc ON e.location_id = loc.location_id AND loc.retired = 0
    WHERE e.voided = 0
        AND e.patient_id = p_patientId
        AND loc.name = "LOCATION_ANC"
        AND DATE(e.encounter_datetime) BETWEEN p_startDate AND p_endDate LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientHIVRetestPosPriorToEnrolOnANCFormWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHIVRetestPosPriorToEnrolOnANCFormWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHIVRetestPosPriorToEnrolOnANCFormWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE patientHIVRetestResultIsPositive TINYINT(1) DEFAULT 0;
    DECLARE patientRepeatTestDateIsBetweenReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuidRepeatTestResult VARCHAR(38) DEFAULT "7682c09b-8e81-4e30-8afd-636fb9fcd4a1";
    DECLARE uuidRepeatTestResultIsPositive VARCHAR(38) DEFAULT "7acfafa4-f19b-485e-97a7-c9e002dbe37a";
    DECLARE uuidRepeatTestDate VARCHAR(38) DEFAULT "541d9f7b-f622-4ebc-a3a3-50c970d4cce0";
    DECLARE priorToANCEnrolmentObsGroupId INT(11) DEFAULT getPriorToANCEnrolmentObsGroupId(p_patientId, p_startDate, p_endDate);
    
    SELECT
        TRUE INTO patientHIVRetestResultIsPositive
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE priorToANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = priorToANCEnrolmentObsGroupId
        AND o.voided = 0 
        AND o.person_id = p_patientId
        AND c.uuid = uuidRepeatTestResult
        AND o.value_coded IS NOT NULL
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = uuidRepeatTestResultIsPositive)
        LIMIT 1;

    SELECT
        TRUE INTO patientRepeatTestDateIsBetweenReportingPeriod
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE priorToANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = priorToANCEnrolmentObsGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidRepeatTestDate
        AND DATE(o.value_datetime) BETWEEN p_startDate AND p_endDate
        LIMIT 1;

    RETURN (patientHIVRetestResultIsPositive && patientRepeatTestDateIsBetweenReportingPeriod);
END$$
DELIMITER ;

-- patientHIVDatePriorToEnrolOnANCFormMoreThan3MBeforeReportEndDate

DROP FUNCTION IF EXISTS patientHIVDatePriorToEnrolOnANCFormMoreThan3MBeforeReportEndDate;

DELIMITER $$
CREATE FUNCTION patientHIVDatePriorToEnrolOnANCFormMoreThan3MBeforeReportEndDate(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE priorToANCEnrolmentObsGroupId INT(11) DEFAULT getPriorToANCEnrolmentObsGroupId(p_patientId, p_startDate, p_endDate);

    SELECT
        TRUE INTO result
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE priorToANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = priorToANCEnrolmentObsGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestDate
        AND o.value_datetime IS NOT NULL
        AND timestampdiff(MONTH, CAST(o.value_datetime AS DATE), p_endDate) > 3
        LIMIT 1;

    RETURN (result );
END$$
DELIMITER ;

-- patientHIVDatePriorToEnrolOnANCForm3MOrLessBeforeReportEndDate

DROP FUNCTION IF EXISTS patientHIVDatePriorToEnrolOnANCForm3MOrLessBeforeReportEndDate;

DELIMITER $$
CREATE FUNCTION patientHIVDatePriorToEnrolOnANCForm3MOrLessBeforeReportEndDate(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE priorToANCEnrolmentObsGroupId INT(11) DEFAULT getPriorToANCEnrolmentObsGroupId(p_patientId, p_startDate, p_endDate);
    
    SELECT
        TRUE INTO result
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE priorToANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = priorToANCEnrolmentObsGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestDate
        AND o.value_datetime IS NOT NULL
        AND timestampdiff(MONTH, CAST(o.value_datetime AS DATE), p_endDate) BETWEEN 0 AND 3
        LIMIT 1;

    RETURN (result );
END$$
DELIMITER ;

-- patientAlreadyOnARTOnANCFormBeforeReportEndDate

DROP FUNCTION IF EXISTS patientAlreadyOnARTOnANCFormBeforeReportEndDate;

DELIMITER $$
CREATE FUNCTION patientAlreadyOnARTOnANCFormBeforeReportEndDate(
    p_patientId INT(11),
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE ARTStartedBeforeReportEndDate TINYINT(1) DEFAULT 0;
    DECLARE uuidARTStatus VARCHAR(38) DEFAULT "f961ec41-cd5d-4b45-91e0-0f5a408fea4b";
    DECLARE uuidAlreadyOnART VARCHAR(38) DEFAULT "6122279f-93a8-4e5a-ac5e-b347b60c989b";
    DECLARE uuidARTStartDate VARCHAR(38) DEFAULT "d986e715-14fd-4ae1-9ef2-7a60e3a6a54e";
    DECLARE uuidArvsArt VARCHAR(38) DEFAULT "89b1cd66-c33a-4ef4-b208-5d86502f14ec";
    DECLARE arvsArtObsGroupId INT(11) DEFAULT NULL;

    SELECT
        o.obs_group_id INTO arvsArtObsGroupId
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidARTStatus
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = uuidAlreadyOnART)
    LIMIT 1;

    SELECT
        TRUE INTO ARTStartedBeforeReportEndDate
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE arvsArtObsGroupId IS NOT NULL
        AND o.obs_group_id = arvsArtObsGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidARTStartDate
        AND DATE(o.value_datetime) < p_endDate
        LIMIT 1;

    RETURN ARTStartedBeforeReportEndDate;
END$$
DELIMITER ;

-- getAtEnrolOnANCFormObsGroupId

DROP FUNCTION IF EXISTS getAtEnrolOnANCFormObsGroupId;

DELIMITER $$
CREATE FUNCTION getAtEnrolOnANCFormObsGroupId(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE atANCEnrolmentObsGroupId INT(11) DEFAULT NULL;
    DECLARE uuidAtToANCEnrolment VARCHAR(38) DEFAULT "d6cc3709-ffa0-42eb-b388-d7def4df30cf";

    SELECT
        o.obs_id INTO atANCEnrolmentObsGroupId
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidAtToANCEnrolment
        AND o.obs_datetime BETWEEN p_startDate AND p_endDate
        LIMIT 1;
    RETURN atANCEnrolmentObsGroupId;
END$$
DELIMITER ;

-- patientHIVTestResultWithinReportingPeriodIs

DROP FUNCTION IF EXISTS patientHIVTestResultWithinReportingPeriodIs;

DELIMITER $$
CREATE FUNCTION patientHIVTestResultWithinReportingPeriodIs(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_uuidTestResult VARCHAR(38),
    p_isPriorToEnrolOnANC TINYINT(1)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE patientHIVResultMatchesInput TINYINT(1) DEFAULT 0;
    DECLARE hivTestDateWithinReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuidHIVTestResult VARCHAR(38) DEFAULT "85dadffe-5714-4210-8632-6fb51ef593b6";
    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE enrolmentObsGroupId INT(11);

    IF (p_isPriorToEnrolOnANC) THEN
        SET enrolmentObsGroupId = getPriorToANCEnrolmentObsGroupId(p_patientId, p_startDate, p_endDate);
    ELSE
        SET enrolmentObsGroupId = getAtEnrolOnANCFormObsGroupId(p_patientId, p_startDate, p_endDate);
    END IF;

    SELECT
        TRUE INTO patientHIVResultMatchesInput
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE enrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = enrolmentObsGroupId
        AND o.voided = 0 
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestResult
        AND o.value_coded IS NOT NULL
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = p_uuidTestResult)
        LIMIT 1;

    SELECT
        TRUE INTO hivTestDateWithinReportingPeriod
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE enrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = enrolmentObsGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestDate
        AND DATE(o.value_datetime) BETWEEN p_startDate AND p_endDate
        LIMIT 1;

    RETURN (patientHIVResultMatchesInput && hivTestDateWithinReportingPeriod);
END$$
DELIMITER ;

-- patientDateOfFirstANCVisitOnANCFormWithinReportingPeriod

DROP FUNCTION IF EXISTS patientDateOfFirstANCVisitOnANCFormWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientDateOfFirstANCVisitOnANCFormWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE dateOfANC1WithinReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuiddateOfANC1 VARCHAR(38) DEFAULT "57d91463-1b95-4e4d-9448-ee4e88c53cb9";
    
    SELECT
        TRUE INTO dateOfANC1WithinReportingPeriod
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0 
        AND o.person_id = p_patientId
        AND c.uuid = uuiddateOfANC1
        AND DATE(o.value_datetime) BETWEEN p_startDate AND p_endDate
        LIMIT 1;

    RETURN (dateOfANC1WithinReportingPeriod);
END$$
DELIMITER ;

-- patientNotEligibleForHIVRetestOnANCFormWithinReportingPeriod

DROP FUNCTION IF EXISTS patientNotEligibleForHIVRetestOnANCFormWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientNotEligibleForHIVRetestOnANCFormWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE patientNotEligibleWithinReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuidRetestEligibleQuestion VARCHAR(38) DEFAULT "9fda317c-9fd4-4423-a09b-dd4ba86a8a61";
    DECLARE uuidNo VARCHAR(38) DEFAULT "b497171e-0410-4d8d-bbd4-7e1a8f8b504e";

    SELECT
        TRUE INTO patientNotEligibleWithinReportingPeriod
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0 
        AND o.person_id = p_patientId
        AND c.uuid = uuidRetestEligibleQuestion
        AND o.value_coded IS NOT NULL
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = uuidNo)
        AND DATE(o.obs_datetime) BETWEEN p_startDate AND p_endDate
        LIMIT 1;

    RETURN patientNotEligibleWithinReportingPeriod;
END$$
DELIMITER ;

-- patientEligibleForHIVTesting

DROP FUNCTION IF EXISTS patientEligibleForHIVTesting;

DELIMITER $$
CREATE FUNCTION patientEligibleForHIVTesting(
    p_patientId INT(11)) RETURNS VARCHAR(3)
    DETERMINISTIC
BEGIN
    RETURN
        IF (
            getObsCodedValue(p_patientId, "5b2e5a44-b55b-4436-9948-67143841ee27") IS NOT NULL
            OR patientIsPregnant(p_patientId)
            OR getObsCodedValue(p_patientId, "44861d4c-de67-4368-b5cf-279b754e5343") IS NOT NULL
        ,"Yes","No");
END$$
DELIMITER ;

-- patientHadAPositiveVirologicHIVTestResultDuringReportingPeriod

DROP FUNCTION IF EXISTS patientHadAPositiveVirologicHIVTestResultDuringReportingPeriod;  

DELIMITER $$ 
CREATE FUNCTION patientHadAPositiveVirologicHIVTestResultDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1) 
    DETERMINISTIC 
BEGIN
    DECLARE pcrExamUuid VARCHAR(38) DEFAULT "a5239a85-6f75-4882-9b9b-60168e54b7da";
    DECLARE pcrExamDateUuid VARCHAR(38) DEFAULT "9bb7b360-3790-4e1a-8aca-0d1341663040";
    DECLARE positiveUuid VARCHAR(38) DEFAULT "7acfafa4-f19b-485e-97a7-c9e002dbe37a";
    DECLARE result TINYINT(1) DEFAULT 0;

    -- openElis check
    SELECT TRUE INTO result
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = pcrExamUuid
        AND o.value_coded = (SELECT concept.concept_id FROM concept WHERE concept.uuid = positiveUuid)
        AND o.date_created BETWEEN p_startDate AND p_endDate
        AND o.order_id IS NOT NULL
    LIMIT 1;

    IF (result) THEN
        return result;
    END IF;

    -- lab form check
    SELECT TRUE INTO result
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = pcrExamUuid
        AND o.value_coded = (SELECT concept.concept_id FROM concept WHERE concept.uuid = positiveUuid)
        AND o.order_id IS NULL
        AND (
            SELECT obs.value_datetime
            FROM obs
            JOIN concept ON concept.concept_id = obs.concept_id AND concept.retired = 0
            WHERE obs.voided = 0 
                AND obs.person_id = o.person_id 
                AND obs.value_datetime IS NOT NULL
                AND obs.encounter_id = o.encounter_id
                AND concept.uuid = pcrExamDateUuid
            LIMIT 1) BETWEEN p_startDate AND p_endDate
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientMostRecentVirologicHIVTestResultIsPositive

DROP FUNCTION IF EXISTS patientMostRecentVirologicHIVTestResultIsPositive;  

DELIMITER $$
CREATE FUNCTION patientMostRecentVirologicHIVTestResultIsPositive(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE pcrExamUuid VARCHAR(38) DEFAULT "a5239a85-6f75-4882-9b9b-60168e54b7da";
    DECLARE positiveUuid VARCHAR(38) DEFAULT "7acfafa4-f19b-485e-97a7-c9e002dbe37a";
    DECLARE result TINYINT(1) DEFAULT 0;

    DECLARE positiveConceptId INT(11);

    SELECT concept.concept_id INTO positiveConceptId
    FROM concept WHERE concept.uuid = positiveUuid;

    SELECT o.value_coded = positiveConceptId INTO result
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = pcrExamUuid
    ORDER BY o.obs_datetime DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getDateOfVirologicTest

DROP FUNCTION IF EXISTS getDateOfVirologicTest;

DELIMITER $$
CREATE FUNCTION getDateOfVirologicTest(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN

    DECLARE dateAtVirologicHIVTestLabForm DATE;
    DECLARE dateAtVirologicHIVTestElis DATE;

    SET dateAtVirologicHIVTestLabForm = getDateOfVirologicHIVTestFromLabForm(p_patientId, p_startDate, p_endDate);
    SET dateAtVirologicHIVTestElis = getDateOfVirologicHIVTestFromElis(p_patientId, p_startDate, p_endDate);

    IF dateAtVirologicHIVTestElis IS NOT NULL THEN
        RETURN dateAtVirologicHIVTestElis;
    ELSE
        RETURN dateAtVirologicHIVTestLabForm;
    END IF;

END$$
DELIMITER ;

-- getDateOfVirologicHIVTestFromLabForm

DROP FUNCTION IF EXISTS getDateOfVirologicHIVTestFromLabForm;

DELIMITER $$ 
CREATE FUNCTION getDateOfVirologicHIVTestFromLabForm(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC 
BEGIN 
    DECLARE pcrExamDateUuid VARCHAR(38) DEFAULT "9bb7b360-3790-4e1a-8aca-0d1341663040";
    DECLARE result DATE;

    SELECT o.value_datetime INTO result
    FROM obs o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.order_id IS NULL
        AND o.person_id = p_patientId
        AND c.uuid = pcrExamDateUuid
        AND o.value_datetime BETWEEN p_startDate AND p_endDate
    ORDER BY o.value_datetime DESC
    LIMIT 1;

    RETURN (result); 
END$$ 
DELIMITER ;

-- getDateOfVirologicHIVTestFromElis

DROP FUNCTION IF EXISTS getDateOfVirologicHIVTestFromElis;  

DELIMITER $$ 
CREATE FUNCTION getDateOfVirologicHIVTestFromElis(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE 
    DETERMINISTIC 
BEGIN
    DECLARE pcrExamUuid VARCHAR(38) DEFAULT "a5239a85-6f75-4882-9b9b-60168e54b7da";
    DECLARE result DATE;

    SELECT DATE(o.date_created) INTO result
    FROM orders o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.patient_id = p_patientId
        AND c.uuid = pcrExamUuid
        AND o.date_created BETWEEN p_startDate AND p_endDate
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN (result); 
END$$ 
DELIMITER ;

-- patientAgeAtVirologicHIVTestIsBetween

DROP FUNCTION IF EXISTS patientAgeAtVirologicHIVTestIsBetween;  

DELIMITER $$ 
CREATE FUNCTION patientAgeAtVirologicHIVTestIsBetween(
    p_patientId INT(11),
    p_startAgeInMonths INT(11),
    p_endAgeInMonths INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_includeStartAge TINYINT(1)) RETURNS TINYINT(1) 
    DETERMINISTIC 
BEGIN 
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE dateAtVirologicHIVTestLabForm DATE;
    DECLARE dateAtVirologicHIVTestElis DATE;
    DECLARE dateAtVirologicHIVTest DATE;

    SET dateAtVirologicHIVTestLabForm = getDateOfVirologicHIVTestFromLabForm(p_patientId, p_startDate, p_endDate);
    SET dateAtVirologicHIVTestElis = getDateOfVirologicHIVTestFromElis(p_patientId, p_startDate, p_endDate);

    IF dateAtVirologicHIVTestLabForm IS NULL AND dateAtVirologicHIVTestElis IS NULL THEN
        RETURN FALSE;
    ELSEIF dateAtVirologicHIVTestElis IS NOT NULL THEN
        SET dateAtVirologicHIVTest = dateAtVirologicHIVTestElis;
    ELSE
        SET dateAtVirologicHIVTest = dateAtVirologicHIVTestLabForm;
    END IF;

    SELECT  
        IF (p_includeStartAge, 
            timestampdiff(MONTH, p.birthdate, dateAtVirologicHIVTest) BETWEEN p_startAgeInMonths AND p_endAgeInMonths, 
            timestampdiff(MONTH, p.birthdate, dateAtVirologicHIVTest) > p_startAgeInMonths
                AND timestampdiff(MONTH, p.birthdate, dateAtVirologicHIVTest) <= p_endAgeInMonths
        ) INTO result
        FROM person p 
        WHERE p.person_id = p_patientId AND p.voided = 0;

    RETURN (result); 
END$$ 
DELIMITER ;

-- getPatientPreviousHIVTestDateFromCounselingForm

DROP FUNCTION IF EXISTS getPatientPreviousHIVTestDateFromCounselingForm;

DELIMITER $$
CREATE FUNCTION getPatientPreviousHIVTestDateFromCounselingForm(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;
    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE uuidCounselingForm VARCHAR(38) DEFAULT "6bfd85ce-22c8-4b54-af0e-ab0af24240e3";

    SELECT
        o.value_datetime INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0 
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestDate
        AND (SELECT obs.concept_id FROM obs WHERE obs_id = o.obs_group_id) = (SELECT concept_id FROM concept WHERE concept.uuid = uuidCounselingForm)
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientHIVFinalTestResultIsWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHIVFinalTestResultIsWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHIVFinalTestResultIsWithinReportingPeriod(
    p_patientId INT(11),
    p_result VARCHAR(8),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE uuidHIVTestFinalResult VARCHAR(38) DEFAULT "41e48d08-2235-47d5-af12-87a009057603";

    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE uuidHIVTestSection VARCHAR(38) DEFAULT "b70dfca0-db21-4533-8c08-4626ff0de265";
    DECLARE withinReportingPeriod TINYINT(1) DEFAULT 0;

    SET withinReportingPeriod = getObsDatetimeValueInSection(p_patientId, uuidHIVTestDate, uuidHIVTestSection) BETWEEN p_startDate AND p_endDate;
    IF withinReportingPeriod IS NULL THEN
        RETURN 0;
    END IF;

    SELECT
        cn.name = p_result INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
        JOIN concept_name cn ON o.value_coded = cn.concept_id AND cn.locale='en'
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestFinalResult
        AND o.date_created BETWEEN p_startDate AND p_endDate
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN (result AND withinReportingPeriod);
END$$
DELIMITER ;

-- getTestingEntryPoint

DROP FUNCTION IF EXISTS getTestingEntryPoint;

DELIMITER $$
CREATE FUNCTION getTestingEntryPoint(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);
    DECLARE uuidTestingEntryPoint VARCHAR(38) DEFAULT "bc43179d-00b4-4712-a5d6-4dabd4230888";

    SELECT
        cn.name INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
        JOIN concept_name cn ON o.value_coded = cn.concept_id AND cn.locale='en'
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidTestingEntryPoint
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getTestingEntryPointWithinRepPeriod

DROP FUNCTION IF EXISTS getTestingEntryPointWithinRepPeriod;

DELIMITER $$
CREATE FUNCTION getTestingEntryPointWithinRepPeriod(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50);
    DECLARE uuidTestingEntryPoint VARCHAR(38) DEFAULT "bc43179d-00b4-4712-a5d6-4dabd4230888";

    SELECT
        cn.name INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
        JOIN concept_name cn ON o.value_coded = cn.concept_id AND cn.locale='en' AND concept_name_type="SHORT"
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidTestingEntryPoint
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- wasHIVTestDoneInANCVisitWithinRepPeriod

DROP FUNCTION IF EXISTS wasHIVTestDoneInANCVisitWithinRepPeriod;

DELIMITER $$
CREATE FUNCTION wasHIVTestDoneInANCVisitWithinRepPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50) DEFAULT FALSE;
    DECLARE hivTestDateUuid VARCHAR(38) DEFAULT 'c6c08cdc-18dc-4f42-809c-959621bc9a6c';
    DECLARE priorAncVisitUuid VARCHAR(38) DEFAULT '130e05df-8283-453b-a611-d4f884fac8e0';
    DECLARE atAncVisitUuid VARCHAR(38) DEFAULT 'd6cc3709-ffa0-42eb-b388-d7def4df30cf';

    SELECT TRUE INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.value_datetime IS NOT NULL
        AND c.uuid = hivTestDateUuid
        AND o.person_id = p_patientId
        AND 
            (
                SELECT concept.uuid
                FROM obs
                    JOIN concept ON obs.concept_id = concept.concept_id
                WHERE obs.voided = 0
                    AND obs.obs_id = o.obs_group_id
                LIMIT 1
            ) IN (priorAncVisitUuid, atAncVisitUuid)
        AND o.value_datetime BETWEEN p_startDate AND p_endDate
    ORDER BY o.value_datetime DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientHadActiveVLTestLessThanAMonthAgoWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHadActiveVLTestLessThanAMonthAgoWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHadActiveVLTestLessThanAMonthAgoWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1);
    DECLARE testDate DATE;
    DECLARE testResult INT(11);
    DECLARE viralLoadIndication VARCHAR(50);

    -- retrieve the test date and result
    CALL retrieveViralLoadTestDateAndResult(p_patientId, testDate, testResult, viralLoadIndication);

    RETURN (testDate IS NOT NULL AND testResult IS NOT NULL AND
        testDate > TIMESTAMPADD(MONTH, -1, CURDATE()) AND
        testResult >= 1000 AND
        testDate BETWEEN p_startDate AND p_endDate);

END$$ 
DELIMITER ;

-- wasIndexDateWithinReportingPeriod

DROP FUNCTION IF EXISTS wasIndexDateWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION wasIndexDateWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_checkDateAccepted TINYINT(1)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE indexDate DATE;
    DECLARE dateUuid VARCHAR(38) DEFAULT '836fe9d4-96f1-4fea-9ad8-35bd06e0ee05'; -- date offered concept uuid

    IF (p_checkDateAccepted) THEN 
        SET dateUuid = 'e7a002be-8afc-48b1-a81b-634e37f2961c'; -- date accepted concept uuid
    END IF;
    
    SELECT value_datetime INTO indexDate
    FROM obs
    WHERE voided = 0 AND person_id = p_patientId AND
        concept_id = (select concept_id from concept where uuid = dateUuid) AND
        value_datetime IS NOT NULL
    ORDER BY value_datetime DESC
    LIMIT 1;

    RETURN (indexDate BETWEEN p_startDate AND p_endDate);

END$$
DELIMITER ;


-- getDaysBetweenHIVPosAndEnrollment

DROP FUNCTION IF EXISTS getDaysBetweenHIVPosAndEnrollment;

DELIMITER $$
CREATE FUNCTION getDaysBetweenHIVPosAndEnrollment(
    p_patientId INT(11)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE enrollmentDate DATE;
    SET enrollmentDate = getPatientDateOfEnrolmentInProgram(p_patientId, "HIV_PROGRAM_KEY");
    RETURN (DATEDIFF(enrollmentDate, getDateOfPositiveHIVResult(p_patientId, "2000-01-01", enrollmentDate)));
END$$
DELIMITER ;

-- getDaysBetweenHIVPosAndART

DROP FUNCTION IF EXISTS getDaysBetweenHIVPosAndART;

DELIMITER $$
CREATE FUNCTION getDaysBetweenHIVPosAndART(
    p_patientId INT(11)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE artStartDate DATE;
    SET artStartDate = getPatientARVStartDate(p_patientId);
    RETURN (DATEDIFF(artStartDate, getDateOfPositiveHIVResult(p_patientId, "2000-01-01", artStartDate)));
END$$
DELIMITER ;

-- getTestedLocation

DROP FUNCTION IF EXISTS getTestedLocation;

DELIMITER $$
CREATE FUNCTION getTestedLocation(
    p_patientId INT(11)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE locationName VARCHAR(255);

    SELECT l.name INTO locationName
    FROM obs o
    JOIN concept_name cn ON cn.concept_id = o.concept_id
    JOIN location l ON o.location_id = l.location_id
    WHERE o.person_id = p_patientId
        AND o.voided = 0
        AND cn.name = 'Final Test Result'
    ORDER BY o.date_created DESC
    LIMIT 1;

    IF (locationName = "LOCATION_COMMUNITY_HOME") THEN
        RETURN "Community home";
    ELSEIF (locationName = "LOCATION_COMMUNITY_MOBILE") THEN
        RETURN "Community mobile";
    ELSE RETURN "Facility";
    END IF;

END$$
DELIMITER ;

-- getDateLatestVLResultShared

DROP FUNCTION IF EXISTS getDateLatestVLResultShared;

DELIMITER $$
CREATE FUNCTION getDateLatestVLResultShared(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    DECLARE routineViralLoadTestUuid VARCHAR(38) DEFAULT '4d80e0ce-5465-4041-9d1e-d281d25a9b50';
    DECLARE targetedViralLoadTestUuid VARCHAR(38) DEFAULT '9ee13e38-c7ce-11e9-a32f-2a2ae2dbcce4';
    DECLARE notDocumentedViralLoadTestUuid VARCHAR(38) DEFAULT '9ee140e0-c7ce-11e9-a32f-2a2ae2dbcce4';

    SELECT o.obs_datetime INTO result
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id
    WHERE o.person_id = p_patientId
        AND o.voided = 0
        AND c.uuid IN (routineViralLoadTestUuid, targetedViralLoadTestUuid, notDocumentedViralLoadTestUuid)
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN result;

END$$
DELIMITER ;

-- getMostRecentResistanceTestResult

DROP FUNCTION IF EXISTS getMostRecentResistanceTestResult;

DELIMITER $$
CREATE FUNCTION getMostRecentResistanceTestResult(
    p_patientId INT(11)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE reistanceTestUuid VARCHAR(38) DEFAULT '97a1a638-03b0-464e-bf75-4717f9f06c38';

    RETURN getObsCodedValue(p_patientId, reistanceTestUuid);
END$$
DELIMITER ;

-- getDateTBPosDiagnose

DROP FUNCTION IF EXISTS getDateTBPosDiagnose;

DELIMITER $$
CREATE FUNCTION getDateTBPosDiagnose(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;
    DECLARE uuidDateBaselineAssessment VARCHAR(38) DEFAULT "1d4a6dc4-c478-4021-982b-62e3c84f7857";
    DECLARE uuidMTBConfirmation VARCHAR(38) DEFAULT "c4bbc310-2e01-4c6d-be90-decc1b91a800";
    DECLARE uuidBacteriologicallyConfirmed VARCHAR(38) DEFAULT "41bde817-b2e0-4f58-88be-f875e7b31eed";
    DECLARE encounterId INT(11);

    SELECT o.encounter_id INTO encounterId
    FROM obs o
    WHERE o.voided = 0 AND
        o.concept_id = (SELECT c.concept_id FROM concept c WHERE c.uuid = uuidMTBConfirmation) AND
        o.value_coded = (SELECT c.concept_id FROM concept c WHERE c.uuid = uuidBacteriologicallyConfirmed)
    ORDER BY o.date_created DESC
    LIMIT 1;

    IF (encounterId IS NULL) THEN
        RETURN NULL;
    END IF;

    SELECT DATE(o.value_datetime) INTO result
    FROM obs o
    WHERE o.voided = 0 AND
        o.encounter_id = encounterId AND
        o.concept_id = (SELECT c.concept_id FROM concept c WHERE c.uuid = uuidDateBaselineAssessment)
    ORDER BY o.date_created DESC;

    RETURN result;
    
END$$
DELIMITER ;

-- getReasonLastVLExam

DROP FUNCTION IF EXISTS getReasonLastVLExam;

DELIMITER $$
CREATE FUNCTION getReasonLastVLExam(
    p_patientId INT(11)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(20);
    DECLARE routineViralLoadTestUuid VARCHAR(38) DEFAULT '4d80e0ce-5465-4041-9d1e-d281d25a9b50';
    DECLARE targetedViralLoadTestUuid VARCHAR(38) DEFAULT '9ee13e38-c7ce-11e9-a32f-2a2ae2dbcce4';
    DECLARE notDocumentedViralLoadTestUuid VARCHAR(38) DEFAULT '9ee140e0-c7ce-11e9-a32f-2a2ae2dbcce4';
    DECLARE nameVLExam VARCHAR(250);

    SELECT cn.name INTO nameVLExam
    FROM obs o
        JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
        JOIN concept_name cn ON cn.concept_id = c.concept_id AND cn.voided = 0 AND cn.locale = 'en' AND cn.locale_preferred = 1
    WHERE o.voided = 0
        AND o.value_numeric IS NOT NULL
        AND o.person_id = p_patientId
        AND c.uuid IN (routineViralLoadTestUuid,targetedViralLoadTestUuid,notDocumentedViralLoadTestUuid)
    ORDER BY o.obs_datetime DESC
    LIMIT 1;

    IF (nameVLExam IS NOT NULL) THEN
        RETURN REPLACE(nameVLExam, ' Viral Load', '');
    ELSE
        RETURN NULL;
    END IF;
END$$
DELIMITER ;

-- getDateVLResultGivenToPatient

DROP FUNCTION IF EXISTS getDateVLResultGivenToPatient;

DELIMITER $$
CREATE FUNCTION getDateVLResultGivenToPatient(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE testDate DATE DEFAULT getViralLoadTestDate(p_patientId);
    
    IF (testDate IS NOT NULL) THEN
        RETURN getDateOfNextVisit(p_patientId, testDate);
    ELSE
        RETURN NULL;
    END IF;
END$$
DELIMITER ;

-- getDateFirstANCVisit

DROP FUNCTION IF EXISTS getDateFirstANCVisit;

DELIMITER $$
CREATE FUNCTION getDateFirstANCVisit(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;
    DECLARE uuiddateOfANC1 VARCHAR(38) DEFAULT "57d91463-1b95-4e4d-9448-ee4e88c53cb9";
    
    SELECT
        o.value_datetime INTO result
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0 
        AND o.person_id = p_patientId
        AND c.uuid = uuiddateOfANC1
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getHistoricalDateOfNotification

DROP FUNCTION IF EXISTS getHistoricalDateOfNotification;

DELIMITER $$
CREATE FUNCTION getHistoricalDateOfNotification(
    p_patientProgramId INT(11),
    p_maxDate DATETIME) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;
    
    SELECT DATE(ppah.value_reference) INTO result
    FROM patient_program_attribute_history ppah
    JOIN program_attribute_type pat ON pat.program_attribute_type_id = ppah.attribute_type_id
    WHERE ppah.patient_program_id = p_patientProgramId
        AND ppah.date_created <= p_maxDate
        AND pat.name = "PROGRAM_MANAGEMENT_2_NOTIFICATION_DATE"
    ORDER BY ppah.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getMostRecentDateOfNotification

DROP FUNCTION IF EXISTS getMostRecentDateOfNotification;

DELIMITER $$
CREATE FUNCTION getMostRecentDateOfNotification(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT DATE(ppah.value_reference) INTO result
    FROM patient_program_attribute_history ppah
        JOIN program_attribute_type pat ON pat.program_attribute_type_id = ppah.attribute_type_id
        JOIN patient_program pp ON pp.patient_program_id = ppah.patient_program_id
        JOIN program p ON p.program_id = pp.program_id
    WHERE
        ppah.date_created BETWEEN p_startDate AND p_endDate AND
        pat.name = "PROGRAM_MANAGEMENT_2_NOTIFICATION_DATE" AND
        p.name = "INDEX_TESTING_PROGRAM_KEY"
    ORDER BY ppah.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getMostRecentNotificationOutcome

DROP FUNCTION IF EXISTS getMostRecentNotificationOutcome;

DELIMITER $$
CREATE FUNCTION getMostRecentNotificationOutcome(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT DATE(ppah.value_reference) INTO result
    FROM patient_program_attribute_history ppah
        JOIN program_attribute_type pat ON pat.program_attribute_type_id = ppah.attribute_type_id
        JOIN patient_program pp ON pp.patient_program_id = ppah.patient_program_id
        JOIN program p ON p.program_id = pp.program_id
    WHERE
        ppah.date_created BETWEEN p_startDate AND p_endDate AND
        pat.name = "PROGRAM_MANAGEMENT_3_NOTIFICATION_OUTCOME" AND
        p.name = "INDEX_TESTING_PROGRAM_KEY"
    ORDER BY ppah.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getNotificationOutcome

DROP FUNCTION IF EXISTS getNotificationOutcome;

DELIMITER $$
CREATE FUNCTION getNotificationOutcome(
    p_patientProgramId INT(11),
    p_maxDate DATETIME) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);
    
    SELECT cn.name INTO result
    FROM patient_program_attribute_history ppah
        JOIN program_attribute_type pat ON pat.program_attribute_type_id = ppah.attribute_type_id
        JOIN concept_name cn ON cn.concept_id = ppah.value_reference AND cn.locale = "en"
    WHERE ppah.patient_program_id = p_patientProgramId
        AND ppah.date_created <= p_maxDate
        AND pat.name = "PROGRAM_MANAGEMENT_3_NOTIFICATION_OUTCOME"
    ORDER BY ppah.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;
