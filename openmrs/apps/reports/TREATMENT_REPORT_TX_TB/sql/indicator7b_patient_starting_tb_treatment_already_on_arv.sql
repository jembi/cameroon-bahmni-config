SELECT 'Patients starting TB treatment who were already on ART' AS 'Title',
    TREATMENT_Indicator7b('#startDate#','#endDate#', 0, 15, 0, 'M') AS '<15 M',
    TREATMENT_Indicator7b('#startDate#','#endDate#', 0, 15, 0, 'F') AS '<15 F',
    TREATMENT_Indicator7b('#startDate#','#endDate#', 15, 200, 1, 'M') AS '>=15 M',
    TREATMENT_Indicator7b('#startDate#','#endDate#', 15, 200, 1, 'F') AS '>=15 F',
    0 AS 'Unknown M',
    0 AS 'Unknown F';