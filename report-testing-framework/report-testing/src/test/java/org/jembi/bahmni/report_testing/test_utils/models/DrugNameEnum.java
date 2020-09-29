package org.jembi.bahmni.report_testing.test_utils.models;

public enum DrugNameEnum {
	ABC_3TC_120_60MG("ABC/3TC 120/60mg"),
	INH_100MG("INH 100mg"),
	INH_300MG("INH 300mg"),
	COTRIMOXAZOLE_400MG("Sulfamethoxazole+Trimethoprine (Cotrimoxazole) (400mg+180mg)/5ml");

	private String value;

	DrugNameEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
