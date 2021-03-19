package org.jembi.bahmni.report_testing.georgetown_reports;

import static org.junit.Assert.assertEquals;

import java.util.List;
import java.util.Map;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;
import org.jembi.bahmni.report_testing.test_utils.models.RelationshipEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ReportEnum;
import org.jembi.bahmni.report_testing.test_utils.models.TherapeuticLineEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.joda.time.Months;
import org.junit.Test;

public class GeorgetownPCRReportTests extends BaseReportTest {
    @Test
    public void childrenWithABiologicalMotherRelationship_shouldBeReported() throws Exception {
        // Prepare
        /* record mother details */
        int patientIdMother = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(1990, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            "ART 123"
        );

        testDataGenerator.registration.recordPersonAddress(
            patientIdMother,
            "14 BAMBI STR", // address1
            "NKUM", // address2
            "NKUM", // address3
            "NKUM", // address4
            "NKUM", // city_village
            "NORD-OUEST", // state_province
            "BUI", // country_district
            "CAMEROON");

        /* record child details */
        LocalDate date10MonthsAgo = new LocalDate().plusMonths(-10);
        int patientIdChild = testDataGenerator.registration.createPatient(
            "BAH203002",
            GenderEnum.MALE,
            new LocalDate(date10MonthsAgo.getYear(), date10MonthsAgo.getMonthOfYear(), date10MonthsAgo.getDayOfMonth()),
            "Junior",
            "Tambwe",
            null,
            null
        );

        /* record relationship between mother and child */
        testDataGenerator.registration.addRelationshipToPatient(
            patientIdChild,
            patientIdMother,
            RelationshipEnum.RELATIONSHIP_BIO_MOTHER,
            RelationshipEnum.RELATIONSHIP_BIO_CHILD);

        /* record PCR test date and result */
        testDataGenerator.manualLabAndResultForm.recordPcrAlerQTestDateAndResult(
            patientIdChild,
            new LocalDateTime(2020, 1, 1, 8, 0),
            new LocalDate(2020, 1, 1),
            ConceptEnum.POSITIVE,
            null);
        
        /* enroll into the HIV program */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientIdChild,
            new LocalDate(2020, 1, 2),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            new LocalDate(2020, 1, 3));

        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientIdMother,
            new LocalDate(2020, 1, 2),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            new LocalDate(2020, 1, 3));
            
        /* record reason for not starting a treatment */
        int encounterId = testDataGenerator.hivTestingAndCounsellingForm.recordHTCResult(
            patientIdChild,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.POSITIVE,
            null);
        
        testDataGenerator.hivTestingAndCounsellingForm.recordStartTreatment(
            patientIdChild,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.NO,
            encounterId);

        testDataGenerator.hivTestingAndCounsellingForm.recordReasonForNotStartingATreatment(
            patientIdChild,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.PATIENT_REFUSED,
            encounterId);

        // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_PCR_REPORT, "georgetownPcrReport.sql",
                new LocalDate(2020, 1, 1), new LocalDate(2020, 1, 31));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.size(), 1);
        assertEquals(result.get(0).get("serialNumber"), "1");
        assertEquals(result.get(0).get("uniquePatientId"), "BAH203002");
        assertEquals(result.get(0).get("dateOfBirth"), date10MonthsAgo.toString());
        assertEquals(result.get(0).get("ageInMonths"), Months.monthsBetween(date10MonthsAgo, LocalDate.now()).getMonths());
        assertEquals(result.get(0).get("motherId"), "BAH203001");
        assertEquals(result.get(0).get("mothersAddress"), "14 BAMBI STR, NKUM");
        assertEquals(result.get(0).get("mothersContact"), "081234567");
        assertEquals(result.get(0).get("resultDatePcr"), "2020-01-01");
        assertEquals(result.get(0).get("pcrResult"), "Positive");
        assertEquals(result.get(0).get("artInitiationDate"), "2020-01-03");
        assertEquals(result.get(0).get("reasonOfNonInitiation"), "Patient refused");
    }

    @Test
    public void twoChildrenWithABiologicalMotherRelationship_shouldAllBeReported() throws Exception {
        // Prepare
        /* record mother details */
        int patientIdMother = testDataGenerator.registration.createPatient(
            "BAH203001",
            GenderEnum.FEMALE,
            new LocalDate(1990, 1, 15),
            "Marie",
            "Tambwe",
            "081234567",
            "ART 123"
        );

        testDataGenerator.registration.recordPersonAddress(
            patientIdMother,
            "14 BAMBI STR", // address1
            "NKUM", // address2
            "NKUM", // address3
            "NKUM", // address4
            "NKUM", // city_village
            "NORD-OUEST", // state_province
            "BUI", // country_district
            "CAMEROON");

        /* record child details */
        LocalDate date10MonthsAgo = new LocalDate().plusMonths(-10);
        int patientIdChild1 = testDataGenerator.registration.createPatient(
            "BAH203002",
            GenderEnum.MALE,
            new LocalDate(date10MonthsAgo.getYear(), date10MonthsAgo.getMonthOfYear(), date10MonthsAgo.getDayOfMonth()),
            "Junior",
            "Tambwe",
            null,
            null
        );

        LocalDate date12MonthsAgo = new LocalDate().plusMonths(-12);
        int patientIdChild2 = testDataGenerator.registration.createPatient(
            "BAH203003",
            GenderEnum.FEMALE,
            new LocalDate(date12MonthsAgo.getYear(), date12MonthsAgo.getMonthOfYear(), date12MonthsAgo.getDayOfMonth()),
            "Eva",
            "Tambwe",
            null,
            null
        );

        /* record relationship between mother and child */
        testDataGenerator.registration.addRelationshipToPatient(
            patientIdChild1,
            patientIdMother,
            RelationshipEnum.RELATIONSHIP_BIO_MOTHER,
            RelationshipEnum.RELATIONSHIP_BIO_CHILD);
        testDataGenerator.registration.addRelationshipToPatient(
            patientIdChild2,
            patientIdMother,
            RelationshipEnum.RELATIONSHIP_BIO_MOTHER,
            RelationshipEnum.RELATIONSHIP_BIO_CHILD);

        /* record PCR test date and result */
        testDataGenerator.manualLabAndResultForm.recordPcrAlerQTestDateAndResult(
            patientIdChild1,
            new LocalDateTime(2020, 1, 1, 8, 0),
            new LocalDate(2020, 1, 1),
            ConceptEnum.POSITIVE,
            null);
        
        /* enroll into the HIV program */
        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientIdChild1,
            new LocalDate(2020, 1, 2),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            new LocalDate(2020, 1, 3));

        testDataGenerator.program.enrollPatientIntoHIVProgram(
            patientIdMother,
            new LocalDate(2020, 1, 2),
            ConceptEnum.WHO_STAGE_1,
            TherapeuticLineEnum.FIRST_LINE,
            new LocalDate(2020, 1, 3));
            
        /* record reason for not starting a treatment */
        int encounterId = testDataGenerator.hivTestingAndCounsellingForm.recordHTCResult(
            patientIdChild1,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.POSITIVE,
            null);
        
        testDataGenerator.hivTestingAndCounsellingForm.recordStartTreatment(
            patientIdChild1,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.NO,
            encounterId);

        testDataGenerator.hivTestingAndCounsellingForm.recordReasonForNotStartingATreatment(
            patientIdChild1,
            new LocalDateTime(2020, 1, 4, 8, 0),
            ConceptEnum.PATIENT_REFUSED,
            encounterId);

             // Execute
        String query = readReportQuery(ReportEnum.GEORGETOWN_PCR_REPORT, "georgetownPcrReport.sql",
                new LocalDate(2020, 1, 1), new LocalDate(2020, 1, 31));
        List<Map<String, Object>> result = getReportResult(query);

        // Assert
        assertEquals(result.size(), 2);
        
        assertEquals(result.get(0).get("serialNumber"), "1");
        assertEquals(result.get(0).get("uniquePatientId"), "BAH203002");
        assertEquals(result.get(0).get("dateOfBirth"), date10MonthsAgo.toString());
        assertEquals(result.get(0).get("ageInMonths"), Months.monthsBetween(date10MonthsAgo, LocalDate.now()).getMonths());
        assertEquals(result.get(0).get("motherId"), "BAH203001");
        assertEquals(result.get(0).get("mothersAddress"), "14 BAMBI STR, NKUM");
        assertEquals(result.get(0).get("mothersContact"), "081234567");
        assertEquals(result.get(0).get("resultDatePcr"), "2020-01-01");
        assertEquals(result.get(0).get("pcrResult"), "Positive");
        assertEquals(result.get(0).get("artInitiationDate"), "2020-01-03");
        assertEquals(result.get(0).get("reasonOfNonInitiation"), "Patient refused");
        
        assertEquals(result.get(1).get("serialNumber"), "2");
        assertEquals(result.get(1).get("uniquePatientId"), "BAH203003");
        assertEquals(result.get(1).get("dateOfBirth"), date12MonthsAgo.toString());
        assertEquals(result.get(1).get("ageInMonths"), Months.monthsBetween(date12MonthsAgo, LocalDate.now()).getMonths());
        assertEquals(result.get(1).get("motherId"), "BAH203001");
        assertEquals(result.get(1).get("mothersAddress"), "14 BAMBI STR, NKUM");
        assertEquals(result.get(1).get("mothersContact"), "081234567");
        assertEquals(result.get(1).get("resultDatePcr"), null);
        assertEquals(result.get(1).get("pcrResult"), null);
        assertEquals(result.get(1).get("artInitiationDate"), null);
        assertEquals(result.get(1).get("reasonOfNonInitiation"), null);
    }
}
