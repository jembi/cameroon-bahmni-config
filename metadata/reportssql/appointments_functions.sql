-- patientHasScheduledAnARTAppointment

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

-- getDayBetweenLastAppointmentAndLastArvPickupDate

DROP FUNCTION IF EXISTS getDayBetweenLastAppointmentAndLastArvPickupDate;

DELIMITER $$
CREATE FUNCTION getDayBetweenLastAppointmentAndLastArvPickupDate(
    p_patientId INT(11),
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    SET result = DATEDIFF(getDateLatestARVRelatedVisit(p_patientId), getDateMostRecentARVAppointmentBeforeOrEqualToDate(p_patientId, p_endDate));
    RETURN (result);
END$$ 
DELIMITER ;


-- patientHasScheduledAnAppointmentDuringReportingPeriod

DROP FUNCTION IF EXISTS patientHasScheduledAnAppointmentDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasScheduledAnAppointmentDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_service VARCHAR(50)) RETURNS VARCHAR(3)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(3) DEFAULT "No";

    SELECT "Yes" INTO result
    FROM patient_appointment pa
    JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
    WHERE pa.voided = 0
        AND pa.patient_id = p_patientId
        AND pa.start_date_time BETWEEN p_startDate AND p_endDate
        AND (aps.name = p_service)
    GROUP BY pa.patient_id;

    RETURN (result);
END$$ 
DELIMITER ;


-- getNumberOfScheduledAppointmentsDuringReportingPeriod

DROP FUNCTION IF EXISTS getNumberOfScheduledAppointmentsDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION getNumberOfScheduledAppointmentsDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_service VARCHAR(50)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(DISTINCT pa.patient_appointment_id) INTO result
    FROM patient_appointment pa
    JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
    WHERE pa.voided = 0
        AND pa.patient_id = p_patientId
        AND pa.start_date_time BETWEEN p_startDate AND p_endDate
        AND (aps.name = p_service)
    GROUP BY pa.patient_id;

    RETURN (result);
END$$ 
DELIMITER ;

-- getDateOfLastScheduledAppointment

DROP FUNCTION IF EXISTS getDateOfLastScheduledAppointment;

DELIMITER $$
CREATE FUNCTION getDateOfLastScheduledAppointment(
    p_patientId INT(11),
    p_service VARCHAR(50)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT pa.start_date_time INTO result
    FROM patient_appointment pa
    JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
    WHERE pa.voided = 0
        AND pa.patient_id = p_patientId
        AND aps.name = p_service
    ORDER BY pa.start_date_time DESC
    LIMIT 1;

    RETURN (result);
END$$ 
DELIMITER ;

-- getNextAppointmentDate

DROP FUNCTION IF EXISTS getNextAppointmentDate;

DELIMITER $$
CREATE FUNCTION getNextAppointmentDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT pa.start_date_time INTO result
    FROM patient_appointment pa
    WHERE pa.voided = 0
        AND pa.patient_id = p_patientId
    ORDER BY pa.start_date_time DESC
    LIMIT 1;

    RETURN (result);
END$$ 
DELIMITER ;

-- getDateOfLastScheduledARTOrARTDispensaryAppointment

DROP FUNCTION IF EXISTS getDateOfLastScheduledARTOrARTDispensaryAppointment;

DELIMITER $$
CREATE FUNCTION getDateOfLastScheduledARTOrARTDispensaryAppointment(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE dateLastARTAppointment DATE DEFAULT getDateOfLastScheduledAppointment(p_patientId, "APPOINTMENT_SERVICE_ART_KEY");
    DECLARE dateLastARTDispensaryAppoint DATE DEFAULT getDateOfLastScheduledAppointment(p_patientId, "APPOINTMENT_SERVICE_ART_DISPENSARY_KEY");
    
    RETURN getGreatestDate(dateLastARTAppointment, dateLastARTDispensaryAppoint);
END$$ 
DELIMITER ;

-- getNextARTPickupDate

DROP FUNCTION IF EXISTS getNextARTPickupDate;

DELIMITER $$
CREATE FUNCTION getNextARTPickupDate(
    p_patientId INT(11),
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE lastArvPickupDate DATE DEFAULT getLastArvPickupDate(p_patientId, '2000-01-01', p_endDate);

    IF lastArvPickupDate IS NULL THEN
        RETURN NULL;
    END IF;

    RETURN(
        SELECT pa.start_date_time
        FROM patient_appointment pa
        JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
        WHERE pa.voided = 0
            AND pa.patient_id = p_patientId
            AND (aps.name = "APPOINTMENT_SERVICE_ART_KEY" OR aps.name = "APPOINTMENT_SERVICE_ART_DISPENSARY_KEY")
            AND pa.start_date_time > lastArvPickupDate
        ORDER BY pa.start_date_time DESC
        LIMIT 1);
END$$ 
DELIMITER ;


-- getARTAppointmentOnOrAfterDate

DROP FUNCTION IF EXISTS getARTAppointmentOnOrAfterDate;

DELIMITER $$
CREATE FUNCTION getARTAppointmentOnOrAfterDate(
    p_patientId INT(11),
    p_date DATE) RETURNS DATE
    DETERMINISTIC
BEGIN

    IF p_date IS NULL THEN
        RETURN NULL;
    END IF;

    RETURN(
        SELECT pa.start_date_time
        FROM patient_appointment pa
        JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
        WHERE pa.voided = 0
            AND pa.patient_id = p_patientId
            AND (aps.name = "APPOINTMENT_SERVICE_ART_KEY" OR aps.name = "APPOINTMENT_SERVICE_ART_DISPENSARY_KEY")
            AND pa.status <> "Cancelled"
            AND pa.start_date_time >= p_date
        ORDER BY pa.start_date_time ASC
        LIMIT 1);
END$$ 
DELIMITER ;
