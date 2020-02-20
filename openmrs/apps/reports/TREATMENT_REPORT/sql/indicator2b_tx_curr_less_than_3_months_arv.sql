SELECT '(TX_CURR) ARV Dispensing Quantity' AS 'Title',
    '< 3 months of ARVs (not MMD) dispensed' AS 'Title2',
    TREATMENT_Indicator2('#startDate#','#endDate#', 0, 15, 0, 'M', 0, 3) AS '<15 M',
    TREATMENT_Indicator2('#startDate#','#endDate#', 0, 15, 0, 'F', 0, 3) AS '<15 F',
    TREATMENT_Indicator2('#startDate#','#endDate#', 15, 200, 1, 'M', 0, 3) AS '>=15 M',
    TREATMENT_Indicator2('#startDate#','#endDate#', 15, 200, 1, 'F', 0, 3) AS '>=15 F',
    0 AS 'Unknown M',
    0 AS 'Unknown F';