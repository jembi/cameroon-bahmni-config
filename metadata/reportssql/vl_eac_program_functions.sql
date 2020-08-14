
-- patientHasEnrolledInVlEacProgram

DROP FUNCTION IF EXISTS patientHasEnrolledInVlEacProgram;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledInVlEacProgram(
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
        p.name = "VL_EAC_PROGRAM_KEY"
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;
