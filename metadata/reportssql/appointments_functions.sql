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
