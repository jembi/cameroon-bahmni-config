package org.jembi.bahmni.report_testing.test_utils;

import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;

public class AncInitialFormDataGenerator {
    Statement stmt;

    public AncInitialFormDataGenerator(Statement stmt) {
        this.stmt = stmt;
    }

    public int recordPriorAncEnrolmentHivTestDateAndResult(int patientId, LocalDateTime obsDateTime, LocalDate testDate, ConceptEnum result, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTreeHivTested = new ArrayList<ConceptEnum>();
        conceptTreeHivTested.add(ConceptEnum.ANC_INITIAL_FORM);
        conceptTreeHivTested.add(ConceptEnum.HIV_STATUS);
        conceptTreeHivTested.add(ConceptEnum.PRIOR_TO_ANC_ENROLMENT);

        List<ConceptEnum> conceptTreeHivTestDate = new ArrayList<ConceptEnum>();
        conceptTreeHivTestDate.addAll(conceptTreeHivTested);

        List<ConceptEnum> conceptTreeHivTestResult = new ArrayList<ConceptEnum>();
        conceptTreeHivTestResult.addAll(conceptTreeHivTested);

        conceptTreeHivTested.add(ConceptEnum.HIV_TESTED);
        conceptTreeHivTestDate.add(ConceptEnum.HIV_TEST_DATE);
        conceptTreeHivTestResult.add(ConceptEnum.HTC_RESULT);

        Integer _encounterId = TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTreeHivTested, ConceptEnum.YES, encounterId, stmt);
        TestDataGenerator.recordFormDatetimeValue(patientId, obsDateTime, conceptTreeHivTestDate, testDate, _encounterId, stmt);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTreeHivTestResult, result, _encounterId, stmt);
    }

    public int recordAtAncEnrolmentHivTestDateAndResult(int patientId, LocalDateTime obsDateTime, LocalDate testDate, ConceptEnum result, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree = new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.ANC_INITIAL_FORM);
        conceptTree.add(ConceptEnum.HIV_STATUS);
        conceptTree.add(ConceptEnum.AT_ANC_ENROLMENT);

        List<Integer> encounterIdAndObsGroupId = TestDataGenerator.recordEmptyFormRecord(patientId, obsDateTime, conceptTree, encounterId, stmt);
        int _encounterId = encounterIdAndObsGroupId.get(0);
        int obsGroupId = encounterIdAndObsGroupId.get(1);

        List<ConceptEnum> conceptTreeHivTestDate = new ArrayList<ConceptEnum>();
        List<ConceptEnum> conceptTreeHivTested = new ArrayList<ConceptEnum>();
        List<ConceptEnum> conceptTreeHivTestResult = new ArrayList<ConceptEnum>();

        conceptTreeHivTested.add(ConceptEnum.HIV_TESTED);
        conceptTreeHivTestDate.add(ConceptEnum.HIV_TEST_DATE);
        conceptTreeHivTestResult.add(ConceptEnum.HTC_RESULT);

        TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTreeHivTested, ConceptEnum.YES, encounterId, obsGroupId, stmt);
        TestDataGenerator.recordFormDatetimeValue(patientId, obsDateTime, conceptTreeHivTestDate, testDate, _encounterId, obsGroupId, stmt);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTreeHivTestResult, result, _encounterId, obsGroupId, stmt);
    }

    public int recordArtStatus(int patientId, LocalDateTime obsDateTime, ConceptEnum status, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree = new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.ANC_INITIAL_FORM);
        conceptTree.add(ConceptEnum.ARVS_ART);
        conceptTree.add(ConceptEnum.ART_STATUS);

        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, status, encounterId, stmt);
    }

    public int recordDateOfFirstANC(int patientId, LocalDateTime obsDateTime, LocalDate dateFirstAnc, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree = new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.ANC_INITIAL_FORM);
        conceptTree.add(ConceptEnum.DATE_FIRST_ANC_VISIT);

        return TestDataGenerator.recordFormDatetimeValue(patientId, obsDateTime, conceptTree, dateFirstAnc, encounterId, stmt);
    }

    public int recordReceivedCotrimoxazole(int patientId, LocalDateTime obsDateTime, ConceptEnum received, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree = new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.ANC_INITIAL_FORM);
        conceptTree.add(ConceptEnum.LLIN_MEDICATION_RECEIVED);
        conceptTree.add(ConceptEnum.RECEIVED_COTRIMOXAZOLE);

        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, received, encounterId, stmt);
    }

    public int recordReceivedLongLastingInsecticideNet(int patientId, LocalDateTime obsDateTime, ConceptEnum received, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree = new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.ANC_INITIAL_FORM);
        conceptTree.add(ConceptEnum.LLIN_MEDICATION_RECEIVED);
        conceptTree.add(ConceptEnum.LONG_LASTING_INSECTICIDE_NET);

        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, received, encounterId, stmt);
    }

    public int recordReceivedAntiTetanusToxoid(int patientId, LocalDateTime obsDateTime, ConceptEnum received, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree = new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.ANC_INITIAL_FORM);
        conceptTree.add(ConceptEnum.LLIN_MEDICATION_RECEIVED);
        conceptTree.add(ConceptEnum.ANTI_TETANUS_TOXOID);

        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, received, encounterId, stmt);
    }
}
