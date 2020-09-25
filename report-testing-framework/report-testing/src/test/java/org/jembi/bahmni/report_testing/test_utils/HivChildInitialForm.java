package org.jembi.bahmni.report_testing.test_utils;

import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.joda.time.LocalDateTime;

public class HivChildInitialForm {
    Statement stmt;

    public HivChildInitialForm(Statement stmt) {
        this.stmt = stmt;
    }

	public int setTherapeuticLineOnInitialHivChildForm(int patientId, LocalDateTime obsDateTime, ConceptEnum value, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree = new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.PATIENT_WITH_HIV_CHILD_INITIAL);
        conceptTree.add(ConceptEnum._5_INITIAL_TREATMENT);
        conceptTree.add(ConceptEnum.PATIENTS_FROM_ANOTHER_CENTER_NON_NAIVE);
        conceptTree.add(ConceptEnum.ARV_PROTOCOL);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, value, encounterId, stmt);
	}
}
