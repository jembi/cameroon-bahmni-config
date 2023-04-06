package org.jembi.bahmni.report_testing.test_utils.models;

public enum DrugNameEnum {
	ABC_3TC_120_60MG("ABC/3TC 120/60mg"),
	ABC_3TC_60_30MG("ABC/3TC 60/30mg"),
	INH_100MG("INH 100mg"),
	INH_300MG("INH 300mg"),
	TDF_FTC_300_200MG("TDF/FTC 300/200mg"),
	TDF_FTC_300_300MG("TDF/FTC 300/300mg"),
	COTRIMOXAZOLE_400MG("Sulfamethoxazole+Trimethoprine (Cotrimoxazole) (400mg+180mg)/5ml");

	private String value;

	DrugNameEnum(String value) {
		this.value = value;
	}

	public String toString() {
		return value;
	}
}
