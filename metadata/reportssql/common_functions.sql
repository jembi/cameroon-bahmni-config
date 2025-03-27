
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

-- patientFinalHIVStatus
DROP FUNCTION IF EXISTS isHivStatus;
DELIMITER $$

CREATE FUNCTION isHivStatus(
    p_patientId INT,
    p_hivResult VARCHAR(255),
    uuidHIVTestFinalResult CHAR(38),
    p_startDate DATETIME,
    p_endDate DATETIME
) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE result BOOLEAN DEFAULT FALSE;

    SELECT
        (cn.name = p_hivResult) INTO result
    FROM
        obs o
        JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
        JOIN concept_name cn ON o.value_coded = cn.concept_id AND cn.locale='en'
    WHERE
        o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestFinalResult
        AND o.date_created BETWEEN p_startDate AND p_endDate
    ORDER BY
        o.date_created DESC
    LIMIT 1;

    RETURN result;
END$$

DELIMITER ;


-- patientAgeWhenTestedForHivIsBetween

DROP FUNCTION IF EXISTS patientAgeWhenTestedForHivIsBetween;  

DELIMITER $$ 
CREATE FUNCTION patientAgeWhenTestedForHivIsBetween(
    p_patientId INT(11),
    p_startAge INT(11),
    p_endAge INT(11),
    p_includeEndAge TINYINT(1)) RETURNS TINYINT(1) 
    DETERMINISTIC 
BEGIN 
    DECLARE result TINYINT(1) DEFAULT 0; 
    DECLARE hivTestDate DATE DEFAULT getObsDatetimeValueInSection(p_patientId, "c6c08cdc-18dc-4f42-809c-959621bc9a6c", "b70dfca0-db21-4533-8c08-4626ff0de265");

    SELECT  
        IF (p_includeEndAge, 
            timestampdiff(YEAR, p.birthdate, hivTestDate) BETWEEN p_startAge AND p_endAge, 
            timestampdiff(YEAR, p.birthdate, hivTestDate) >= p_startAge
                AND timestampdiff(YEAR, p.birthdate, hivTestDate) < p_endAge
        ) INTO result  
    FROM person p 
    WHERE p.person_id = p_patientId AND p.voided = 0 
    LIMIT 1;

    RETURN (result); 
END$$ 
DELIMITER ;

-- patientAgeAtHivEnrollment

DROP FUNCTION IF EXISTS patientAgeAtHivEnrollment;  

DELIMITER $$ 
CREATE FUNCTION patientAgeAtHivEnrollment(
    p_patientId INT(11)) RETURNS INT(11) 
    DETERMINISTIC 
BEGIN 
    DECLARE result INT (11); 

    SELECT  
        timestampdiff(YEAR, p.birthdate, pp.date_enrolled) INTO result  
    FROM person p 
        JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0 
        JOIN program pro ON pp.program_id = pro.program_id AND pro.retired = 0 
    WHERE p.person_id = p_patientId AND p.voided = 0 
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result ); 
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
    DECLARE uuidYesFullname VARCHAR(38) DEFAULT "a2065636-5326-40f5-aed6-0cc2cca81ccc";
    
    SELECT TRUE INTO patientPregnant
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId 
        AND c.uuid = uuidPatientIsPregnant
        AND o.value_coded = (SELECT concept.concept_id FROM concept WHERE concept.uuid = uuidYesFullname)
    GROUP BY c.uuid;
        
    RETURN (patientPregnant );
END$$
DELIMITER ;

-- getPregnancyStatus

DROP FUNCTION IF EXISTS getPregnancyStatus;

DELIMITER $$
CREATE FUNCTION getPregnancyStatus(
    p_patientId INT(11)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN 
    DECLARE pregrantStatusObsDate1 DATETIME DEFAULT getObsLastModifiedDate(p_patientId, "279583bf-70d4-40b5-82e9-6cb29fbe00b4");
    DECLARE pregrantStatusObsDate2 DATETIME DEFAULT getObsLastModifiedDate(p_patientId, "b2e1ffa5-a6a8-4f3d-b797-25f11a66293b");
    DECLARE pregrancyStatus VARCHAR(250) DEFAULT "";

    IF pregrantStatusObsDate1 >= pregrantStatusObsDate2 OR pregrantStatusObsDate1 IS NULL THEN
        SET pregrancyStatus = getMostRecentCodedObservation(p_patientId,"HTC, Pregnancy Status","en");
    ELSEIF pregrantStatusObsDate1 < pregrantStatusObsDate2 OR pregrantStatusObsDate2 IS NULL THEN
        SET pregrancyStatus = getMostRecentCodedObservation(p_patientId,"Pregnancy","en");
    ELSE
        RETURN NULL;
    END IF;

    RETURN 
      CASE
            WHEN pregrancyStatus = "Yes full name" THEN "Pregnant"
            WHEN pregrancyStatus = "No full name" THEN "Not Pregnant"
            WHEN pregrancyStatus = "Do not know" THEN "Do not know"
            WHEN pregrancyStatus = "Not Applicable" THEN "Not Applicable"
            ELSE NULL
        END;
  
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

-- getLabTestOrderDate

DROP FUNCTION IF EXISTS getLabTestOrderDate;

DELIMITER $$
CREATE FUNCTION getLabTestOrderDate(
    p_patientId INT(11),
    p_labTestName VARCHAR(255),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    RETURN (
        SELECT o.date_activated
        FROM orders o
        JOIN concept_name cn ON o.concept_id = cn.concept_id
        WHERE o.patient_id = p_patientId AND o.voided = 0
            AND o.date_activated BETWEEN p_startDate AND p_endDate
            AND cn.locale='en' AND cn.concept_name_type = 'FULLY_SPECIFIED'
            AND cn.name = p_labTestName
        ORDER BY o.date_activated DESC
        LIMIT 1);
END$$
DELIMITER ;

-- getNumericLabTestResult

DROP FUNCTION IF EXISTS getNumericLabTestResult;

DELIMITER $$

CREATE FUNCTION getNumericLabTestResult(
    patientId INT(11),
    labTestId VARCHAR(255)
)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE result DECIMAL(10,2);
    SELECT 
        o.value_numeric
    INTO result
    FROM 
        obs o
    WHERE 
        o.person_id = patientId
        AND o.voided = 0
        AND o.concept_id = labTestId
        AND o.value_numeric IS NOT NULL
    ORDER BY 
        o.obs_datetime DESC
    LIMIT 1;
    RETURN result;
END$$

DELIMITER ;



-- check if form is filled for the patient within the reporting period
DROP FUNCTION IF EXISTS isFormFilledWithinReportingPeriod;
DELIMITER $$
CREATE FUNCTION isFormFilledWithinReportingPeriod(
    p_patientId INT(11),
    p_formConceptUuid VARCHAR(38),
    p_startDate DATE,
    p_endDate DATE
) RETURNS TINYINT(1) DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT 1 INTO result
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = p_formConceptUuid
        AND o.obs_datetime BETWEEN p_startDate AND p_endDate
    LIMIT 1;

    RETURN result;

END$$

DELIMITER ;

