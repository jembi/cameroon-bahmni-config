package org.jembi.bahmni.report_testing.test_utils;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.jembi.bahmni.report_testing.test_utils.models.DrugNameEnum;
import org.jembi.bahmni.report_testing.test_utils.models.DurationUnitEnum;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;
import org.jembi.bahmni.report_testing.test_utils.models.NotificationOutcomeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ObsValueTypeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.PatientIdenfierTypeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ProgramNameEnum;
import org.jembi.bahmni.report_testing.test_utils.models.RelationshipEnum;
import org.jembi.bahmni.report_testing.test_utils.models.TherapeuticLineEnum;
import org.jembi.bahmni.report_testing.test_utils.models.VisitTypeEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;

public class TestDataGenerator {
	Statement stmt;

	public void setStatement(Statement stmt) {
		this.stmt = stmt;
	}

	public int createPerson(GenderEnum gender, LocalDate dateOfBirth, String firstName, String familyName) throws Exception {
		String uuid = generateUUID();

		String updateQuery = "INSERT INTO person "
				+ "(gender, birthdate, birthdate_estimated, dead, date_created, voided, uuid, deathdate_estimated) VALUES"
				+ "('" + gender + "', '" + dateOfBirth + "', 0, 0, now(), 0, '" + uuid + "', 0)";

		stmt.executeUpdate(updateQuery);

		int personId = getQueryIntResult( "SELECT person_id FROM person WHERE uuid = '" + uuid + "'");

		String query = "INSERT INTO person_name (preferred, person_id, given_name, family_name, creator, date_created, voided, uuid) VALUES " +
			"(1," + personId + ",'" + firstName + "','" + familyName + "',4,now(),0,'" + generateUUID() + "')";
		stmt.executeUpdate(query);

		return personId;
	}

	public int createPatient(GenderEnum gender, LocalDate dateOfBirth, String firstName, String familyName) throws Exception {
		int personId = createPerson(gender, dateOfBirth, firstName, familyName);

		String createQuery = "INSERT INTO patient "
				+ "(patient_id, creator, date_created, voided, allergy_status) VALUES"
				+ "('" + personId + "', 1, now(), 0, '')";

		stmt.executeUpdate(createQuery);

		return personId;
	}

	public int setHTCHivTestDate(int patientId, LocalDateTime obsDateTime, LocalDate testDate, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTree.add(ConceptEnum.HTC_HIV_TEST);
        conceptTree.add(ConceptEnum.HIV_TEST_DATE);
        return recordFormDatetimeValue(patientId, obsDateTime, conceptTree, testDate, encounterId);
	}

	public int setHTCFinalResult(int patientId, LocalDateTime obsDateTime, ConceptEnum testResult, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTree.add(ConceptEnum.FINAL_RESULT);
        conceptTree.add(ConceptEnum.FINAL_TEST_RESULT);
        return recordFormCodedValue(patientId, obsDateTime, conceptTree, testResult, encounterId);
	}

	public int setIndexTestingOffered(int patientId, LocalDateTime obsDateTime, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTreeOfferedIndexTesting= new ArrayList<ConceptEnum>();
        conceptTreeOfferedIndexTesting.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTreeOfferedIndexTesting.add(ConceptEnum.HTC_HIV_TEST);
        conceptTreeOfferedIndexTesting.add(ConceptEnum.INDEX_TESTING_OFFERED);
        return recordFormCodedValue(patientId, obsDateTime, conceptTreeOfferedIndexTesting, ConceptEnum.YES, null);
	}

	public int setIndexTestingDateOffered(int patientId, LocalDateTime obsDateTime, LocalDate dateOffered, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTreeDateOfferedIndexTesting= new ArrayList<ConceptEnum>();
        conceptTreeDateOfferedIndexTesting.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTreeDateOfferedIndexTesting.add(ConceptEnum.HTC_HIV_TEST);
        conceptTreeDateOfferedIndexTesting.add(ConceptEnum.DATE_INDEX_TESTING_OFFERED);
        return recordFormDatetimeValue(patientId, obsDateTime, conceptTreeDateOfferedIndexTesting, dateOffered, encounterId);
	}

