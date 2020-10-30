package org.jembi.bahmni.report_testing.test_utils;

import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;

public class EACFormDataGenerator {
    Statement stmt;

    public EACFormDataGenerator(Statement stmt) {
        this.stmt = stmt;
    }

    public int recordEACOutcome(int patientId, LocalDateTime obsDateTime, ConceptEnum outcome, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree = new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.EAC_FORM);
		conceptTree.add(ConceptEnum.EAC_OUTCOME);

        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, outcome, encounterId, stmt);
	}

    public int recordEACOutcomeNote(int patientId, LocalDateTime obsDateTime, String note, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree = new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.EAC_FORM);
		conceptTree.add(ConceptEnum.EAC_OUTCOME_NOTES);

        return TestDataGenerator.recordFormTextValue(patientId, obsDateTime, conceptTree, note, encounterId, stmt);
	}
}
