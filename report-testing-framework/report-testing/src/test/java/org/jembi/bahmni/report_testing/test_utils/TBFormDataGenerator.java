package org.jembi.bahmni.report_testing.test_utils;

import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;

public class TBFormDataGenerator {
    Statement stmt;

    public TBFormDataGenerator(Statement stmt) {
        this.stmt = stmt;
    }

	public int setDateBaselineAssessment(int patientId, LocalDateTime obsDateTime, LocalDate dateBaselineAssessment, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.TB_FORM);
        conceptTree.add(ConceptEnum.DATE_BASELINE_ASSESSMENT);
        return TestDataGenerator.recordFormDatetimeValue(patientId, obsDateTime, conceptTree, dateBaselineAssessment, encounterId, stmt);
	}

	public int setTBScreened(int patientId, LocalDateTime obsDateTime, ConceptEnum value, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.TB_FORM);
        conceptTree.add(ConceptEnum.SCREENED);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, value, encounterId, stmt);
    }

	public int setTBScreeningResult(int patientId, LocalDateTime obsDateTime, ConceptEnum result, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.TB_FORM);
        conceptTree.add(ConceptEnum.TB_STATUS);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, result, encounterId, stmt);
	}

	public int setMTBConfirmation(int patientId, LocalDateTime obsDateTime, ConceptEnum value, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.TB_FORM);
        conceptTree.add(ConceptEnum.MTB_CONFIRMATION);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, value, encounterId, stmt);
	}
}
