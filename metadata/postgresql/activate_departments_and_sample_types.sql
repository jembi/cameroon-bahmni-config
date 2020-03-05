-- psql -U clinlims -d clinlims -a -f /bahmni/cameroon-bahmni-metadata/postgresql/activate_departments_and_sample_types.sql
update test_section set is_active='N';
update test_section set is_active='Y' where description in ('Bacteriology Dept Orders','Haematology Dept Orders','Biochemistry Dept Orders','Parasitology Dept Orders', 'Serology Dept Orders');
update type_of_sample set is_active='N';
update type_of_sample set is_active='Y' where description in ('Blood sample','Serum sample','Urine Sample','Urine Sediments sample','Arteriall blood sample','Cerebro-spinal fluid sample','Puncture liquid sample','Semen sample','Sputum sample','Stool sample','Urethral smear sample','Vaginal Cervical smear sample','Skin snip sample','PUS sample');