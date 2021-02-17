SELECT
    (SELECT value FROM site_information WHERE name = 'SiteName') AS HF_Name,
    CASE WHEN t.name LIKE '%PCR%' THEN 'PCR'
         WHEN t.name LIKE '%Viral Load%' THEN 'VL'
         ELSE 'Resistance'
    END AS Test_type,
    t.name AS Test_name,
    (SELECT identity_data FROM patient_identity WHERE patient_id = sh.patient_id AND identity_type_id = 2) AS Patient_ID,
    (SELECT DATE_PART('year', now()) - DATE_PART('year', birth_date) FROM patient WHERE id = sh.patient_id) AS Age,
    (SELECT gender FROM patient WHERE id = sh.patient_id) AS Gender,
    (SELECT TO_CHAR(birth_date :: DATE, 'dd-Mon-yyyy') FROM patient WHERE id = sh.patient_id) AS date_of_birth,
    s.accession_number AS Sample_ID,
    DATE(s.received_date) AS Sample_collection_date,
    (SELECT substring(name FROM 10) FROM sample_source WHERE id = s.sample_source_id) AS Service,
    (SELECT name FROM organization WHERE id = ref.organization_id) AS Referral_Lab,
    TO_CHAR(ref.referral_request_date :: DATE, 'dd-Mon-yyyy') AS Referral_Date,
    TO_CHAR(r.lastupdated :: DATE, 'dd-Mon-yyyy') AS Result_Date,
    CASE WHEN r.result_type != 'D' THEN r.value
        ELSE (SELECT dict_entry from dictionary WHERE r.value != '' AND id = CAST(r.value AS INTEGER))
    END AS Result_Value
FROM analysis a
    INNER JOIN test t on t.id = a.test_id
    INNER JOIN sample_item si ON si.id = a.sampitem_id
    INNER JOIN sample s ON s.id = si.samp_id
    INNER JOIN sample_human sh ON s.id = sh.samp_id
    LEFT OUTER JOIN result r ON r.analysis_id = a.id
    LEFT OUTER JOIN referral ref ON ref.analysis_id = a.id
WHERE
    t.name IN ('PCR(ALERE-Q)', 'Routine Viral Load', 'Targeted Viral Load', 'Not Documented Viral Load', 'ARV Resistance Test') AND
    s.received_date BETWEEN '#startDate#' AND '#endDate#'
ORDER BY s.received_date DESC;
