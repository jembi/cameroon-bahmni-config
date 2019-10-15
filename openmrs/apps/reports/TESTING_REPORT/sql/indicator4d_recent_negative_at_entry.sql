SELECT 'Recent Negative at entry' AS 'Number of pregnant women with known HIV status at first antenatal care visit (ANC1) (includes those who already knew their HIV status prior to ANC1)', 
            TESTING_Indicator4d('#startDate#','#endDate#', 0, 10, 0) AS '<10 years',
            TESTING_Indicator4d('#startDate#','#endDate#', 10, 14, 1) AS '10-14 years',
            TESTING_Indicator4d('#startDate#','#endDate#', 15, 19, 1) AS '15-19 years',
            TESTING_Indicator4d('#startDate#','#endDate#', 20, 24, 1) AS '20-24 years',
            TESTING_Indicator4d('#startDate#','#endDate#', 25, 29, 1) AS '25-29 years',
            TESTING_Indicator4d('#startDate#','#endDate#', 30, 34, 1) AS '30-34 years',
            TESTING_Indicator4d('#startDate#','#endDate#', 35, 39, 1) AS '35-39 years',
            TESTING_Indicator4d('#startDate#','#endDate#', 40, 44, 1) AS '40-44 years',
            TESTING_Indicator4d('#startDate#','#endDate#', 45, 49, 1) AS '45-49 years',
            TESTING_Indicator4d('#startDate#','#endDate#', 50, 200, 1) AS '>=50 years',
            TESTING_Indicator4d('#startDate#','#endDate#', 0, 0, 0) AS 'Unknown Age';