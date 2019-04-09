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
		var other = formFieldValues['Circumstances of screening'];
		if (other == "Other") {
			conditions.show.push("If other specify")
		} else {
			conditions.hide.push("If other specify")
		}
		return conditions;
	},
	'Opportunistic disease': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var yes = formFieldValues['Opportunistic disease'];
		if (yes == "Yes full name") {
			conditions.show.push("If yes specify")
		} else {
			conditions.hide.push("If yes specify")
		}
		return conditions;
	},
	'Tuberculosis': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var yes = formFieldValues['Tuberculosis'];
		if (yes == "Yes full name") {
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
		var yes = formFieldValues['Alcohol consumption'];
		if (yes == "Yes full name") {
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
		var yes = formFieldValues['ATCD prescription ARV'];
		if (yes == "Yes full name") {
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
		var yes = formFieldValues['Medication allergy'];
		if (yes == "Yes full name") {
			conditions.show.push("If yes specify allergy");
		} else {
			conditions.hide.push("If yes specify allergy");
		}
		return conditions;
	},
	'II. PATIENT BACKGROUND' : function (formName, formFieldValues, patient) {
		var conditions = {show: [], hide: []};
		if (patient.gender === "M") {
			conditions.hide.push("II.4 Female");
		} 
		return conditions;
	},
	'Review (General health)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Review (General health)'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Tiredness");
			conditions.show.push("Fatigue (General health)");
			conditions.show.push("Fever (General health)");
			conditions.show.push("Night Sweats (General health)");
			conditions.show.push("Weight Loss (General health)");
			conditions.show.push("Weight Gain");
			conditions.show.push("Inadequate Growth In Height");
		} else {
			conditions.hide.push("Tiredness");
			conditions.hide.push("Fatigue (General health)");
			conditions.hide.push("Fever (General health)");
			conditions.hide.push("Night Sweats (General health)");
			conditions.hide.push("Weight Loss (General health)");
			conditions.hide.push("Weight Gain");
			conditions.hide.push("Inadequate Growth In Height");
		}
		return conditions;
	},
	'Review (Ear, Nose, Mouth, Throat)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Review (Ear, Nose, Mouth, Throat)'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Difficulty With Hearing");
			conditions.show.push("Rhinorrhea");
			conditions.show.push("Ringing In The Ears");
			conditions.show.push("Mouths Sores");
			conditions.show.push("Loose Teeth");
			conditions.show.push("Ear Pain (Ear, Nose, Mouth, Throat)");
			conditions.show.push("Nosebleeds");
			conditions.show.push("Sore Throat (Ear, Nose, Mouth, Throat)");
			conditions.show.push("Facial Pain Or Numbness");
		} else {
			conditions.hide.push("Difficulty With Hearing");
			conditions.hide.push("Rhinorrhea");
			conditions.hide.push("Ringing In The Ears");
			conditions.hide.push("Mouths Sores");
			conditions.hide.push("Loose Teeth");
			conditions.hide.push("Ear Pain (Ear, Nose, Mouth, Throat)");
			conditions.hide.push("Nosebleeds");
			conditions.hide.push("Sore Throat (Ear, Nose, Mouth, Throat)");
			conditions.hide.push("Facial Pain Or Numbness");
		}
		return conditions;
	},
	'Cardiovascular': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Cardiovascular'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Palpitation");
			conditions.show.push("Chest Pain (Cardiovascular)");
			conditions.show.push("Swelling Of Feet/Legs");
			conditions.show.push("Pain In Legs With Walking");
			conditions.show.push("Irregular Heart Beats");
			conditions.show.push("Varicose Veins");
		} else {
			conditions.hide.push("Palpitation");
			conditions.hide.push("Chest Pain (Cardiovascular)");
			conditions.hide.push("Swelling Of Feet/Legs");
			conditions.hide.push("Pain In Legs With Walking");
			conditions.hide.push("Irregular Heart Beats");
			conditions.hide.push("Varicose Veins");
		}
		return conditions;
	},
	'Respiratory': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Respiratory'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Shortness Of Breath (Respiratory)");
			conditions.show.push("Night Sweats (Respiratory)");
			conditions.show.push("Cough (Respiratory)");
			conditions.show.push("Wheezing (Respiratory)");
			conditions.show.push("Coughing Up Blood");
		} else {
			conditions.hide.push("Shortness Of Breath (Respiratory)");
			conditions.hide.push("Night Sweats (Respiratory)");
			conditions.hide.push("Cough (Respiratory)");
			conditions.hide.push("Wheezing (Respiratory)");
			conditions.hide.push("Coughing Up Blood");
		}
		return conditions;
	},
	'Gastro Intestinal': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Gastro Intestinal'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Nausea");
			conditions.show.push("Vomitting");
			conditions.show.push("Diarrhea");
			conditions.show.push("Abdominal Pain (Gastrointenstinal)");
			conditions.show.push("Blood In Stool");
			conditions.show.push("Blood In Vomitus");
			conditions.show.push("Constipation (Gastrointenstinal)");
			conditions.show.push("Heartburn (Gastrointenstinal)");
			conditions.show.push("Difficulty Swallowing");
			conditions.show.push("Incontinence (Gastrointenstinal)");
		} else {
			conditions.hide.push("Nausea");
			conditions.hide.push("Vomitting");
			conditions.hide.push("Diarrhea");
			conditions.hide.push("Abdominal Pain (Gastrointenstinal)");
			conditions.hide.push("Blood In Stool");
			conditions.hide.push("Blood In Vomitus");
			conditions.hide.push("Constipation (Gastrointenstinal)");
			conditions.hide.push("Heartburn (Gastrointenstinal)");
			conditions.hide.push("Difficulty Swallowing");
			conditions.hide.push("Incontinence (Gastrointenstinal)");
		}
		return conditions;
	},
	'Genito-Urinary': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Genito-Urinary'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Painful Urination");
			conditions.show.push("Frequent Urination (Genito-Urinary)");
			conditions.show.push("Urgency");
			conditions.show.push("Prostate Problems");
			conditions.show.push("Bladder Problems");
			conditions.show.push("Blood In Urine");
			conditions.show.push("Impotence");
		} else {
			conditions.hide.push("Painful Urination");
			conditions.hide.push("Frequent Urination (Genito-Urinary)");
			conditions.hide.push("Urgency");
			conditions.hide.push("Prostate Problems");
			conditions.hide.push("Bladder Problems");
			conditions.hide.push("Blood In Urine");
			conditions.hide.push("Impotence");
		}
		return conditions;
	},
	'Musculo-Skeletal': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Musculo-Skeletal'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Joint Pain (Musculo-Skeletal)");
			conditions.show.push("Aching Muscles");
			conditions.show.push("Shoulder Pain");
			conditions.show.push("Swelling Of Joints");
			conditions.show.push("Joint Deformities");
			conditions.show.push("Back Pain");
		} else {
			conditions.hide.push("Joint Pain (Musculo-Skeletal)");
			conditions.hide.push("Aching Muscles");
			conditions.hide.push("Shoulder Pain");
			conditions.hide.push("Swelling Of Joints");
			conditions.hide.push("Joint Deformities");
			conditions.hide.push("Back Pain");
		}
		return conditions;
	},
	'Skin, Hair And Breast': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Skin, Hair And Breast'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Itching");
			conditions.show.push("Hair Loss");
			conditions.show.push("Hair Increase");
			conditions.show.push("New Skin Lesion");
			conditions.show.push("Breast Pain");
			conditions.show.push("Breast Mass");
			conditions.show.push("Beast Change");
		} else {
			conditions.hide.push("Itching");
			conditions.hide.push("Hair Loss");
			conditions.hide.push("Hair Increase");
			conditions.hide.push("New Skin Lesion");
			conditions.hide.push("Breast Pain");
			conditions.hide.push("Breast Mass");
			conditions.hide.push("Beast Change");
		}
		return conditions;
	},
	'Neurologic': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Neurologic'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Convulsion (Neurologic)");
			conditions.show.push("Frequent Headaches");
			conditions.show.push("Double Vision");
			conditions.show.push("Weakness (Neurologic)");
			conditions.show.push("Changes In Sensation");
			conditions.show.push("Problems With Walking");
			conditions.show.push("Problem With Balance");
			conditions.show.push("Dizziness (Neurologic)");
			conditions.show.push("Tremor");
			conditions.show.push("Loss Of Consciousness");
			conditions.show.push("Episodes Of Visual Loss");
			conditions.show.push("Uncontrolled Emotion");
		} else {
			conditions.hide.push("Convulsion (Neurologic)");
			conditions.hide.push("Frequent Headaches");
			conditions.hide.push("Double Vision");
			conditions.hide.push("Weakness (Neurologic)");
			conditions.hide.push("Changes In Sensation");
			conditions.hide.push("Problems With Walking");
			conditions.hide.push("Problem With Balance");
			conditions.hide.push("Dizziness (Neurologic)");
			conditions.hide.push("Tremor");
			conditions.hide.push("Loss Of Consciousness");
			conditions.hide.push("Episodes Of Visual Loss");
			conditions.hide.push("Uncontrolled Emotion");
		}
		return conditions;
	},
	'Psychiatric': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Psychiatric'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Insomnia");
			conditions.show.push("Irritability");
			conditions.show.push("Depression (Psychiatric)");
			conditions.show.push("Anxiety (Psychiatric)");
			conditions.show.push("Mood Swings");
			conditions.show.push("Recurrent Bad Thoughts");
			conditions.show.push("Hallucinations");
		} else {
			conditions.hide.push("Insomnia");
			conditions.hide.push("Irritability");
			conditions.hide.push("Depression (Psychiatric)");
			conditions.hide.push("Anxiety (Psychiatric)");
			conditions.hide.push("Mood Swings");
			conditions.hide.push("Recurrent Bad Thoughts");
			conditions.hide.push("Hallucinations");
		}
		return conditions;
	},
	'Endocrinologic': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Endocrinologic'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Intolerance To Heat");
			conditions.show.push("Intolerance To Cold");
			conditions.show.push("Menstrual Irregularities");
			conditions.show.push("Frequent Hunger");
			conditions.show.push("Frequent Thirst");
			conditions.show.push("Frequent Urination (Endocrinologic)");
			conditions.show.push("Changes In Sex Drive");
		} else {
			conditions.hide.push("Intolerance To Heat");
			conditions.hide.push("Intolerance To Cold");
			conditions.hide.push("Menstrual Irregularities");
			conditions.hide.push("Frequent Hunger");
			conditions.hide.push("Frequent Thirst");
			conditions.hide.push("Frequent Urination (Endocrinologic)");
			conditions.hide.push("Changes In Sex Drive");
		}
		return conditions;
	},
	'Hematologic': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Hematologic'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Easy Bleeding");
			conditions.show.push("Easy Bruising");
			conditions.show.push("Anemia");
			conditions.show.push("Abnormal Blood Test");
			conditions.show.push("Leukemia");
			conditions.show.push("Lymphadenopathy");
		} else {
			conditions.hide.push("Easy Bleeding");
			conditions.hide.push("Easy Bruising");
			conditions.hide.push("Anemia");
			conditions.hide.push("Abnormal Blood Test");
			conditions.hide.push("Leukemia");
			conditions.hide.push("Lymphadenopathy");
		}
		return conditions;
	}
};