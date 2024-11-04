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
        AND pa.status = "Scheduled"
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

-- getDateMostRecentARVAppointmentBeforeOrEqualToDate

DROP FUNCTION IF EXISTS getDateMostRecentARVAppointmentBeforeOrEqualToDate;

DELIMITER $$
CREATE FUNCTION getDateMostRecentARVAppointmentBeforeOrEqualToDate(
    p_patientId INT(11),
    p_date DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT DATE(pa.start_date_time) INTO result
    FROM patient_appointment pa
    JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
    WHERE pa.voided = 0
        AND pa.status = "Scheduled"
        AND pa.patient_id = p_patientId
        AND pa.start_date_time <= p_date
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

-- getDateSecondMostRecentARVAppointmentBeforeOrEqualToDate

DROP FUNCTION IF EXISTS getDateSecondMostRecentARVAppointmentBeforeOrEqualToDate;

DELIMITER $$
CREATE FUNCTION getDateSecondMostRecentARVAppointmentBeforeOrEqualToDate(
    p_patientId INT(11),
    p_date DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT DATE(pa.start_date_time) INTO result
    FROM patient_appointment pa
    JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
    WHERE pa.voided = 0
        AND pa.status = "Scheduled"
        AND pa.patient_id = p_patientId
        AND pa.start_date_time <= p_date
        AND (
            aps.name = "APPOINTMENT_SERVICE_ANC_KEY" OR
            aps.name = "APPOINTMENT_SERVICE_ART_KEY" OR
            aps.name = "APPOINTMENT_SERVICE_ART_DISPENSARY_KEY" OR
            aps.name = "APPOINTMENT_SERVICE_OPD_KEY")
    ORDER BY pa.start_date_time DESC
    LIMIT 1, 1;

    RETURN (result);
END$$
DELIMITER ;

-- getDateARVAppointmentAfterDate

DROP FUNCTION IF EXISTS getDateARVAppointmentAfterDate;

DELIMITER $$
CREATE FUNCTION getDateARVAppointmentAfterDate(
    p_patientId INT(11),
    p_date DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT DATE(pa.start_date_time) INTO result
    FROM patient_appointment pa
    JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
    WHERE pa.voided = 0
        AND pa.status = "Scheduled"
        AND pa.patient_id = p_patientId
        AND pa.start_date_time > p_date
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

-- getDateARVAppointmentWithinReportingPeriod

DROP FUNCTION IF EXISTS getDateARVAppointmentWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION getDateARVAppointmentWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT DATE(pa.start_date_time) INTO result
    FROM patient_appointment pa
    JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
    WHERE pa.voided = 0
        AND pa.status = "Scheduled"
        AND pa.patient_id = p_patientId
        AND pa.start_date_time BETWEEN p_startDate AND p_endDate
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

-- getPatientMostRecentProgramAPSName

DROP FUNCTION IF EXISTS getPatientMostRecentProgramAPSName;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramAPSName(
    p_patientId INT(11),
    p_program VARCHAR(250)) RETURNS VARCHAR(250)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(250);
    DECLARE uuidProgramAPSName VARCHAR(38) DEFAULT "8bb0bdc0-aaf3-4501-8954-d1b17226075b";

    SET result = getPatientMostRecentProgramAttributeValueInProgram(p_patientId, uuidProgramAPSName, p_program);

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

-- patientIsNotDefaulterBasedOnDays

DROP FUNCTION IF EXISTS patientIsNotDefaulterBasedOnDays;

DELIMITER $$
CREATE FUNCTION patientIsNotDefaulterBasedOnDays(
  p_patientId INT(11),
  p_startDate DATE,
  p_endDate DATE) RETURNS TINYINT(1)
DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 1;

    DECLARE endDateOfARTPrescription DATE;
    DECLARE defaulterDays INT(11);

    SET endDateOfARTPrescription = patientARTPrescriptionEndDate(p_patientId);

    IF endDateOfARTPrescription IS NOT NULL THEN
        SET defaulterDays = DATEDIFF(p_endDate, endDateOfARTPrescription);
    END IF;
    IF defaulterDays > 1 AND defaulterDays < 90 THEN
      SET result = 0;
    END IF;

    RETURN (result);
END$$
DELIMITER ;

-- patientIsNotDefaulter for 1 month

DROP FUNCTION IF EXISTS patientIsNotDefaulterFor1Month;

DELIMITER $$
CREATE FUNCTION patientIsNotDefaulterFor1Month(
  p_patientId INT(11),
  p_startDate DATE,
  p_endDate DATE) RETURNS TINYINT(1)
DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 1;

    DECLARE endDateOfARTPrescription DATE;
    DECLARE defaulterDays INT(11);

    SET endDateOfARTPrescription = patientARTPrescriptionEndDate(p_patientId);

    IF endDateOfARTPrescription IS NOT NULL THEN
        SET defaulterDays = DATEDIFF(p_endDate, endDateOfARTPrescription);
    END IF;
    IF defaulterDays > 1 AND defaulterDays < 30 THEN
      SET result = 0;
    END IF;

    RETURN (result);
END$$
DELIMITER ;


-- patientIsNotDefaulterBasedOnDays for 2 month

DROP FUNCTION IF EXISTS patientIsNotDefaulterFor2Month;

DELIMITER $$
CREATE FUNCTION patientIsNotDefaulterFor2Month(
  p_patientId INT(11),
  p_startDate DATE,
  p_endDate DATE) RETURNS TINYINT(1)
DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 1;

    DECLARE endDateOfARTPrescription DATE;
    DECLARE defaulterDays INT(11);

    SET endDateOfARTPrescription = patientARTPrescriptionEndDate(p_patientId);

    IF endDateOfARTPrescription IS NOT NULL THEN
        SET defaulterDays = DATEDIFF(p_endDate, endDateOfARTPrescription);
    END IF;
    IF defaulterDays > 1 AND defaulterDays < 60 THEN
      SET result = 0;
    END IF;

    RETURN (result);
END$$
DELIMITER ;


-- patientIsNotLostToFollowUpBasedOnDays

DROP FUNCTION IF EXISTS patientIsNotLostToFollowUpBasedOnDays;

DELIMITER $$
CREATE FUNCTION patientIsNotLostToFollowUpBasedOnDays(
  p_patientId INT(11),
  p_startDate DATE,
  p_endDate DATE) RETURNS TINYINT(1)
DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 1;

    DECLARE endDateOfARTPrescription DATE;
    DECLARE ltfuDays INT(11);

    SET endDateOfARTPrescription = patientARTPrescriptionEndDate(p_patientId);

    IF endDateOfARTPrescription IS NOT NULL THEN
        SET ltfuDays = DATEDIFF(p_endDate, endDateOfARTPrescription);
    END IF;
    IF ltfuDays >= 90 THEN
      SET result = 0;
    END IF;

    RETURN (result);
END$$
DELIMITER ;

-- patientHasReturnedToTreatmentWithinTheReportingPeriod

DROP FUNCTION IF EXISTS patientHasReturnedToTreatmentWithinTheReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasReturnedToTreatmentWithinTheReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM patient_program pp
        JOIN program p ON pp.program_id = p.program_id
        JOIN patient_identifier pi ON pp.patient_id = pi.patient_id
        JOIN person pe ON pp.patient_id = pe.person_id
        JOIN obs o ON o.person_id = pe.person_id
        JOIN concept_name cn ON o.concept_id = cn.concept_id
    WHERE
        p.name = 'HIV_DEFAULTERS_PROGRAM_KEY'
        AND cn.name = 'PROGRAM_MANAGEMENT_9_RETURNED_TO_TREATMENT_DATE'
        AND o.value_datetime BETWEEN p_startDate AND p_endDate
        AND o.voided = 0
        ORDER BY pp.patient_id, o.value_datetime;

    RETURN (result);
END$$
DELIMITER ;



