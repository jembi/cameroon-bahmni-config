SELECT 'Paediatric' AS 'Title',
    Testing_Indicator1('#startDate#','#endDate#',0,1,0,'m','Positive','Paediatric') AS '<1 years M Pos',
    Testing_Indicator1('#startDate#','#endDate#',0,1,0,'f','Positive','Paediatric') AS '<1 years F Pos',
    Testing_Indicator1('#startDate#','#endDate#',1,4,1,'m','Positive','Paediatric') AS '1 - 4 years M Pos',
    Testing_Indicator1('#startDate#','#endDate#',1,4,1,'f','Positive','Paediatric') AS '1 - 4 years F Pos',
    Testing_Indicator1('#startDate#','#endDate#',0,1,0,'m','Negative','Paediatric') AS '<1 years M Neg',
    Testing_Indicator1('#startDate#','#endDate#',0,1,0,'f','Negative','Paediatric') AS '<1 years F Neg',
    Testing_Indicator1('#startDate#','#endDate#',1,4,1,'m','Negative','Paediatric') AS '1 - 4 years M Neg',
    Testing_Indicator1('#startDate#','#endDate#',1,4,1,'f','Negative','Paediatric') AS '1 - 4 years F Neg';