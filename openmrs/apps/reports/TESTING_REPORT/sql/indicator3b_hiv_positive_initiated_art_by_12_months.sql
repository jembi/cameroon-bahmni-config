SELECT 'Positive, Confirmed Initiated ART' AS 'Number of HIV-infected infants identified in the reporting period, whose diagnostic sample was collected by 12 months of age',
    Testing_Indicator3b('#startDate#','#endDate#', 0, 2, 1) AS '0<=2',
    Testing_Indicator3b('#startDate#','#endDate#', 2, 12, 0) AS '2-12';