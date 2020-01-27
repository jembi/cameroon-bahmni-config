SELECT 'Refused (Stopped) Treatment' AS 'Title',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 0, 1, 0, 'M') AS '<1 M',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 0, 1, 0, 'F') AS '<1 F',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 1, 4, 1, 'M') AS '1-4 M',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 1, 4, 1, 'F') AS '1-4 F',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 5, 9, 1, 'M') AS '5-9 M',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 5, 9, 1, 'F') AS '5-9 F',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 10, 14, 1, 'M') AS '10-14 M',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 10, 14, 1, 'F') AS '10-14 F',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 15, 19, 1, 'M') AS '15-19 M',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 15, 19, 1, 'F') AS '15-19 F',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 20, 24, 1, 'M') AS '20-24 M',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 20, 24, 1, 'F') AS '20-24 F',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 25, 29, 1, 'M') AS '25-29 M',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 25, 29, 1, 'F') AS '25-29 F',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 30, 34, 1, 'M') AS '30-34 M',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 30, 34, 1, 'F') AS '30-34 F',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 35, 39, 1, 'M') AS '35-39 M',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 35, 39, 1, 'F') AS '35-39 F',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 40, 44, 1, 'M') AS '40-44 M',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 40, 44, 1, 'F') AS '40-44 F',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 45, 49, 1, 'M') AS '45-49 M',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 45, 49, 1, 'F') AS '45-49 F',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 50, 200, 1, 'M') AS '>=50 M',
    TREATMENT_Indicator4d('#startDate#','#endDate#', 50, 200, 1, 'F') AS '>=50 F',
    0 AS 'Unknown M',
    0 AS 'Unknown F';