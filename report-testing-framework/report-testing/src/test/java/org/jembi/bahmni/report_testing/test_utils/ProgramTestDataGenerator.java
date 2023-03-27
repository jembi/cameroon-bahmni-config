package org.jembi.bahmni.report_testing.test_utils;

import java.sql.Statement;

import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.jembi.bahmni.report_testing.test_utils.models.NotificationOutcomeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.PreTrackingOutcomeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ProgramNameEnum;
import org.jembi.bahmni.report_testing.test_utils.models.TherapeuticLineEnum;
import org.jembi.bahmni.report_testing.test_utils.models.TrackingOutcomeEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;

public class ProgramTestDataGenerator {
	Statement stmt;

    public ProgramTestDataGenerator(Statement stmt) {
        this.stmt = stmt;
	}

	public void recordIndexNotificationDateAndOutcome(int patientProgramId, LocalDate notificationDate, String notificationOutcome) throws Exception {
		recordProgramAttributeDateValue(patientProgramId, "PROGRAM_MANAGEMENT_2_NOTIFICATION_DATE", notificationDate, notificationDate);
		recordProgramAttributeCodedValue(patientProgramId, "PROGRAM_MANAGEMENT_3_NOTIFICATION_OUTCOME", notificationOutcome, notificationDate);
	}

	public void recordProgramHistoricalData(int patientProgramId, int attributeTypeId, LocalDateTime dateCreated, String value) throws Exception {
		String query = "INSERT INTO patient_program_attribute_history (patient_program_id, attribute_type_id, value_reference, uuid, creator, date_created) VALUES "+
		"(" + patientProgramId + "," + attributeTypeId + ",'" + value + "',UUID(),4,'" + dateCreated + "')";
		stmt.executeUpdate(query);
    }

    public int enrollPatientIntoHIVProgram(int patientId, LocalDate enrollmentDate, ConceptEnum patientClinicalStage, TherapeuticLineEnum therapeuticLine, LocalDate treatmentStartDate) throws Exception {
		return enrollPatientIntoHIVProgram(patientId, enrollmentDate, patientClinicalStage, therapeuticLine, treatmentStartDate, null);
    }

