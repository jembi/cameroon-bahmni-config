SELECT
    countRegPatientsByServiceType('#startDate#','#endDate#','VISIT_TYPE_ANC') AS 'ANC',
    countRegPatientsByServiceType('#startDate#','#endDate#','VISIT_TYPE_ART') AS 'ART',
    countRegPatientsByServiceType('#startDate#','#endDate#','VISIT_TYPE_ART_DISPENSATION') AS 'ART_DISPENSATION',
    countRegPatientsByServiceType('#startDate#','#endDate#','VISIT_TYPE_CARDIOLOGY') AS 'CARDIOLOGY';
