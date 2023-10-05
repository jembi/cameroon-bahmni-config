-- Adding ABHA Number Identifier Type
INSERT IGNORE INTO patient_identifier_type (name, description, creator, uuid, uniqueness_behavior, location_behavior, date_created)
SELECT 'UHC Unique ID', 'UHC Unique ID', creator, '0c1caf8b-61a9-4455-8c44-3fea85462def', 'UNIQUE', 'NOT_USED', NOW()
FROM users
WHERE username = 'admin';

update global_property set property_value=(SELECT CONCAT(IF(ISNULL(property_value),'',CONCAT(property_value,',')),uuid)
 from patient_identifier_type where name = 'UHC Unique ID') where property = 'bahmni.extraPatientIdentifierTypes';
