package org.jembi.bahmni.report_testing.test_utils;

import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;

public class HivTestingAndCounsellingFormDataGenerator {
    Statement stmt;

    public HivTestingAndCounsellingFormDataGenerator(Statement stmt) {
        this.stmt = stmt;
    }

    public int setHTCHivTestDate(int patientId, LocalDateTime obsDateTime, LocalDate testDate, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTree.add(ConceptEnum.HTC_HIV_TEST);
        conceptTree.add(ConceptEnum.HIV_TEST_DATE);
        return TestDataGenerator.recordFormDatetimeValue(patientId, obsDateTime, conceptTree, testDate, encounterId, stmt);
    }
    
    public int setHTCFinalResult(int patientId, LocalDateTime obsDateTime, ConceptEnum testResult, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTree.add(ConceptEnum.FINAL_RESULT);
        conceptTree.add(ConceptEnum.FINAL_TEST_RESULT);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, testResult, encounterId, stmt);
    }

    public int setHTCResultReceived(int patientId, LocalDateTime obsDateTime, ConceptEnum testResult, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTree.add(ConceptEnum.POST_TEST_COUNSELING);
        conceptTree.add(ConceptEnum.RESULT_RECEIVED);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, testResult, encounterId, stmt);
    }

    public int recordHTCResult(int patientId, LocalDateTime obsDateTime, ConceptEnum result, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTree.add(ConceptEnum.POST_TEST_COUNSELING);
        conceptTree.add(ConceptEnum.HTC_RESULT);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, result, encounterId, stmt);
    }

    public int recordResultReceived(int patientId, LocalDateTime obsDateTime, boolean result, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTree.add(ConceptEnum.POST_TEST_COUNSELING);
        conceptTree.add(ConceptEnum.RESULT_RECEIVED);
        return TestDataGenerator.recordFormBooleanValue(patientId, obsDateTime, conceptTree, result, encounterId, stmt);
    }

    public int recordStartTreatment(int patientId, LocalDateTime obsDateTime, ConceptEnum value, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTree.add(ConceptEnum.POST_TEST_COUNSELING);
        conceptTree.add(ConceptEnum.START_TREATMENT);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, value, encounterId, stmt);
    }

    public int recordPreTestCounseling(int patientId, LocalDateTime obsDateTime, ConceptEnum value, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTree.add(ConceptEnum.HTC_PRE_TEST_COUNSELING_SET);
        conceptTree.add(ConceptEnum.PRE_TEST_COUNSELING);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, value, encounterId, stmt);
    }

    public int recordTestingEntryPointAndModality(int patientId, LocalDateTime obsDateTime, ConceptEnum value, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTree.add(ConceptEnum.TESTING_ENTRY_POINT_AND_MODALITY);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, value, encounterId, stmt);
    }

    public int recordPregnancy(int patientId, LocalDateTime obsDateTime, ConceptEnum value, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTree.add(ConceptEnum.REASON_FOR_TEST);
        conceptTree.add(ConceptEnum.PREGNANCY);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, value, encounterId, stmt);
    }

    public int recordRiskGroup(int patientId, LocalDateTime obsDateTime, ConceptEnum value, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTree.add(ConceptEnum.HTC_PRE_TEST_COUNSELING_SET);
        conceptTree.add(ConceptEnum.RISK_GROUP);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, value, encounterId, stmt);
    }

    public int recordReasonForNotStartingATreatment(int patientId, LocalDateTime obsDateTime, ConceptEnum reason, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTree.add(ConceptEnum.POST_TEST_COUNSELING);
        conceptTree.add(ConceptEnum.REASON_FOR_NOT_STARTING_TREATMENT);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, reason, encounterId, stmt);
    }

	public int setIndexTestingOffered(int patientId, LocalDateTime obsDateTime, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTreeOfferedIndexTesting= new ArrayList<ConceptEnum>();
        conceptTreeOfferedIndexTesting.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTreeOfferedIndexTesting.add(ConceptEnum.HTC_HIV_TEST);
        conceptTreeOfferedIndexTesting.add(ConceptEnum.INDEX_TESTING_OFFERED);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTreeOfferedIndexTesting, ConceptEnum.YES, null, stmt);
	}

	public int setIndexTestingDateOffered(int patientId, LocalDateTime obsDateTime, LocalDate dateOffered, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTreeDateOfferedIndexTesting= new ArrayList<ConceptEnum>();
        conceptTreeDateOfferedIndexTesting.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTreeDateOfferedIndexTesting.add(ConceptEnum.HTC_HIV_TEST);
        conceptTreeDateOfferedIndexTesting.add(ConceptEnum.DATE_INDEX_TESTING_OFFERED);
        return TestDataGenerator.recordFormDatetimeValue(patientId, obsDateTime, conceptTreeDateOfferedIndexTesting, dateOffered, encounterId, stmt);
	}

	public int setIndexTestingAccepted(int patientId, LocalDateTime obsDateTime, Integer encounterId) throws Exception {
        List<ConceptEnum> conceptTreeAcceptedIndexTesting= new ArrayList<ConceptEnum>();
        conceptTreeAcceptedIndexTesting.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTreeAcceptedIndexTesting.add(ConceptEnum.HTC_HIV_TEST);
        conceptTreeAcceptedIndexTesting.add(ConceptEnum.INDEX_TESTING_ACCEPTED);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTreeAcceptedIndexTesting, ConceptEnum.TRUE, null, stmt);
	}

	public int setIndexTestingDateAccepted(int patientId, LocalDateTime obsDateTime, LocalDate accepted, Integer encounterId) throws Exception {
        List<ConceptEnum> conceptTreeDateAccepedIndexTesting= new ArrayList<ConceptEnum>();
        conceptTreeDateAccepedIndexTesting.add(ConceptEnum.HIV_TESTING_AND_COUNSELING);
        conceptTreeDateAccepedIndexTesting.add(ConceptEnum.HTC_HIV_TEST);
        conceptTreeDateAccepedIndexTesting.add(ConceptEnum.DATE_INDEX_TESTING_ACCEPTED);
        return TestDataGenerator.recordFormDatetimeValue(patientId, obsDateTime, conceptTreeDateAccepedIndexTesting, accepted, encounterId, stmt);
	}
}
