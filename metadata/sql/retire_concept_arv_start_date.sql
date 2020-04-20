UPDATE concept
SET
    retired = true,
    retired_by = 1,
    date_retired = CURRENT_DATE(),
    retire_reason = 'Replaced by treatment date from program form'
WHERE
    uuid = "e3f9c7ee-aa3e-4224-9d18-42e09b095ac6";

UPDATE concept_name
SET
    voided = true,
    voided_by = 1,
    date_voided = CURRENT_DATE(),
    void_reason = 'Replaced by treatment date from program form'
WHERE
    concept_id = (SELECT concept_id FROM concept WHERE uuid = "e3f9c7ee-aa3e-4224-9d18-42e09b095ac6");
