SELECT '3 - 5 months of ARVs dispensed' AS 'Title2',
    TREATMENT_Indicator2('#startDate#','#endDate#', 0, 15, 0, 'M', 3, 6) AS '<15 M',
    TREATMENT_Indicator2('#startDate#','#endDate#', 0, 15, 0, 'F', 3, 6) AS '<15 F',
    TREATMENT_Indicator2('#startDate#','#endDate#', 15, 200, 1, 'M', 3, 6) AS '>=15 M',
    TREATMENT_Indicator2('#startDate#','#endDate#', 15, 200, 1, 'F', 3, 6) AS '>=15 F',
    0 AS 'Unknown M',
    0 AS 'Unknown F';