    public int enrollPatientIntoHIVProgram(int patientId, LocalDate enrollmentDate, ConceptEnum patientClinicalStage, TherapeuticLineEnum therapeuticLine, LocalDate treatmentStartDate, String apsName) throws Exception {
		int patientProgramId = enrollPatientIntoProgram(patientId, enrollmentDate, ProgramNameEnum.HIV_PROGRAM_KEY);
		
		if (patientClinicalStage != null) {
			addPatientClinicalStage(patientId, patientProgramId, patientClinicalStage);
		}

		if (therapeuticLine != null) {
			recordProgramAttributeCodedValue(patientProgramId, "PROGRAM_MANAGEMENT_6_LABEL_THERAPEUTIC_LINE", therapeuticLine.toString(), enrollmentDate);
		}

		if (treatmentStartDate != null) {
			recordProgramAttributeDateValue(patientProgramId, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", treatmentStartDate, enrollmentDate);
		}

		if (apsName != null) {
			recordProgramAttributeTextValue(patientProgramId, "PROGRAM_MANAGEMENT_5_APS_NAME", apsName, enrollmentDate);
		}

		return patientProgramId;
    }
    
	public int enrollPatientIntoIndexTestingProgram(int patientId, LocalDate enrollmentDate, ConceptEnum patientClinicalStage, LocalDate notificationDate, NotificationOutcomeEnum notificationOutcome) throws Exception {
		int patientProgramId = enrollPatientIntoProgram(patientId, enrollmentDate, ProgramNameEnum.INDEX_TESTING_PROGRAM_KEY);

		addPatientClinicalStage(patientId, patientProgramId, patientClinicalStage);

		if (notificationDate != null) {
			recordProgramAttributeDateValue(patientProgramId, "PROGRAM_MANAGEMENT_2_NOTIFICATION_DATE", notificationDate, enrollmentDate);
		}

		if (notificationOutcome != null) {
			recordProgramAttributeCodedValue(patientProgramId, "PROGRAM_MANAGEMENT_3_NOTIFICATION_OUTCOME", notificationOutcome.toString(), enrollmentDate);
		}

		return patientProgramId;
	}

	public void markPatientAsTransferredOut(int patientId, LocalDate outcomeDate) throws Exception {
		String query = "SELECT patient_program_id FROM patient_program WHERE patient_id = " + patientId + " AND program_id = (SELECT p.program_id FROM program p WHERE p.name = 'HIV_PROGRAM_KEY') LIMIT 1";
		int patientProgramId = TestDataGenerator.getQueryIntResult(query, stmt);
		recordProgramOutcome(patientProgramId, ConceptEnum.TRANSFERRED_OUT, outcomeDate);
	}

	public void markPatientAsUnplannedAid(int patientId, LocalDate outcomeDate) throws Exception {
		String query = "SELECT patient_program_id FROM patient_program WHERE patient_id = " + patientId + " AND program_id = (SELECT p.program_id FROM program p WHERE p.name = 'HIV_PROGRAM_KEY') LIMIT 1";
		int patientProgramId = TestDataGenerator.getQueryIntResult(query, stmt);
		recordProgramAttributeCodedValue(patientProgramId, "PROGRAM_MANAGEMENT_5_PATIENT_STAGE", "Unplanned Aid", outcomeDate);
	}

	public void recordProgramOutcome(int patientProgramId, ConceptEnum outcome, LocalDate dateCompleted) throws Exception {
		int conceptId = TestDataGenerator.getConceptId(outcome, stmt);
		String stringDateCompleted = dateCompleted != null ? "'" + dateCompleted + "'" : "NOW()";
		String query = "UPDATE patient_program SET outcome_concept_id = " + conceptId + ", date_completed = " + stringDateCompleted + " " +
			"WHERE patient_program_id = " + patientProgramId + "";
		stmt.executeUpdate(query);
	}

	public void enrollPatientIntoTBProgram(int patientId, LocalDate enrollmentDate, ConceptEnum patientClinicalStage, LocalDate treatmentStartDate) throws Exception {
		int patientProgramId = enrollPatientIntoProgram(patientId, enrollmentDate, ProgramNameEnum.TB_PROGRAM_KEY);

		addPatientClinicalStage(patientId, patientProgramId, patientClinicalStage);

		if (treatmentStartDate != null) {
			recordProgramAttributeDateValue(patientProgramId, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", treatmentStartDate, enrollmentDate);
		}
	}

	public int enrollPatientIntoEACProgram(int patientId, LocalDate enrollmentDate, ConceptEnum patientClinicalStage) throws Exception {
		int patientProgramId = enrollPatientIntoProgram(patientId, enrollmentDate, ProgramNameEnum.VL_EAC_PROGRAM_KEY);

		addPatientClinicalStage(patientId, patientProgramId, patientClinicalStage);
		return patientProgramId;
	}

	public void enrollPatientIntoDefaulterProgram(
		int patientId,
		LocalDate enrollmentDate,
		ConceptEnum patientClinicalStage,
		LocalDate treatmentStartDate,
		LocalDate trackingDate,
		PreTrackingOutcomeEnum preTrackingOutcome,
		TrackingOutcomeEnum trackingOutcome) throws Exception {

		int patientProgramId = enrollPatientIntoProgram(patientId, enrollmentDate, ProgramNameEnum.HIV_DEFAULTERS_PROGRAM_KEY);
		addPatientClinicalStage(patientId, patientProgramId, patientClinicalStage);

		if (treatmentStartDate != null) {
			recordProgramAttributeDateValue(patientProgramId, "PROGRAM_MANAGEMENT_2_PATIENT_TREATMENT_DATE", treatmentStartDate, enrollmentDate);
		}

		if (trackingDate != null) {
			recordProgramAttributeDateValue(patientProgramId, "PROGRAM_MANAGEMENT_4_TRACKING_DATE", trackingDate, enrollmentDate);
		}

		if (preTrackingOutcome != null) {
			recordProgramAttributeCodedValue(patientProgramId, "PROGRAM_MANAGEMENT_3_PRETRACKING_OUTCOME", preTrackingOutcome.toString(), enrollmentDate);
		}

		if (trackingOutcome != null) {
			recordProgramAttributeCodedValue(patientProgramId, "PROGRAM_MANAGEMENT_6_TRACKING_OUTCOME", trackingOutcome.toString(), enrollmentDate);
		}
	}

	private void addPatientClinicalStage(int patientId, int patientProgramId, ConceptEnum patientClinicalStage) throws Exception {
		int stateId = TestDataGenerator.getQueryIntResult("SELECT pws.program_workflow_state_id " +
			"FROM program_workflow_state pws JOIN concept c ON c.concept_id = pws.concept_id " + 
			"WHERE c.uuid = '" + patientClinicalStage + "'", stmt);

		String query = "INSERT INTO patient_state (patient_program_id, state, creator, date_created, voided, uuid) VALUES " + 
			"(" + patientProgramId + "," + stateId + ",4,now(),0,'" + TestDataGenerator.generateUUID() + "')";
		stmt.executeUpdate(query);
	}

	private int enrollPatientIntoProgram(int patientId, LocalDate enrollmentDate, ProgramNameEnum programName) throws Exception {
		String uuidPatientProgram = TestDataGenerator.generateUUID();

		int programId = TestDataGenerator.getQueryIntResult("SELECT program_id FROM program WHERE name = '" + programName + "'", stmt);
	
		String createPatientProgramQuery = "INSERT INTO patient_program "
				+ "(patient_id, program_id, date_enrolled, creator, date_created, voided, uuid) VALUES"
				+ "('" + patientId + "','" + programId + "', '" + enrollmentDate + "',4,now(),0,'" + uuidPatientProgram + "')";

		stmt.executeUpdate(createPatientProgramQuery);

		return TestDataGenerator.getQueryIntResult("SELECT patient_program_id FROM patient_program WHERE uuid = '" + uuidPatientProgram + "'", stmt);

	}

	private void recordProgramAttributeDateValue(int patientProgramId, String programAttributeName, LocalDate value, LocalDate dateCreated) throws Exception {
		int attributeTypeId = TestDataGenerator.getQueryIntResult("SELECT program_attribute_type_id FROM program_attribute_type WHERE name = '" + programAttributeName + "'", stmt);
		String query =  "INSERT INTO patient_program_attribute "
		+ "(patient_program_id, attribute_type_id, value_reference, creator, date_created, voided, uuid) VALUES"
		+ "(" + patientProgramId + "," + attributeTypeId + ",'" + value + "', 4, '" + dateCreated + "', 0, '" + TestDataGenerator.generateUUID() + "')";
		stmt.executeUpdate(query);
	}

	public void recordProgramAttributeCodedValue(int patientProgramId, String programAttributeName, String conceptName, LocalDate dateCreated) throws Exception {
		int attributeTypeId = TestDataGenerator.getQueryIntResult("SELECT program_attribute_type_id FROM program_attribute_type WHERE name = '" + programAttributeName + "'", stmt);
		int conceptId = TestDataGenerator.getQueryIntResult("SELECT concept_id FROM concept_name WHERE name = '" + conceptName + "'", stmt);
		String query =  "INSERT INTO patient_program_attribute "
		+ "(patient_program_id, attribute_type_id, value_reference, creator, date_created, voided, uuid) VALUES"
		+ "(" + patientProgramId + "," + attributeTypeId + "," + conceptId + ", 4, '" + dateCreated + "', 0, '" + TestDataGenerator.generateUUID() + "')";
		stmt.executeUpdate(query);
	}

	public void recordProgramAttributeTextValue(int patientProgramId, String programAttributeName, String value, LocalDate dateCreated) throws Exception {
		int attributeTypeId = TestDataGenerator.getQueryIntResult("SELECT program_attribute_type_id FROM program_attribute_type WHERE name = '" + programAttributeName + "'", stmt);
		String query =  "INSERT INTO patient_program_attribute "
		+ "(patient_program_id, attribute_type_id, value_reference, creator, date_created, voided, uuid) VALUES"
		+ "(" + patientProgramId + "," + attributeTypeId + ",'" + value + "', 4, '" + dateCreated + "', 0, '" + TestDataGenerator.generateUUID() + "')";
		stmt.executeUpdate(query);
	}
}
