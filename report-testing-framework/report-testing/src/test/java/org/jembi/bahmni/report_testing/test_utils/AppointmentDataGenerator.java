package org.jembi.bahmni.report_testing.test_utils;

import java.sql.Statement;
import org.jembi.bahmni.report_testing.test_utils.models.AppointmentServiceEnum;
import org.joda.time.LocalDateTime;

public class AppointmentDataGenerator {
	Statement stmt;

    public AppointmentDataGenerator(Statement stmt) {
        this.stmt = stmt;
    }

    public void recordAppointment(
		int patientId,
		AppointmentServiceEnum service,
		LocalDateTime startDateTime,
		LocalDateTime endDateTime) throws Exception {

		int appointmentServiceId =  TestDataGenerator.getQueryIntResult("SELECT appointment_service_id FROM appointment_service WHERE name ='" + service + "'", stmt);

		String query = "INSERT INTO patient_appointment (appointment_number, patient_id, start_date_time, end_date_time, appointment_service_id, status, appointment_kind, date_created, creator, uuid, voided) VALUES "
		 + "('" + TestDataGenerator.generateUUID() + "'," + patientId + ",'" + startDateTime + "','" + endDateTime + "'," + appointmentServiceId + ",'Scheduled','Scheduled',now(),4,'" + TestDataGenerator.generateUUID() + "',0)";
		
		stmt.executeUpdate(query);
	}

}
