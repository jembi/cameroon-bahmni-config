SELECT '6 or more months of ARVs dispensed' AS 'Title',
    TREATMENT_Indicator2('#startDate#','#endDate#', 0, 15, 0, 'M', 6, 200) AS '<15 M',
    TREATMENT_Indicator2('#startDate#','#endDate#', 0, 15, 0, 'F', 6, 200) AS '<15 F',
    TREATMENT_Indicator2('#startDate#','#endDate#', 15, 200, 1, 'M', 6, 200) AS '>=15 M',
    TREATMENT_Indicator2('#startDate#','#endDate#', 15, 200, 1, 'F', 6, 200) AS '>=15 F',
    0 AS 'Unknown M',
    0 AS 'Unknown F';