package org.jembi.bahmni.report_testing.georgetown_reports;

import static org.junit.Assert.assertEquals;

import java.util.List;
import java.util.Map;

import org.jembi.bahmni.report_testing.test_utils.BaseReportTest;
import org.jembi.bahmni.report_testing.test_utils.models.AppointmentServiceEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ArtDispensationModelEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ConceptEnum;
import org.jembi.bahmni.report_testing.test_utils.models.DrugNameEnum;
import org.jembi.bahmni.report_testing.test_utils.models.DurationUnitEnum;
import org.jembi.bahmni.report_testing.test_utils.models.GenderEnum;
import org.jembi.bahmni.report_testing.test_utils.models.PersonAttributeTypeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.PreTrackingOutcomeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ReasonForConsultationEnum;
import org.jembi.bahmni.report_testing.test_utils.models.ReportEnum;
import org.jembi.bahmni.report_testing.test_utils.models.TherapeuticLineEnum;
import org.jembi.bahmni.report_testing.test_utils.models.TrackingOutcomeEnum;
import org.jembi.bahmni.report_testing.test_utils.models.VisitTypeEnum;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.junit.Test;

public class GeorgetownPatientInformationReportTests extends BaseReportTest {
        @Test
        public void patientEnrolledToHiv_shouldBeReported() throws Exception {
                // Prepare
                /* create a patient */
                int patientId = testDataGenerator.registration.createPatient(
                                "BAH203001",
                                GenderEnum.FEMALE,
                                new LocalDate(2000, 1, 15),
                                "Marie",
                                "Tambwe",
                                "081234567",
                                "ART 123");

                /* record profession */
                testDataGenerator.registration.addPersonAttributeCodedValue(
                                patientId,
                                PersonAttributeTypeEnum.OCCUPATION.toString(),
                                ConceptEnum.PRIVATE_SECTOR_EMPLOYEE);

                /* record the patient address */
                testDataGenerator.registration.recordPersonAddress(
                                patientId,
                                "14 BAMBI STR", // address1
                                "NKUM", // address2
                                "YAOUNDE 1", // address3
                                "NKUM", // address4
                                "FOUDA", // city_village
                                "CENTRE", // state_province
                                "MFOUNDI", // country_district
                                "CAMEROON"); // country

                /* start an OPD visit */
                int encounterIdOpdVisit = testDataGenerator.startVisit(
                                patientId,
                                new LocalDate(2019, 12, 30),
                                VisitTypeEnum.VISIT_TYPE_OPD);

                /* record the HIV test date and result */
                int encounterIdHtc = testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
                                patientId,
                                new LocalDateTime(2020, 1, 1, 8, 0),
                                new LocalDate(2020, 1, 1),
                                null);
                testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
                                patientId,
                                new LocalDateTime(2020, 1, 1, 8, 0),
                                ConceptEnum.POSITIVE,
                                encounterIdHtc);

                /* enroll into the HIV program, including reason for consultation */
                int patientProgramId = testDataGenerator.program.enrollPatientIntoHIVProgram(
                                patientId,
                                new LocalDate(2020, 1, 2),
                                ConceptEnum.WHO_STAGE_1,
                                TherapeuticLineEnum.SECOND_LINE,
                                new LocalDate(2020, 1, 3));
                testDataGenerator.program.recordProgramAttributeCodedValue(
                                patientProgramId,
                                "PROGRAM_MANAGEMENT_5_PATIENT_STAGE",
                                ReasonForConsultationEnum.INITIATION_OF_ART.toString(),
                                new LocalDate(2020, 1, 2));

                /* dispense ARV */
                testDataGenerator.drug.orderDrug(
                                patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.ABC_3TC_120_60MG,
                                new LocalDateTime(2020, 1, 5, 8, 0, 0),
                                1,
                                DurationUnitEnum.MONTH,
                                true);

                testDataGenerator.drug.orderDrug(
                                patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.ABC_3TC_60_30MG,
                                new LocalDateTime(2020, 1, 5, 8, 30, 0),
                                1,
                                DurationUnitEnum.MONTH,
                                true);

                /*
                 * enroll into the defaulter program, including pre-tracking and tracking
                 * outcomes
                 */
                testDataGenerator.program.enrollPatientIntoDefaulterProgram(
                                patientId,
                                new LocalDate(2020, 2, 1),
                                ConceptEnum.CALL_1,
                                new LocalDate(2020, 1, 4),
                                new LocalDate(2020, 2, 3),
                                PreTrackingOutcomeEnum._7_TO_30_DAYS,
                                TrackingOutcomeEnum.CALLS_NOT_PICKED_UP);

                /* record the therapeutic line at initiation in the initial hiv form */
                int encounterIdAdultHivForm = testDataGenerator.hivAdultInitialForm
                                .setTherapeuticLineOnInitialHivAdultForm(
                                                patientId,
                                                new LocalDateTime(2020, 1, 7, 8, 0, 0),
                                                ConceptEnum.FIRST_THERAPEUTIC_LINE,
                                                null);

                /* record the sexual orientation */
                testDataGenerator.hivAdultInitialForm.setKpType(
                                patientId,
                                new LocalDateTime(2020, 1, 8, 8, 0, 0),
                                ConceptEnum.MIGRANT,
                                encounterIdAdultHivForm);

                /* record an ART Dispensation appointment */
                testDataGenerator.appointment.recordAppointment(
                                patientId,
                                AppointmentServiceEnum.ART_DISPENSARY,
                                new LocalDateTime(2020, 1, 15, 8, 0, 0),
                                new LocalDateTime(2020, 1, 15, 10, 0, 0));

                /* record VL date and result */
                testDataGenerator.manualLabAndResultForm.setRoutineViralLoadTestDateAndResult(
                                patientId,
                                new LocalDateTime(2020, 1, 9, 8, 0, 0),
                                new LocalDate(2020, 1, 9),
                                900,
                                null);

                /* record Disclosure Status */
                testDataGenerator.patientWithHivChildFollowUpForm.setDisclosureStatus(
                                patientId,
                                new LocalDateTime(2020, 1, 9, 8, 0, 0),
                                ConceptEnum.NOTHING_DISCLOSURE_NOT_MADE,
                                encounterIdOpdVisit);

                /* record TB screening */
                testDataGenerator.tbForm.setTBScreened(
                                patientId,
                                new LocalDateTime(2020, 1, 6, 10, 0),
                                ConceptEnum.YES,
                                encounterIdOpdVisit);

                /* record INH DispenseDate */
                testDataGenerator.drug.orderDrug(patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.INH_100MG,
                                new LocalDateTime(2020, 1, 6, 10, 0),
                                20,
                                DurationUnitEnum.DAY,
                                true);

                /* record ART DSD Models */
                testDataGenerator.program.recordProgramAttributeCodedValue(
                                patientProgramId,
                                "PROGRAM_MANAGEMENT_92_ART_DISPENSATION_MODEL",
                                ArtDispensationModelEnum.CBO_DISPENSATION.toString(),
                                new LocalDate(2020, 1, 2));

                // Execute
                String query = readReportQuery(
                                ReportEnum.GEORGETOWN_PATIENT_INFORMATION_REPORT,
                                "georgetownPatientInformationReport.sql",
                                new LocalDate(2020, 1, 1),
                                new LocalDate(2020, 1, 31));
                List<Map<String, Object>> result = getReportResult(query);

                // Assert
                assertEquals(result.get(0).get("serialNumber"), "1");
                assertEquals(result.get(0).get("artCode"), "ART 123");
                assertEquals(result.get(0).get("facilityName"), "CENTRE");
                assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
                assertEquals(result.get(0).get("ageAtEnrollment"), 19);
                assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
                assertEquals(result.get(0).get("sex"), "f");
                assertEquals(result.get(0).get("hivTestDate"), "2020-01-01");
                assertEquals(result.get(0).get("dateArvInitiation"), "2020-01-03");
                assertEquals(result.get(0).get("address"), "FOUDA,14 BAMBI STR");
                assertEquals(result.get(0).get("region"), "CENTRE");
                assertEquals(result.get(0).get("division"), "MFOUNDI");
                assertEquals(result.get(0).get("subDivision"), "YAOUNDE 1");
                assertEquals(result.get(0).get("village"), "FOUDA");
                assertEquals(result.get(0).get("contactTelephone"), "081234567");
                assertEquals(result.get(0).get("clinicalWhoStage"), "WHO stage 1");
                assertEquals(result.get(0).get("regimentAtArtInitiation"), "ABC/3TC 120/60mg");
                assertEquals(result.get(0).get("lineAtInitiation"), "1st line");
                assertEquals(result.get(0).get("currentRegimen"), "ABC/3TC 120/60mg;ABC/3TC 60/30mg");
                assertEquals(result.get(0).get("currentLine"), "2nd line");
                assertEquals(result.get(0).get("eligibilityForVl"), "No");
                assertEquals(result.get(0).get("dateOfLastVisit"), "2019-12-30");
                assertEquals(result.get(0).get("lastAppointmentDate"), "2020-01-15");
                assertEquals(result.get(0).get("reasonsForConsultation"), "Initiation of ART");
                assertEquals(result.get(0).get("transfertOut"), "No");
                assertEquals(result.get(0).get("kp"), "True");
                assertEquals(result.get(0).get("kpType"), "Migrant");
                assertEquals(result.get(0).get("profession"), "Private sector employee");
                assertEquals(result.get(0).get("preTrackingOutcome"), "7 to 30 days");
                assertEquals(result.get(0).get("trackingOutcome"), "Calls not picked up");
                assertEquals(result.get(0).get("lastViralLoadResultDate"), "2020-01-09");
                assertEquals(result.get(0).get("lastViralLoadResult"), 900);
                assertEquals(result.get(0).get("reasonOfLastVL"), "Routine");
                assertEquals(result.get(0).get("disclosureStatus"), "Nothing (disclosure not made)");
                assertEquals(result.get(0).get("tbScreening"), "Yes full name");
                assertEquals(result.get(0).get("inhDispenseDate"), "2020-01-06");
                assertEquals(result.get(0).get("inhDuration"), 0);
                assertEquals(result.get(0).get("artDSDModels"), "CBO dispensation");
        }

        /**
         * the column "Regiment at ART Initiation" is retrieved from a different concept
         * when the patient is a child
         */
        @Test
        public void childEnrolledToHiv_shouldBeReported() throws Exception {
                // Prepare
                /* create a patient */
                int patientId = testDataGenerator.registration.createPatient(
                                "BAH203001",
                                GenderEnum.FEMALE,
                                new LocalDate(2010, 1, 15),
                                "Marie",
                                "Tambwe",
                                "081234567",
                                "ART 123");

                /* record profession */
                testDataGenerator.registration.addPersonAttributeCodedValue(
                                patientId,
                                PersonAttributeTypeEnum.OCCUPATION.toString(),
                                ConceptEnum.PRIVATE_SECTOR_EMPLOYEE);

                /* record the patient address */
                testDataGenerator.registration.recordPersonAddress(
                                patientId,
                                "14 BAMBI STR", // address1
                                "NKUM", // address2
                                "YAOUNDE 1", // address3
                                "NKUM", // address4
                                "FOUDA", // city_village
                                "CENTRE", // state_province
                                "MFOUNDI", // country_district
                                "CAMEROON"); // country

                /* start an OPD visit */
                int encounterIdOpdVisit = testDataGenerator.startVisit(
                                patientId,
                                new LocalDate(2019, 12, 30),
                                VisitTypeEnum.VISIT_TYPE_OPD);

                /* record the HIV test date and result */
                int encounterIdHtc = testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
                                patientId,
                                new LocalDateTime(2020, 1, 1, 8, 0),
                                new LocalDate(2020, 1, 1),
                                null);
                testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
                                patientId,
                                new LocalDateTime(2020, 1, 1, 8, 0),
                                ConceptEnum.POSITIVE,
                                encounterIdHtc);

                /* enroll into the HIV program, including reason for consultation */
                int patientProgramId = testDataGenerator.program.enrollPatientIntoHIVProgram(
                                patientId,
                                new LocalDate(2020, 1, 2),
                                ConceptEnum.WHO_STAGE_1,
                                TherapeuticLineEnum.SECOND_LINE,
                                new LocalDate(2020, 1, 3));
                testDataGenerator.program.recordProgramAttributeCodedValue(
                                patientProgramId,
                                "PROGRAM_MANAGEMENT_5_PATIENT_STAGE",
                                ReasonForConsultationEnum.INITIATION_OF_ART.toString(),
                                new LocalDate(2020, 1, 2));

                /* dispense ARV */
                testDataGenerator.drug.orderDrug(
                                patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.ABC_3TC_120_60MG,
                                new LocalDateTime(2020, 1, 5, 8, 0, 0),
                                1,
                                DurationUnitEnum.MONTH,
                                true);

                testDataGenerator.drug.orderDrug(
                                patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.ABC_3TC_60_30MG,
                                new LocalDateTime(2020, 1, 5, 8, 0, 0),
                                1,
                                DurationUnitEnum.MONTH,
                                true);

                /*
                 * enroll into the defaulter program, including pre-tracking and tracking
                 * outcomes
                 */
                testDataGenerator.program.enrollPatientIntoDefaulterProgram(
                                patientId,
                                new LocalDate(2020, 2, 1),
                                ConceptEnum.CALL_1,
                                new LocalDate(2020, 1, 4),
                                new LocalDate(2020, 2, 3),
                                PreTrackingOutcomeEnum._7_TO_30_DAYS,
                                TrackingOutcomeEnum.CALLS_NOT_PICKED_UP);

                /* record the therapeutic line at initiation in the initial hiv form */
                int encounterIdChildHivForm = testDataGenerator.hivChildInitialForm
                                .setTherapeuticLineOnInitialHivChildForm(
                                                patientId,
                                                new LocalDateTime(2020, 1, 7, 8, 0, 0),
                                                ConceptEnum.FIRST_THERAPEUTIC_LINE,
                                                null);

                /* record the sexual orientation */
                testDataGenerator.hivAdultInitialForm.setKpType(
                                patientId,
                                new LocalDateTime(2020, 1, 8, 8, 0, 0),
                                ConceptEnum.MIGRANT,
                                encounterIdChildHivForm);

                /* record an ART Dispensation appointment */
                testDataGenerator.appointment.recordAppointment(
                                patientId,
                                AppointmentServiceEnum.ART_DISPENSARY,
                                new LocalDateTime(2020, 1, 15, 8, 0, 0),
                                new LocalDateTime(2020, 1, 15, 10, 0, 0));

                /* record VL date and result */
                testDataGenerator.manualLabAndResultForm.setRoutineViralLoadTestDateAndResult(
                                patientId,
                                new LocalDateTime(2020, 1, 9, 8, 0, 0),
                                new LocalDate(2020, 1, 9),
                                900,
                                null);

                /* record Disclosure Status */
                testDataGenerator.patientWithHivChildFollowUpForm.setDisclosureStatus(
                                patientId,
                                new LocalDateTime(2020, 1, 9, 8, 0, 0),
                                ConceptEnum.NOTHING_DISCLOSURE_NOT_MADE,
                                encounterIdOpdVisit);

                /* record TB screening */
                testDataGenerator.tbForm.setTBScreened(
                                patientId,
                                new LocalDateTime(2020, 1, 6, 10, 0),
                                ConceptEnum.YES,
                                encounterIdOpdVisit);

                /* record INH DispenseDate */
                testDataGenerator.drug.orderDrug(patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.INH_100MG,
                                new LocalDateTime(2020, 1, 6, 10, 0),
                                20,
                                DurationUnitEnum.DAY,
                                true);

                /* record ART DSD Models */
                testDataGenerator.program.recordProgramAttributeCodedValue(
                                patientProgramId,
                                "PROGRAM_MANAGEMENT_92_ART_DISPENSATION_MODEL",
                                ArtDispensationModelEnum.CBO_DISPENSATION.toString(),
                                new LocalDate(2020, 1, 2));

                String query = readReportQuery(
                                ReportEnum.GEORGETOWN_PATIENT_INFORMATION_REPORT,
                                "georgetownPatientInformationReport.sql",
                                new LocalDate(2020, 1, 1),
                                new LocalDate(2020, 1, 31));
                List<Map<String, Object>> result = getReportResult(query);

                // Assert
                assertEquals(result.get(0).get("serialNumber"), "1");
                assertEquals(result.get(0).get("artCode"), "ART 123");
                assertEquals(result.get(0).get("facilityName"), "CENTRE");
                assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
                assertEquals(result.get(0).get("ageAtEnrollment"), 9);
                assertEquals(result.get(0).get("dateOfBirth"), "2010-01-15");
                assertEquals(result.get(0).get("sex"), "f");
                assertEquals(result.get(0).get("hivTestDate"), "2020-01-01");
                assertEquals(result.get(0).get("dateArvInitiation"), "2020-01-03");
                assertEquals(result.get(0).get("address"), "FOUDA,14 BAMBI STR");
                assertEquals(result.get(0).get("region"), "CENTRE");
                assertEquals(result.get(0).get("division"), "MFOUNDI");
                assertEquals(result.get(0).get("subDivision"), "YAOUNDE 1");
                assertEquals(result.get(0).get("village"), "FOUDA");
                assertEquals(result.get(0).get("contactTelephone"), "081234567");
                assertEquals(result.get(0).get("clinicalWhoStage"), "WHO stage 1");
                assertEquals(result.get(0).get("regimentAtArtInitiation"), "ABC/3TC 120/60mg");
                assertEquals(result.get(0).get("lineAtInitiation"), "1st line");
                assertEquals(result.get(0).get("currentRegimen"), "ABC/3TC 120/60mg;ABC/3TC 60/30mg");
                assertEquals(result.get(0).get("currentLine"), "2nd line");
                assertEquals(result.get(0).get("eligibilityForVl"), "No");
                assertEquals(result.get(0).get("dateOfLastVisit"), "2019-12-30");
                assertEquals(result.get(0).get("lastAppointmentDate"), "2020-01-15");
                assertEquals(result.get(0).get("reasonsForConsultation"), "Initiation of ART");
                assertEquals(result.get(0).get("transfertOut"), "No");
                assertEquals(result.get(0).get("kp"), "True");
                assertEquals(result.get(0).get("kpType"), "Migrant");
                assertEquals(result.get(0).get("profession"), "Private sector employee");
                assertEquals(result.get(0).get("preTrackingOutcome"), "7 to 30 days");
                assertEquals(result.get(0).get("trackingOutcome"), "Calls not picked up");
                assertEquals(result.get(0).get("lastViralLoadResultDate"), "2020-01-09");
                assertEquals(result.get(0).get("lastViralLoadResult"), 900);
                assertEquals(result.get(0).get("reasonOfLastVL"), "Routine");
                assertEquals(result.get(0).get("disclosureStatus"), "Nothing (disclosure not made)");
                assertEquals(result.get(0).get("tbScreening"), "Yes full name");
                assertEquals(result.get(0).get("inhDispenseDate"), "2020-01-06");
                assertEquals(result.get(0).get("inhDuration"), 0);
                assertEquals(result.get(0).get("artDSDModels"), "CBO dispensation");
        }

        // /** when the sexual orientation is not populated, the column "KP?" should =
        // "False" */
        @Test
        public void patientWithNoKPEnrolledToHiv_shouldBeReported() throws Exception {
                // Prepare
                /* create a patient */
                int patientId = testDataGenerator.registration.createPatient(
                                "BAH203001",
                                GenderEnum.FEMALE,
                                new LocalDate(2000, 1, 15),
                                "Marie",
                                "Tambwe",
                                "081234567",
                                "ART 123");

                /* record profession */
                testDataGenerator.registration.addPersonAttributeCodedValue(
                                patientId,
                                PersonAttributeTypeEnum.OCCUPATION.toString(),
                                ConceptEnum.PRIVATE_SECTOR_EMPLOYEE);

                /* record the patient address */
                testDataGenerator.registration.recordPersonAddress(
                                patientId,
                                "14 BAMBI STR", // address1
                                "NKUM", // address2
                                "YAOUNDE 1", // address3
                                "NKUM", // address4
                                "FOUDA", // city_village
                                "CENTRE", // state_province
                                "MFOUNDI", // country_district
                                "CAMEROON"); // country

                /* start an OPD visit */
                int encounterIdOpdVisit = testDataGenerator.startVisit(
                                patientId,
                                new LocalDate(2019, 12, 30),
                                VisitTypeEnum.VISIT_TYPE_OPD);

                /* record the HIV test date and result */
                int encounterIdHtc = testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
                                patientId,
                                new LocalDateTime(2020, 1, 1, 8, 0),
                                new LocalDate(2020, 1, 1),
                                null);
                testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
                                patientId,
                                new LocalDateTime(2020, 1, 1, 8, 0),
                                ConceptEnum.POSITIVE,
                                encounterIdHtc);

                /* enroll into the HIV program, including reason for consultation */
                int patientProgramId = testDataGenerator.program.enrollPatientIntoHIVProgram(
                                patientId,
                                new LocalDate(2020, 1, 2),
                                ConceptEnum.WHO_STAGE_1,
                                TherapeuticLineEnum.SECOND_LINE,
                                new LocalDate(2020, 1, 3));
                testDataGenerator.program.recordProgramAttributeCodedValue(
                                patientProgramId,
                                "PROGRAM_MANAGEMENT_5_PATIENT_STAGE",
                                ReasonForConsultationEnum.INITIATION_OF_ART.toString(),
                                new LocalDate(2020, 1, 2));

                /* dispense ARV */
                testDataGenerator.drug.orderDrug(
                                patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.ABC_3TC_120_60MG,
                                new LocalDateTime(2020, 1, 5, 8, 0, 0),
                                1,
                                DurationUnitEnum.MONTH,
                                true);

                testDataGenerator.drug.orderDrug(
                                patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.ABC_3TC_60_30MG,
                                new LocalDateTime(2020, 1, 5, 8, 0, 0),
                                1,
                                DurationUnitEnum.MONTH,
                                true);

                /*
                 * enroll into the defaulter program, including pre-tracking and tracking
                 * outcomes
                 */
                testDataGenerator.program.enrollPatientIntoDefaulterProgram(
                                patientId,
                                new LocalDate(2020, 2, 1),
                                ConceptEnum.CALL_1,
                                new LocalDate(2020, 1, 4),
                                new LocalDate(2020, 2, 3),
                                PreTrackingOutcomeEnum._7_TO_30_DAYS,
                                TrackingOutcomeEnum.CALLS_NOT_PICKED_UP);

                /* record the therapeutic line at initiation in the initial hiv form */
                testDataGenerator.hivAdultInitialForm.setTherapeuticLineOnInitialHivAdultForm(
                                patientId,
                                new LocalDateTime(2020, 1, 7, 8, 0, 0),
                                ConceptEnum.FIRST_THERAPEUTIC_LINE,
                                null);

                /* record an ART Dispensation appointment */
                testDataGenerator.appointment.recordAppointment(
                                patientId,
                                AppointmentServiceEnum.ART_DISPENSARY,
                                new LocalDateTime(2020, 1, 15, 8, 0, 0),
                                new LocalDateTime(2020, 1, 15, 10, 0, 0));

                /* record VL date and result */
                testDataGenerator.manualLabAndResultForm.setRoutineViralLoadTestDateAndResult(
                                patientId,
                                new LocalDateTime(2020, 1, 9, 8, 0, 0),
                                new LocalDate(2020, 1, 9),
                                900,
                                null);

                /* record Disclosure Status */
                testDataGenerator.patientWithHivChildFollowUpForm.setDisclosureStatus(
                                patientId,
                                new LocalDateTime(2020, 1, 9, 8, 0, 0),
                                ConceptEnum.NOTHING_DISCLOSURE_NOT_MADE,
                                encounterIdOpdVisit);

                /* record TB screening */
                testDataGenerator.tbForm.setTBScreened(
                                patientId,
                                new LocalDateTime(2020, 1, 6, 10, 0),
                                ConceptEnum.YES,
                                encounterIdOpdVisit);

                /* record INH DispenseDate */
                testDataGenerator.drug.orderDrug(patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.INH_100MG,
                                new LocalDateTime(2020, 1, 6, 10, 0),
                                20,
                                DurationUnitEnum.DAY,
                                true);

                /* record ART DSD Models */
                testDataGenerator.program.recordProgramAttributeCodedValue(
                                patientProgramId,
                                "PROGRAM_MANAGEMENT_92_ART_DISPENSATION_MODEL",
                                ArtDispensationModelEnum.CBO_DISPENSATION.toString(),
                                new LocalDate(2020, 1, 2));

                // Execute
                String query = readReportQuery(
                                ReportEnum.GEORGETOWN_PATIENT_INFORMATION_REPORT,
                                "georgetownPatientInformationReport.sql",
                                new LocalDate(2020, 1, 1),
                                new LocalDate(2020, 1, 31));
                List<Map<String, Object>> result = getReportResult(query);

                // Assert
                assertEquals(result.get(0).get("serialNumber"), "1");
                assertEquals(result.get(0).get("artCode"), "ART 123");
                assertEquals(result.get(0).get("facilityName"), "CENTRE");
                assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
                assertEquals(result.get(0).get("ageAtEnrollment"), 19);
                assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
                assertEquals(result.get(0).get("sex"), "f");
                assertEquals(result.get(0).get("hivTestDate"), "2020-01-01");
                assertEquals(result.get(0).get("dateArvInitiation"), "2020-01-03");
                assertEquals(result.get(0).get("address"), "FOUDA,14 BAMBI STR");
                assertEquals(result.get(0).get("region"), "CENTRE");
                assertEquals(result.get(0).get("division"), "MFOUNDI");
                assertEquals(result.get(0).get("subDivision"), "YAOUNDE 1");
                assertEquals(result.get(0).get("village"), "FOUDA");
                assertEquals(result.get(0).get("contactTelephone"), "081234567");
                assertEquals(result.get(0).get("clinicalWhoStage"), "WHO stage 1");
                assertEquals(result.get(0).get("regimentAtArtInitiation"), "ABC/3TC 120/60mg");
                assertEquals(result.get(0).get("lineAtInitiation"), "1st line");
                assertEquals(result.get(0).get("currentRegimen"), "ABC/3TC 120/60mg;ABC/3TC 60/30mg");
                assertEquals(result.get(0).get("currentLine"), "2nd line");
                assertEquals(result.get(0).get("eligibilityForVl"), "No");
                assertEquals(result.get(0).get("dateOfLastVisit"), "2019-12-30");
                assertEquals(result.get(0).get("lastAppointmentDate"), "2020-01-15");
                assertEquals(result.get(0).get("reasonsForConsultation"), "Initiation of ART");
                assertEquals(result.get(0).get("transfertOut"), "No");
                assertEquals(result.get(0).get("kp"), "False");
                assertEquals(result.get(0).get("kpType"), null);
                assertEquals(result.get(0).get("profession"), "Private sector employee");
                assertEquals(result.get(0).get("preTrackingOutcome"), "7 to 30 days");
                assertEquals(result.get(0).get("trackingOutcome"), "Calls not picked up");
                assertEquals(result.get(0).get("lastViralLoadResultDate"), "2020-01-09");
                assertEquals(result.get(0).get("lastViralLoadResult"), 900);
                assertEquals(result.get(0).get("reasonOfLastVL"), "Routine");
                assertEquals(result.get(0).get("disclosureStatus"), "Nothing (disclosure not made)");
                assertEquals(result.get(0).get("tbScreening"), "Yes full name");
                assertEquals(result.get(0).get("inhDispenseDate"), "2020-01-06");
                assertEquals(result.get(0).get("inhDuration"), 0);
                assertEquals(result.get(0).get("artDSDModels"), "CBO dispensation");
        }

        // /** when the patient is eligible for VL, the column "Eligibilty for VL"
        // should = "Yes" */
        @Test
        public void patientEligibleForVLAndEnrolledToHiv_shouldBeReported() throws Exception {
                // Prepare
                /* create a patient */
                int patientId = testDataGenerator.registration.createPatient(
                                "BAH203001",
                                GenderEnum.FEMALE,
                                new LocalDate(2000, 1, 15),
                                "Marie",
                                "Tambwe",
                                "081234567",
                                "ART 123");

                /* record profession */
                testDataGenerator.registration.addPersonAttributeCodedValue(
                                patientId,
                                PersonAttributeTypeEnum.OCCUPATION.toString(),
                                ConceptEnum.PRIVATE_SECTOR_EMPLOYEE);

                /* record the patient address */
                testDataGenerator.registration.recordPersonAddress(
                                patientId,
                                "14 BAMBI STR", // address1
                                "NKUM", // address2
                                "YAOUNDE 1", // address3
                                "NKUM", // address4
                                "FOUDA", // city_village
                                "CENTRE", // state_province
                                "MFOUNDI", // country_district
                                "CAMEROON"); // country

                /* start an OPD visit */
                int encounterIdOpdVisit = testDataGenerator.startVisit(
                                patientId,
                                new LocalDate(2019, 12, 30),
                                VisitTypeEnum.VISIT_TYPE_OPD);

                /* record the HIV test date and result */
                int encounterIdHtc = testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
                                patientId,
                                new LocalDateTime(2020, 1, 1, 8, 0),
                                new LocalDate(2020, 1, 1),
                                null);
                testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
                                patientId,
                                new LocalDateTime(2020, 1, 1, 8, 0),
                                ConceptEnum.POSITIVE,
                                encounterIdHtc);

                /* enroll into the HIV program, including reason for consultation */
                int patientProgramId = testDataGenerator.program.enrollPatientIntoHIVProgram(
                                patientId,
                                new LocalDate(2020, 1, 2),
                                ConceptEnum.WHO_STAGE_1,
                                TherapeuticLineEnum.SECOND_LINE,
                                new LocalDate(2020, 1, 3));
                testDataGenerator.program.recordProgramAttributeCodedValue(
                                patientProgramId,
                                "PROGRAM_MANAGEMENT_5_PATIENT_STAGE",
                                ReasonForConsultationEnum.INITIATION_OF_ART.toString(),
                                new LocalDate(2020, 1, 2));

                /* dispense ARV */
                testDataGenerator.drug.orderDrug(
                                patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.ABC_3TC_120_60MG,
                                new LocalDateTime(2020, 1, 5, 8, 0, 0),
                                1000,
                                DurationUnitEnum.MONTH,
                                true);

                /*
                 * enroll into the defaulter program, including pre-tracking and tracking
                 * outcomes
                 */
                testDataGenerator.program.enrollPatientIntoDefaulterProgram(
                                patientId,
                                new LocalDate(2020, 2, 1),
                                ConceptEnum.CALL_1,
                                new LocalDate(2020, 1, 4),
                                new LocalDate(2020, 2, 3),
                                PreTrackingOutcomeEnum._7_TO_30_DAYS,
                                TrackingOutcomeEnum.CALLS_NOT_PICKED_UP);

                /* record the therapeutic line at initiation in the initial hiv form */
                int encounterIdAdultHivForm = testDataGenerator.hivAdultInitialForm
                                .setTherapeuticLineOnInitialHivAdultForm(
                                                patientId,
                                                new LocalDateTime(2020, 1, 7, 8, 0, 0),
                                                ConceptEnum.FIRST_THERAPEUTIC_LINE,
                                                null);

                /* record the sexual orientation */
                testDataGenerator.hivAdultInitialForm.setKpType(
                                patientId,
                                new LocalDateTime(2020, 1, 8, 8, 0, 0),
                                ConceptEnum.MIGRANT,
                                encounterIdAdultHivForm);

                /* record an ART Dispensation appointment */
                testDataGenerator.appointment.recordAppointment(
                                patientId,
                                AppointmentServiceEnum.ART_DISPENSARY,
                                new LocalDateTime(2020, 1, 15, 8, 0, 0),
                                new LocalDateTime(2020, 1, 15, 10, 0, 0));

                /* record VL date and result */
                testDataGenerator.manualLabAndResultForm.setRoutineViralLoadTestDateAndResult(
                                patientId,
                                new LocalDateTime(2019, 1, 9, 8, 0, 0),
                                new LocalDate(2019, 1, 9), // the last VL is more than 1 year old; therefore the patient
                                                           // is Eligible for VL
                                900,
                                null);

                /* record Disclosure Status */
                testDataGenerator.patientWithHivChildFollowUpForm.setDisclosureStatus(
                                patientId,
                                new LocalDateTime(2020, 1, 9, 8, 0, 0),
                                ConceptEnum.NOTHING_DISCLOSURE_NOT_MADE,
                                encounterIdOpdVisit);

                /* record TB screening */
                testDataGenerator.tbForm.setTBScreened(
                                patientId,
                                new LocalDateTime(2020, 1, 6, 10, 0),
                                ConceptEnum.YES,
                                encounterIdOpdVisit);

                /* record INH DispenseDate */
                testDataGenerator.drug.orderDrug(patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.INH_100MG,
                                new LocalDateTime(2020, 1, 6, 10, 0),
                                20,
                                DurationUnitEnum.DAY,
                                true);

                /* record ART DSD Models */
                testDataGenerator.program.recordProgramAttributeCodedValue(
                                patientProgramId,
                                "PROGRAM_MANAGEMENT_92_ART_DISPENSATION_MODEL",
                                ArtDispensationModelEnum.CBO_DISPENSATION.toString(),
                                new LocalDate(2020, 1, 2));

                // Execute
                String query = readReportQuery(
                                ReportEnum.GEORGETOWN_PATIENT_INFORMATION_REPORT,
                                "georgetownPatientInformationReport.sql",
                                new LocalDate(2020, 1, 1),
                                new LocalDate(2020, 1, 31));
                List<Map<String, Object>> result = getReportResult(query);

                // Assert
                assertEquals(result.get(0).get("serialNumber"), "1");
                assertEquals(result.get(0).get("artCode"), "ART 123");
                assertEquals(result.get(0).get("facilityName"), "CENTRE");
                assertEquals(result.get(0).get("uniquePatientId"), "BAH203001");
                assertEquals(result.get(0).get("ageAtEnrollment"), 19);
                assertEquals(result.get(0).get("dateOfBirth"), "2000-01-15");
                assertEquals(result.get(0).get("sex"), "f");
                assertEquals(result.get(0).get("hivTestDate"), "2020-01-01");
                assertEquals(result.get(0).get("dateArvInitiation"), "2020-01-03");
                assertEquals(result.get(0).get("address"), "FOUDA,14 BAMBI STR");
                assertEquals(result.get(0).get("contactTelephone"), "081234567");
                assertEquals(result.get(0).get("clinicalWhoStage"), "WHO stage 1");
                assertEquals(result.get(0).get("regimentAtArtInitiation"), "ABC/3TC 120/60mg");
                assertEquals(result.get(0).get("lineAtInitiation"), "1st line");
                assertEquals(result.get(0).get("currentRegimen"), "ABC/3TC 120/60mg");
                assertEquals(result.get(0).get("currentLine"), "2nd line");
                assertEquals(result.get(0).get("eligibilityForVl"), "Yes");
                assertEquals(result.get(0).get("dateOfLastVisit"), "2019-12-30");
                assertEquals(result.get(0).get("lastAppointmentDate"), "2020-01-15");
                assertEquals(result.get(0).get("reasonsForConsultation"), "Initiation of ART");
                assertEquals(result.get(0).get("transfertOut"), "No");
                assertEquals(result.get(0).get("kp"), "True");
                assertEquals(result.get(0).get("kpType"), "Migrant");
                assertEquals(result.get(0).get("profession"), "Private sector employee");
                assertEquals(result.get(0).get("preTrackingOutcome"), "7 to 30 days");
                assertEquals(result.get(0).get("trackingOutcome"), "Calls not picked up");
                assertEquals(result.get(0).get("lastViralLoadResultDate"), "2019-01-09");
                assertEquals(result.get(0).get("lastViralLoadResult"), 900);
                assertEquals(result.get(0).get("reasonOfLastVL"), "Routine");
                assertEquals(result.get(0).get("disclosureStatus"), "Nothing (disclosure not made)");
                assertEquals(result.get(0).get("tbScreening"), "Yes full name");
                assertEquals(result.get(0).get("inhDispenseDate"), "2020-01-06");
                assertEquals(result.get(0).get("inhDuration"), 0);
                assertEquals(result.get(0).get("artDSDModels"), "CBO dispensation");
        }

        @Test
        public void patientNOTEnrolledToHiv_shouldNOTBeReported() throws Exception {
                // Prepare
                /* create a patient */
                int patientId = testDataGenerator.registration.createPatient(
                                "BAH203001",
                                GenderEnum.FEMALE,
                                new LocalDate(2000, 1, 15),
                                "Marie",
                                "Tambwe",
                                "081234567",
                                "ART 123");

                /* record profession */
                testDataGenerator.registration.addPersonAttributeCodedValue(
                                patientId,
                                PersonAttributeTypeEnum.OCCUPATION.toString(),
                                ConceptEnum.PRIVATE_SECTOR_EMPLOYEE);

                /* record the patient address */
                testDataGenerator.registration.recordPersonAddress(
                                patientId,
                                "14 BAMBI STR", // address1
                                "NKUM", // address2
                                "YAOUNDE 1", // address3
                                "NKUM", // address4
                                "FOUDA", // city_village
                                "CENTRE", // state_province
                                "MFOUNDI", // country_district
                                "CAMEROON"); // country

                /* start an OPD visit */
                int encounterIdOpdVisit = testDataGenerator.startVisit(
                                patientId,
                                new LocalDate(2019, 12, 30),
                                VisitTypeEnum.VISIT_TYPE_OPD);

                /* record the HIV test date and result */
                int encounterIdHtc = testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
                                patientId,
                                new LocalDateTime(2020, 1, 1, 8, 0),
                                new LocalDate(2020, 1, 1),
                                null);
                testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
                                patientId,
                                new LocalDateTime(2020, 1, 1, 8, 0),
                                ConceptEnum.POSITIVE,
                                encounterIdHtc);

                /* dispense ARV */
                testDataGenerator.drug.orderDrug(
                                patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.ABC_3TC_120_60MG,
                                new LocalDateTime(2020, 1, 5, 8, 0, 0),
                                1,
                                DurationUnitEnum.MONTH,
                                true);

                testDataGenerator.drug.orderDrug(
                                patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.INH_100MG,
                                new LocalDateTime(2020, 2, 5, 8, 0, 0),
                                1,
                                DurationUnitEnum.MONTH,
                                true);

                /*
                 * enroll into the defaulter program, including pre-tracking and tracking
                 * outcomes
                 */
                testDataGenerator.program.enrollPatientIntoDefaulterProgram(
                                patientId,
                                new LocalDate(2020, 2, 1),
                                ConceptEnum.CALL_1,
                                new LocalDate(2020, 1, 4),
                                new LocalDate(2020, 2, 3),
                                PreTrackingOutcomeEnum._7_TO_30_DAYS,
                                TrackingOutcomeEnum.CALLS_NOT_PICKED_UP);

                /* record the therapeutic line at initiation in the initial hiv form */
                int encounterIdAdultHivForm = testDataGenerator.hivAdultInitialForm
                                .setTherapeuticLineOnInitialHivAdultForm(
                                                patientId,
                                                new LocalDateTime(2020, 1, 7, 8, 0, 0),
                                                ConceptEnum.FIRST_THERAPEUTIC_LINE,
                                                null);

                /* record the sexual orientation */
                testDataGenerator.hivAdultInitialForm.setSexualOrientation(
                                patientId,
                                new LocalDateTime(2020, 1, 8, 8, 0, 0),
                                ConceptEnum.HETEROSEXUAL,
                                encounterIdAdultHivForm);

                /* record an ART Dispensation appointment */
                testDataGenerator.appointment.recordAppointment(
                                patientId,
                                AppointmentServiceEnum.ART_DISPENSARY,
                                new LocalDateTime(2020, 1, 15, 8, 0, 0),
                                new LocalDateTime(2020, 1, 15, 10, 0, 0));

                /* record VL date and result */
                testDataGenerator.manualLabAndResultForm.setRoutineViralLoadTestDateAndResult(
                                patientId,
                                new LocalDateTime(2020, 1, 9, 8, 0, 0),
                                new LocalDate(2020, 1, 9),
                                900,
                                null);

                // Execute
                String query = readReportQuery(
                                ReportEnum.GEORGETOWN_PATIENT_INFORMATION_REPORT,
                                "georgetownPatientInformationReport.sql",
                                new LocalDate(2020, 1, 1),
                                new LocalDate(2020, 1, 31));
                List<Map<String, Object>> result = getReportResult(query);

                // Assert
                assertEquals(result.size(), 0);
        }

        @Test
        public void patientNOTOnTreatmentDuringReportingPeriod_shouldNOTBeReported()
                        throws Exception {
                // Prepare
                /* create a patient */
                int patientId = testDataGenerator.registration.createPatient(
                                "BAH203001",
                                GenderEnum.FEMALE,
                                new LocalDate(2000, 1, 15),
                                "Marie",
                                "Tambwe",
                                "081234567",
                                "ART 123");

                /* record profession */
                testDataGenerator.registration.addPersonAttributeCodedValue(
                                patientId,
                                PersonAttributeTypeEnum.OCCUPATION.toString(),
                                ConceptEnum.PRIVATE_SECTOR_EMPLOYEE);

                /* record the patient address */
                testDataGenerator.registration.recordPersonAddress(
                                patientId,
                                "14 BAMBI STR", // address1
                                "NKUM", // address2
                                "NKUM", // address3
                                "NKUM", // address4
                                "NKUM", // city_village
                                "NORD-OUEST", // state_province
                                "BUI", // country_district
                                "CAMEROON"); // country

                /* start an OPD visit */
                int encounterIdOpdVisit = testDataGenerator.startVisit(
                                patientId,
                                new LocalDate(2019, 12, 30),
                                VisitTypeEnum.VISIT_TYPE_OPD);

                /* record the HIV test date and result */
                int encounterIdHtc = testDataGenerator.hivTestingAndCounsellingForm.setHTCHivTestDate(
                                patientId,
                                new LocalDateTime(2020, 1, 1, 8, 0),
                                new LocalDate(2020, 1, 1),
                                null);
                testDataGenerator.hivTestingAndCounsellingForm.setHTCFinalResult(
                                patientId,
                                new LocalDateTime(2020, 1, 1, 8, 0),
                                ConceptEnum.POSITIVE,
                                encounterIdHtc);

                /* enroll into the HIV program, including reason for consultation */
                int patientProgramId = testDataGenerator.program.enrollPatientIntoHIVProgram(
                                patientId,
                                new LocalDate(2020, 1, 2),
                                ConceptEnum.WHO_STAGE_1,
                                TherapeuticLineEnum.SECOND_LINE,
                                new LocalDate(2020, 1, 3));
                testDataGenerator.program.recordProgramAttributeCodedValue(
                                patientProgramId,
                                "PROGRAM_MANAGEMENT_5_PATIENT_STAGE",
                                ReasonForConsultationEnum.INITIATION_OF_ART.toString(),
                                new LocalDate(2020, 1, 2));

                /* dispense ARV */
                testDataGenerator.drug.orderDrug(
                                patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.ABC_3TC_120_60MG,
                                new LocalDateTime(2020, 1, 5, 8, 0, 0),
                                1,
                                DurationUnitEnum.MONTH,
                                true);

                testDataGenerator.drug.orderDrug(
                                patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.INH_100MG,
                                new LocalDateTime(2020, 2, 5, 8, 0, 0),
                                1,
                                DurationUnitEnum.MONTH,
                                true);

                /*
                 * enroll into the defaulter program, including pre-tracking and tracking
                 * outcomes
                 */
                testDataGenerator.program.enrollPatientIntoDefaulterProgram(
                                patientId,
                                new LocalDate(2020, 2, 1),
                                ConceptEnum.CALL_1,
                                new LocalDate(2020, 1, 4),
                                new LocalDate(2020, 2, 3),
                                PreTrackingOutcomeEnum._7_TO_30_DAYS,
                                TrackingOutcomeEnum.CALLS_NOT_PICKED_UP);

                /* record the therapeutic line at initiation in the initial hiv form */
                int encounterIdAdultHivForm = testDataGenerator.hivAdultInitialForm
                                .setTherapeuticLineOnInitialHivAdultForm(
                                                patientId,
                                                new LocalDateTime(2020, 1, 7, 8, 0, 0),
                                                ConceptEnum.FIRST_THERAPEUTIC_LINE,
                                                null);

                /* record the sexual orientation */
                testDataGenerator.hivAdultInitialForm.setSexualOrientation(
                                patientId,
                                new LocalDateTime(2020, 1, 8, 8, 0, 0),
                                ConceptEnum.HETEROSEXUAL,
                                encounterIdAdultHivForm);

                /* record an ART Dispensation appointment */
                testDataGenerator.appointment.recordAppointment(
                                patientId,
                                AppointmentServiceEnum.ART_DISPENSARY,
                                new LocalDateTime(2020, 1, 15, 8, 0, 0),
                                new LocalDateTime(2020, 1, 15, 10, 0, 0));

                /* record VL date and result */
                testDataGenerator.manualLabAndResultForm.setRoutineViralLoadTestDateAndResult(
                                patientId,
                                new LocalDateTime(2020, 1, 9, 8, 0, 0),
                                new LocalDate(2020, 1, 9),
                                900,
                                null);

                /* record Disclosure Status */
                testDataGenerator.patientWithHivChildFollowUpForm.setDisclosureStatus(
                                patientId,
                                new LocalDateTime(2020, 1, 9, 8, 0, 0),
                                ConceptEnum.NOTHING_DISCLOSURE_NOT_MADE,
                                encounterIdOpdVisit);

                /* record TB screening */
                testDataGenerator.tbForm.setTBScreened(
                                patientId,
                                new LocalDateTime(2020, 1, 6, 10, 0),
                                ConceptEnum.YES,
                                encounterIdOpdVisit);

                /* record INH DispenseDate */
                testDataGenerator.drug.orderDrug(patientId,
                                encounterIdOpdVisit,
                                DrugNameEnum.INH_100MG,
                                new LocalDateTime(2020, 1, 6, 10, 0),
                                20,
                                DurationUnitEnum.DAY,
                                true);

                /* record ART DSD Models */
                testDataGenerator.program.recordProgramAttributeCodedValue(
                                patientProgramId,
                                "PROGRAM_MANAGEMENT_92_ART_DISPENSATION_MODEL",
                                ArtDispensationModelEnum.CBO_DISPENSATION.toString(),
                                new LocalDate(2020, 1, 2));

                // Execute
                String query = readReportQuery(
                                ReportEnum.GEORGETOWN_PATIENT_INFORMATION_REPORT,
                                "georgetownPatientInformationReport.sql",
                                new LocalDate(2020, 7, 1),
                                new LocalDate(2020, 7, 31));
                List<Map<String, Object>> result = getReportResult(query);

                // Assert
                assertEquals(result.size(), 0);
        }
}
