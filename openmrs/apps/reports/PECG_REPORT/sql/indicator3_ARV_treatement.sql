 /*D3. Number of new PLWHA placed 
        on ARV who took treatment in the month*/ SELECT
            /*Pivoting the table*/     'Number of new PLWHA placed on ARV who took treatment in the month' AS '-'  ,
            SUM(lessThan1yrMale) AS '<1 M',
            SUM(lessThan1yrFemale) AS '<1 F',
            SUM(1To4yrMale) AS '1-4 M',
            SUM(1To4yrFemale) AS '1-4 F',
            SUM(5To9yrMale) AS '5-9 M',
            SUM(5To9yrFemale) AS '5-9 F',
            SUM(10To14yrMale) AS '10-14 M',
            SUM(10To14yrFemale) AS '10-14 F',
            SUM(15To19yrMale) AS '15-19 M',
            SUM(15To19yrFemale) AS '15-19 F',
            SUM(20To24yrMale) AS '20-24 M',
            SUM(20To24yrFemale) AS '20-24 F',
            SUM(25To49yrMale) AS '25-49 M',
            SUM(25To49yrFemale) AS '25-49 F',
            SUM(GrtThanequalto50Male) AS '>=50 M',
            SUM(GrtThanequalto50Female) AS '>=50 F'     
    FROM
        (     SELECT
            'Number of new PLWHA placed on ARV who took treatment in the month',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) < 1 
                AND p.gender = 'M'          THEN COUNT(1)  
            END AS 'lessThan1yrMale',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) < 1 
                AND p.gender = 'F'          THEN COUNT(1)  
            END AS 'lessThan1yrFemale',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 1 AND 4 
                AND p.gender = 'M'          THEN COUNT(1)  
            END AS '1To4yrMale',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 1 AND 4 
                AND p.gender = 'F'          THEN COUNT(1)  
            END AS '1To4yrFemale',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 5 AND 9 
                AND p.gender = 'M'          THEN COUNT(1)  
            END AS '5To9yrMale',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 5 AND 9 
                AND p.gender = 'F'          THEN COUNT(1)  
            END AS '5To9yrFemale',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 10 AND 14 
                AND p.gender = 'M'          THEN COUNT(1)  
            END AS '10To14yrMale',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 10 AND 14 
                AND p.gender = 'F'          THEN COUNT(1)  
            END AS '10To14yrFemale',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 15 AND 19 
                AND p.gender = 'M'          THEN COUNT(1)  
            END AS '15To19yrMale',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 15 AND 19 
                AND p.gender = 'F'          THEN COUNT(1)  
            END AS '15To19yrFemale',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 20 AND 24 
                AND p.gender = 'M'          THEN COUNT(1)  
            END AS '20To24yrMale',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 20 AND 24 
                AND p.gender = 'F'          THEN COUNT(1)  
            END AS '20To24yrFemale',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 25 AND 49 
                AND p.gender = 'M'          THEN COUNT(1)  
            END AS '25To49yrMale',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 25 AND 49 
                AND p.gender = 'F'          THEN COUNT(1)  
            END AS '25To49yrFemale',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) >= 50 
                AND p.gender = 'M'          THEN COUNT(1)  
            END AS 'GrtThanequalto50Male',
            CASE 
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) >= 50 
                AND p.gender = 'F'          THEN COUNT(1)  
            END AS 'GrtThanequalto50Female'     
        FROM
            (              select
                distinct p.person_id,
                pp.date_enrolled  
            from
                person_name pn     
            join
                person p 
                    on p.person_id = pn.person_id  
                    and p.voided=0    
            join
                patient_program pp 
                    on pp.patient_id=p.person_id 
                    and pp.voided=0 
                    and pp.date_completed is null    
                    and cast(pp.date_enrolled AS DATE) between '#startDate#'AND '#endDate#'    
            join
                program pr 
                    on pr.program_id=pp.program_id 
                    and pr.name like '%HIV Program%'    
            join
                patient_program_attribute ppa 
                    on ppa.patient_program_id=pp.patient_program_id     
                    and cast(ppa.value_reference AS DATE) between '#startDate#'AND '#endDate#'    
            join
                program_attribute_type pat 
                    on pat.program_attribute_type_id = ppa.attribute_type_id 
                    and pat.name like 'Date%'              ) AS ListOfpatient            
        INNER JOIN
            person p 
                ON p.person_id = ListOfpatient.person_id            
        GROUP BY
            CASE                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) < 1 
                AND p.gender = 'M'                THEN '< 1 Yr M'                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) < 1 
                AND p.gender = 'F'                THEN '< 1 Yr F'                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 1 AND 4 
                AND p.gender = 'M'                THEN '1-4 Yrs M'                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 1 AND 4 
                AND p.gender = 'F'                THEN '1-4 Yrs F'                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 5 AND 9 
                AND p.gender = 'M'                THEN '5-9 Yrs M'                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 5 AND 9 
                AND p.gender = 'F'                THEN '5-9 Yrs F'                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 10 AND 14 
                AND p.gender = 'M'                THEN '10-14 Yrs M'                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 10 AND 14 
                AND p.gender = 'F'                THEN '10-14 Yrs F'                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 15 AND 19 
                AND p.gender = 'M'                THEN '15-19 Yrs M'                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 15 AND 19 
                AND p.gender = 'F'                THEN '15-19 Yrs F'                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 20 AND 24 
                AND p.gender = 'M'                THEN '20-24 Yrs M'                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 20 AND 24 
                AND p.gender = 'F'                THEN '20-24 Yrs F'                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 25 AND 49 
                AND p.gender = 'M'                THEN '25-49 Yrs M'                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) BETWEEN 25 AND 49 
                AND p.gender = 'F'                THEN '25-49 Yrs F'                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) >= 50 
                AND p.gender = 'M'                THEN '>= 50 Yrs M'                
                WHEN timestampdiff(YEAR,
                p.birthdate,
                ListOfpatient.date_enrolled) >= 50 
                AND p.gender = 'F'                THEN '>= 50 Yrs F'             
            END     ) AS Sub_query      ;
    
