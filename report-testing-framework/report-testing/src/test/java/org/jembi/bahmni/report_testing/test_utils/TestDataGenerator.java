package org.jembi.bahmni.report_testing.test_utils;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ObsValueTypeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.VisitTypeEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;

public class TestDataGenerator {
	Statement stmt;

	public RegistrationTestDataGenerator registration;
	public ProgramTestDataGenerator program;
	public HivTestingAndCounsellingFormDataGenerator hivTestingAndCounsellingForm ;
	public ManualLabAndResultFormDataGenerator manualLabAndResultForm;
	public TBFormDataGenerator tbForm;
	public HivAdultInitialForm hivAdultInitialForm;
	public HivChildInitialForm hivChildInitialForm;
	public AppointmentDataGenerator appointment;
	public DrugDataGenerator drug;
	public EACFormDataGenerator eacForm;
	public AncInitialFormDataGenerator ancInitialForm;
	public PatientWithHivChildFollowUpForm  patientWithHivChildFollowUpForm;

	public void setStatement(Statement stmt) {
		this.stmt = stmt;
		registration = new RegistrationTestDataGenerator(stmt);
		program = new ProgramTestDataGenerator(stmt);
		hivTestingAndCounsellingForm = new HivTestingAndCounsellingFormDataGenerator(stmt);
		manualLabAndResultForm = new ManualLabAndResultFormDataGenerator(stmt);
		tbForm = new TBFormDataGenerator(stmt);
		hivAdultInitialForm = new HivAdultInitialForm(stmt);
		hivChildInitialForm = new HivChildInitialForm(stmt);
		appointment = new AppointmentDataGenerator(stmt);
		eacForm = new EACFormDataGenerator(stmt);
		drug = new DrugDataGenerator(stmt);
		ancInitialForm = new AncInitialFormDataGenerator(stmt);
		patientWithHivChildFollowUpForm = new PatientWithHivChildFollowUpForm(stmt);
	}

	static public int recordFormTextValue(int patientId, LocalDateTime observationDateTime, List<ConceptEnum> conceptTree, String value, Integer encounterId, Statement stmt) throws Exception {
		return recordFormValue(patientId, observationDateTime, conceptTree, value, ObsValueTypeEnum.TEXT, encounterId, null, stmt);
	}

	static public int recordFormNumericValue(int patientId, LocalDateTime observationDateTime, List<ConceptEnum> conceptTree, int value, Integer encounterId, Statement stmt) throws Exception {
		return recordFormValue(patientId, observationDateTime, conceptTree, value + "", ObsValueTypeEnum.NUMERIC, encounterId, null, stmt);
	}

	static public int recordFormBooleanValue(int patientId, LocalDateTime observationDateTime, List<ConceptEnum> conceptTree, boolean value, Integer encounterId, Statement stmt) throws Exception {
		return recordFormValue(patientId, observationDateTime, conceptTree, value + "", ObsValueTypeEnum.CODED, encounterId, null, stmt);
	}

	static public int recordFormDatetimeValue(int patientId, LocalDateTime observationDateTime, List<ConceptEnum> conceptTree, LocalDate value, Integer encounterId, Statement stmt) throws Exception {
		return recordFormValue(patientId, observationDateTime, conceptTree, value.toString(), ObsValueTypeEnum.DATE_TIME, encounterId, null, stmt);
	}

	static public int recordFormDatetimeValue(int patientId, LocalDateTime observationDateTime, List<ConceptEnum> conceptTree, LocalDate value, Integer encounterId, Integer groupId, Statement stmt) throws Exception {
		return recordFormValue(patientId, observationDateTime, conceptTree, value.toString(), ObsValueTypeEnum.DATE_TIME, encounterId, groupId, stmt);
	}

	static public int recordFormCodedValue(int patientId, LocalDateTime observationDateTime, List<ConceptEnum> conceptTree, ConceptEnum codedValue, Integer encounterId, Statement stmt) throws Exception {
		Integer conceptId = getConceptId(codedValue, stmt);
		return recordFormValue(patientId, observationDateTime, conceptTree, conceptId.toString(), ObsValueTypeEnum.CODED, encounterId, null, stmt);
	}
	
	static public int recordFormCodedValue(int patientId, LocalDateTime observationDateTime, List<ConceptEnum> conceptTree, ConceptEnum codedValue, Integer encounterId, Integer groupId, Statement stmt) throws Exception {
		Integer conceptId = getConceptId(codedValue, stmt);
		return recordFormValue(patientId, observationDateTime, conceptTree, conceptId.toString(), ObsValueTypeEnum.CODED, encounterId, groupId, stmt);
	}

