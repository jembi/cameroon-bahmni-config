SELECT
    LTFU_Indicator('#startDate#','#endDate#', 0, 1, 0, 'M') AS '<1 M',
    LTFU_Indicator('#startDate#','#endDate#', 0, 1, 0, 'F') AS '<1 F',
    LTFU_Indicator('#startDate#','#endDate#', 1, 4, 1, 'M') AS '1-4 M',
    LTFU_Indicator('#startDate#','#endDate#', 1, 4, 1, 'F') AS '1-4 F',
    LTFU_Indicator('#startDate#','#endDate#', 5, 9, 1, 'M') AS '5-9 M',
    LTFU_Indicator('#startDate#','#endDate#', 5, 9, 1, 'F') AS '5-9 F',
    LTFU_Indicator('#startDate#','#endDate#', 10, 14, 1, 'M') AS '10-14 M',
    LTFU_Indicator('#startDate#','#endDate#', 10, 14, 1, 'F') AS '10-14 F',
    LTFU_Indicator('#startDate#','#endDate#', 15, 19, 1, 'M') AS '15-19 M',
    LTFU_Indicator('#startDate#','#endDate#', 15, 19, 1, 'F') AS '15-19 F',
    LTFU_Indicator('#startDate#','#endDate#', 20, 24, 1, 'M') AS '20-24 M',
    LTFU_Indicator('#startDate#','#endDate#', 20, 24, 1, 'F') AS '20-24 F',
    LTFU_Indicator('#startDate#','#endDate#', 25, 49, 1, 'M') AS '25-49 M',
    LTFU_Indicator('#startDate#','#endDate#', 25, 49, 1, 'F') AS '25-49 F',
    LTFU_Indicator('#startDate#','#endDate#', 50, 200, 1, 'M') AS '>=50 M',
    LTFU_Indicator('#startDate#','#endDate#', 50, 200, 1, 'F') AS '>=50 F';

	