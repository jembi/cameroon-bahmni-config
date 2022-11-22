SELECT
  'Number of people tested positive started on ART among people tested positive in the month disaggregated by entry point' AS 'Title',
        HIVTMI_Indicator4_disaggregated_by_entry_point('#startDate#','#endDate#', 'Index') AS 'Index',
        HIVTMI_Indicator4_disaggregated_by_entry_point('#startDate#','#endDate#','LOCATION_EMERGENCY') AS 'Emergency',
        HIVTMI_Indicator4_disaggregated_by_entry_point('#startDate#','#endDate#','PMTCT [ANC1-Only],PMTCT [Post ANC1],Other testing at ANC') AS 'CPN / ANC',
        HIVTMI_Indicator4_disaggregated_by_entry_point('#startDate#','#endDate#','Labor and delivery,PNC') AS 'SA/Maternité / Delivery room/Postpartumn',
        HIVTMI_Indicator4_disaggregated_by_entry_point('#startDate#','#endDate#','VCT') AS 'VCT',
        HIVTMI_Indicator4_disaggregated_by_entry_point('#startDate#','#endDate#', 'Inpatient,Other testing at Inpatient') AS 'Hospitalization',
        HIVTMI_Indicator4_disaggregated_by_entry_point('#startDate#','#endDate#','Paediatric') AS 'Pediatrics',
        HIVTMI_Indicator4_disaggregated_by_entry_point('#startDate#','#endDate#','Other testing at TB Unit') AS 'Other testing at TB Unit',
        HIVTMI_Indicator4_disaggregated_by_entry_point('#startDate#','#endDate#','Blood Bank') AS 'Blood Bank',
        HIVTMI_Indicator4_disaggregated_by_entry_point('#startDate#','#endDate#','Screening campaign') AS 'Screening Campaign',
        HIVTMI_Indicator4_disaggregated_by_entry_point('#startDate#','#endDate#','Malnutrition,Operative Notes,OPD,Other PITC,STI,VMMC,LOCATION_LABORATORY,Community Testing-Outreach,Community Testing-Satellite Site,Treatment Unit (UPEC),Partners of PW,Partners of BFW,PITC (Outpatient Department - casuality)') AS 'Other entry Points';