	static public List<Integer> recordEmptyFormRecord(int patientId, LocalDateTime observationDateTime, List<ConceptEnum> conceptTree, Integer encounterId, Statement stmt) throws Exception {
		List<Integer> result = new ArrayList<Integer>();

		if (encounterId == null) {
			String uuid = generateUUID();
			String query = "INSERT INTO encounter (encounter_type, patient_id, encounter_datetime, creator, date_created, voided, uuid) VALUES " +
			"(1," + patientId + ",'" + observationDateTime + "',4,'" + observationDateTime + "',0,'" + uuid + "')";
			stmt.executeUpdate(query);
			encounterId = getQueryIntResult("SELECT encounter_id FROM encounter WHERE uuid = '" + uuid + "'", stmt);
		}
		result.add(encounterId);

		Integer obsGroupId = null;
		for(int i = 0; i < conceptTree.size(); i++) {
			ConceptEnum concept = conceptTree.get(i);
			int conceptId = getConceptId(concept, stmt);
			String uuid = generateUUID();
			if (i < conceptTree.size() -1) {
				String query = "INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime," + (obsGroupId == null ? "": "obs_group_id,") + "creator, date_created, voided, uuid, status) VALUES " + 
				"(" + patientId + "," + conceptId + "," + encounterId + ",'" + observationDateTime + "'," + (obsGroupId == null ? "": obsGroupId + ",") + "4,'" + observationDateTime + "',0,'" + uuid + "','')";
				stmt.executeUpdate(query);
				obsGroupId = getQueryIntResult("SELECT obs_id FROM obs WHERE uuid = '" + uuid + "'", stmt);
			} else {
				String query = "INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime," + (obsGroupId == null ? "": "obs_group_id,") + " creator, date_created, voided, uuid, status) VALUES " + 
				"(" + patientId + "," + conceptId + "," + encounterId + ",'" + observationDateTime + "'," + (obsGroupId == null ? "": obsGroupId) + ",4,'" + observationDateTime + "',0,'" + uuid + "','')";
				stmt.executeUpdate(query);
				obsGroupId = getQueryIntResult("SELECT obs_id FROM obs WHERE uuid = '" + uuid + "'", stmt);
			}
		}

		result.add(obsGroupId);

		return result;
	}

	static public int recordFormValue(int patientId, LocalDateTime observationDateTime, List<ConceptEnum> conceptTree, String value, ObsValueTypeEnum dataType, Integer encounterId, Integer obsGroupId, Statement stmt) throws Exception {
		if (encounterId == null) {
			String uuid = generateUUID();
			String query = "INSERT INTO encounter (encounter_type, patient_id, encounter_datetime, creator, date_created, voided, uuid) VALUES " +
			"(1," + patientId + ",'" + observationDateTime + "',4,'" + observationDateTime + "',0,'" + uuid + "')";
			stmt.executeUpdate(query);
			encounterId = getQueryIntResult("SELECT encounter_id FROM encounter WHERE uuid = '" + uuid + "'", stmt);
		}

		for(int i = 0; i < conceptTree.size(); i++) {
			ConceptEnum concept = conceptTree.get(i);
			int conceptId = getConceptId(concept, stmt);
			String uuid = generateUUID();
			if (i < conceptTree.size() -1) {
				String query = "INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime," + (obsGroupId == null ? "": "obs_group_id,") + "creator, date_created, voided, uuid, status) VALUES " + 
				"(" + patientId + "," + conceptId + "," + encounterId + ",'" + observationDateTime + "'," + (obsGroupId == null ? "": obsGroupId + ",") + "4,'" + observationDateTime + "',0,'" + uuid + "','')";
				stmt.executeUpdate(query);
				obsGroupId = getQueryIntResult("SELECT obs_id FROM obs WHERE uuid = '" + uuid + "'", stmt);
			} else {
				String query = "INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime," + (obsGroupId == null ? "": "obs_group_id,") + dataType + (dataType != null ? ",":"") + " creator, date_created, voided, uuid, status) VALUES " + 
				"(" + patientId + "," + conceptId + "," + encounterId + ",'" + observationDateTime + "'," + (obsGroupId == null ? "": obsGroupId + ",") + "'" + value + "',4,'" + observationDateTime + "',0,'" + uuid + "','')";
				stmt.executeUpdate(query);
			}
		}

		return encounterId;
	}

	public static int getConceptId(ConceptEnum concept, Statement stmt) throws Exception {
		return getQueryIntResult("SELECT concept_id FROM concept WHERE uuid = '" + concept + "'", stmt);
	}

	public int startVisit(int patientId, LocalDate dateStarted, VisitTypeEnum visitType) throws Exception {
		String uuid = generateUUID();

        int visitTypeId = getQueryIntResult("SELECT visit_type_id FROM visit_type WHERE name = '" + visitType + "'", stmt);

		String createQuery = "INSERT INTO visit "
				+ "(patient_id, visit_type_id, date_started, creator, date_created, voided, uuid) VALUES"
				+ "('" + patientId + "', " + visitTypeId + ", '" + dateStarted + "', 4, '" + dateStarted + "', 0, '" + uuid + "')";

		stmt.executeUpdate(createQuery);

		int visitId =  getQueryIntResult("SELECT visit_id FROM visit WHERE uuid = '" + uuid + "'", stmt);
		int encounterId = addConsultationEncounter(patientId, visitId);

		return encounterId;
	}

	private int addConsultationEncounter(int patientId, int visitId) throws Exception {
		String uuidEncounter = generateUUID();

		String createEncounterQuery = "INSERT INTO encounter "
				+ "(patient_id, encounter_type, encounter_datetime, creator, date_created, voided, visit_id, uuid) VALUES"
				+ "(" + patientId + ", 1, now(), 4, now(), 0," + visitId + ",'" + uuidEncounter + "')";

		stmt.executeUpdate(createEncounterQuery);

		return getQueryIntResult("SELECT encounter_id FROM encounter WHERE uuid = '" + uuidEncounter + "'", stmt);
	}

	public static String generateUUID() {
		UUID uuid = UUID.randomUUID();
        return uuid.toString();
	}

	public static int getQueryIntResult(String query, Statement stmt) throws Exception {
		ResultSet rs = stmt.executeQuery(query);
		while (rs.next()) {
			return rs.getInt(1);
		}
		throw new Exception("No result found");
	}

	public static String getQueryStringResult(String query, Statement stmt) throws Exception {
		ResultSet rs = stmt.executeQuery(query);
		while (rs.next()) {
			return rs.getString(1);
		}
		throw new Exception("No result found");
	}

}