
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


