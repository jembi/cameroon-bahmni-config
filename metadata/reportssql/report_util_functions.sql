
-- patientGenderIs

DROP FUNCTION IF EXISTS patientGenderIs;

DELIMITER $$
CREATE FUNCTION patientGenderIs(
    p_patientId INT(11),
    p_gender VARCHAR(1)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT p.gender = p_gender INTO result
    FROM person p
    WHERE p.person_id = p_patientId AND p.voided = 0;

    RETURN (result );
END$$
DELIMITER ;

-- patientAgeWhenRegisteredForHivProgramIsBetween

DROP FUNCTION IF EXISTS patientAgeWhenRegisteredForHivProgramIsBetween;  

DELIMITER $$ 
CREATE FUNCTION patientAgeWhenRegisteredForHivProgramIsBetween(
    p_patientId INT(11),
    p_startAge INT(11),
    p_endAge INT(11),
    p_includeEndAge TINYINT(1)) RETURNS TINYINT(1) 
    DETERMINISTIC 
BEGIN 
    DECLARE result TINYINT(1) DEFAULT 0; 
    SELECT  
        IF (p_includeEndAge, 
            timestampdiff(YEAR, p.birthdate, pp.date_enrolled) BETWEEN p_startAge AND p_endAge, 
            timestampdiff(YEAR, p.birthdate, pp.date_enrolled) >= p_startAge
                AND timestampdiff(YEAR, p.birthdate, pp.date_enrolled) < p_endAge
        ) INTO result  
    FROM person p 
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0 
    JOIN program pro ON pp.program_id = pro.program_id AND pro.retired = 0 
    WHERE p.person_id = p_patientId AND p.voided = 0 
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result ); 
END$$ 
DELIMITER ;

-- patientHasEnrolledIntoHivProgramBefore

DROP FUNCTION IF EXISTS patientHasEnrolledIntoHivProgramBefore;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledIntoHivProgramBefore(
    p_patientId INT(11),
    p_date DATE) RETURNS TINYINT(1)
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
        AND DATE(pp.date_enrolled) < p_date
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result );
END$$
DELIMITER ;

-- patientHasEnrolledIntoHivProgramDuringReportingPeriod

DROP FUNCTION IF EXISTS patientHasEnrolledIntoHivProgramDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledIntoHivProgramDuringReportingPeriod(
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
        AND DATE(pp.date_enrolled) BETWEEN p_startDate AND p_endDate
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result );
END$$
DELIMITER ;

-- patientHasEnrolledIntoHivProgramDuringOrBeforeReportingPeriod

DROP FUNCTION IF EXISTS patientHasEnrolledIntoHivProgramDuringOrBeforeReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledIntoHivProgramDuringOrBeforeReportingPeriod(
    p_patientId INT(11),
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
        AND DATE(pp.date_enrolled) <= p_endDate
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result );
END$$
DELIMITER ;

-- patientHasRegisteredWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHasRegisteredWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasRegisteredWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT
        TRUE INTO result
    FROM patient p
    WHERE p.patient_id = p_patientId
        AND p.voided = 0
        AND CAST(p.date_created AS DATE) BETWEEN p_startDate AND p_endDate;

    RETURN (result );
END$$
DELIMITER ;

-- patientHasEnrolledIntoHivProgram

DROP FUNCTION IF EXISTS patientHasEnrolledIntoHivProgram;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledIntoHivProgram(
    p_patientId INT(11)) RETURNS VARCHAR(3)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(3) DEFAULT "No";

    SELECT
        "Yes" INTO result
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE p.person_id = p_patientId
        AND p.voided = 0
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result);
END$$
DELIMITER ;

-- arvInitiationDateSpecified

DROP FUNCTION IF EXISTS arvInitiationDateSpecified;

DELIMITER $$
CREATE FUNCTION arvInitiationDateSpecified(
    p_patientId INT(11)) RETURNS VARCHAR(3)
    DETERMINISTIC
BEGIN
    IF getPatientProgramTreatmentStartDate(p_patientId) IS NOT NULL THEN
        RETURN "Yes";
    ELSE
        RETURN "No";
    END IF;
END$$
DELIMITER ;

-- getPatientDateOfEnrolmentInHIVProgram

DROP FUNCTION IF EXISTS getPatientDateOfEnrolmentInHIVProgram;

