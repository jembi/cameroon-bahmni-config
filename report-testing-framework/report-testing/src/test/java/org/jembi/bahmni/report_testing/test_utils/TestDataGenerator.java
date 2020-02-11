package org.jembi.bahmni.report_testing.test_utils;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.UUID;

import org.jembi.bahmni.report_testing.test_utils.models.ConceptUuidEnum;
import org.jembi.bahmni.report_testing.test_utils.models.DrugNameEnum;
import org.jembi.bahmni.report_testing.test_utils.models.DurationUnitEnum;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;
import org.jembi.bahmni.report_testing.test_utils.models.TherapeuticLineEnum;
import org.jembi.bahmni.report_testing.test_utils.models.VisitTypeEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;

public class TestDataGenerator {
	Statement stmt;

	public void setStatement(Statement stmt) {
		this.stmt = stmt;
	}

	public int createPerson(GenderEnum gender, LocalDate dateOfBirth) throws Exception {
		String uuid = generateUUID();

		String updateQuery = "INSERT INTO person "
				+ "(gender, birthdate, birthdate_estimated, dead, date_created, voided, uuid, deathdate_estimated) VALUES"
				+ "('" + gender + "', '" + dateOfBirth + "', 0, 0, now(), 0, '" + uuid + "', 0)";

		stmt.executeUpdate(updateQuery);

		String query = "SELECT person_id FROM person WHERE uuid = '" + uuid + "'";
		ResultSet rs = stmt.executeQuery(query);
		while (rs.next()) {
			return rs.getInt(1);
		}

		throw new Exception("Person creation failed");
	}

	public int createPatient(GenderEnum gender, LocalDate dateOfBirth) throws Exception {
		int personId = createPerson(gender, dateOfBirth);

		String createQuery = "INSERT INTO patient "
				+ "(patient_id, creator, date_created, voided, allergy_status) VALUES"
				+ "('" + personId + "', 1, now(), 0, '')";

		stmt.executeUpdate(createQuery);

		return personId;
	}

	public int startVisit(int patientId, VisitTypeEnum visitType) throws Exception {
		String uuid = generateUUID();

        int visitTypeId = getQueryIntResult("SELECT visit_type_id FROM visit_type WHERE name = '" + visitType + "'");

		String createQuery = "INSERT INTO visit "
				+ "(patient_id, visit_type_id, date_started, creator, date_created, voided, uuid) VALUES"
				+ "('" + patientId + "', " + visitTypeId + ", now(), 4, now(), 0, '" + uuid + "')";

		stmt.executeUpdate(createQuery);

		int visitId =  getQueryIntResult("SELECT visit_id FROM visit WHERE uuid = '" + uuid + "'");
		int encounterId = addConsultationEncounter(patientId, visitId);

		return encounterId;
	}

	public int enrollPatientIntoHIVProgram(int patientId, LocalDate enrollmentDate, TherapeuticLineEnum therapeuticLine) throws Exception {
		String uuidPatientProgram = generateUUID();
		String uuidPatientProgramAttribute = generateUUID();

		int programId = getQueryIntResult("SELECT program_id FROM program WHERE name = 'HIV_PROGRAM_KEY'");
	
		String createPatientProgramQuery = "INSERT INTO patient_program "
				+ "(patient_id, program_id, date_enrolled, creator, date_created, voided, uuid) VALUES"
				+ "('" + patientId + "','" + programId + "', '" + enrollmentDate + "',4,now(),0,'" + uuidPatientProgram + "')";

		stmt.executeUpdate(createPatientProgramQuery);

		int patientProgramId = getQueryIntResult("SELECT patient_program_id FROM patient_program WHERE uuid = '" + uuidPatientProgram + "'");
		int therapeuticLineAttributeTypeId = getQueryIntResult("SELECT program_attribute_type_id FROM program_attribute_type WHERE name = 'PROGRAM_MANAGEMENT_6_LABEL_THERAPEUTIC_LINE'");
		int therapeuticLineConceptId = getQueryIntResult("SELECT concept_id FROM concept_name WHERE name = '" + therapeuticLine + "'");

		String createPatientProgramAttributeQuery = "INSERT INTO patient_program_attribute "
				+ "(patient_program_id, attribute_type_id, value_reference, creator, date_created, voided, uuid) VALUES"
				+ "(" + patientProgramId + "," + therapeuticLineAttributeTypeId + "," + therapeuticLineConceptId + ", 4, now(), 0, '" + uuidPatientProgramAttribute + "')";

		stmt.executeUpdate(createPatientProgramAttributeQuery);

		return getQueryIntResult("SELECT patient_program_attribute_id FROM patient_program_attribute WHERE uuid = '" + uuidPatientProgramAttribute + "'");
	}