	public int setIndexTestingAccepted(int patientId, LocalDateTime obsDateTime, Integer encounterId) throws Exception {
        List<ConceptEnum> conceptTreeAcceptedIndexTesting= new ArrayList<ConceptEnum>();
        conceptTreeAcceptedIndexTesting.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTreeAcceptedIndexTesting.add(ConceptEnum.HTC_HIV_TEST);
        conceptTreeAcceptedIndexTesting.add(ConceptEnum.INDEX_TESTING_ACCEPTED);
        return recordFormCodedValue(patientId, obsDateTime, conceptTreeAcceptedIndexTesting, ConceptEnum.TRUE, null);
	}

	public int setIndexTestingDateAccepted(int patientId, LocalDateTime obsDateTime, LocalDate accepted, Integer encounterId) throws Exception {
        List<ConceptEnum> conceptTreeDateAccepedIndexTesting= new ArrayList<ConceptEnum>();
        conceptTreeDateAccepedIndexTesting.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTreeDateAccepedIndexTesting.add(ConceptEnum.HTC_HIV_TEST);
        conceptTreeDateAccepedIndexTesting.add(ConceptEnum.DATE_INDEX_TESTING_ACCEPTED);
        return recordFormDatetimeValue(patientId, obsDateTime, conceptTreeDateAccepedIndexTesting, accepted, encounterId);
	}

