SELECT
  'Number of people tested in the month desegregate by entry point' AS 'Title',
        HIVTMI_Indicator1_disaggregated_entry_point('#startDate#','#endDate#','Index') AS 'Index',
        HIVTMI_Indicator1_disaggregated_entry_point('#startDate#','#endDate#', 'Emergency') AS 'Emergency',
        HIVTMI_Indicator1_disaggregated_entry_point('#startDate#','#endDate#', 'PMTCT [ANC1-Only],PMTCT [Post ANC1],Other testing at ANC)') AS 'ANC',
        HIVTMI_Indicator1_disaggregated_entry_point('#startDate#','#endDate#', 'Labor and delivery,PNC') AS 'Delivery room',
        HIVTMI_Indicator1_disaggregated_entry_point('#startDate#','#endDate#', 'VCT') AS 'VCT',
        HIVTMI_Indicator1_disaggregated_entry_point('#startDate#','#endDate#', 'Inpatient,Other testing at Inpatient') AS 'Hospitalization',
        HIVTMI_Indicator1_disaggregated_entry_point('#startDate#','#endDate#', 'Pediatric') AS 'Pediatrics',
        HIVTMI_Indicator1_disaggregated_entry_point('#startDate#','#endDate#', 'Blood Bank') AS 'Blood bank',
        HIVTMI_Indicator1_disaggregated_entry_point('#startDate#','#endDate#', 'Screening campaign') AS 'Screening campaign',
        HIVTMI_Indicator1_disaggregated_entry_point('#startDate#','#endDate#', 'Malnutrition,OPD,Other PITC,STI,VMMC,Laboratory,Community Testing-Outreach,Community Testing-Satellite Site,Treatment Unit (UPEC),Partners of PW,Partners of BFW,PITC (Outpatient Department - casuality)') AS 'Others';