	public void setARVStartDate(int patientId, LocalDate startDate) throws Exception {
		String uuidObs = generateUUID();
		String uuidArvStartDate = "e3f9c7ee-aa3e-4224-9d18-42e09b095ac6";
		
		int arvStartDateConceptId = getQueryIntResult("SELECT concept_id FROM concept WHERE uuid = '" + uuidArvStartDate + "'");

		String createObservationQuery = "INSERT INTO obs "
				+ "(person_id, concept_id, obs_datetime, value_datetime, creator, date_created, voided, uuid, status) VALUES"
				+ "(" + patientId + "," + arvStartDateConceptId + ", now(), '" + startDate + "',4,now(),0,'" + uuidObs + "','FINAL')";

		stmt.executeUpdate(createObservationQuery);
	}

	public int orderDrug(int patientId, int encounterId, DrugNameEnum drugName, LocalDateTime startDate, int duration, DurationUnitEnum durationUnit) throws Exception {
		String uuidOrder = generateUUID();
		String orderNumber = generateUUID();
		int drugConceptId = getQueryIntResult("SELECT concept_id FROM drug WHERE name = '" + drugName + "'");
		int drugId = getQueryIntResult("SELECT drug_id FROM drug WHERE name = '" + drugName + "'");

		String createOrderQuery = "INSERT INTO orders "
				+ "(patient_id, scheduled_date, order_type_id, concept_id, orderer, encounter_id, creator, date_created, voided, uuid, urgency, order_number, order_action, care_setting) VALUES"
				+ "(" + patientId + ",'" + startDate + "', 2," + drugConceptId + ", 2," + encounterId + ", 4,now(),0,'" + uuidOrder + "','ON_SCHEDULED_DATE','" + orderNumber + "','NEW',1)";

		stmt.executeUpdate(createOrderQuery);
		int orderId = getQueryIntResult("SELECT order_id FROM orders WHERE uuid = '" + uuidOrder + "'");
		int durationUnitConceptId = getQueryIntResult("SELECT concept_id FROM concept_name WHERE name = '" + durationUnit + "'");

		String createDrugOrderQuery = "INSERT INTO drug_order "
				+ "(order_id, drug_inventory_id, dose, as_needed, dosing_type, quantity, duration, duration_units, quantity_units, route, dose_units, frequency, dispense_as_written) VALUES"
				+ "(" + orderId + "," + drugId + ", 1, 0, 'org.openmrs.module.bahmniemrapi.drugorder.dosinginstructions.FlexibleDosingInstructions',1," + duration + "," + durationUnitConceptId + ",342,68,342,1, 0)";

		stmt.executeUpdate(createDrugOrderQuery);
		
		return orderId;
	}

	public void setHivTestedBefore(int patientId, int encounterId, ConceptUuidEnum conceptUuid) throws Exception {
		createCodedObservation(
            encounterId,
            patientId,
            new ConceptUuidEnum [] { ConceptUuidEnum.HIV_TESTING_AND_COUNSELING },
            ConceptUuidEnum.HIV_TESTED_BEFORE,
            conceptUuid);
	}

	public void setHivTestDate(int patientId, int encounterId, LocalDate date) throws Exception {
		createDateObservation(
            encounterId,
            patientId,
            new ConceptUuidEnum [] { ConceptUuidEnum.HIV_TESTING_AND_COUNSELING },
            ConceptUuidEnum.HIV_TEST_DATE,
            date);
	}

	public void setTestingEntryPointAndModality(int patientId, int encounterId, ConceptUuidEnum conceptUuid) throws Exception {
		createCodedObservation(
            encounterId,
            patientId,
            new ConceptUuidEnum [] { ConceptUuidEnum.HIV_TESTING_AND_COUNSELING },
            ConceptUuidEnum.TESTING_ENTRY_POINT_AND_MODALITY,
            conceptUuid);
	}

	public void setHivFinalTestResult(int patientId, int encounterId, ConceptUuidEnum conceptUuid) throws Exception {
		createCodedObservation(
            encounterId,
            patientId,
            new ConceptUuidEnum [] {
				ConceptUuidEnum.HIV_TESTING_AND_COUNSELING,
				ConceptUuidEnum.HTC_HIV_TEST,
				ConceptUuidEnum.FINAL_RESULT },
            ConceptUuidEnum.FINAL_TEST_RESULT,
            conceptUuid);
	}

	public void createCodedObservation(int encounterId, int patientId, ConceptUuidEnum[] parentConceptUuids, ConceptUuidEnum conceptUuid, ConceptUuidEnum codedValueUuid) throws Exception {
		createObservation(encounterId, patientId, parentConceptUuids, conceptUuid, codedValueUuid, null, null, null);
	}

	public void createNumericObservation(int encounterId, int patientId, ConceptUuidEnum[] parentConceptUuids, ConceptUuidEnum conceptUuid, Integer numericValue) throws Exception {
		createObservation(encounterId, patientId, parentConceptUuids, conceptUuid, null, numericValue, null, null);
	}

