SELECT
    countRegPatientsByLocation('#startDate#','#endDate#','LOCATION_ANC') AS 'ANC',
    countRegPatientsByLocation('#startDate#','#endDate#','LOCATION_ART') AS 'ART',
    countRegPatientsByLocation('#startDate#','#endDate#','LOCATION_ART_DISPENSATION') AS 'ART_DISPENSATION',
    countRegPatientsByLocation('#startDate#','#endDate#','LOCATION_CARDIOLOGY') AS 'CARDIOLOGY';
