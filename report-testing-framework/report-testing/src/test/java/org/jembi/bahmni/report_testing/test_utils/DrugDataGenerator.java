package org.jembi.bahmni.report_testing.test_utils;

import java.sql.Statement;
import org.jembi.bahmni.report_testing.test_utils.models.DrugNameEnum;
import org.jembi.bahmni.report_testing.test_utils.models.DurationUnitEnum;
import org.joda.time.LocalDateTime;

public class DrugDataGenerator {
	Statement stmt;

    public DrugDataGenerator(Statement stmt) {
        this.stmt = stmt;
    }

	public int orderDrug(int patientId, int encounterId, DrugNameEnum drugName, LocalDateTime startDate, int duration, DurationUnitEnum durationUnit, boolean dispensed) throws Exception {
		String uuidOrder = TestDataGenerator.generateUUID();
		String orderNumber = TestDataGenerator.generateUUID();
		int drugConceptId = TestDataGenerator.getQueryIntResult("SELECT concept_id FROM drug WHERE name = '" + drugName + "'", stmt);
		int drugId = TestDataGenerator.getQueryIntResult("SELECT drug_id FROM drug WHERE name = '" + drugName + "'", stmt);

		String createOrderQuery = "INSERT INTO orders "
				+ "(patient_id, scheduled_date, order_type_id, concept_id, orderer, encounter_id, creator, date_created, voided, uuid, urgency, order_number, order_action, care_setting) VALUES"
				+ "(" + patientId + ",'" + startDate + "', 2," + drugConceptId + ", 2," + encounterId + ", 4,'" + startDate + "',0,'" + uuidOrder + "','ON_SCHEDULED_DATE','" + orderNumber + "','NEW',1)";

		stmt.executeUpdate(createOrderQuery);
		int orderId = TestDataGenerator.getQueryIntResult("SELECT order_id FROM orders WHERE uuid = '" + uuidOrder + "'", stmt);
		int durationUnitConceptId = TestDataGenerator.getQueryIntResult("SELECT concept_id FROM concept_name WHERE name = '" + durationUnit + "'", stmt);

		String createDrugOrderQuery = "INSERT INTO drug_order "
				+ "(order_id, drug_inventory_id, dose, as_needed, dosing_type, quantity, duration, duration_units, quantity_units, route, dose_units, frequency, dispense_as_written) VALUES"
				+ "(" + orderId + "," + drugId + ", 1, 0, 'org.openmrs.module.bahmniemrapi.drugorder.dosinginstructions.FlexibleDosingInstructions',1," + duration + "," + durationUnitConceptId + ",342,68,342,1, 0)";

		stmt.executeUpdate(createDrugOrderQuery);

		if (dispensed) {
			dispenseDrugOrder(patientId, orderId);
		}
		
		return orderId;
    }
    
    public void dispenseDrugOrder(int patientId, int drugOrderId) throws Exception {
		String uuidObs = TestDataGenerator.generateUUID();
		String uuidDispensedConcept = "ff0d6d6a-e276-11e4-900f-080027b662ec";

		int dispensedConceptConceptId = TestDataGenerator.getQueryIntResult("SELECT concept_id FROM concept WHERE uuid = '" + uuidDispensedConcept + "'", stmt);

		String createObservationQuery = "INSERT INTO obs "
				+ "(person_id, concept_id, obs_datetime, creator, date_created, voided, uuid, status, order_id) VALUES"
				+ "(" + patientId + "," + dispensedConceptConceptId + ", now(), 4, now(), 0,'" + uuidObs + "','FINAL'," + drugOrderId + ")";

		stmt.executeUpdate(createObservationQuery);
	}


}
