/*D2. Number of old PLWHA on ARV who came for treatment in the month*/ 
SELECT QUERY.a, 
min(QUERY.less_than_1_M) AS '<1 M',
min(QUERY.less_than_1_F) AS '<1 F',
min(QUERY.14M) AS '1-4 M',
min(QUERY.14F) AS '1-4 F',
min(QUERY.59M) AS '5-9 M',
min(QUERY.59F) AS '5-9 F',
min(QUERY.1014M) AS '10-14 M',
min(QUERY.1014F) AS '10-14F',
min(QUERY.1519M) AS '15-19 M',
min(QUERY.1519F) AS '15-19 F',
min(QUERY.2024M) AS '20-24 M',
min(QUERY.2024F) AS '20-24 F',
min(QUERY.2549M) AS '25-49 M',
min(QUERY.2549F) AS '25-49 F',
min(QUERY.greater_than_or_equalTo_50M) AS '>=50 M',
min(QUERY.greater_than_or_equalTo_50F) AS '>=50 F' 
    FROM (
            SELECT 
            'Number of old PLWHA on ARV who came for treatment in the month' AS 'a'  ,
            SUM(lessThan1yrMale) AS 'less_than_1_M',
            SUM(lessThan1yrFemale) AS 'less_than_1_F',
            SUM(1To4yrMale) AS '14M',
            SUM(1To4yrFemale) AS '14F',
            SUM(5To9yrMale) AS '59M',
            SUM(5To9yrFemale) AS '59F',
            SUM(10To14yrMale) AS '1014M',
            SUM(10To14yrFemale) AS '1014F',
            SUM(15To19yrMale) AS '1519M',
            SUM(15To19yrFemale) AS '1519F',
            SUM(20To24yrMale) AS '2024M',
            SUM(20To24yrFemale) AS '2024F',
            SUM(25To49yrMale) AS '2549M',
            SUM(25To49yrFemale) AS '2549F',
            SUM(GrtThanequalto50Male) AS 'greater_than_or_equalTo_50M',
            SUM(GrtThanequalto50Female) AS 'greater_than_or_equalTo_50F'     
    FROM (     
            SELECT
            'Number of old PLWHA on ARV who came for treatment in the month',
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
        FROM (    
            SELECT
                distinct p.person_id,
                pp.date_enrolled as 'date_enrolled'
            from obs o 
            inner join concept_name cn on o.concept_id=cn.concept_id and cn.name like '%Date de début de traitement ARV%' or cn.name like '%ARV treatment start date%'
            and cn.concept_name_type = 'FULLY_SPECIFIED' 
            and cast(o.value_datetime AS DATE) between date '#startDate#'AND '#endDate#'
            join person p on p.person_id = o.person_id and p.voided=0 
            inner join obs obs1 on o.obs_group_id=obs1.obs_id
            inner join obs obs2 on obs2.obs_id=obs1.obs_group_id 
            inner join obs obs3 on obs3.obs_id=obs2.obs_group_id 
            inner join concept_name cn2 on obs3.concept_id=cn2.concept_id and cn2.name like '%FICHE DU PATIENT AVEC VIH - ADULTE%' or cn2.name like '%ADULT HIV PATIENT FORM%' 
            and cn2.concept_name_type = 'FULLY_SPECIFIED'
            join 
            concept c
            on c.concept_id=o.concept_id and c.retired=0
            join obs obs4 on p.person_id = obs4.person_id and p.voided=0 
            join 
                  concept_name cn3 
                  on cn3.concept_id=obs4.concept_id and cn3.voided=0 and cn3.concept_name_type ='FULLY_SPECIFIED' 
                  and cn3.name ='Dispensed'
            join
                patient_program pp 
                    on pp.patient_id=p.person_id 
                    and pp.voided=0 
                    and pp.date_completed is null
            join
                program pr 
                    on pr.program_id=pp.program_id 
                    and pr.name like '%HIV Program%'  
            
            ) AS ListOfpatient            
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
            END     ) AS Sub_query      
            UNION ALL
            SELECT
            'Number of old PLWHA on ARV who came for treatment in the month' AS 'a'  ,
            SUM(lessThan1yrMale) AS 'less_than_1_M',
            SUM(lessThan1yrFemale) AS 'less_than_1_F',
            SUM(1To4yrMale) AS '14M',
            SUM(1To4yrFemale) AS '14F',
            SUM(5To9yrMale) AS '59M',
            SUM(5To9yrFemale) AS '59F',
            SUM(10To14yrMale) AS '1014M',
            SUM(10To14yrFemale) AS '1014F',
            SUM(15To19yrMale) AS '1519M',
            SUM(15To19yrFemale) AS '1519F',
            SUM(20To24yrMale) AS '2024M',
            SUM(20To24yrFemale) AS '2024M',
            SUM(25To49yrMale) AS '2549M',
            SUM(25To49yrFemale) AS '2549F',
            SUM(GrtThanequalto50Male) AS 'greater_than_or_equalTo_50M',
            SUM(GrtThanequalto50Female) AS 'greater_than_or_equalTo_50F'     
    FROM (     
            SELECT
            'Number of old PLWHA on ARV who came for treatment in the month',
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
        FROM (    
            SELECT
                distinct p.person_id,
                pp.date_enrolled as 'date_enrolled'
            from person p inner join 
            obs o2 on p.person_id = o2.person_id and p.voided=0 
            inner join concept_name cn5 on o2.concept_id=cn5.concept_id and cn5.name like '%Date de début de traitement ARV%' or cn5.name like '%ARV treatment start date%' 
            and cn5.concept_name_type = 'FULLY_SPECIFIED'
            and cast(o2.value_datetime AS DATE) between date '#startDate#'AND '#endDate#'
            inner join obs obs4 on o2.obs_group_id=obs4.obs_id
            inner join obs obs5 on obs5.obs_id=obs4.obs_group_id 
            inner join obs obs6 on obs6.obs_id=obs5.obs_group_id 
            inner join obs obs7 on obs7.obs_id=obs6.obs_group_id 
            inner join concept_name cn4 on obs7.concept_id=cn4.concept_id and cn4.name like '%FICHE DU PATIENT AVEC VIH - ENFANT%' or cn4.name like '%CHILD HIV PATIENT FORM%' 
            and cn4.concept_name_type = 'FULLY_SPECIFIED'
            join 
            concept c
            on c.concept_id=o2.concept_id and c.retired=0
            join obs obs8 on p.person_id = obs8.person_id and p.voided=0 
            join 
                  concept_name cn3 
                  on cn3.concept_id=obs8.concept_id and cn3.voided=0 and cn3.concept_name_type ='FULLY_SPECIFIED' 
                  and cn3.name ='Dispensed'
            join
                patient_program pp 
                    on pp.patient_id=p.person_id 
                    and pp.voided=0 
                    and pp.date_completed is null    
                    and cast(pp.date_enrolled AS DATE) between date '#startDate#'AND '#endDate#'
            join
                program pr 
                    on pr.program_id=pp.program_id 
                    and pr.name like '%HIV Program%'  
            ) AS ListOfpatient            
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
            END     ) AS Sub_query
            UNION ALL
            SELECT
            'Number of old PLWHA on ARV who came for treatment in the month' AS 'a'  ,
            SUM(lessThan1yrMale) AS 'less_than_1_M',
            SUM(lessThan1yrFemale) AS 'less_than_1_F',
            SUM(1To4yrMale) AS '14M',
            SUM(1To4yrFemale) AS '14F',
            SUM(5To9yrMale) AS '59M',
            SUM(5To9yrFemale) AS '59F',
            SUM(10To14yrMale) AS '1014M',
            SUM(10To14yrFemale) AS '1014F',
            SUM(15To19yrMale) AS '1519M',
            SUM(15To19yrFemale) AS '1519F',
            SUM(20To24yrMale) AS '2024M',
            SUM(20To24yrFemale) AS '2024M',
            SUM(25To49yrMale) AS '2549M',
            SUM(25To49yrFemale) AS '2549F',
            SUM(GrtThanequalto50Male) AS 'greater_than_or_equalTo_50M',
            SUM(GrtThanequalto50Female) AS 'greater_than_or_equalTo_50F'     
    FROM (     
            SELECT
            'Number of old PLWHA on ARV who came for treatment in the month',
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
        FROM (    
            SELECT
                distinct p.person_id,
                pp.date_enrolled as 'date_enrolled'
            from person p inner join 
            obs o3 on p.person_id = o3.person_id and p.voided=0 
            inner join concept_name cn6 on o3.concept_id=cn6.concept_id and cn6.name like "%Si traitement ARV antérieur\; Date début%" or cn6.name like "%If anterior ARV treatment\; Start date%"
            and cn6.concept_name_type = 'FULLY_SPECIFIED'
            and cast(o3.value_datetime AS DATE) between date '#startDate#'AND '#endDate#' 
            inner join obs obs8 on o3.obs_group_id=obs8.obs_id
            inner join obs obs9 on obs9.obs_id=obs8.obs_group_id 
            inner join obs obs10 on obs10.obs_id=obs9.obs_group_id 
            inner join concept_name cn7 on obs10.concept_id=cn7.concept_id and cn7.name like '%FICHE DU PATIENT AVEC VIH - ADULTE%' or cn7.name like "%ADULT HIV PATIENT FORM%" 
            and cn7.concept_name_type = 'FULLY_SPECIFIED'
            join 
            concept c
            on c.concept_id=o3.concept_id and c.retired=0
            join obs obs4 on p.person_id = obs4.person_id and p.voided=0 
            join 
                  concept_name cn3 
                  on cn3.concept_id=obs4.concept_id and cn3.voided=0 and cn3.concept_name_type ='FULLY_SPECIFIED' 
                  and cn3.name ='Dispensed'
            join
                patient_program pp 
                    on pp.patient_id=p.person_id 
                    and pp.voided=0 
                    and pp.date_completed is null  
            join
                program pr 
                    on pr.program_id=pp.program_id 
                    and pr.name like '%HIV Program%'  
            ) AS ListOfpatient            
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
            END     ) AS Sub_query
            UNION ALL
            SELECT
            'Number of old PLWHA on ARV who came for treatment in the month' AS 'a'  ,
            SUM(lessThan1yrMale) AS 'less_than_1_M',
            SUM(lessThan1yrFemale) AS 'less_than_1_F',
            SUM(1To4yrMale) AS '14M',
            SUM(1To4yrFemale) AS '14F',
            SUM(5To9yrMale) AS '59M',
            SUM(5To9yrFemale) AS '59F',
            SUM(10To14yrMale) AS '1014M',
            SUM(10To14yrFemale) AS '1014F',
            SUM(15To19yrMale) AS '1519M',
            SUM(15To19yrFemale) AS '1519F',
            SUM(20To24yrMale) AS '2024M',
            SUM(20To24yrFemale) AS '2024M',
            SUM(25To49yrMale) AS '2549M',
            SUM(25To49yrFemale) AS '2549F',
            SUM(GrtThanequalto50Male) AS 'greater_than_or_equalTo_50M',
            SUM(GrtThanequalto50Female) AS 'greater_than_or_equalTo_50F'     
    FROM (     
            SELECT
            'Number of old PLWHA on ARV who came for treatment in the month',
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
        FROM (    
            SELECT
                distinct p.person_id,
                pp.date_enrolled as 'date_enrolled'
            from person p inner join 
            obs o4 on p.person_id = o4.person_id and p.voided=0            
            inner join concept_name cn8 on o4.concept_id=cn8.concept_id and cn8.name like "%Date d\'initiation%"  or cn8.name like "%Initiation date%" 
            and cn8.concept_name_type = 'FULLY_SPECIFIED' 
            and cast(o4.value_datetime AS DATE) between date '#startDate#'AND '#endDate#'
            inner join obs obs11 on o4.obs_group_id=obs11.obs_id
            inner join obs obs12 on obs12.obs_id=obs11.obs_group_id 
            inner join obs obs13 on obs13.obs_id=obs12.obs_group_id 
            inner join concept_name cn9 on obs13.concept_id=cn9.concept_id and cn9.name like '%FICHE DU PATIENT AVEC VIH - ENFANT%' or cn9.name like '%CHILD HIV PATIENT FORM%' 
            and cn9.concept_name_type = 'FULLY_SPECIFIED'
            join 
            concept c
            on c.concept_id=o4.concept_id and c.retired=0
            join obs obs4 on p.person_id = obs4.person_id and p.voided=0 
            join 
                  concept_name cn3 
                  on cn3.concept_id=obs4.concept_id and cn3.voided=0 and cn3.concept_name_type ='FULLY_SPECIFIED' 
                  and cn3.name ='Dispensed'
            join
                patient_program pp 
                    on pp.patient_id=p.person_id 
                    and pp.voided=0 
                    and pp.date_completed is null
            join
                program pr 
                    on pr.program_id=pp.program_id 
                    and pr.name like '%HIV Program%'  
            ) AS ListOfpatient            
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
            END     ) AS Sub_query     
            ) QUERY GROUP BY QUERY.a;