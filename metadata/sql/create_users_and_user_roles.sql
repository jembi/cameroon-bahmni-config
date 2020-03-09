SET @nursesalt = (SHA2(SUBSTRING(MD5(RAND()), -10), 512));
SET @doctorsalt = (SHA2(SUBSTRING(MD5(RAND()), -10), 512));
SET @receptionsalt = (SHA2(SUBSTRING(MD5(RAND()), -10), 512));

SET @nurse_user_uuid = '3bfbd6ec-ad1c-11e9-a2a3-2a2ae2dbcce4';
SET @doctor_user_uuid = '3bfbdbba-ad1c-11e9-a2a3-2a2ae2dbcce4';
SET @reception_user_uuid = '3bfbdd40-ad1c-11e9-a2a3-2a2ae2dbcce4';
SET @superman_user_uuid = 'c1c21e11-3f10-11e4-adec-0800271c1b75';

SET @nurse_person_uuid = '564565ae-aec5-11e9-a2a3-2a2ae2dbcce4';
SET @doctor_person_uuid = '56456824-aec5-11e9-a2a3-2a2ae2dbcce4';
SET @reception_person_uuid = '56456978-aec5-11e9-a2a3-2a2ae2dbcce4';

INSERT IGNORE INTO person (uuid, gender, date_created, creator)
    VALUES (@nurse_person_uuid, 'F', NOW(), '4');

SET @nurse_person_id = (SELECT person_id FROM person WHERE uuid = @nurse_person_uuid);

INSERT IGNORE INTO person_name (person_id, uuid, given_name, family_name) 
    VALUES (@nurse_person_id, '7459fb76-c81a-4a04-9578-656018d2828f', 'Nurse', '');

INSERT IGNORE INTO person (uuid, gender, date_created, creator)
    VALUES (@doctor_person_uuid, 'F', NOW(), '4');

SET @doctor_person_id = (SELECT person_id FROM person WHERE uuid = @doctor_person_uuid);

INSERT IGNORE INTO person_name (person_id, uuid, given_name, family_name) 
    VALUES (@doctor_person_id, 'c4d2632f-3ed2-4f5f-b37a-f92398cc5cc8', 'Doctor', '');

INSERT IGNORE INTO person (uuid, gender, date_created, creator)
    VALUES (@reception_person_uuid, 'F', NOW(), '4');

SET @reception_person_id = (SELECT person_id FROM person WHERE uuid = @reception_person_uuid);

INSERT IGNORE INTO person_name (person_id, uuid, given_name, family_name) 
    VALUES (@reception_person_id, 'df9280ef-9f5a-4207-9668-9725355dfd01', 'Reception', '');

SET @nurse_exists = (SELECT 1 FROM users WHERE uuid = @nurse_user_uuid);
SET @doctor_exists = (SELECT 1 FROM users WHERE uuid = @doctor_user_uuid);
SET @reception_exists = (SELECT 1 FROM users WHERE uuid = @reception_user_uuid);

INSERT IGNORE INTO users (system_id, username, password, salt, date_created, uuid, person_id, creator)
    SELECT 
        'Nurse', 'Nurse', SHA2(CONCAT('Nurse#123', @nursesalt), 512), @nursesalt, NOW(), @nurse_user_uuid, @nurse_person_id, '4'
    FROM DUAL
    WHERE @nurse_exists IS NULL;

INSERT IGNORE INTO users (system_id, username, password, salt, date_created, uuid, person_id, creator)
    SELECT     
        'Doctor', 'Doctor', SHA2(CONCAT('Doctor#123', @doctorsalt), 512), @doctorsalt, NOW(), @doctor_user_uuid, @doctor_person_id, '4'
    FROM DUAL
    WHERE @doctor_exists IS NULL;