DELIMITER $$
CREATE FUNCTION getPatientDateOfEnrolmentInHIVProgram(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    RETURN getPatientDateOfEnrolmentInProgram(p_patientId, "HIV_PROGRAM_KEY");
END$$
DELIMITER ;

-- patientHasAtLeastOneArvDrugPrescribed

DROP FUNCTION IF EXISTS patientHasAtLeastOneArvDrugPrescribed;

DELIMITER $$
CREATE FUNCTION patientHasAtLeastOneArvDrugPrescribed(
    p_patientId INT(11)) RETURNS VARCHAR(3)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(3) DEFAULT "No";

    SELECT "Yes" INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
    GROUP BY o.patient_id;

    RETURN (result);
END$$
DELIMITER ;

-- patientLatestArvDrugWasDispensed

DROP FUNCTION IF EXISTS patientLatestArvDrugWasDispensed;

DELIMITER $$
CREATE FUNCTION patientLatestArvDrugWasDispensed(
    p_patientId INT(11)) RETURNS VARCHAR(3)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(3) DEFAULT "No";

    SELECT "Yes" INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    GROUP BY o.patient_id;

    RETURN (result);
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

-- mostRecentNotDocumentedViralLoadExamIsBelow

DROP FUNCTION IF EXISTS mostRecentNotDocumentedViralLoadExamIsBelow;

DELIMITER $$
CREATE FUNCTION mostRecentNotDocumentedViralLoadExamIsBelow(
    p_patientId INT(11),
    p_endDate DATE,
    p_examResult INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE uuidNotDocumentedViralLoadExam VARCHAR(38) DEFAULT "9ee140e0-c7ce-11e9-a32f-2a2ae2dbcce4";
    DECLARE uuidNotDocumentedViralLoadExamDate VARCHAR(38) DEFAULT "ac4797de-c891-11e9-a32f-2a2ae2dbcce4";

    return mostRecentViralLoadExamIsBelow(uuidNotDocumentedViralLoadExam, uuidNotDocumentedViralLoadExamDate, p_patientId, p_endDate, p_examResult);

END$$ 
DELIMITER ;

-- mostRecentRoutineViralLoadExamIsBelow

DROP FUNCTION IF EXISTS mostRecentRoutineViralLoadExamIsBelow;

DELIMITER $$
CREATE FUNCTION mostRecentRoutineViralLoadExamIsBelow(
    p_patientId INT(11),
    p_endDate DATE,
    p_examResult INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE uuidRoutineViralLoadExam VARCHAR(38) DEFAULT "4d80e0ce-5465-4041-9d1e-d281d25a9b50";
    DECLARE uuidRoutineViralLoadExamDate VARCHAR(38) DEFAULT "cac6bf44-f671-4f85-ab76-71e7f099d3cb";

    return mostRecentViralLoadExamIsBelow(uuidRoutineViralLoadExam, uuidRoutineViralLoadExamDate, p_patientId, p_endDate, p_examResult);

END$$ 
DELIMITER ;

-- mostRecentTargetedViralLoadExamIsBelow

DROP FUNCTION IF EXISTS mostRecentTargetedViralLoadExamIsBelow;

DELIMITER $$
CREATE FUNCTION mostRecentTargetedViralLoadExamIsBelow(
    p_patientId INT(11),
    p_endDate DATE,
    p_examResult INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE uuidTargetedViralLoadExam VARCHAR(38) DEFAULT "9ee13e38-c7ce-11e9-a32f-2a2ae2dbcce4";
    DECLARE uuidTargetedViralLoadExamDate VARCHAR(38) DEFAULT "ac479522-c891-11e9-a32f-2a2ae2dbcce4";

    return mostRecentViralLoadExamIsBelow(uuidTargetedViralLoadExam, uuidTargetedViralLoadExamDate, p_patientId, p_endDate, p_examResult);

END$$ 
DELIMITER ;

-- mostRecentViralLoadExamIsBelow

DROP FUNCTION IF EXISTS mostRecentViralLoadExamIsBelow;

DELIMITER $$
CREATE FUNCTION mostRecentViralLoadExamIsBelow(
    p_uuidViralLoadExam VARCHAR(38),
    p_uuidViralLoadExamDate VARCHAR(38),
    p_patientId INT(11),
    p_endDate DATE,
    p_examResult INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE testDateFromForm DATE;
    DECLARE testDateFromOpenElis DATE;
    DECLARE useFormResult TINYINT(1) DEFAULT 0;
    DECLARE testResultFromForm INT(11);
    DECLARE testResultFromOpenElis INT(11);
    DECLARE encounterIdOfFormResult INT(11);

    -- Read and store latest test date and result from form "LAB RESULTS - ADD MANUALLY" that is before p_endDate
    SELECT
        o.value_datetime, o.encounter_id
        INTO testDateFromForm, encounterIdOfFormResult
    FROM obs o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.order_id IS NULL
        AND o.value_datetime IS NOT NULL
        AND o.value_datetime < p_endDate
        AND o.person_id = p_patientId
        AND c.uuid = p_uuidViralLoadExamDate
    ORDER BY o.value_datetime DESC
    LIMIT 1;

    SELECT o.value_numeric INTO testResultFromForm
    FROM obs o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.encounter_id = encounterIdOfFormResult
        AND o.order_id IS NULL
        AND o.value_numeric IS NOT NULL
        AND o.person_id = p_patientId
        AND c.uuid = p_uuidViralLoadExam
    ORDER BY o.obs_id DESC
    LIMIT 1;

    -- read and store latest test date and result from elis that is before p_endDate
    SELECT
        o.obs_datetime, o.value_numeric
        INTO testDateFromOpenElis, testResultFromOpenElis
    FROM obs o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.order_id IS NOT NULL
        AND o.value_numeric IS NOT NULL
        AND o.person_id = p_patientId
        AND c.uuid = p_uuidViralLoadExam
        AND o.obs_datetime < p_endDate
    ORDER BY o.obs_datetime DESC
    LIMIT 1;

    -- return 0 if both dates are null
    IF (testDateFromForm IS NULL AND testDateFromOpenElis IS NULL) THEN
        RETURN 0;
    END IF;

    -- decide which result to use
    IF (testDateFromOpenElis IS NULL OR (testDateFromForm IS NOT NULL AND testDateFromForm > testDateFromOpenElis)) THEN
        SET useFormResult = 1;
    END IF;

    -- verify if result < p_examResult
    IF (useFormResult) THEN
        return testResultFromForm < p_examResult;
    ELSE
        return testResultFromOpenElis < p_examResult;
    END IF;

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
    DECLARE enrolmentDate DATE DEFAULT getPatientProgramTreatmentStartDate(p_patientId);
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

-- patientWasOnARVTreatmentDuringReportingPeriod

DROP FUNCTION IF EXISTS patientWasOnARVTreatmentDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientWasOnARVTreatmentDuringReportingPeriod(
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
        AND patientHasTherapeuticLine(p_patientId, 0)
        AND o.scheduled_date <= p_endDate
        AND calculateTreatmentEndDate(
            o.scheduled_date,
            do.duration,
            c.uuid -- uuid of the duration unit concept
            ) >= p_startDate
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    GROUP BY o.patient_id;

    RETURN (result );
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

-- patientTherapeuticLineSpecified

DROP FUNCTION IF EXISTS patientTherapeuticLineSpecified;

DELIMITER $$
CREATE FUNCTION patientTherapeuticLineSpecified(
    p_patientId INT(11)) RETURNS VARCHAR(3)
    DETERMINISTIC
BEGIN

    IF patientHasTherapeuticLine(p_patientId, 0) = 1 THEN
        RETURN 'Yes';
    ELSE
        RETURN 'No';
    END IF;

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
        AND o.scheduled_date BETWEEN TIMESTAMPADD(MONTH,p_monthOffset,p_startDate) AND TIMESTAMPADD(MONTH,p_monthOffset,p_endDate)
    GROUP BY o.patient_id;

    RETURN (drugNotDispensed OR drugNotOrdered);
END$$ 
DELIMITER ;

-- patientHasScheduledAnARTAppointmentDuringReportingPeriod

DROP FUNCTION IF EXISTS patientHasScheduledAnARTAppointment;

DELIMITER $$
CREATE FUNCTION patientHasScheduledAnARTAppointment(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_monthOffset INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM patient_appointment pa
    JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
    WHERE pa.voided = 0
        AND pa.patient_id = p_patientId
        AND pa.start_date_time BETWEEN TIMESTAMPADD(MONTH,p_monthOffset,p_startDate)  AND TIMESTAMPADD(MONTH,p_monthOffset,p_endDate)
        AND (aps.name = "APPOINTMENT_SERVICE_ART_KEY" OR aps.name = "APPOINTMENT_SERVICE_ART_DISPENSARY_KEY")
    GROUP BY pa.patient_id;

    RETURN (result );
END$$ 
DELIMITER ;

-- drugOrderIsDispensed

DROP FUNCTION IF EXISTS drugOrderIsDispensed;

DELIMITER $$
CREATE FUNCTION drugOrderIsDispensed(
    p_patientId INT(11),
    p_orderId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE drugDispensed TINYINT(1) DEFAULT 0;
    DECLARE retrospectiveDrugEntry TINYINT(1) DEFAULT 0;
    DECLARE uuidDispensedConcept VARCHAR(38) DEFAULT 'ff0d6d6a-e276-11e4-900f-080027b662ec';

    SELECT TRUE INTO drugDispensed
    FROM obs o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND o.order_id = p_orderId
        AND c.uuid = uuidDispensedConcept;

    SELECT TRUE INTO retrospectiveDrugEntry
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON c.concept_id = do.duration_units AND retired = 0
    WHERE o.voided = 0
        AND o.patient_id = p_patientId
        AND o.order_id = p_orderId
        AND o.date_created > calculateTreatmentEndDate(
            o.scheduled_date,
            do.duration,
            c.uuid);

    RETURN (drugDispensed OR retrospectiveDrugEntry); 
END$$ 

DELIMITER ; 

-- calculateTreatmentEndDate

DROP FUNCTION IF EXISTS calculateTreatmentEndDate;

DELIMITER $$
CREATE FUNCTION calculateTreatmentEndDate(
    p_startDate DATE,
    p_duration INT(11),
    p_uuidDurationUnit VARCHAR(38)) RETURNS DATE
    DETERMINISTIC
BEGIN

    DECLARE result DATE;
    DECLARE uuidMinute VARCHAR(38) DEFAULT '33bc78b1-8a92-11e4-977f-0800271c1b75';
    DECLARE uuidHour VARCHAR(38) DEFAULT 'bb62c684-3f10-11e4-adec-0800271c1b75';
    DECLARE uuidDay VARCHAR(38) DEFAULT '9d7437a9-3f10-11e4-adec-0800271c1b75';
    DECLARE uuidWeek VARCHAR(38) DEFAULT 'bb6436e3-3f10-11e4-adec-0800271c1b75';
    DECLARE uuidMonth VARCHAR(38) DEFAULT 'bb655344-3f10-11e4-adec-0800271c1b75';

    IF p_uuidDurationUnit = uuidMinute THEN
        SET result = timestampadd(MINUTE, p_duration, p_startDate);
    ELSEIF p_uuidDurationUnit = uuidHour THEN
        SET result = timestampadd(HOUR, p_duration, p_startDate);
    ELSEIF p_uuidDurationUnit = uuidDay THEN
        SET result = timestampadd(DAY, p_duration, p_startDate);
    ELSEIF p_uuidDurationUnit = uuidWeek THEN
        SET result = timestampadd(WEEK, p_duration, p_startDate);
    ELSEIF p_uuidDurationUnit = uuidMonth THEN
        SET result = timestampadd(MONTH, p_duration, p_startDate);
    END IF;

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

-- patientIsPregnant

DROP FUNCTION IF EXISTS patientIsPregnant;

DELIMITER $$
CREATE FUNCTION patientIsPregnant(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN 
    DECLARE patientPregnant TINYINT(1) DEFAULT 0;

    DECLARE uuidPatientIsPregnant VARCHAR(38) DEFAULT "279583bf-70d4-40b5-82e9-6cb29fbe00b4";

    SELECT TRUE INTO patientPregnant
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId 
        AND c.uuid = uuidPatientIsPregnant
    GROUP BY c.uuid;
        
    RETURN (patientPregnant );
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

-- _drugIsARV

DROP FUNCTION IF EXISTS _drugIsARV;

DELIMITER $$
CREATE FUNCTION _drugIsARV(
    p_drugConceptId INT(11),
    p_orderLineUuid VARCHAR(38)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM concept_set cs
    INNER JOIN concept c ON c.concept_id = cs.concept_set AND c.retired = 0
    WHERE c.uuid = p_orderLineUuid
        AND cs.concept_id = p_drugConceptId
    LIMIT 1;

    return result;
END$$
DELIMITER ;

-- patientHasTherapeuticLine
-- This is a util function to avoid duplicating the SQL code on 
-- patientHasTherapeuticLineFirstLine, patientHasTherapeuticLineSecondLine and patientHasTherapeuticLineThirdLine

DROP FUNCTION IF EXISTS _patientHasTherapeuticLine;

DELIMITER $$
CREATE FUNCTION _patientHasTherapeuticLine(
    p_patientId INT(11),
    p_uuidConceptARVLineNumber VARCHAR(38)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE uuidTherapeuticLine VARCHAR(38) DEFAULT "397b7bc7-13ca-4e4e-abc3-bf854904dce3";
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM patient_program_attribute ppa
    JOIN program_attribute_type pat ON ppa.attribute_type_id = pat.program_attribute_type_id AND pat.retired = 0
    JOIN patient_program pp ON ppa.patient_program_id = pp.patient_program_id AND pp.voided = 0
    JOIN concept c ON ppa.value_reference = c.concept_id
    WHERE ppa.voided = 0
        AND pp.patient_id = p_patientId
        AND pat.uuid = uuidTherapeuticLine
        AND c.uuid = p_uuidConceptARVLineNumber
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientHasTherapeuticLineFirstLine

DROP FUNCTION IF EXISTS patientHasTherapeuticLineFirstLine;

DELIMITER $$
CREATE FUNCTION patientHasTherapeuticLineFirstLine(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE p_uuidConceptFirstLine VARCHAR(38) DEFAULT "9d928a3f-95cb-487f-96ef-86cf960503a9";

    RETURN _patientHasTherapeuticLine(p_patientId, p_uuidConceptFirstLine);
END$$
DELIMITER ;

-- patientHasTherapeuticLineSecondLine

DROP FUNCTION IF EXISTS patientHasTherapeuticLineSecondLine;

DELIMITER $$
CREATE FUNCTION patientHasTherapeuticLineSecondLine(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE p_uuidConceptSecondLine VARCHAR(38) DEFAULT "d0ee855d-f0b4-49d2-be02-1d1457d5c8bf";

    RETURN _patientHasTherapeuticLine(p_patientId, p_uuidConceptSecondLine);
END$$
DELIMITER ;

-- patientHasTherapeuticLineThirdLine

DROP FUNCTION IF EXISTS patientHasTherapeuticLineThirdLine;

DELIMITER $$
CREATE FUNCTION patientHasTherapeuticLineThirdLine(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE p_uuidConceptThirdLine VARCHAR(38) DEFAULT "d1661aa5-9a4f-4b31-b816-6973aa604289";

    RETURN _patientHasTherapeuticLine(p_patientId, p_uuidConceptThirdLine);
END$$
DELIMITER ;

-- patientHasTherapeuticLine

DROP FUNCTION IF EXISTS patientHasTherapeuticLine;

DELIMITER $$
CREATE FUNCTION patientHasTherapeuticLine(
    p_patientId INT(11),
    p_protocolLineNumber INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE result TINYINT(1);
    
    IF p_protocolLineNumber = 1 THEN
        SET result = patientHasTherapeuticLineFirstLine(p_patientId);
    ELSEIF p_protocolLineNumber = 2 THEN
        SET result = patientHasTherapeuticLineSecondLine(p_patientId);
    ELSEIF p_protocolLineNumber = 3 THEN
        SET result = patientHasTherapeuticLineThirdLine(p_patientId);
    ELSE
        SET result =  
            patientHasTherapeuticLineFirstLine(p_patientId) OR
            patientHasTherapeuticLineSecondLine(p_patientId) OR
            patientHasTherapeuticLineThirdLine(p_patientId);
    END IF;

    RETURN (result);

END$$
DELIMITER ;

-- drugIsARV

DROP FUNCTION IF EXISTS drugIsARV;

DELIMITER $$
CREATE FUNCTION drugIsARV(
    p_drugConceptId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE uuidARVDrugsSet VARCHAR(38) DEFAULT "9e7f1f61-216f-44bb-b5bb-35c9a0d9d9ba";

    SELECT TRUE INTO result
    FROM concept_set cs
    INNER JOIN concept c ON c.concept_id = cs.concept_set AND c.retired = 0
    WHERE c.uuid = uuidARVDrugsSet
        AND cs.concept_id = p_drugConceptId
    LIMIT 1;

    return result;
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

    -- retrieve the test date
    CALL retrieveViralLoadTestDateAndResult(p_patientId, testDate, testResult);

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

-- patientIsVirallySuppressed

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

    -- retrieve the test date
    CALL retrieveViralLoadTestDateAndResult(p_patientId, testDate, testResult);

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
    OUT p_testResult INT(11)
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
        SELECT o.value_numeric INTO p_testResult
        FROM obs o
        JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
        WHERE o.voided = 0
            AND o.order_id IS NULL
            AND o.value_numeric IS NOT NULL
            AND o.person_id = p_patientId
            AND (c.uuid = routineViralLoadTestUuid OR c.uuid = targetedViralLoadTestUuid OR c.uuid = notDocumentedViralLoadTestUuid)
        ORDER BY o.obs_datetime DESC
        LIMIT 1;
    ELSE
        SELECT o.value_numeric INTO p_testResult
        FROM obs o
        JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
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

-- patientHasNotBeenEnrolledIntoHivProgram

DROP FUNCTION IF EXISTS patientHasNotBeenEnrolledIntoHivProgram;

DELIMITER $$
CREATE FUNCTION patientHasNotBeenEnrolledIntoHivProgram(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE hivProgramFound TINYINT(1) DEFAULT 0;

    SELECT
        TRUE INTO hivProgramFound
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE p.person_id = p_patientId
        AND p.voided = 0
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (!hivProgramFound);
END$$
DELIMITER ;

-- patientAgeIsBetween

DROP FUNCTION IF EXISTS patientAgeIsBetween;  

DELIMITER $$ 
CREATE FUNCTION patientAgeIsBetween(
    p_patientId INT(11),
    p_startAge INT(11),
    p_endAge INT(11),
    p_includeEndAge TINYINT(1)) RETURNS TINYINT(1) 
    DETERMINISTIC 
BEGIN 
    DECLARE result TINYINT(1) DEFAULT 0; 
    SELECT  
        IF (p_includeEndAge, 
            timestampdiff(YEAR, p.birthdate, CURDATE()) BETWEEN p_startAge AND p_endAge, 
            timestampdiff(YEAR, p.birthdate, CURDATE()) >= p_startAge
                AND timestampdiff(YEAR, p.birthdate, CURDATE()) < p_endAge
        ) INTO result
        FROM person p 
        WHERE p.person_id = p_patientId AND p.voided = 0;

    RETURN (result ); 
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
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    GROUP BY o.patient_id;

    RETURN (result);
END$$ 
DELIMITER ;

-- drugIsChildProphylaxis

DROP FUNCTION IF EXISTS drugIsChildProphylaxis;

DELIMITER $$
CREATE FUNCTION drugIsChildProphylaxis(
    p_drugConceptId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE childProphylaxisUuid VARCHAR(38) DEFAULT "fa7e7514-146b-4add-92ee-95d6e03315e0";
    return _drugIsARV(p_drugConceptId, childProphylaxisUuid);
END$$
DELIMITER ;

-- drugIsAdultProphylaxis

DROP FUNCTION IF EXISTS drugIsAdultProphylaxis;

DELIMITER $$
CREATE FUNCTION drugIsAdultProphylaxis(
    p_drugConceptId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE adultProphylaxisUuid VARCHAR(38) DEFAULT "48990aed-5d90-4165-8d56-6e03e9914951";
    return _drugIsARV(p_drugConceptId, adultProphylaxisUuid);
END$$
DELIMITER ;

-- patientIsAdult

DROP FUNCTION IF EXISTS patientIsAdult;

DELIMITER $$
CREATE FUNCTION patientIsAdult(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM person p
    WHERE p.person_id = p_patientId
    AND  timestampdiff(YEAR, p.birthdate, CURDATE()) >= 15
    AND p.voided = 0;

    RETURN result;
END$$
DELIMITER ;
