SELECT 'New on ART/Screen Positive' AS 'Title',
    TREATMENT_Indicator7c('#startDate#','#endDate#', 0, 15, 0, 'M') AS '<15 M',
    TREATMENT_Indicator7c('#startDate#','#endDate#', 0, 15, 0, 'F') AS '<15 F',
    TREATMENT_Indicator7c('#startDate#','#endDate#', 15, 200, 1, 'M') AS '>=15 M',
    TREATMENT_Indicator7c('#startDate#','#endDate#', 15, 200, 1, 'F') AS '>=15 F',
    0 AS 'Unknown M',
    0 AS 'Unknown F';