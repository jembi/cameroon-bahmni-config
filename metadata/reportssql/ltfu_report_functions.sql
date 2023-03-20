-- LTFU Report

DROP FUNCTION IF EXISTS LTFU_Indicator;

DELIMITER $$
CREATE FUNCTION LTFU_Indicator(
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
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasEnrolledIntoHivProgram(pat.patient_id) = "Yes" AND
    patientHasTherapeuticLine(pat.patient_id, 0) AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_endDate) AND
    patientWasOnARVTreatmentByDate(pat.patient_id, p_startDate) AND
    patientIsLostToFollowUp(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

-- getDateMostRecentARVAppointmentThatIsBeforeReportEndDate

DROP FUNCTION IF EXISTS getDateMostRecentARVAppointmentThatIsBeforeReportEndDate;

DELIMITER $$
CREATE FUNCTION getDateMostRecentARVAppointmentThatIsBeforeReportEndDate(
    p_patientId INT(11),
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT DATE(pa.start_date_time) INTO result
    FROM patient_appointment pa
    JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
    WHERE pa.voided = 0
        AND pa.patient_id = p_patientId
        AND pa.start_date_time < p_endDate
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


-- getDateMostRecentARVAppointmentWhereStatusMissed

DROP FUNCTION IF EXISTS getDateMostRecentARVAppointmentWhereStatusMissed;

DELIMITER $$
CREATE FUNCTION getDateMostRecentARVAppointmentWhereStatusMissed(
    p_patientId INT(11),
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT DATE(pa.start_date_time) INTO result
    FROM patient_appointment pa
    JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
    WHERE pa.voided = 0
        AND pa.patient_id = p_patientId
        AND (pa.status = "Scheduled" OR pa.status = "Missed")
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

-- getDateMostRecentHIVRelatedEncounterWithinReportingPeriod

DROP FUNCTION IF EXISTS getDateMostRecentHIVRelatedEncounterWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION getDateMostRecentHIVRelatedEncounterWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT e.encounter_datetime INTO result
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
    ORDER BY e.encounter_datetime DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getDateMostRecentARVPickupWithinReportingPeriod

DROP FUNCTION IF EXISTS getDateMostRecentARVPickupWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION getDateMostRecentARVPickupWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT o.scheduled_date INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND o.order_action <> "DISCONTINUE"
        AND o.date_stopped IS NULL
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    ORDER BY o.scheduled_date DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientIsLostToFollowUp

DROP FUNCTION IF EXISTS patientIsLostToFollowUp;

DELIMITER $$
CREATE FUNCTION patientIsLostToFollowUp(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    DECLARE dateOfARVAppointment DATE;
    DECLARE dateOfMostRecentHIVRelatedEncounterWithinReportingPeriod DATE;
    DECLARE dateOfLastARVPickupWithinReportingPeriod DATE;
    DECLARE ltfuStartDate DATE;

    SET dateOfARVAppointment = getDateMostRecentARVAppointmentThatIsBeforeReportEndDate(p_patientId, p_endDate);
    SET dateOfMostRecentHIVRelatedEncounterWithinReportingPeriod = getDateMostRecentHIVRelatedEncounterWithinReportingPeriod(p_patientId, p_startDate, p_endDate);
    SET dateOfLastARVPickupWithinReportingPeriod = getDateMostRecentARVPickupWithinReportingPeriod(p_patientId, p_startDate, p_endDate);

    IF dateOfARVAppointment IS NOT NULL THEN
        SET ltfuStartDate = timestampadd(DAY, 28, dateOfARVAppointment);
    END IF;

    SET result =
        ltfuStartDate <= p_endDate AND
        dateOfLastARVPickupWithinReportingPeriod IS NULL AND
        (
            dateOfMostRecentHIVRelatedEncounterWithinReportingPeriod IS NULL OR
            dateOfMostRecentHIVRelatedEncounterWithinReportingPeriod > ltfuStartDate
        );

    RETURN (result);
END$$
DELIMITER ;
