
DROP FUNCTION IF EXISTS countRegPatientsByLocation;

DELIMITER $$
CREATE FUNCTION countRegPatientsByLocation(
    p_startDate DATETIME,
    p_endDate DATETIME,
    location_name VARCHAR(255)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT 
        COUNT(distinct p.patient_id) INTO result 
    FROM patient p, encounter e 
    WHERE e.encounter_datetime between p_startDate and p_endDate
        AND e.patient_id=p.patient_id 
        AND e.encounter_type = (select encounter_type_id from encounter_type where name = 'REG')
        AND e.location_id=(select location_id from location where name=location_name);

    RETURN result;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS countHivEncountersByForm;

DELIMITER $$
CREATE FUNCTION countHivEncountersByForm(
    p_startDate DATETIME,
    p_endDate DATETIME,
    formUuid VARCHAR(255)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT 
        COUNT(distinct e.encounter_id) INTO result 
    FROM encounter e, obs o 
    WHERE e.encounter_datetime between p_startDate and p_endDate
        AND o.encounter_id=e.encounter_id
        AND o.concept_id=(select concept_id from concept where uuid=formUuid);

    RETURN result;
END$$
DELIMITER ;
