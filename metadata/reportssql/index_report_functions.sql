DROP FUNCTION IF EXISTS Index_Indicator1a;

DELIMITER $$
CREATE FUNCTION Index_Indicator1a(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;
    DECLARE uuidServiceRequired VARCHAR(38) DEFAULT "9818d68b-6cc9-4a37-8e11-0d29389c4b9b";

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeAtReportEndDateIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge, p_endDate) AND
    getPatientIndexTestingDateOffered(pat.patient_id) IS NOT NULL AND
    getObsCodedShortNameValue(pat.patient_id, uuidServiceRequired) NOT IN ("Community home", "Community mobile");

    RETURN (result);
END$$ 
DELIMITER ;

-- getPatientIndexTestingDateOffered

DROP FUNCTION IF EXISTS getPatientIndexTestingDateOffered;

DELIMITER $$
CREATE FUNCTION getPatientIndexTestingDateOffered(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE uuidIndexTestingDateOffered VARCHAR(38) DEFAULT "836fe9d4-96f1-4fea-9ad8-35bd06e0ee05";
    RETURN getObsDatetimeValue(p_patientId, uuidIndexTestingDateOffered);
END$$
DELIMITER ;

-- patientAgeAtReportEndDateIsBetween

DROP FUNCTION IF EXISTS patientAgeAtReportEndDateIsBetween;

DELIMITER $$
CREATE FUNCTION patientAgeAtReportEndDateIsBetween(
    p_patientId INT(11),
    p_startAge INT(11),
    p_endAge INT(11),
    p_includeEndAge TINYINT(1),
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1);

    SELECT 
        IF (p_includeEndAge, 
            timestampdiff(YEAR, p.birthdate, p_endDate) BETWEEN p_startAge AND p_endAge, 
            timestampdiff(YEAR, p.birthdate, p_endDate) >= p_startAge
                AND timestampdiff(YEAR, p.birthdate, p_endDate) < p_endAge
        ) INTO result  
    FROM person p 
    WHERE p.voided = 0
        AND p.person_id = p_patientId
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;
