SELECT
    countHivEncountersByForm('#startDate#','#endDate#','1fb2dd86-53b5-4815-9c64-edc081b908d9') AS 'hiv_adult_initial_form',
    countHivEncountersByForm('#startDate#','#endDate#','41cd339f-27fb-4acb-8841-74c9ea1069f1') AS 'hiv_adult_followup_form',
    countHivEncountersByForm('#startDate#','#endDate#','48a724c1-fd24-45da-855c-33fcb4ce9c5d') AS 'hiv_child_initial_form',
    countHivEncountersByForm('#startDate#','#endDate#','9e38f9c3-1f04-4221-b5c9-51d5adbe1931') AS 'hiv_child_followup_form';