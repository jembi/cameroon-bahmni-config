-- psql -U clinlims -d clinlims -a -f /bahmni/cameroon-bahmni-metadata/postgresql/add_test_ranges.sql
delete from result_limits;
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (1,(select id from test where description = 'Bleeding time'),4,0,5,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (2,(select id from test where description = 'Total Leucocyte count'),4,3.5,12,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (3,(select id from test where description = 'Neutrophils'),4,3,5.8,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (4,(select id from test where description = 'Eosinophils'),4,0.05,0.25,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (5,(select id from test where description = 'Lymphocytes'),4,1.5,3,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (6,(select id from test where description = 'Basophils'),4,0.01,0.05,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (7,(select id from test where description = 'Monocytes'),4,0.3,0.5,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (8,(select id from test where description = 'Platelets'),4,150,400,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (9,(select id from test where description = 'RBC'),4,4.2,5.4,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (10,(select id from test where description = 'MCV'),4,76,100,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (11,(select id from test where description = 'Reticulocytes'),4,0.025,0.075,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (12,(select id from test where description = 'MCH'),4,50,50,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (13,(select id from test where description = 'Triglycerides'),4,40,160,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (14,(select id from test where description = 'HDL'),4,0,5.2,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (15,(select id from test where description = 'LDL'),4,0,0.91,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (16,(select id from test where description = 'Sodium'),4,135,145,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (17,(select id from test where description = 'Creatinine'),4,50,110,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (18,(select id from test where description = 'Chloride'),4,96,106,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (19,(select id from test where description = 'Potassium'),4,3.5,5.1,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (20,(select id from test where description = 'Uric acid'),4,2.9,8.2,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (21,(select id from test where description = 'Calcium'),4,2.1,2.5,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (22,(select id from test where description = 'Magnésium'),4,0.65,1.05,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (23,(select id from test where description = 'Amylase'),4,25,125,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (24,(select id from test where description = 'Urea'),4,0.7,6.4,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (25,(select id from test where description = 'Haemoglobin'),4,12,18,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (26,(select id from test where description = 'Prostate specific antigen (PSA)'),4,0,4,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (27,(select id from test where description = 'Erythrocyte Sedimentation Rate'),4,0,15,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (28,(select id from test where description = 'Prothrombin time (PT)'),4,9,12,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (29,(select id from test where description = 'Direct or conjugate Bilirubin'),4,0,5,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (30,(select id from test where description = 'Alanine Aminotransferase'),4,5,35,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (31,(select id from test where description = 'Aspartate Aminotransferase'),4,7,40,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (32,(select id from test where description = 'Total Bilirubin'),4,1,22,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (33,(select id from test where description = 'Specific gravity'),4,1.003,1.03,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (34,(select id from test where description = 'PTH'),4,1.4,6.8,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (35,(select id from test where description = 'Haematocrit'),4,0.4,0.54,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (36,(select id from test where description = 'Thrombin Time'),4,0,17,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (37,(select id from test where description = 'APTT test'),4,25,40,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (38,(select id from test where description = 'TO Titre'),4,20,160,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (39,(select id from test where description = 'TH Titre'),4,20,160,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (40,(select id from test where description = 'AO Titre'),4,20,160,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (41,(select id from test where description = 'AH Titre'),4,20,160,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (42,(select id from test where description = 'BO Titre'),4,20,160,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (43,(select id from test where description = 'BH Titre'),4,20,160,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (44,(select id from test where description = 'CO Titre'),4,20,160,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (45,(select id from test where description = 'CH Titre'),4,20,160,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (47,(select id from test where description = 'CO2 (total)'),4,22,29,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (48,(select id from test where description = 'Protein (serum) - Total'),4,60,80,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (49,(select id from test where description = 'Protein (serum) - Albumin'),4,35,55,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (50,(select id from test where description = 'Fasting blood glucose'),4,3.9,6.1,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (51,(select id from test where description = 'Sodium (urine)'),4,40,220,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (52,(select id from test where description = 'Iron level'),4,5,29,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (53,(select id from test where description = 'Iron binding capacity (TIBC)'),4,45,73,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (54,(select id from test where description = 'Ferritin'),4,20,200,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (55,(select id from test where description = 'Bicarbonate (HCO3)'),4,23,29,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (56,(select id from test where description = 'Calcium Ionized'),4,1.15,1.35,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (57,(select id from test where description = 'Creatine kinase'),4,20,215,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (58,(select id from test where description = 'Osmolality (serum)'),4,285,295,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (59,(select id from test where description = 'Chloride (urine)'),4,110,250,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (60,(select id from test where description = 'Creatinine (urine)'),4,7,17.6,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (61,(select id from test where description = 'Magnesium (urine)'),4,3,4.3,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (62,(select id from test where description = 'Osmolality (urine)'),4,38,1400,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (63,(select id from test where description = 'Protein (urine)'),4,10,150,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (64,(select id from test where description = 'Cortisol (plasma) 8 AM'),4,170,635,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (65,(select id from test where description = 'Cortisol (plasma) 4 PM'),4,82,413,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (66,(select id from test where description = 'Oxygen (arterial saturation)'),4,94,94,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (67,(select id from test where description = 'pCO2 (arterial)'),4,35,45,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (68,(select id from test where description = 'pO2 (arterial)'),4,80,100,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (69,(select id from test where description = 'pH (arterial)'),4,7.35,7.45,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (70,(select id from test where description = 'Triiodothyronine total (T3)'),4,3.5,6.5,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (71,(select id from test where description = 'Triiodothyronine free (FT3)'),4,0.45,1.71,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (72,(select id from test where description = 'Thyroxine total (T4)'),4,66,155,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (73,(select id from test where description = 'Thyroxine free (FT4)'),4,13,27,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (74,(select id from test where description = 'Growth hormone (hGH) fasting'),4,0,10,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (75,(select id from test where description = 'Sperm count'),4,20,150,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (76,(select id from test where description = 'GGT (Gamma-Glutamyl Transferase) Test'),4,9,48,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (77,(select id from test where description = 'Lipase'),4,0,1.6,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (78,(select id from test where description = 'Glucose-6-phosphate dehydrogenase'),4,5.5,20.5,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (79,(select id from test where description = 'D-dimeres IFA'),4,0,500,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (80,(select id from test where description = 'Alpha-fetoprotein (AFP)'),4,0,8,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (81,(select id from test where description = 'Rheumatoid factor Test'),4,0,6,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (82,(select id from test where description = 'Alkaline phosphatase'),4,35,400,'f', now());
insert into result_limits (id,test_id,test_result_type_id,low_normal,high_normal, always_validate,lastupdated) values (83,(select id from test where description = 'Urobilinogen (Urine)'),4,0.2,32,'f', now());