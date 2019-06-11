SELECT 'PATIENT DATA COLLECTION' AS '-'  ,
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 0, 1, 0, 'M') AS '< 1 year M', 
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 0, 1, 0, 'F') AS '< 1 year F',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 1, 2, 0, 'M') AS '1 - < 2 years M',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 1, 2, 0, 'F') AS '1 - < 2 years F',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 2, 3, 0, 'M') AS '2 - < 3 years M',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 2, 3, 0, 'F') AS '2 - < 3 years F',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 3, 4, 1, 'M') AS '3 - 4 years M',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 3, 4, 1, 'F') AS '3 - 4 years F',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 5, 14, 1, 'M') AS '5 - 14 years M',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 5, 14, 1, 'F') AS '5 - 14 years F',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 15, 19, 1, 'M') AS '15 - 19 years M',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 15, 19, 1, 'F') AS '15 - 19 years F',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 20, 24, 1, 'M') AS '20 - 24 years M',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 20, 24, 1, 'F') AS '20 - 24 years F',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 25, 29, 1, 'M') AS '25 - 29 years M',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 25, 29, 1, 'F') AS '25 - 29 years F',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 30, 34, 1, 'M') AS '30 - 34 years M',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 30, 34, 1, 'F') AS '30 - 34 years F',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 35, 39, 1, 'M') AS '35 - 39 years M',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 35, 39, 1, 'F') AS '35 - 39 years F',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 40, 44, 1, 'M') AS '40 - 44 years M',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 40, 44, 1, 'F') AS '40 - 44 years F',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 45, 49, 1, 'M') AS '45 - 49 years M',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 45, 49, 1, 'F') AS '45 - 49 years F',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 50, 200, 1, 'M') AS '50 yearss and more M',
            PECG_DATA_COLLECTION('#startDate#','#endDate#', 50, 200, 1, 'F') AS '50 yearss and more F';