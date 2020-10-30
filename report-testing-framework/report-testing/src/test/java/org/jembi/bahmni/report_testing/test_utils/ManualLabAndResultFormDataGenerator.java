package org.jembi.bahmni.report_testing.test_utils;

import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;

public class ManualLabAndResultFormDataGenerator {
    Statement stmt;

    public ManualLabAndResultFormDataGenerator(Statement stmt) {
        this.stmt = stmt;
    }

    public int setRoutineViralLoadTestDateAndResult(int patientId, LocalDateTime obsDateTime, LocalDate testDate, int testResult, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTreeVL = new ArrayList<ConceptEnum>();
        conceptTreeVL.add(ConceptEnum.LAB_RESULT_ADD_MANUALLY);
		conceptTreeVL.add(ConceptEnum.SEROLOGY_DEPT_FORM);
		
		List<ConceptEnum> conceptTreeVLTestDate = new ArrayList<ConceptEnum>();
		conceptTreeVLTestDate.addAll(conceptTreeVL);

		conceptTreeVL.add(ConceptEnum.ROUTINE_VIRAL_LOAD);
		conceptTreeVLTestDate.add(ConceptEnum.ROUTINE_VIRAL_LOAD_TEST_DATE);

        int encounterIdVL = TestDataGenerator.recordFormNumericValue(patientId, obsDateTime, conceptTreeVL, testResult, encounterId, stmt);
        return TestDataGenerator.recordFormDatetimeValue(patientId, obsDateTime, conceptTreeVLTestDate, testDate, encounterIdVL, stmt);
    }
    
    public int recordPcrAlerQTestDateAndResult(int patientId, LocalDateTime obsDateTime, LocalDate testDate, ConceptEnum testResult, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTreePCR = new ArrayList<ConceptEnum>();
        conceptTreePCR.add(ConceptEnum.LAB_RESULT_ADD_MANUALLY);
		conceptTreePCR.add(ConceptEnum.HAEMATOLOGY_DEPT_FORM);
		
		List<ConceptEnum> conceptTreePCRTestDate = new ArrayList<ConceptEnum>();
		conceptTreePCRTestDate.addAll(conceptTreePCR);

		conceptTreePCR.add(ConceptEnum.PCR_ALERE_Q);
		conceptTreePCRTestDate.add(ConceptEnum.PCR_ALERE_Q_TEST_DATE);

        int encounterIdPCR = TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTreePCR, testResult, encounterId, stmt);
        return TestDataGenerator.recordFormDatetimeValue(patientId, obsDateTime, conceptTreePCRTestDate, testDate, encounterIdPCR, stmt);
    }
}
