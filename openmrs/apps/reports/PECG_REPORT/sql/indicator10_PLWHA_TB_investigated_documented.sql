SELECT
    'Number of PLWHA in whom TB was investigated and documented' AS 'Title',
    PECG_Indicator10('#startDate#','#endDate#', 0, 1, 0, 'M') AS '<1 M',
    PECG_Indicator10('#startDate#','#endDate#', 0, 1, 0, 'F') AS '<1 F',
    PECG_Indicator10('#startDate#','#endDate#', 1, 4,  1, 'M') AS '1-4 M',
    PECG_Indicator10('#startDate#','#endDate#', 1, 4,  1, 'F') AS '1-4 F',
    PECG_Indicator10('#startDate#','#endDate#', 5, 9,  1, 'M') AS '5-9 M',
    PECG_Indicator10('#startDate#','#endDate#', 5, 9,  1, 'F') AS '5-9 F',
    PECG_Indicator10('#startDate#','#endDate#', 10, 14,  1, 'M') AS '10-14 M',
    PECG_Indicator10('#startDate#','#endDate#', 10, 14,  1, 'F') AS '10-14 F',
    PECG_Indicator10('#startDate#','#endDate#', 15, 19,  1, 'M') AS '15-19 M',
    PECG_Indicator10('#startDate#','#endDate#', 15, 19,  1, 'F') AS '15-19 F',
    PECG_Indicator10('#startDate#','#endDate#', 20, 24,  1, 'M') AS '20-24 M',
    PECG_Indicator10('#startDate#','#endDate#', 20, 24,  1, 'F') AS '20-24 F',
    PECG_Indicator10('#startDate#','#endDate#', 25, 49,  1, 'M') AS '25-49 M',
    PECG_Indicator10('#startDate#','#endDate#', 25, 49,  1, 'F') AS '25-49 F',
    PECG_Indicator10('#startDate#','#endDate#', 50, 200,  1, 'M') AS '>=50 M',
    PECG_Indicator10('#startDate#','#endDate#', 50, 200,  1, 'F') AS '>=50 F';
    