	public void createTextObservation(int encounterId, int patientId, ConceptUuidEnum[] parentConceptUuids, ConceptUuidEnum conceptUuid, String textValue) throws Exception {
		createObservation(encounterId, patientId, parentConceptUuids, conceptUuid, null, null, textValue, null);
	}

	public void createDateObservation(int encounterId, int patientId, ConceptUuidEnum[] parentConceptUuids, ConceptUuidEnum conceptUuid, LocalDate dateValue) throws Exception {
		createObservation(encounterId, patientId, parentConceptUuids, conceptUuid, null, null, null, dateValue);
	}

	public void createObservation(int encounterId, int patientId, ConceptUuidEnum[] parentConceptUuids, ConceptUuidEnum conceptUuid, ConceptUuidEnum codedValueUuid, Integer numericValue, String textValue, LocalDate dateValue) throws Exception {
		Integer obsGroupId = null;
		int conceptId;
		if (parentConceptUuids != null && parentConceptUuids.length > 0) {
			for (ConceptUuidEnum parentConceptUuid : parentConceptUuids) {
				conceptId = getConceptId(parentConceptUuid);
				obsGroupId = createObservation(obsGroupId, patientId, conceptId, null, null, null, null);
			}
		}

		conceptId = getConceptId(conceptUuid);
		createObservation(obsGroupId, patientId, conceptId, codedValueUuid, numericValue, textValue, dateValue);
	}

	private int addConsultationEncounter(int patientId, int visitId) throws Exception {
		String uuidEncounter = generateUUID();

		String createEncounterQuery = "INSERT INTO encounter "
				+ "(patient_id, encounter_type, encounter_datetime, creator, date_created, voided, visit_id, uuid) VALUES"
				+ "(" + patientId + ", 1, now(), 4, now(), 0," + visitId + ",'" + uuidEncounter + "')";

		stmt.executeUpdate(createEncounterQuery);

		return getQueryIntResult("SELECT encounter_id FROM encounter WHERE uuid = '" + uuidEncounter + "'");
	}

	public void dispenseDrugOrder(int patientId, int drugOrderId) throws Exception {
		String uuidObs = generateUUID();
		String uuidDispensedConcept = "ff0d6d6a-e276-11e4-900f-080027b662ec";

		int dispensedConceptConceptId = getQueryIntResult("SELECT concept_id FROM concept WHERE uuid = '" + uuidDispensedConcept + "'");

		String createObservationQuery = "INSERT INTO obs "
				+ "(person_id, concept_id, obs_datetime, creator, date_created, voided, uuid, status, order_id) VALUES"
				+ "(" + patientId + "," + dispensedConceptConceptId + ", now(), 4, now(), 0,'" + uuidObs + "','FINAL'," + drugOrderId + ")";

		stmt.executeUpdate(createObservationQuery);
	}

	public int getConceptId(ConceptUuidEnum conceptUuid) throws Exception {
		return getQueryIntResult("SELECT concept_id FROM concept WHERE uuid ='" + conceptUuid + "'");
	}

	private int createObservation(Integer obsGroupId, int patientId, int conceptId, ConceptUuidEnum codedValueUuid, Integer numericValue, String textValue, LocalDate dateValue) throws Exception {
		String uuidObs = generateUUID();

		String dateValueString = "null";
		if (dateValue != null) {
			dateValueString = "'" + dateValue + "'";
		}

		if (textValue != null) {
			textValue = "'" + dateValue + "'";
		} else {
			textValue = "null";
		}

		String codedValueString = "null";
		Integer conceptIdValueCoded;

		if (codedValueUuid != null) {
			conceptIdValueCoded = getConceptId(codedValueUuid);
			codedValueString = conceptIdValueCoded.toString();
		}

		String createObservationQuery = "INSERT INTO obs "
		+ "(obs_group_id, person_id, concept_id, obs_datetime, creator, date_created, voided, uuid, status, value_coded, value_numeric, value_text, value_datetime) VALUES"
		+ "(" + obsGroupId + "," + patientId + "," + conceptId + ", now(), 4, now(), 0,'" + uuidObs + "','FINAL'," + codedValueString + "," + numericValue + "," + textValue + "," + dateValueString + ")";

		stmt.executeUpdate(createObservationQuery);

		String query = "SELECT obs_id FROM obs WHERE uuid = '" + uuidObs + "'";
		ResultSet rs = stmt.executeQuery(query);
		while (rs.next()) {
			return rs.getInt(1);
		}

		throw new Exception("Obseervation creation failed");
	}

	private String generateUUID() {
		UUID uuid = UUID.randomUUID();
        return uuid.toString();
	}

	public int getQueryIntResult(String query) throws Exception {
		ResultSet rs = stmt.executeQuery(query);
		while (rs.next()) {
			return rs.getInt(1);
		}
		throw new Exception("No result found");
	}

	public String getQueryStringResult(String query) throws Exception {
		ResultSet rs = stmt.executeQuery(query);
		while (rs.next()) {
			return rs.getString(1);
		}
		throw new Exception("No result found");
	}
}
