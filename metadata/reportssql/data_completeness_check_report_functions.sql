
-- getPatientEntryPointAndModality

DROP FUNCTION IF EXISTS getPatientEntryPointAndModality;

DELIMITER $$
CREATE FUNCTION getPatientEntryPointAndModality(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE uuidEntryPointAndModality VARCHAR(38) DEFAULT "bc43179d-00b4-4712-a5d6-4dabd4230888";
    DECLARE entryPointAndModality VARCHAR(50) DEFAULT getObsCodedShortNameValue(p_patientId, uuidEntryPointAndModality);
    DECLARE entryPointAndModalityDate DATE;
    
    IF (entryPointAndModality IS NOT NULL) THEN
        SET entryPointAndModalityDate = getObsCreatedDate(p_patientId, uuidEntryPointAndModality);
        RETURN CONCAT(entryPointAndModality, " (", DATE_FORMAT(entryPointAndModalityDate, "%d-%b-%Y"), ")");
    ELSE
        RETURN NULL;
    END IF;
END$$ 
DELIMITER ;

-- getGreatestDate

DROP FUNCTION IF EXISTS getGreatestDate;

DELIMITER $$
CREATE FUNCTION getGreatestDate(
    p_date1 DATE,
    p_date2 DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    IF (p_date1 > p_date2 OR p_date2 IS NULL) THEN
        RETURN p_date1;
    ELSE
        RETURN p_date2;
    END IF;
END$$ 
DELIMITER ;

-- getPatientHivInitialFormLastModificationDate

DROP FUNCTION IF EXISTS getPatientHivInitialFormLastModificationDate;

DELIMITER $$
CREATE FUNCTION getPatientHivInitialFormLastModificationDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    DECLARE uuidAdultHivInitialForm VARCHAR(38) DEFAULT "1fb2dd86-53b5-4815-9c64-edc081b908d9";
    DECLARE uuidChildHivInitialForm VARCHAR(38) DEFAULT "48a724c1-fd24-45da-855c-33fcb4ce9c5d";

    DECLARE dateLastChangeInAdultForm DATE DEFAULT getObsLastModifiedDate(p_patientId, uuidAdultHivInitialForm);
    DECLARE dateLastChangeInChildForm DATE DEFAULT getObsLastModifiedDate(p_patientId, uuidChildHivInitialForm);
    
    RETURN getGreatestDate(dateLastChangeInAdultForm, dateLastChangeInChildForm);
END$$ 
DELIMITER ;

-- getPatientHivFollowUpFormLastModificationDate

DROP FUNCTION IF EXISTS getPatientHivFollowUpFormLastModificationDate;

DELIMITER $$
CREATE FUNCTION getPatientHivFollowUpFormLastModificationDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    DECLARE uuidAdultHivFollowUpForm VARCHAR(38) DEFAULT "41cd339f-27fb-4acb-8841-74c9ea1069f1";
    DECLARE uuidChildHivFollowUpForm VARCHAR(38) DEFAULT "9e38f9c3-1f04-4221-b5c9-51d5adbe1931";

    DECLARE dateLastChangeInAdultForm DATE DEFAULT getObsLastModifiedDate(p_patientId, uuidAdultHivFollowUpForm);
    DECLARE dateLastChangeInChildForm DATE DEFAULT getObsLastModifiedDate(p_patientId, uuidChildHivFollowUpForm);
    
    RETURN getGreatestDate(dateLastChangeInAdultForm, dateLastChangeInChildForm);
END$$ 
DELIMITER ;

-- getPatientLabResultLastModificationDate

DROP FUNCTION IF EXISTS getPatientLabResultLastModificationDate;

DELIMITER $$
CREATE FUNCTION getPatientLabResultLastModificationDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN

    DECLARE uuidLabResultForm VARCHAR(38) DEFAULT "3b5b8d72-2f86-48fc-9b81-0be908ed392c";

    RETURN getObsLastModifiedDate(p_patientId, uuidLabResultForm);

END$$ 
DELIMITER ;

-- getPatientChildExposedLastModificationDate

DROP FUNCTION IF EXISTS getPatientChildExposedLastModificationDate;

DELIMITER $$
CREATE FUNCTION getPatientChildExposedLastModificationDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN

    DECLARE uuidChildExposedForm VARCHAR(38) DEFAULT "81c7f82b-0c8b-4d02-ad0c-5c3935689642";

    RETURN getObsLastModifiedDate(p_patientId, uuidChildExposedForm);

END$$ 
DELIMITER ;

-- getPatientChildExposedFollowUpLastModificationDate

DROP FUNCTION IF EXISTS getPatientChildExposedFollowUpLastModificationDate;

DELIMITER $$
CREATE FUNCTION getPatientChildExposedFollowUpLastModificationDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN

    DECLARE uuidChildExposedFollowUpForm VARCHAR(38) DEFAULT "ac96f10d-6bb9-49c8-9cf7-cec3c10c2112";

    RETURN getObsLastModifiedDate(p_patientId, uuidChildExposedFollowUpForm);

END$$ 
DELIMITER ;

-- getPatientANCInitialLastModificationDate

DROP FUNCTION IF EXISTS getPatientANCInitialLastModificationDate;

DELIMITER $$
CREATE FUNCTION getPatientANCInitialLastModificationDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN

    DECLARE uuidANCInitialForm VARCHAR(38) DEFAULT "14815716-7d9a-4306-8f05-f27c3ff30709";

    RETURN getObsLastModifiedDate(p_patientId, uuidANCInitialForm);

END$$ 
DELIMITER ;

-- getPatientANCFollowUpLastModificationDate

DROP FUNCTION IF EXISTS getPatientANCFollowUpLastModificationDate;

DELIMITER $$
CREATE FUNCTION getPatientANCFollowUpLastModificationDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN

    DECLARE uuidANCFollowUpForm VARCHAR(38) DEFAULT "bf0c145e-5e7a-41a2-a081-a98fc3723ffd";

    RETURN getObsLastModifiedDate(p_patientId, uuidANCFollowUpForm);

END$$ 
DELIMITER ;

-- getPatientHIVTestingAndCounsellingLastModificationDate

DROP FUNCTION IF EXISTS getPatientHIVTestingAndCounsellingLastModificationDate;

DELIMITER $$
CREATE FUNCTION getPatientHIVTestingAndCounsellingLastModificationDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN

    DECLARE uuidHIVTestingAndCounsellingForm VARCHAR(38) DEFAULT "6bfd85ce-22c8-4b54-af0e-ab0af24240e3";

    RETURN getObsLastModifiedDate(p_patientId, uuidHIVTestingAndCounsellingForm);

END$$ 
DELIMITER ;

-- getPatientHistoryAndExaminationLastModificationDate

DROP FUNCTION IF EXISTS getPatientHistoryAndExaminationLastModificationDate;

DELIMITER $$
CREATE FUNCTION getPatientHistoryAndExaminationLastModificationDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN

    DECLARE uuidHistoryAndExaminationForm VARCHAR(38) DEFAULT "c393fd1d-3f10-11e4-adec-0800271c1b75";

    RETURN getObsLastModifiedDate(p_patientId, uuidHistoryAndExaminationForm);

END$$ 
DELIMITER ;

-- getPatientSystemAndPhysicalExamLastModificationDate

DROP FUNCTION IF EXISTS getPatientSystemAndPhysicalExamLastModificationDate;

DELIMITER $$
CREATE FUNCTION getPatientSystemAndPhysicalExamLastModificationDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN

    DECLARE uuidSystemAndPhysicalExamForm VARCHAR(38) DEFAULT "b92d7a42-0127-45b9-86c1-57075a405e0e";

    RETURN getObsLastModifiedDate(p_patientId, uuidSystemAndPhysicalExamForm);

END$$ 
DELIMITER ;

-- getPatientInformedConsent

DROP FUNCTION IF EXISTS getPatientInformedConsent;

DELIMITER $$
CREATE FUNCTION getPatientInformedConsent(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE uuidInformedConsent VARCHAR(38) DEFAULT "a55e6e56-d3a2-45a8-aa78-3f6a940f609a";
    DECLARE informedConsent VARCHAR(5) DEFAULT getObsCodedValue(p_patientId, uuidInformedConsent);
    DECLARE informedConsentDate DATE;

    IF informedConsent = "True" THEN 
        SET informedConsent = "Yes";
    ELSEIF informedConsent = "False" THEN
        SET informedConsent = "No";
    END IF;

    IF (informedConsent IS NOT NULL) THEN
        SET informedConsentDate = getObsCreatedDate(p_patientId, uuidInformedConsent);
        RETURN CONCAT(informedConsent, " (", DATE_FORMAT(informedConsentDate, "%d-%b-%Y"), ")");
    ELSE
        RETURN NULL;
    END IF;

END$$
DELIMITER ;

-- getPatientHIVTestDate

DROP FUNCTION IF EXISTS getPatientHIVTestDate;

DELIMITER $$
CREATE FUNCTION getPatientHIVTestDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE uuidHIVTest VARCHAR(38) DEFAULT "b70dfca0-db21-4533-8c08-4626ff0de265";

    RETURN getObsDatetimeValueInSection(p_patientId, uuidHIVTestDate, uuidHIVTest);
END$$
DELIMITER ;

-- getPatientHIVFinalTestResult

DROP FUNCTION IF EXISTS getPatientHIVFinalTestResult;

DELIMITER $$
CREATE FUNCTION getPatientHIVFinalTestResult(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE uuidHIVFinalResult VARCHAR(38) DEFAULT "41e48d08-2235-47d5-af12-87a009057603";
    DECLARE hivFinalResult VARCHAR(50) DEFAULT getObsCodedValue(p_patientId, uuidHIVFinalResult);
    DECLARE hivFinalResultDate DATE;
    
    IF (hivFinalResult IS NOT NULL) THEN
        SET hivFinalResultDate = getObsCreatedDate(p_patientId, uuidHIVFinalResult);
        RETURN CONCAT(hivFinalResult, " (", DATE_FORMAT(hivFinalResultDate, "%d-%b-%Y"), ")");
    ELSE
        RETURN NULL;
    END IF;

END$$
DELIMITER ;

-- getPatientIndexTestingOffered

DROP FUNCTION IF EXISTS getPatientIndexTestingOffered;

DELIMITER $$
CREATE FUNCTION getPatientIndexTestingOffered(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE uuidIndexTestingOffered VARCHAR(38) DEFAULT "533f4c86-1324-4260-bce5-0f872a556963";
    RETURN getObsYesNoValueWithDate(p_patientId, uuidIndexTestingOffered);
END$$
DELIMITER ;

-- getPatientIndexTestingAccepted

DROP FUNCTION IF EXISTS getPatientIndexTestingAccepted;

DELIMITER $$
CREATE FUNCTION getPatientIndexTestingAccepted(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE uuidIndexTestingAccepted VARCHAR(38) DEFAULT "78d13812-cd29-4214-9a58-a8710fd69cff";
    RETURN getObsYesNoValueWithDate(p_patientId, uuidIndexTestingAccepted);
END$$
DELIMITER ;

-- patientHadALeastOneViralLoadExam

DROP FUNCTION IF EXISTS patientHadALeastOneViralLoadExam;

DELIMITER $$
CREATE FUNCTION patientHadALeastOneViralLoadExam(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE viralLoadTestDate DATE DEFAULT getViralLoadTestDate(p_patientId);

    IF viralLoadTestDate IS NOT NULL THEN
        RETURN CONCAT("Yes (", DATE_FORMAT(viralLoadTestDate, "%d-%b-%Y"), ")");
    ELSE
        RETURN NULL;
    END IF;

END$$
DELIMITER ;

-- patientHadACD4Exam

DROP FUNCTION IF EXISTS patientHadACD4Exam;

DELIMITER $$
CREATE FUNCTION patientHadACD4Exam(
    p_patientId INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE uuidCD4Exam VARCHAR(38) DEFAULT "809dd0f5-ce54-441c-b835-a2a8b06a6140";
    DECLARE uuidCD4ExamDate VARCHAR(38) DEFAULT "c036cb1f-d061-40f4-b0f6-2401b4607f59";
    DECLARE examResult INT(11) DEFAULT getObsNumericValue(p_patientId, uuidCD4Exam);
    DECLARE examResultDate DATE;

    IF examResult IS NOT NULL THEN
        -- RETURN "Yes";
        SET examResultDate = getMostRecentTestResultDate(p_patientId, uuidCD4Exam, uuidCD4ExamDate);
        IF examResultDate IS NOT NULL THEN
            RETURN CONCAT("Yes (", DATE_FORMAT(examResultDate, "%d-%b-%Y"), ")");
        ELSE
            RETURN "Yes";
        END IF;
    ELSE
        RETURN NULL;
    END IF;

END$$
DELIMITER ;

-- getMostRecentTestResultDate

DROP FUNCTION IF EXISTS getMostRecentTestResultDate;

DELIMITER $$
CREATE FUNCTION getMostRecentTestResultDate(
    p_patientId INT(11),
    p_uuidTest VARCHAR(38),
    p_uuidTestDate VARCHAR(38)) RETURNS DATE
    DETERMINISTIC
BEGIN

    DECLARE resultDateFromForm DATE DEFAULT getObsDatetimeValue(p_patientId, p_uuidTestDate);
    DECLARE resultDateFromElis DATE;

    SELECT
        o.date_created INTO resultDateFromElis
    FROM obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.order_id IS NOT NULL
        AND o.person_id = p_patientId
        AND c.uuid = p_uuidTest
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN getGreatestDate(resultDateFromForm,resultDateFromElis);

END$$
DELIMITER ;

-- patientHadAHivRelatedVisitWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHadAHivRelatedVisitWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHadAHivRelatedVisitWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1);

    SELECT TRUE INTO result
    FROM encounter e
    JOIN `location` loc ON loc.location_id = e.location_id
    WHERE e.voided = 0
        AND e.patient_id = p_patientId
        AND e.encounter_datetime BETWEEN p_startDate AND p_endDate
        AND loc.name IN (
            "LOCATION_ANC",
            "LOCATION_ART",
            "LOCATION_ART_DISPENSATION",
            "LOCATION_OPD"
        )
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getDateLatestARTOrARTDispensaryVisit

DROP FUNCTION IF EXISTS getDateLatestARTOrARTDispensaryVisit;

DELIMITER $$
CREATE FUNCTION getDateLatestARTOrARTDispensaryVisit(
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
            "LOCATION_ART_DISPENSATION"
        )
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getDateLatestARVRelatedVisit

DROP FUNCTION IF EXISTS getDateLatestARVRelatedVisit;

DELIMITER $$
CREATE FUNCTION getDateLatestARVRelatedVisit(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT v.date_started INTO result
    FROM visit v
    JOIN visit_type vt ON vt.visit_type_id = v.visit_type_id
    WHERE v.voided = 0
        AND v.patient_id = p_patientId
        AND vt.name IN (
            "VISIT_TYPE_ANC",
            "VISIT_TYPE_ART",
            "VISIT_TYPE_ART_DISPENSATION",
            "VISIT_TYPE_OPD",
            "Special OPD"
        )
    ORDER BY v.date_started DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getNumberOfVisits

DROP FUNCTION IF EXISTS getNumberOfVisits;

DELIMITER $$
CREATE FUNCTION getNumberOfVisits(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_location VARCHAR(255)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11);

    SELECT count(DISTINCT e.encounter_id) INTO result
    FROM encounter e
    JOIN `location` loc ON loc.location_id = e.location_id
    WHERE e.voided = 0
        AND e.patient_id = p_patientId
        AND e.encounter_datetime BETWEEN p_startDate AND p_endDate
        AND loc.name = p_location
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;
