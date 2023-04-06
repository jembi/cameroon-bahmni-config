package org.jembi.bahmni.report_testing.test_utils;

import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.joda.time.LocalDateTime;

public class HivAdultInitialForm {
    Statement stmt;

    public HivAdultInitialForm(Statement stmt) {
        this.stmt = stmt;
    }

    public int setTherapeuticLineOnInitialHivAdultForm(int patientId, LocalDateTime obsDateTime, ConceptEnum value, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.PATIENT_WITH_HIV_ADULT_INITIAL);
        conceptTree.add(ConceptEnum._3_INITIAL_VISIT);
        conceptTree.add(ConceptEnum._3_3_TREATMENTS);
        conceptTree.add(ConceptEnum.THERAPEUTIC_LINE);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, value, encounterId, stmt);
    }
    
    public int setSexualOrientation(int patientId, LocalDateTime obsDateTime, ConceptEnum value, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.PATIENT_WITH_HIV_ADULT_INITIAL);
        conceptTree.add(ConceptEnum.SOCIO_DEMOGRAPHIC_INFORMATION);
        conceptTree.add(ConceptEnum.SEXUAL_ORIENTATION);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, value, encounterId, stmt);
	}

    
    public int setKpType(int patientId, LocalDateTime obsDateTime, ConceptEnum value, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.PATIENT_WITH_HIV_ADULT_INITIAL);
        conceptTree.add(ConceptEnum.SOCIO_DEMOGRAPHIC_INFORMATION);
        conceptTree.add(ConceptEnum.KP_TYPE);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, value, encounterId, stmt);
	}
}
