package org.jembi.bahmni.report_testing.test_utils.models;

public enum AppointmentServiceEnum {
    ART_DISPENSARY("APPOINTMENT_SERVICE_ART_DISPENSARY_KEY");

    private String value;

	AppointmentServiceEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
