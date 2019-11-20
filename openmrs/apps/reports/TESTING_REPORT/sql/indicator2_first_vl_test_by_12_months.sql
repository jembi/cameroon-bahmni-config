SELECT 'Total' AS 'Number of infants who had a first virologic HIV test (sample collected) by 12 months of age during the reporting period',
    Testing_Indicator2('#startDate#','#endDate#', 0, 2, 1) AS '0<=2',
    Testing_Indicator2('#startDate#','#endDate#', 2, 12, 0) AS '2-12';