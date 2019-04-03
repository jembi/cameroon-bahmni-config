Bahmni.ConceptSet.FormConditions.rules = {
    'Diastolic Data' : function (formName, formFieldValues) {
        var systolic = formFieldValues['Systolic'];
        var diastolic = formFieldValues['Diastolic'];
        if (systolic || diastolic) {
            return {
                enable: ["Posture"]
            }
        } else {
            return {
                disable: ["Posture"]
            }
        }
    },
    'Systolic Data' : function (formName, formFieldValues) {
        var systolic = formFieldValues['Systolic'];
        var diastolic = formFieldValues['Diastolic'];
        if (systolic || diastolic) {
            return {
                enable: ["Posture"]
            }
        } else {
            return {
                disable: ["Posture"]
            }
        }
    },
	/**
	 * Handling conditions for PATIENT WITH HIV - ADULT INITIAL form
	 */
	'Circumstances of screening': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var autres = formFieldValues['Circumstances of screening'];
		if(autres == "Other") {
			conditions.show.push("If other specify")
		} else {
			conditions.hide.push("If other specify")
		}
		return conditions;
	},
	'Opportunistic disease': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var oui = formFieldValues['Opportunistic disease'];
		if(oui == "Yes") {
			conditions.show.push("If yes specify")
		} else {
			conditions.hide.push("If yes specify")
		}
		return conditions;
	},
	'Tuberculosis': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var oui = formFieldValues['Tuberculosis'];
		if(oui == "Yes") {
			conditions.show.push("If yes, specify start date");
			conditions.show.push("End date of treatment");
		} else {
			conditions.hide.push("If yes, specify start date");
			conditions.hide.push("End date of treatment")
		}
		return conditions;
	},
	'Alcohol consumption': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var oui = formFieldValues['Alcohol consumption'];
		if(oui == "Yes") {
			conditions.show.push("If yes, type of alcohol");
			conditions.show.push("Frequency of alcohol consumption");
		} else {
			conditions.hide.push("If yes, type of alcohol");
			conditions.hide.push("Frequency of alcohol consumption")
		}
		return conditions;
	},
	'ATCD prescription ARV': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var oui = formFieldValues['ATCD prescription ARV'];
		if(oui == "Yes") {
			conditions.show.push("If previous ARV treatment; start date");
			conditions.show.push("End Date");
			conditions.show.push("Health Facility");
			conditions.show.push("Circumstances of previous ARV treatment");
			conditions.show.push("Prescribed ARV drug");
			conditions.show.push("Treatment still in progress");
		} else {
			conditions.hide.push("If previous ARV treatment; start date");
			conditions.hide.push("End Date");
			conditions.hide.push("Health Facility");
			conditions.hide.push("Circumstances of previous ARV treatment");
			conditions.hide.push("Prescribed ARV drug");
			conditions.hide.push("Treatment still in progress");
		}
		return conditions;
	},
	'Medication allergy': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var oui = formFieldValues['Medication allergy'];
		if(oui == "Yes") {
			conditions.show.push("If yes specify allergy");
		} else {
			conditions.hide.push("If yes specify allergy");
		}
		return conditions;
	},
	'III. PATIENT BACKGROUND' : function (formName, formFieldValues, patient) {
		var conditions = {show: [], hide: []};
		if (patient.gender === "M") {
			conditions.hide.push("III.4 Female");
		} 
		return conditions;
	}
};