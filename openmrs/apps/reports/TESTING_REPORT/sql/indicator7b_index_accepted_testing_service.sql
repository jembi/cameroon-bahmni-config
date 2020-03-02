SELECT 'Number of index cases accepted index testing services' AS 'Title',
    Testing_Indicator7ab('#startDate#','#endDate#',0,1,0,'m', 1) AS '<1 years M Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',0,1,0,'f', 1) AS '<1 years F Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',1,4,1,'m', 1) AS '1 - 4 years M Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',1,4,1,'f', 1) AS '1 - 4 years F Pos',   
    Testing_Indicator7ab('#startDate#','#endDate#',5,9,1,'m', 1) AS '5 - 9 years M Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',5,9,1,'f', 1) AS '5 - 9 years F Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',10,14,1,'m', 1) AS '10-14 years M Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',10,14,1,'f', 1) AS '10-14 years F Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',15,19,1,'m', 1) AS '15-19 years M Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',15,19,1,'f', 1) AS '15-19 years F Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',20,24,1,'m', 1) AS '20-24 years M Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',20,24,1,'f', 1) AS '20-24 years F Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',25,29,1,'m', 1) AS '25-29 years M Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',25,29,1,'f', 1) AS '25-29 years F Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',30,34,1,'m', 1) AS '30-34 years M Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',30,34,1,'f', 1) AS '30-34 years F Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',35,39,1,'m', 1) AS '35-39 years M Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',35,39,1,'f', 1) AS '35-39 years F Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',40,44,1,'m', 1) AS '40-44 years M Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',40,44,1,'f', 1) AS '40-44 years F Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',45,49,1,'m', 1) AS '45-49 years M Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',45,49,1,'f', 1) AS '45-49 years F Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',50,200,1,'m', 1) AS '>=50 years M Pos',
    Testing_Indicator7ab('#startDate#','#endDate#',50,200,1,'f', 1) AS '>=50 years F Pos',
    0 AS 'Unknown Age M Pos',
    0 AS 'Unknown Age F Pos';