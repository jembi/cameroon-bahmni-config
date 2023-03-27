package org.jembi.bahmni.report_testing.test_utils;

import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;

public class PatientWithHivChildFollowUpForm {
    Statement stmt;

    public PatientWithHivChildFollowUpForm(Statement stmt) {
        this.stmt = stmt;
    }

    public int setDisclosureStatus(int patientId, LocalDateTime obsDateTime, ConceptEnum value, Integer encounterId) throws Exception {
		List<ConceptEnum> conceptTree= new ArrayList<ConceptEnum>();
        conceptTree.add(ConceptEnum.PATIENT_WITH_HIV_CHILD_FOLLOW_UP);
        conceptTree.add(ConceptEnum.CONSULTATION_FOLLOW_UP);
        conceptTree.add(ConceptEnum.WHAT_DOES_THE_CHILD_KNOW_ABOUT_THEIR_DISEASE);
        return TestDataGenerator.recordFormCodedValue(patientId, obsDateTime, conceptTree, value, encounterId, stmt);
    }
}