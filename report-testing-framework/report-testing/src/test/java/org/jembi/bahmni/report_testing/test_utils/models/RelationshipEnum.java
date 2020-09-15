package org.jembi.bahmni.report_testing.test_utils.models;

public enum RelationshipEnum {
    RELATIONSHIP_SIBLING("RELATIONSHIP_SIBLING"),
    RELATIONSHIP_PARTNER("RELATIONSHIP_PARTNER"),
	RELATIONSHIP_BIO_CHILD("RELATIONSHIP_BIO_CHILD"),
	RELATIONSHIP_BIO_FATHER("RELATIONSHIP_BIO_FATHER"),
	RELATIONSHIP_BIO_MOTHER("RELATIONSHIP_BIO_MOTHER");

	private String value;

	RelationshipEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
