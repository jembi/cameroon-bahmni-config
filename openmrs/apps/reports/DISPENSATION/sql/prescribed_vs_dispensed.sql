SELECT
    cn.name AS 'Drug',
    getNumberOfARVPrescribed('#startDate#','#endDate#', cn.name) AS 'Prescribed',
    getNumberOfARVDispensed('#startDate#','#endDate#', cn.name) AS 'Dispensed'
FROM concept_set cs
    JOIN concept_name cn ON cn.concept_id = cs.concept_id AND cn.locale = "en" AND cn.locale_preferred = 1
    JOIN concept c ON cs.concept_set = c.concept_id
WHERE c.uuid = '9e7f1f61-216f-44bb-b5bb-35c9a0d9d9ba'
ORDER BY cn.name ASC;