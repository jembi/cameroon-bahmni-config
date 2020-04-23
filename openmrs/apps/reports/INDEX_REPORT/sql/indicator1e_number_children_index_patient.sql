SELECT 'Number of children for index patient' AS 'Title',
    Index_Indicator1e('#startDate#','#endDate#',0,1,0,'m') AS '<1 years M',
    Index_Indicator1e('#startDate#','#endDate#',0,1,0,'f') AS '<1 years F',
    Index_Indicator1e('#startDate#','#endDate#',1,4,1,'m') AS '1 - 4 years M',
    Index_Indicator1e('#startDate#','#endDate#',1,4,1,'f') AS '1 - 4 years F',
    Index_Indicator1e('#startDate#','#endDate#',5,9,1,'m') AS '5 - 9 years M',
    Index_Indicator1e('#startDate#','#endDate#',5,9,1,'f') AS '5 - 9 years F',
    Index_Indicator1e('#startDate#','#endDate#',10,14,1,'m') AS '10-14 years M',
    Index_Indicator1e('#startDate#','#endDate#',10,14,1,'f') AS '10-14 years F',
    Index_Indicator1e('#startDate#','#endDate#',15,19,1,'m') AS '15-19 years M',
    Index_Indicator1e('#startDate#','#endDate#',15,19,1,'f') AS '15-19 years F',
    Index_Indicator1e('#startDate#','#endDate#',20,24,1,'m') AS '20-24 years M',
    Index_Indicator1e('#startDate#','#endDate#',20,24,1,'f') AS '20-24 years F',
    Index_Indicator1e('#startDate#','#endDate#',25,29,1,'m') AS '25-29 years M',
    Index_Indicator1e('#startDate#','#endDate#',25,29,1,'f') AS '25-29 years F',
    Index_Indicator1e('#startDate#','#endDate#',30,34,1,'m') AS '30-34 years M',
    Index_Indicator1e('#startDate#','#endDate#',30,34,1,'f') AS '30-34 years F',
    Index_Indicator1e('#startDate#','#endDate#',35,39,1,'m') AS '35-39 years M',
    Index_Indicator1e('#startDate#','#endDate#',35,39,1,'f') AS '35-39 years F',
    Index_Indicator1e('#startDate#','#endDate#',40,44,1,'m') AS '40-44 years M',
    Index_Indicator1e('#startDate#','#endDate#',40,44,1,'f') AS '40-44 years F',
    Index_Indicator1e('#startDate#','#endDate#',45,49,1,'m') AS '45-49 years M',
    Index_Indicator1e('#startDate#','#endDate#',45,49,1,'f') AS '45-49 years F',
    Index_Indicator1e('#startDate#','#endDate#',50,200,1,'m') AS '>=50 years M',
    Index_Indicator1e('#startDate#','#endDate#',50,200,1,'f') AS '>=50 years F',
    0 AS 'Unknown Age M',
    0 AS 'Unknown Age F';