	public int setDateBaselineAssessment(int patientId, LocalDateTime obsDateTime, LocalDate dateBaselineAssessment, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.TB_FORM);
        conceptTree.add(ConceptEnum.DATE_BASELINE_ASSESSMENT);
        return recordFormDatetimeValue(patientId, obsDateTime, conceptTree, dateBaselineAssessment, encounterId);
	}

	public int setTBScreened(int patientId, LocalDateTime obsDateTime, ConceptEnum value, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.TB_FORM);
        conceptTree.add(ConceptEnum.SCREENED);
        return recordFormCodedValue(patientId, obsDateTime, conceptTree, value, encounterId);
	}

	public int setMTBConfirmation(int patientId, LocalDateTime obsDateTime, ConceptEnum value, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.TB_FORM);
        conceptTree.add(ConceptEnum.MTB_CONFIRMATION);
        return recordFormCodedValue(patientId, obsDateTime, conceptTree, value, encounterId);
	}

	public int recordFormTextValue(int patientId, LocalDateTime observationDateTime, List<ConceptEnum> conceptTree, String value, Integer encounterId) throws Exception {
		return recordFormValue(patientId, observationDateTime, conceptTree, value, ObsValueTypeEnum.TEXT, encounterId);
	}

	public int recordFormDatetimeValue(int patientId, LocalDateTime observationDateTime, List<ConceptEnum> conceptTree, LocalDate value, Integer encounterId) throws Exception {
		return recordFormValue(patientId, observationDateTime, conceptTree, value.toString(), ObsValueTypeEnum.DATE_TIME, encounterId);
	}

	public int recordFormCodedValue(int patientId, LocalDateTime observationDateTime, List<ConceptEnum> conceptTree, ConceptEnum codedValue, Integer encounterId) throws Exception {
		Integer conceptId = getConceptId(codedValue);
		return recordFormValue(patientId, observationDateTime, conceptTree, conceptId.toString(), ObsValueTypeEnum.CODED, encounterId);
	}

	private int recordFormValue(int patientId, LocalDateTime observationDateTime, List<ConceptEnum> conceptTree, String value, ObsValueTypeEnum dataType, Integer encounterId) throws Exception {
		if (encounterId == null) {
			String uuid = generateUUID();
			String query = "INSERT INTO encounter (encounter_type, patient_id, encounter_datetime, creator, date_created, voided, uuid) VALUES " +
			"(1," + patientId + ",'" + observationDateTime + "',4,now(),0,'" + uuid + "')";
			stmt.executeUpdate(query);
			encounterId = getQueryIntResult("SELECT encounter_id FROM encounter WHERE uuid = '" + uuid + "'");
		}

		Integer obsGroupId = null;
		for(int i = 0; i < conceptTree.size(); i++) {
			ConceptEnum concept = conceptTree.get(i);
			int conceptId = getConceptId(concept);
			String uuid = generateUUID();
			if (i < conceptTree.size() -1) {
				String query = "INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime," + (obsGroupId == null ? "": "obs_group_id,") + "creator, date_created, voided, uuid, status) VALUES " + 
				"(" + patientId + "," + conceptId + "," + encounterId + ",'" + observationDateTime + "'," + (obsGroupId == null ? "": obsGroupId + ",") + "4,now(),0,'" + uuid + "','')";
				stmt.executeUpdate(query);
				obsGroupId = getQueryIntResult("SELECT obs_id FROM obs WHERE uuid = '" + uuid + "'");
			} else {
				String query = "INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime," + (obsGroupId == null ? "": "obs_group_id,") + dataType + ", creator, date_created, voided, uuid, status) VALUES " + 
				"(" + patientId + "," + conceptId + "," + encounterId + ",'" + observationDateTime + "'," + (obsGroupId == null ? "": obsGroupId + ",") + "'" + value + "',4,now(),0,'" + uuid + "','')";
				stmt.executeUpdate(query);
			}
		}

		return encounterId;
	}

	private int getConceptId(ConceptEnum concept) throws Exception {
		return getQueryIntResult("SELECT concept_id FROM concept WHERE uuid = '" + concept + "'");
	}

	public int createPatient(String uniqueId, GenderEnum gender, LocalDate dateOfBirth,String firstName, String familyName, String telephone, String artCode) throws Exception {
		int patientId = createPatient(gender, dateOfBirth, firstName, familyName);

		addPatientIdentifier(patientId, PatientIdenfierTypeEnum.BAHMNI_IDENTIFIER, uniqueId);

		if (telephone != null) {
			addPersonAttributeTextValue(patientId, "PERSON_ATTRIBUTE_TYPE_PHONE_NUMBER", telephone);
		}

		if (artCode != null) {
			addPatientIdentifier(patientId, PatientIdenfierTypeEnum.ART, artCode);
		}

		return patientId;
	}

	private void addPatientIdentifier(int patientId, PatientIdenfierTypeEnum identifierType, String value) throws Exception {
		int identifierTypeId = getQueryIntResult("SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = '" + identifierType +"'");
		String queryPatientIdentifer = "INSERT INTO patient_identifier " +
			"(patient_id, identifier, identifier_type, preferred, creator, date_created, voided, uuid) VALUES " +
			"(" + patientId + ",'" + value + "'," + identifierTypeId + ",1,4,now(),0,'" + generateUUID() + "')";
		stmt.executeUpdate(queryPatientIdentifer);
	}

	public void addRelationshipToPatient(int idPatientA, int idPatientB, RelationshipEnum relPersonAToPersonB, RelationshipEnum relPersonBToPersonA) throws Exception {
		int relationshipTypeId = getQueryIntResult("SELECT relationship_type_id FROM relationship_type WHERE a_is_to_b = '" + relPersonAToPersonB + "'  AND b_is_to_a = '" + relPersonBToPersonA + "'");
		String query = "INSERT INTO relationship (person_a, relationship, person_b, creator, date_created, voided, uuid) VALUES " +
			"(" + idPatientA +"," + relationshipTypeId + "," + idPatientB + ",4,now(),0,'" + generateUUID() + "')";
		
		stmt.executeUpdate(query);
	}

	public void addPersonAttributeTextValue(int patientId, String personAttributeName, String value) throws Exception {
		int personAttributeId = getQueryIntResult("SELECT person_attribute_type_id FROM person_attribute_type WHERE name = '" + personAttributeName + "'");
		String queryPersonAttribute = "INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, voided, uuid) VALUES " +
		"(" + patientId + ", '" + value + "'," + personAttributeId + ",4,now(),0,uuid)";
		stmt.executeUpdate(queryPersonAttribute);
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

	public void enrollPatientIntoHIVProgram(int patientId, LocalDate enrollmentDate, ConceptEnum patientClinicalStage, TherapeuticLineEnum therapeuticLine, LocalDate treatmentStartDate) throws Exception {
		int patientProgramId = enrollPatientIntoProgram(patientId, enrollmentDate, ProgramNameEnum.HIV_PROGRAM_KEY);

		if (patientClinicalStage != null) {
			addPatientClinicalStage(patientId, patientProgramId, patientClinicalStage);
		}

		if (therapeuticLine != null) {
			recordProgramAttributeCodedValue(patientProgramId, "PROGRAM_MANAGEMENT_6_LABEL_THERAPEUTIC_LINE", therapeuticLine.toString());
		}

		if (treatmentStartDate != null) {
			recordProgramAttributeDateValue(patientProgramId, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", treatmentStartDate);
		}
	}

	public void enrollPatientIntoIndexTestingProgram(int patientId, LocalDate enrollmentDate, ConceptEnum patientClinicalStage, LocalDate notificationDate, NotificationOutcomeEnum notificationOutcome) throws Exception {
		int patientProgramId = enrollPatientIntoProgram(patientId, enrollmentDate, ProgramNameEnum.INDEX_TESTING_PROGRAM_KEY);

		addPatientClinicalStage(patientId, patientProgramId, patientClinicalStage);

		if (notificationDate != null) {
			recordProgramAttributeDateValue(patientProgramId, "PROGRAM_MANAGEMENT_2_NOTIFICATION_DATE", notificationDate);
		}

		if (notificationOutcome != null) {
			recordProgramAttributeCodedValue(patientProgramId, "PROGRAM_MANAGEMENT_3_NOTIFICATION_OUTCOME", notificationOutcome.toString());
		}
	}

	public void enrollPatientIntoTBProgram(int patientId, LocalDate enrollmentDate, ConceptEnum patientClinicalStage, LocalDate treatmentStartDate) throws Exception {
		int patientProgramId = enrollPatientIntoProgram(patientId, enrollmentDate, ProgramNameEnum.TB_PROGRAM_KEY);

		addPatientClinicalStage(patientId, patientProgramId, patientClinicalStage);

		if (treatmentStartDate != null) {
			recordProgramAttributeDateValue(patientProgramId, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", treatmentStartDate);
		}
	}

	private void addPatientClinicalStage(int patientId, int patientProgramId, ConceptEnum patientClinicalStage) throws Exception {
		int stateId = getQueryIntResult("SELECT pws.program_workflow_state_id " +
			"FROM program_workflow_state pws JOIN concept c ON c.concept_id = pws.concept_id " + 
			"WHERE c.uuid = '" + patientClinicalStage + "'");

		String query = "INSERT INTO patient_state (patient_program_id, state, creator, date_created, voided, uuid) VALUES " + 
			"(" + patientProgramId + "," + stateId + ",4,now(),0,'" + generateUUID() + "')";
		stmt.executeUpdate(query);
	}

	private int enrollPatientIntoProgram(int patientId, LocalDate enrollmentDate, ProgramNameEnum programName) throws Exception {
		String uuidPatientProgram = generateUUID();

		int programId = getQueryIntResult("SELECT program_id FROM program WHERE name = '" + programName + "'");
	
		String createPatientProgramQuery = "INSERT INTO patient_program "
				+ "(patient_id, program_id, date_enrolled, creator, date_created, voided, uuid) VALUES"
				+ "('" + patientId + "','" + programId + "', '" + enrollmentDate + "',4,now(),0,'" + uuidPatientProgram + "')";

		stmt.executeUpdate(createPatientProgramQuery);

		return getQueryIntResult("SELECT patient_program_id FROM patient_program WHERE uuid = '" + uuidPatientProgram + "'");

	}

	private void recordProgramAttributeDateValue(int patientProgramId, String programAttributeName, LocalDate value) throws Exception {
		int attributeTypeId = getQueryIntResult("SELECT program_attribute_type_id FROM program_attribute_type WHERE name = '" + programAttributeName + "'");
		String query =  "INSERT INTO patient_program_attribute "
		+ "(patient_program_id, attribute_type_id, value_reference, creator, date_created, voided, uuid) VALUES"
		+ "(" + patientProgramId + "," + attributeTypeId + ",'" + value + "', 4, now(), 0, '" + generateUUID() + "')";
		stmt.executeUpdate(query);
	}

	private void recordProgramAttributeCodedValue(int patientProgramId, String programAttributeName, String conceptName) throws Exception {
		int attributeTypeId = getQueryIntResult("SELECT program_attribute_type_id FROM program_attribute_type WHERE name = '" + programAttributeName + "'");
		int conceptId = getQueryIntResult("SELECT concept_id FROM concept_name WHERE name = '" + conceptName + "'");
		String query =  "INSERT INTO patient_program_attribute "
		+ "(patient_program_id, attribute_type_id, value_reference, creator, date_created, voided, uuid) VALUES"
		+ "(" + patientProgramId + "," + attributeTypeId + "," + conceptId + ", 4, now(), 0, '" + generateUUID() + "')";
		stmt.executeUpdate(query);
	}

	public int orderDrug(int patientId, int encounterId, DrugNameEnum drugName, LocalDateTime startDate, int duration, DurationUnitEnum durationUnit, boolean dispensed) throws Exception {
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

		if (dispensed) {
			dispenseDrugOrder(patientId, orderId);
		}
		
		return orderId;
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