INSERT IGNORE INTO users (system_id, username, password, salt, date_created, uuid, person_id, creator)
    SELECT 
        'Reception', 'Reception', SHA2(CONCAT('Reception#123', @receptionsalt), 512), @receptionsalt, NOW(), @reception_user_uuid, @reception_person_id, '4'
    FROM DUAL
    WHERE @reception_exists IS NULL;

SET @nurse_user_id = (SELECT user_id FROM users WHERE uuid = @nurse_user_uuid);
SET @doctor_user_id = (SELECT user_id FROM users WHERE uuid = @doctor_user_uuid);
SET @reception_user_id = (SELECT user_id FROM users WHERE uuid = @reception_user_uuid);
SET @superman_user_id = (SELECT user_id FROM users WHERE uuid = @superman_user_uuid);

INSERT IGNORE INTO provider (person_id, creator, date_created, uuid)
    VALUES
        (@nurse_person_id, '4', NOW(), '1ad6aa26-adfa-11e9-a2a3-2a2ae2dbcce4'),
        (@doctor_person_id, '4', NOW(), '1ad6ac88-adfa-11e9-a2a3-2a2ae2dbcce4'),
        (@reception_person_id, '4', NOW(), '1ad6adf0-adfa-11e9-a2a3-2a2ae2dbcce4');

INSERT IGNORE INTO role (role, description, uuid)
   VALUES 
        ('Nurse', 'Nurse Role', 'cdd84e88-b41a-11e9-a2a3-2a2ae2dbcce4'),
        ('Doctor', 'Doctor Role', 'cdd85374-b41a-11e9-a2a3-2a2ae2dbcce4'),
        ('Reception', 'Reception Role', 'cdd854e6-b41a-11e9-a2a3-2a2ae2dbcce4');

INSERT IGNORE INTO role_role (parent_role, child_role)
    VALUES 
        ('Appointments:FullAccess', 'Nurse'),
        ('Clinical-App', 'Nurse'),
        ('PatientDocuments-App', 'Nurse'),
        ('Programs-App', 'Nurse'),
        ('Reports-App', 'Nurse'),
        ('Registration-App', 'Nurse'),
        ('Clinical-App-Bacteriology', 'Nurse'),
        ('Clinical-App-Diagnosis', 'Nurse'),
        ('Clinical-App-Observations', 'Nurse'),
        ('Clinical-App-Disposition', 'Nurse'),
        ('Clinical-App-Orders', 'Nurse'),
        ('Clinical-App-Save', 'Nurse'),
        ('Appointments:FullAccess', 'Doctor'),
        ('Clinical-App', 'Doctor'),
        ('PatientDocuments-App', 'Doctor'),
        ('Programs-App', 'Doctor'),
        ('Reports-App', 'Doctor'),
        ('Registration-App', 'Doctor'),
        ('Clinical-App-Bacteriology', 'Doctor'),
        ('Clinical-App-Diagnosis', 'Doctor'),
        ('Clinical-App-Observations', 'Doctor'),
        ('Clinical-App-Disposition', 'Doctor'),
        ('Clinical-App-Orders', 'Doctor'),
        ('Clinical-App-Save', 'Doctor'),
        ('Appointments:FullAccess', 'Reception'),
        ('PatientDocuments-App', 'Reception'),
        ('Programs-App', 'Reception'),
        ('Reports-App', 'Reception'),
        ('Registration-App', 'Reception');

INSERT IGNORE INTO user_role (user_id, role)
    VALUES 
        (@nurse_user_id, 'Nurse');

INSERT IGNORE INTO user_role (user_id, role)
    VALUES 
        (@doctor_user_id, 'Doctor');

INSERT IGNORE INTO user_role (user_id, role)
    VALUES 
        (@reception_user_id, 'Reception');

INSERT IGNORE INTO user_role (user_id, role)
    VALUES 
        (@superman_user_id, 'Appointments:FullAccess');

-- Update roles so that they don't have permission to view dhis apps by default:
DELETE FROM role_privilege WHERE privilege = "app:dhis";
