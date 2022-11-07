SELECT
  'Number of people tested in the month disaggregated by entry point' AS 'Title',
        HIVTMI_Indicator1_disaggregated_by_single_entry_point('#startDate#','#endDate#', 'Index') AS 'Index',
        HIVTMI_Indicator1_disaggregated_by_single_entry_point('#startDate#','#endDate#','Emergency') AS 'Emergency',
        HIVTMI_Indicator1_disaggregated_by_three_entry_point('#startDate#','#endDate#','PMTCT [ANC1-Only]','PMTCT [Post ANC1]','Other testing at ANC') AS 'CPN / ANC',
        HIVTMI_Indicator1_disaggregated_by_two_entry_point('#startDate#','#endDate#','Labor and delivery', 'PNC') AS 'SA/Maternité / Delivery room/Postpartumn',
        HIVTMI_Indicator1_disaggregated_by_single_entry_point('#startDate#','#endDate#','VCT') AS 'VCT',
        HIVTMI_Indicator1_disaggregated_by_two_entry_point('#startDate#','#endDate#', 'Inpatient', 'Other testing at Inpatient') AS 'Hospitalization',
        HIVTMI_Indicator1_disaggregated_by_single_entry_point('#startDate#','#endDate#','Pediatric') AS 'Pediatrics',
        HIVTMI_Indicator1_disaggregated_by_single_entry_point('#startDate#','#endDate#','Other testing at TB Unit') AS 'Other testing at TB Unit',
        HIVTMI_Indicator1_disaggregated_by_single_entry_point('#startDate#','#endDate#','Blood Bank') AS 'Blood Bank',
        HIVTMI_Indicator1_disaggregated_by_single_entry_point('#startDate#','#endDate#','Screening campaign') AS 'Screening Campaign',
        HIVTMI_Indicator1_disaggregated_by_other_entry_points('#startDate#','#endDate#') AS 'Other entry Points';