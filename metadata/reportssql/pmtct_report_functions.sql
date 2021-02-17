-- PMTCT Report

DROP FUNCTION IF EXISTS PMTCT_Indicator1;

DELIMITER $$
CREATE FUNCTION PMTCT_Indicator1(
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientDateOfFirstANCVisitOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PMTCT_Indicator2;

DELIMITER $$
CREATE FUNCTION PMTCT_Indicator2(
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    NOT patientHIVTestedPriorToEnrolOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientHIVTestedAtEnrolOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND 
    patientGenderIs(pat.patient_id, 'F');

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PMTCT_Indicator3;

DELIMITER $$
CREATE FUNCTION PMTCT_Indicator3(
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    DECLARE uuidHIVTestResultPositive VARCHAR(38) DEFAULT "7acfafa4-f19b-485e-97a7-c9e002dbe37a";
    DECLARE uuidHIVTestResultNegative VARCHAR(38) DEFAULT "718b4589-2a11-4355-b8dc-aa668a93e098";
    DECLARE uuidHIVTestResultIndeterminate VARCHAR(38) DEFAULT "32c3c2e4-317f-4c49-b927-34b3752e05cb";

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    NOT patientHIVTestedPriorToEnrolOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    (
        patientHIVTestResultWithinReportingPeriodIs(pat.patient_id, p_startDate, p_endDate, uuidHIVTestResultPositive, 0) OR
        patientHIVTestResultWithinReportingPeriodIs(pat.patient_id, p_startDate, p_endDate, uuidHIVTestResultNegative, 0) OR
        patientHIVTestResultWithinReportingPeriodIs(pat.patient_id, p_startDate, p_endDate, uuidHIVTestResultIndeterminate, 0)
    ) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND
    patientGenderIs(pat.patient_id, "F");

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PMTCT_Indicator4;

DELIMITER $$
CREATE FUNCTION PMTCT_Indicator4(
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    DECLARE uuidHIVTestResultPositive VARCHAR(38) DEFAULT "7acfafa4-f19b-485e-97a7-c9e002dbe37a";

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    NOT patientHIVTestedPriorToEnrolOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientHIVTestResultWithinReportingPeriodIs(pat.patient_id, p_startDate, p_endDate, uuidHIVTestResultPositive, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND
    patientGenderIs(pat.patient_id, "F");

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PMTCT_Indicator5;

DELIMITER $$
CREATE FUNCTION PMTCT_Indicator5(
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    DECLARE uuidHIVTestResultPositive VARCHAR(38) DEFAULT "7acfafa4-f19b-485e-97a7-c9e002dbe37a";

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientDateOfFirstANCVisitOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientHasHIVPOSTestPriorToEnrolOnANCFormBeforeReportingPeriod(pat.patient_id, p_startDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND
    patientGenderIs(pat.patient_id, "F");

    RETURN (result);
END$$ 
DELIMITER ;

-- patientHIVTestedPriorToEnrolOnANCFormWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHIVTestedPriorToEnrolOnANCFormWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHIVTestedPriorToEnrolOnANCFormWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE hivTestedWithinReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuidHIVTested VARCHAR(38) DEFAULT "dbfbf26c-a236-40f7-812a-4171b0daac4c";
    DECLARE uuidYes VARCHAR(38) DEFAULT "a2065636-5326-40f5-aed6-0cc2cca81ccc";
    DECLARE priorToANCEnrolmentObsGroupId INT(11) DEFAULT getPriorToANCEnrolmentObsGroupId(p_patientId, p_startDate, p_endDate);

    SELECT
        TRUE INTO hivTestedWithinReportingPeriod
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE priorToANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = priorToANCEnrolmentObsGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTested
        AND o.value_coded IS NOT NULL
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = uuidYes)
        LIMIT 1;

    RETURN (hivTestedWithinReportingPeriod);
END$$
DELIMITER ;

-- patientHIVTestedAtEnrolOnANCFormWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHIVTestedAtEnrolOnANCFormWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHIVTestedAtEnrolOnANCFormWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE hivTestDateWithinReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE atANCEnrolmentObsGroupId INT(11) DEFAULT getAtEnrolOnANCFormObsGroupId(p_patientId, p_startDate, p_endDate);

    SELECT
        TRUE INTO hivTestDateWithinReportingPeriod
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE atANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = atANCEnrolmentObsGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestDate
        AND DATE(o.value_datetime) BETWEEN p_startDate AND p_endDate
        LIMIT 1;

    RETURN (hivTestDateWithinReportingPeriod);
END$$
DELIMITER ;

-- patientHasHIVPOSTestPriorToEnrolOnANCFormBeforeReportingPeriod

DROP FUNCTION IF EXISTS patientHasHIVPOSTestPriorToEnrolOnANCFormBeforeReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasHIVPOSTestPriorToEnrolOnANCFormBeforeReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE HIVPOSTestGroupId INT(11) DEFAULT 0;
    DECLARE patientTestDateIsBeforeReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuidPriorToANCEnrolment VARCHAR(38) DEFAULT "130e05df-8283-453b-a611-d4f884fac8e0";
    DECLARE uuidHIVTestResult VARCHAR(38) DEFAULT "85dadffe-5714-4210-8632-6fb51ef593b6";
    DECLARE uuidHIVTestResultPositive VARCHAR(38) DEFAULT "7acfafa4-f19b-485e-97a7-c9e002dbe37a";
    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";

    SELECT
        o.obs_group_id INTO HIVPOSTestGroupId
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0 
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestResult
        AND o.value_coded IS NOT NULL
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = uuidHIVTestResultPositive)
        AND (SELECT obs.concept_id FROM obs WHERE obs_id = o.obs_group_id) = (SELECT concept_id FROM concept WHERE concept.uuid = uuidPriorToANCEnrolment)
        LIMIT 1;

    SELECT
        TRUE INTO patientTestDateIsBeforeReportingPeriod
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE HIVPOSTestGroupId IS NOT NULL
        AND o.obs_group_id = HIVPOSTestGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestDate
        AND o.value_datetime IS NOT NULL
        AND DATE(o.value_datetime) < p_startDate
        LIMIT 1;

    RETURN patientTestDateIsBeforeReportingPeriod;
END$$
DELIMITER ;

-- getViralLoadIndication

DROP FUNCTION IF EXISTS getViralLoadIndication;

DELIMITER $$
CREATE FUNCTION getViralLoadIndication(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE testDate DATE;
    DECLARE testResult INT(11);
    DECLARE viralLoadIndication VARCHAR(50);

    CALL retrieveViralLoadTestDateAndResult(p_patientId, testDate, testResult, viralLoadIndication);

    RETURN viralLoadIndication;
END$$
DELIMITER ;

-- getHIVDefaulterStatus

DROP FUNCTION IF EXISTS getHIVDefaulterStatus;

DELIMITER $$
CREATE FUNCTION getHIVDefaulterStatus(
    p_patientId INT(11)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE patientIsDefaulter TINYINT(1) DEFAULT patientIsDefaulter(p_patientId);
    DECLARE patientEnrolledInDefaultersProgram TINYINT(1) DEFAULT patientHasEnrolledInDefaulterProgram(p_patientId);
    DECLARE defaulterProgramOutcome VARCHAR(250) DEFAULT getPatientMostRecentProgramOutcome(p_patientId, "en", 'HIV_DEFAULTERS_PROGRAM_KEY');

    IF (defaulterProgramOutcome IS NOT NULL) THEN
        RETURN defaulterProgramOutcome;
    ELSEIF (patientEnrolledInDefaultersProgram) THEN
        RETURN "Tracking started, not yet returned to care";
    ELSEIF (patientIsDefaulter) THEN
        RETURN "Tracking hasn't started";
    ELSE
        RETURN NULL;
    END IF;

END$$
DELIMITER ;

-- getInfantOutcomeAt18Months

DROP FUNCTION IF EXISTS getInfantOutcomeAt18Months;

DELIMITER $$
CREATE FUNCTION getInfantOutcomeAt18Months(
    p_patientId INT(11)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE uuidPCRTest VARCHAR(38) DEFAULT "a5239a85-6f75-4882-9b9b-60168e54b7da";
    DECLARE uuidPCRTestDate VARCHAR(38) DEFAULT "9bb7b360-3790-4e1a-8aca-0d1341663040";

    DECLARE testResult VARCHAR(50);
    DECLARE testDate DATE;

    CALL retrieveTestDateAndResultWithinReportingPeriod(p_patientId, "2000-01-01", "2100-01-01", uuidPCRTest, uuidPCRTestDate, testDate, testResult);

    IF (timestampdiff(MONTH, getPatientBirthdate(p_patientId), testDate) = 18) THEN
        RETURN testResult;
    END IF;

    RETURN NULL;

END$$
DELIMITER ;

-- getPatientARTStatus

DROP FUNCTION IF EXISTS getPatientARTStatus;

DELIMITER $$
CREATE FUNCTION getPatientARTStatus(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    
    IF (patientHasStartedARVTreatmentDuringReportingPeriod(p_patientId, p_startDate, p_endDate)) THEN
        RETURN "Newly enrolled";
    END IF;

    IF (patientHasStartedARVTreatmentBefore(p_patientId, p_startDate)) THEN
        RETURN "Already enrolled";
    END IF;

    RETURN NULL;
END$$
DELIMITER ;
