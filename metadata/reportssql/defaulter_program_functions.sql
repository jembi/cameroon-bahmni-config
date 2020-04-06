-- getDateMostRecentARVAppointment

DROP FUNCTION IF EXISTS getDateMostRecentARVAppointment;

DELIMITER $$
CREATE FUNCTION getDateMostRecentARVAppointment(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT DATE(pa.start_date_time) INTO result
    FROM patient_appointment pa
    JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
    WHERE pa.voided = 0
        AND pa.patient_id = p_patientId
        AND (
            aps.name = "APPOINTMENT_SERVICE_ANC_KEY" OR
            aps.name = "APPOINTMENT_SERVICE_ART_KEY" OR
            aps.name = "APPOINTMENT_SERVICE_ART_DISPENSARY_KEY" OR
            aps.name = "APPOINTMENT_SERVICE_OPD_KEY")
    ORDER BY pa.start_date_time DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getDateMostRecentHIVRelatedEncounter

DROP FUNCTION IF EXISTS getDateMostRecentHIVRelatedEncounter;

DELIMITER $$
CREATE FUNCTION getDateMostRecentHIVRelatedEncounter(
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
            "LOCATION_ANC",
            "LOCATION_ART",
            "LOCATION_ART_DISPENSATION",
            "LOCATION_OPD"
        )
    ORDER BY e.encounter_datetime DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;


-- patientIsDefaulter

DROP FUNCTION IF EXISTS patientIsDefaulter;

DELIMITER $$
CREATE FUNCTION patientIsDefaulter(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE dateOfLastHIVRelatedAppointment DATE;
    DECLARE dateOfLastHIVRelatedEncounter DATE;

    SET dateOfLastHIVRelatedAppointment = getDateMostRecentARVAppointment(p_patientId);
    SET dateOfLastHIVRelatedEncounter = getDateMostRecentHIVRelatedEncounter(p_patientId);

    RETURN NOT (
        patientHasEnrolledIntoHivProgram(p_patientId) = "No" OR -- a patient not in HIV cannot be a defaulter
        dateOfLastHIVRelatedAppointment IS NULL OR -- the patient has no appointment and therefore cannot be a defaulter
        TIMESTAMPADD(DAY, 7, dateOfLastHIVRelatedAppointment) > CURRENT_DATE() OR -- one week after the last appointment falls in future, the patient is therefore not yet a defaulter
        (dateOfLastHIVRelatedEncounter IS NOT NULL AND dateOfLastHIVRelatedEncounter >= dateOfLastHIVRelatedAppointment) -- the patient visited the clinic at or after the date of the appointment
    );
END$$
DELIMITER ;

-- getPatientMostRecentProgramAttributeCodedValue

DROP FUNCTION IF EXISTS getPatientMostRecentProgramAttributeCodedValue;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramAttributeCodedValue(
    p_patientId INT(11),
    p_uuidProgramAttribute VARCHAR(38),
    p_language VARCHAR(3)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);

    SELECT cn.name INTO result
    FROM patient_program_attribute ppa
        JOIN program_attribute_type pat ON pat.program_attribute_type_id = ppa.attribute_type_id AND pat.retired = 0
        JOIN patient_program pp ON ppa.patient_program_id = pp.patient_program_id AND pp.voided = 0
        JOIN concept c ON ppa.value_reference = c.concept_id
        JOIN concept_name cn ON cn.concept_id = c.concept_id AND cn.locale = p_language
    WHERE
        ppa.voided = 0 AND
        pp.patient_id = p_patientId AND
        pat.uuid = p_uuidProgramAttribute
    ORDER BY ppa.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getPatientMostRecentProgramAttributeValue

DROP FUNCTION IF EXISTS getPatientMostRecentProgramAttributeValue;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramAttributeValue(
    p_patientId INT(11),
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
        pat.uuid = p_uuidProgramAttribute
    ORDER BY ppa.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getPatientMostRecentProgramTrackingStateValue

DROP FUNCTION IF EXISTS getPatientMostRecentProgramTrackingStateValue;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramTrackingStateValue(
    p_patientId INT(11),
    p_language VARCHAR(3)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);
    DECLARE uuidDefaulterProgramTrackingState VARCHAR(38) DEFAULT "39202f47-a709-11e6-91e9-0800270d80ce";

    SELECT cn.name INTO result
    FROM patient_state ps
        JOIN program_workflow_state pws ON ps.state = pws.program_workflow_state_id AND pws.retired = 0
        JOIN concept_name cn ON pws.concept_id = cn.concept_id AND cn.locale=p_language
        JOIN patient_program pp ON pp.patient_program_id = ps.patient_program_id AND pp.voided = 0
        JOIN program p ON p.program_id = pp.program_id AND p.retired = 0
    WHERE
        pp.patient_id = p_patientId AND
        p.name = "HIV_DEFAULTERS_PROGRAM_KEY"
    ORDER BY ps.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getPatientMostRecentProgramTrackingDateValue

DROP FUNCTION IF EXISTS getPatientMostRecentProgramTrackingDateValue;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramTrackingDateValue(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;
    DECLARE uuidProgramTrackingDate VARCHAR(38) DEFAULT "9b4b2dd5-bc5e-44b9-ad95-333a7bbfee3c";

    SET result = DATE(getPatientMostRecentProgramAttributeValue(p_patientId, uuidProgramTrackingDate));

    RETURN (result);
END$$
DELIMITER ;

-- getPatientMostRecentProgramTrackingOutcomeValue

DROP FUNCTION IF EXISTS getPatientMostRecentProgramTrackingOutcomeValue;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramTrackingOutcomeValue(
    p_patientId INT(11),
    p_language VARCHAR(3)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);
    DECLARE uuidProgramTrackingOutcome VARCHAR(38) DEFAULT "caf6d807-861d-4393-9d6e-940b98fa712d";

    SET result = getPatientMostRecentProgramAttributeCodedValue(p_patientId, uuidProgramTrackingOutcome, p_language);

    RETURN (result);
END$$
DELIMITER ;

-- getPatientMostRecentProgramAPSName

DROP FUNCTION IF EXISTS getPatientMostRecentProgramAPSName;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramAPSName(
    p_patientId INT(11)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);
    DECLARE uuidProgramAPSName VARCHAR(38) DEFAULT "8bb0bdc0-aaf3-4501-8954-d1b17226075b";

    SET result = getPatientMostRecentProgramAttributeValue(p_patientId, uuidProgramAPSName);

    RETURN (result);
END$$
DELIMITER ;

-- getPatientProgramARTNumber

DROP FUNCTION IF EXISTS getPatientProgramARTNumber;

DELIMITER $$
CREATE FUNCTION getPatientProgramARTNumber(
    p_patientId INT(11)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);
    DECLARE uuidProgramARTNumber VARCHAR(38) DEFAULT "c41f844e-a707-11e6-91e9-0800270d80ce";

    SET result = getPatientMostRecentProgramAttributeValue(p_patientId, uuidProgramARTNumber);

    RETURN (result);
END$$
DELIMITER ;

-- getPatientProgramTreatmentStartDate

DROP FUNCTION IF EXISTS getPatientProgramTreatmentStartDate;

DELIMITER $$
CREATE FUNCTION getPatientProgramTreatmentStartDate(
    p_patientId INT(11)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);
    DECLARE uuidProgramTreatmentStartDate VARCHAR(38) DEFAULT "2dc1aafd-a708-11e6-91e9-0800270d80ce";

    SET result = getPatientMostRecentProgramAttributeValue(p_patientId, uuidProgramTreatmentStartDate);

    RETURN (result);
END$$
DELIMITER ;

-- patientHasEnrolledInDefaulterProgram

DROP FUNCTION IF EXISTS patientHasEnrolledInDefaulterProgram;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledInDefaulterProgram(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM patient_program pp
        JOIN program p ON pp.program_id = p.program_id AND p.retired = 0
    WHERE
        pp.voided = 0 AND
        pp.patient_id = p_patientId AND
        p.name = "HIV_DEFAULTERS_PROGRAM_KEY"
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getPatientMostRecentProgramOutcome

DROP FUNCTION IF EXISTS getPatientMostRecentProgramOutcome;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramOutcome(
    p_patientId INT(11),
    p_language VARCHAR(3),
    p_program VARCHAR(250)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);

    SELECT cn.name INTO result
    FROM patient_program pp
        JOIN program p ON pp.program_id = p.program_id AND p.retired = 0
        JOIN concept_name cn ON cn.concept_id = pp.outcome_concept_id AND cn.locale = p_language
    WHERE
        pp.voided = 0 AND
        pp.patient_id = p_patientId AND
        p.name = p_program
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;
