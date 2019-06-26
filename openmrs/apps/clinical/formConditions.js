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
	 * Handling conditions for PATIENT WITH HIV - CHILD FOLLOW UP FORM
	 */
	'Normal nutrition': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var value = formFieldValues['Normal nutrition'];
		if (value === "No full name") {
			conditions.show.push("Acute malnutrition (Moderate if P / T between - 2 and - 3 SD, Severe if <- 3 SD)")
			conditions.show.push("Chronic malnutrition (Moderate if T / A between - 2 and - 3 SD, Severe if <- 3 SD)")
		} else {
			conditions.hide.push("Acute malnutrition (Moderate if P / T between - 2 and - 3 SD, Severe if <- 3 SD)")
			conditions.hide.push("Chronic malnutrition (Moderate if T / A between - 2 and - 3 SD, Severe if <- 3 SD)")
		}
		return conditions;
	},
	'Adherence': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var other = formFieldValues['Adherence'];
		if (other !== "Good" && other) {
			conditions.show.push("Probable cause of non-compliance")
		} else {
			conditions.hide.push("Probable cause of non-compliance")
		}
		return conditions;
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
			conditions.show.push("End date");
			conditions.show.push("Health Facility");
			conditions.show.push("Circumstances of previous ARV treatment");
			conditions.show.push("Prescribed ARV drug");
			conditions.show.push("Treatment still in progress");
		} else {
			conditions.hide.push("If previous ARV treatment; start date");
			conditions.hide.push("End date");
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
			conditions.show.push("Tiredness?");
			conditions.show.push("Weakness?");
			conditions.show.push("Fever?");
			conditions.show.push("Night Sweats?");
			conditions.show.push("Weight Loss?");
			conditions.show.push("Weight Gain?");
			conditions.show.push("Inadequate Growth In Height?");
		} else {
			conditions.hide.push("Tiredness?");
			conditions.hide.push("Weakness?");
			conditions.hide.push("Fever?");
			conditions.hide.push("Night Sweats?");
			conditions.hide.push("Weight Loss?");
			conditions.hide.push("Weight Gain?");
			conditions.hide.push("Inadequate Growth In Height?");
		}
		return conditions;
	},
	'Review (Ear, Nose, Mouth, Throat)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Review (Ear, Nose, Mouth, Throat)'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Difficulty With Hearing?");
			conditions.show.push("Rhinorrhea?");
			conditions.show.push("Ringing In The Ears?");
			conditions.show.push("Mouths Sores?");
			conditions.show.push("Loose Teeth?");
			conditions.show.push("Ear Pain?");
			conditions.show.push("Nosebleeds?");
			conditions.show.push("Sore Throat?");
			conditions.show.push("Facial Pain Or Numbness?");
		} else {
			conditions.hide.push("Difficulty With Hearing?");
			conditions.hide.push("Rhinorrhea?");
			conditions.hide.push("Ringing In The Ears?");
			conditions.hide.push("Mouths Sores?");
			conditions.hide.push("Loose Teeth?");
			conditions.hide.push("Ear Pain?");
			conditions.hide.push("Nosebleeds?");
			conditions.hide.push("Sore Throat?");
			conditions.hide.push("Facial Pain Or Numbness?");
		}
		return conditions;
	},
	'Review (Cardiovascular)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Review (Cardiovascular)'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Palpitation?");
			conditions.show.push("Chest Pain?");
			conditions.show.push("Swelling Of Feet/Legs?");
			conditions.show.push("Pain In Legs With Walking?");
			conditions.show.push("Irregular Heart Beats?");
			conditions.show.push("Varicose Veins?");
		} else {
			conditions.hide.push("Palpitation?");
			conditions.hide.push("Chest Pain?");
			conditions.hide.push("Swelling Of Feet/Legs?");
			conditions.hide.push("Pain In Legs With Walking?");
			conditions.hide.push("Irregular Heart Beats?");
			conditions.hide.push("Varicose Veins?");
		}
		return conditions;
	},
	'Review (Respiratory)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Review (Respiratory)'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Shortness Of Breath?");
			conditions.show.push("Night Sweats?");
			conditions.show.push("Cough?");
			conditions.show.push("Wheezing?");
			conditions.show.push("Coughing Up Blood?");
		} else {
			conditions.hide.push("Shortness Of Breath?");
			conditions.hide.push("Night Sweats?");
			conditions.hide.push("Cough?");
			conditions.hide.push("Wheezing?");
			conditions.hide.push("Coughing Up Blood?");
		}
		return conditions;
	},
	'Review (Gastro Intestinal)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Review (Gastro Intestinal)'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Nausea?");
			conditions.show.push("Vomiting?");
			conditions.show.push("Diarrhea?");
			conditions.show.push("Abdominal Pain?");
			conditions.show.push("Blood In Stool?");
			conditions.show.push("Blood In Vomitus?");
			conditions.show.push("Constipation?");
			conditions.show.push("Heartburn?");
			conditions.show.push("Difficulty Swallowing?");
			conditions.show.push("Incontinence?");
		} else {
			conditions.hide.push("Nausea?");
			conditions.hide.push("Vomiting?");
			conditions.hide.push("Diarrhea?");
			conditions.hide.push("Abdominal Pain?");
			conditions.hide.push("Blood In Stool?");
			conditions.hide.push("Blood In Vomitus?");
			conditions.hide.push("Constipation?");
			conditions.hide.push("Heartburn?");
			conditions.hide.push("Difficulty Swallowing?");
			conditions.hide.push("Incontinence?");
		}
		return conditions;
	},
	'Review (Genito-Urinary)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Review (Genito-Urinary)'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Painful Urination?");
			conditions.show.push("Frequent Urination?");
			conditions.show.push("Urgency?");
			conditions.show.push("Prostate Problems?");
			conditions.show.push("Bladder Problems?");
			conditions.show.push("Blood In Urine?");
			conditions.show.push("Impotence?");
		} else {
			conditions.hide.push("Painful Urination?");
			conditions.hide.push("Frequent Urination?");
			conditions.hide.push("Urgency?");
			conditions.hide.push("Prostate Problems?");
			conditions.hide.push("Bladder Problems?");
			conditions.hide.push("Blood In Urine?");
			conditions.hide.push("Impotence?");
		}
		return conditions;
	},
	'Review (Musculo-Skeletal)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Review (Musculo-Skeletal)'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Joint Pain?");
			conditions.show.push("Aching Muscles?");
			conditions.show.push("Shoulder Pain?");
			conditions.show.push("Swelling Of Joints?");
			conditions.show.push("Joint Deformities?");
			conditions.show.push("Back Pain?");
		} else {
			conditions.hide.push("Joint Pain?");
			conditions.hide.push("Aching Muscles?");
			conditions.hide.push("Shoulder Pain?");
			conditions.hide.push("Swelling Of Joints?");
			conditions.hide.push("Joint Deformities?");
			conditions.hide.push("Back Pain?");
		}
		return conditions;
	},
	'Review (Skin, Hair And Breast)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Review (Skin, Hair And Breast)'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Rash?");
			conditions.show.push("Itching?");
			conditions.show.push("Hair Loss?");
			conditions.show.push("Hair Increase?");
			conditions.show.push("New Skin Lesion?");
			conditions.show.push("Breast Pain?");
			conditions.show.push("Breast Mass?");
			conditions.show.push("Breast Change?");
		} else {
			conditions.hide.push("Rash?");
			conditions.hide.push("Itching?");
			conditions.hide.push("Hair Loss?");
			conditions.hide.push("Hair Increase?");
			conditions.hide.push("New Skin Lesion?");
			conditions.hide.push("Breast Pain?");
			conditions.hide.push("Breast Mass?");
			conditions.hide.push("Breast Change?");
		}
		return conditions;
	},
	'Review (Neurologic)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Review (Neurologic)'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Convulsion?");
			conditions.show.push("Frequent Headaches?");
			conditions.show.push("Double Vision?");
			conditions.show.push("Weakness?");
			conditions.show.push("Changes In Sensation?");
			conditions.show.push("Problems With Walking?");
			conditions.show.push("Problem With Balance?");
			conditions.show.push("Dizziness?");
			conditions.show.push("Tremor?");
			conditions.show.push("Loss Of Consciousness?");
			conditions.show.push("Episodes Of Visual Loss?");
			conditions.show.push("Uncontrolled Emotion?");
		} else {
			conditions.hide.push("Convulsion?");
			conditions.hide.push("Frequent Headaches?");
			conditions.hide.push("Double Vision?");
			conditions.hide.push("Weakness?");
			conditions.hide.push("Changes In Sensation?");
			conditions.hide.push("Problems With Walking?");
			conditions.hide.push("Problem With Balance?");
			conditions.hide.push("Dizziness?");
			conditions.hide.push("Tremor?");
			conditions.hide.push("Loss Of Consciousness?");
			conditions.hide.push("Episodes Of Visual Loss?");
			conditions.hide.push("Uncontrolled Emotion?");
		}
		return conditions;
	},
	'Review (Psychiatric)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Review (Psychiatric)'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Insomnia?");
			conditions.show.push("Irritability?");
			conditions.show.push("Depression?");
			conditions.show.push("Anxiety?");
			conditions.show.push("Mood Swings?");
			conditions.show.push("Recurrent Bad Thoughts?");
			conditions.show.push("Hallucinations?");
		} else {
			conditions.hide.push("Insomnia?");
			conditions.hide.push("Irritability?");
			conditions.hide.push("Depression?");
			conditions.hide.push("Anxiety?");
			conditions.hide.push("Mood Swings?");
			conditions.hide.push("Recurrent Bad Thoughts?");
			conditions.hide.push("Hallucinations?");
		}
		return conditions;
	},
	'Review (Endocrinologic)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Review (Endocrinologic)'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Intolerance To Heat?");
			conditions.show.push("Intolerance To Cold?");
			conditions.show.push("Menstrual Irregularities?");
			conditions.show.push("Frequent Hunger?");
			conditions.show.push("Frequent Thirst?");
			conditions.show.push("Frequent Urination?");
			conditions.show.push("Changes In Sex Drive?");
		} else {
			conditions.hide.push("Intolerance To Heat?");
			conditions.hide.push("Intolerance To Cold?");
			conditions.hide.push("Menstrual Irregularities?");
			conditions.hide.push("Frequent Hunger?");
			conditions.hide.push("Frequent Thirst?");
			conditions.hide.push("Frequent Urination?");
			conditions.hide.push("Changes In Sex Drive?");
		}
		return conditions;
	},
	'Review (Hematologic)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var abnormal = formFieldValues['Review (Hematologic)'];
		if (abnormal === "Abnormal") {
			conditions.show.push("Easy Bleeding?");
			conditions.show.push("Easy Bruising?");
			conditions.show.push("Anemia?");
			conditions.show.push("Abnormal Blood Test?");
			conditions.show.push("Leukemia?");
			conditions.show.push("Lymphadenopathy?");
		} else {
			conditions.hide.push("Easy Bleeding?");
			conditions.hide.push("Easy Bruising?");
			conditions.hide.push("Anemia?");
			conditions.hide.push("Abnormal Blood Test?");
			conditions.hide.push("Leukemia?");
			conditions.hide.push("Lymphadenopathy?");
		}
		return conditions;
	},
	/**
	 * Handling conditions for LAB RESULTS - ADD MANUALLY form
	 */
	'Vaginal Cervical smear Clue cells': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var value = formFieldValues['Vaginal Cervical smear Clue cells'];
		if (value && value !== "") {
			conditions.show.push("Vaginal Cervical smear Clue cells Test Date");
		} else {
			conditions.hide.push("Vaginal Cervical smear Clue cells Test Date");
		}
		return conditions;
	},
	'Vaginal Cervical smear Yeast cells per field': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};
		var value = formFieldValues['Vaginal Cervical smear Yeast cells per field'];
		if (value && value !== "") {	
			conditions.show.push("Vaginal Cervical smear Yeast cells per field Test Date");
		} else {	
			conditions.hide.push("Vaginal Cervical smear Yeast cells per field Test Date");
		}	
		return conditions;	
	},
	'Vaginal Cervical smear Epithelial cells per field': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};		
		var value = formFieldValues['Vaginal Cervical smear Epithelial cells per field'];
		if (value && value !== "") {		
			conditions.show.push("Vaginal Cervical smear Epithelial cells per field Test Date");
		} else {		
			conditions.hide.push("Vaginal Cervical smear Epithelial cells per field Test Date");
		}		
		return conditions;		
	},					
	'Vaginal Cervical smear Leucocytes per field': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};		
		var value = formFieldValues['Vaginal Cervical smear Leucocytes per field'];
		if (value && value !== "") {		
			conditions.show.push("Vaginal Cervical smear Leucocytes per field Test Date");
		} else {		
			conditions.hide.push("Vaginal Cervical smear Leucocytes per field Test Date");
		}		
		return conditions;		
	},					
	'Vaginal Cervical smear Trichomonas vaginalis 1 ou 0': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};		
		var value = formFieldValues['Vaginal Cervical smear Trichomonas vaginalis 1 ou 0'];
		if (value && value !== "") {		
			conditions.show.push("Vaginal Cervical smear Trichomonas vaginalis 1 ou 0 Test Date");
		} else {		
			conditions.hide.push("Vaginal Cervical smear Trichomonas vaginalis 1 ou 0 Test Date");
		}		
		return conditions;		
	},					
	'Vaginal Cervical smear Doderlein flora': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};		
		var value = formFieldValues['Vaginal Cervical smear Doderlein flora'];
		if (value && value !== "") {		
			conditions.show.push("Vaginal Cervical smear Doderlein flora Test Date");
		} else {		
			conditions.hide.push("Vaginal Cervical smear Doderlein flora Test Date");
		}		
		return conditions;		
	},					
	'Vaginal Cervical smear Gram + Bacilli': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};		
		var value = formFieldValues['Vaginal Cervical smear Gram + Bacilli'];
		if (value && value !== "") {		
			conditions.show.push("Vaginal Cervical smear Gram + Bacilli Test Date");
		} else {		
			conditions.hide.push("Vaginal Cervical smear Gram + Bacilli Test Date");
		}		
		return conditions;		
	},
	'Vaginal Cervical smear Gram - Cocci': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};		
		var value = formFieldValues['Vaginal Cervical smear Gram - Cocci'];
		if (value && value !== "") {		
			conditions.show.push("Vaginal Cervical smear Gram - Cocci Test Date");
		} else {		
			conditions.hide.push("Vaginal Cervical smear Gram - Cocci Test Date");
		}		
		return conditions;		
	},		
	'Vaginal Cervical smear Gardenerella vaginalis': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};		
		var value = formFieldValues['Vaginal Cervical smear Gardenerella vaginalis'];
		if (value && value !== "") {		
			conditions.show.push("Vaginal Cervical smear Gardenerella vaginalis Test Date");
		} else {		
			conditions.hide.push("Vaginal Cervical smear Gardenerella vaginalis Test Date");
		}		
		return conditions;		
	},					
	'Vaginal Cervical smear Gram - Bacilli': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};		
		var value = formFieldValues['Vaginal Cervical smear Gram - Bacilli'];
		if (value && value !== "") {		
			conditions.show.push("Vaginal Cervical smear Gram - Bacilli Test Date");
		} else {		
			conditions.hide.push("Vaginal Cervical smear Gram - Bacilli Test Date");
		}		
		return conditions;		
	},					
	'Vaginal Cervical smear Gram + Cocci': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};		
		var value = formFieldValues['Vaginal Cervical smear Gram + Cocci'];
		if (value && value !== "") {		
			conditions.show.push("Vaginal Cervical smear Gram + Cocci Test Date");
		} else {		
			conditions.hide.push("Vaginal Cervical smear Gram + Cocci Test Date");
		}		
		return conditions;		
	},				
	'Vaginal Cervical smear Type of vaginal flora': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};		
		var value = formFieldValues['Vaginal Cervical smear Type of vaginal flora'];
		if (value && value !== "") {		
			conditions.show.push("Vaginal Cervical smear Type of vaginal flora Test Date");
		} else {		
			conditions.hide.push("Vaginal Cervical smear Type of vaginal flora Test Date");
		}		
		return conditions;		
	},					
	'Vaginal Cervical smear Identified germ': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};		
		var value = formFieldValues['Vaginal Cervical smear Identified germ'];
		if (value && value !== "") {		
			conditions.show.push("Vaginal Cervical smear Identified germ Test Date");
		} else {		
			conditions.hide.push("Vaginal Cervical smear Identified germ Test Date");
		}		
		return conditions;		
	},					
	'Vaginal Cervical smear Antibiogram S.I.R': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};		
		var value = formFieldValues['Vaginal Cervical smear Antibiogram S.I.R'];
		if (value && value !== "") {		
			conditions.show.push("Vaginal Cervical smear Antibiogram S.I.R Test Date");
		} else {		
			conditions.hide.push("Vaginal Cervical smear Antibiogram S.I.R Test Date");
		}		
		return conditions;		
	},
	'Vaginal Cervical smear Macroscopic appearance': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};		
		var value = formFieldValues['Vaginal Cervical smear Macroscopic appearance'];
		if (value && value !== "") {		
			conditions.show.push("Vaginal Cervical smear Macroscopic appearance Test Date");
		} else {		
			conditions.hide.push("Vaginal Cervical smear Macroscopic appearance Test Date");
		}		
		return conditions;		
	},
	'Urethral smear Epithelial cells': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Epithelial cells'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Epithelial cells Test Date");
		} else {	
			conditions.hide.push("Urethral smear Epithelial cells Test Date");
		}	
		return conditions;
	},
	'Urethral smear Trichomonas vaginalis': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Trichomonas vaginalis'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Trichomonas vaginalis Test Date");
		} else {	
			conditions.hide.push("Urethral smear Trichomonas vaginalis Test Date");
		}	
		return conditions;	
	},	
	'Urethral smear Leucocytes (WBC)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Leucocytes (WBC)'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Leucocytes (WBC) Test Date");
		} else {	
			conditions.hide.push("Urethral smear Leucocytes (WBC) Test Date");
		}	
		return conditions;	
	},	
	'Urethral smear Yeast': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Yeast'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Yeast Test Date");
		} else {	
			conditions.hide.push("Urethral smear Yeast Test Date");
		}	
		return conditions;	
	},	
	'Urethral smear Diplocoque de Neisseria': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Diplocoque de Neisseria'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Diplocoque de Neisseria Test Date");
		} else {	
			conditions.hide.push("Urethral smear Diplocoque de Neisseria Test Date");
		}	
		return conditions;	
	},	
	'Urethral smear Gram + Bacilli': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Gram + Bacilli'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Gram + Bacilli Test Date");
		} else {	
			conditions.hide.push("Urethral smear Gram + Bacilli Test Date");
		}	
		return conditions;	
	},	
	'Urethral smear Gram - Bacilli': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Gram - Bacilli'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Gram - Bacilli Test Date");
		} else {	
			conditions.hide.push("Urethral smear Gram - Bacilli Test Date");
		}	
		return conditions;	
	},	
	'Urethral smear Gram + Cocci': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Gram + Cocci'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Gram + Cocci Test Date");
		} else {	
			conditions.hide.push("Urethral smear Gram + Cocci Test Date");
		}	
		return conditions;	
	},	
	'Urethral smear Gram - Cocci': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Gram - Cocci'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Gram - Cocci Test Date");
		} else {	
			conditions.hide.push("Urethral smear Gram - Cocci Test Date");
		}	
		return conditions;	
	},	
	'Urethral smear Identified germ': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Identified germ'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Identified germ Test Date");
		} else {	
			conditions.hide.push("Urethral smear Identified germ Test Date");
		}	
		return conditions;	
	},	
	'Urethral smear Antibiogram S.I.R': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Antibiogram S.I.R'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Antibiogram S.I.R Test Date");
		} else {	
			conditions.hide.push("Urethral smear Antibiogram S.I.R Test Date");
		}	
		return conditions;	
	},
	'Urethral smear Aspect macroscopique': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Aspect macroscopique'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Aspect macroscopique Test Date");
		} else {	
			conditions.hide.push("Urethral smear Aspect macroscopique Test Date");
		}	
		return conditions;	
	},
	'Urethral smear Hematies': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Hematies'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Hematies Test Date");
		} else {	
			conditions.hide.push("Urethral smear Hematies Test Date");
		}	
		return conditions;	
	},
	'Urethral smear Cylindre': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Cylindre'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Cylindre Test Date");
		} else {	
			conditions.hide.push("Urethral smear Cylindre Test Date");
		}	
		return conditions;	
	},
	'Urethral smear Cristaux': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Cristaux'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Cristaux Test Date");
		} else {	
			conditions.hide.push("Urethral smear Cristaux Test Date");
		}	
		return conditions;	
	},
	'Urethral smear Elements levuriformes': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Elements levuriformes'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Elements levuriformes Test Date");
		} else {	
			conditions.hide.push("Urethral smear Elements levuriformes Test Date");
		}	
		return conditions;	
	},
	'Urethral smear Bacteries': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Bacteries'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Bacteries Test Date");
		} else {	
			conditions.hide.push("Urethral smear Bacteries Test Date");
		}	
		return conditions;	
	},
	'Urethral smear Oeufs de parasites': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Oeufs de parasites'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Oeufs de parasites Test Date");
		} else {	
			conditions.hide.push("Urethral smear Oeufs de parasites Test Date");
		}	
		return conditions;	
	},
	'Urethral smear Celleles vesicales': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urethral smear Celleles vesicales'];
		if (value && value !== "") {	
			conditions.show.push("Urethral smear Celleles vesicales Test Date");
		} else {	
			conditions.hide.push("Urethral smear Celleles vesicales Test Date");
		}	
		return conditions;	
	},
	'Cyto Bacterial exam of urine Epithelial cells': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Cyto Bacterial exam of urine Epithelial cells'];
		if (value && value !== "") {	
			conditions.show.push("Cyto Bacterial exam of urine Epithelial cells Test Date");
		} else {	
			conditions.hide.push("Cyto Bacterial exam of urine Epithelial cells Test Date");
		}	
		return conditions;	
	},		
	'Cyto Bacterial exam of urine Bacteria (ml)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Cyto Bacterial exam of urine Bacteria (ml)'];
		if (value && value !== "") {	
			conditions.show.push("Cyto Bacterial exam of urine Bacteria (ml) Test Date");
		} else {	
			conditions.hide.push("Cyto Bacterial exam of urine Bacteria (ml) Test Date");
		}	
		return conditions;	
	},		
	'Cyto Bacterial exam of urine Number of white blood cells': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Cyto Bacterial exam of urine Number of white blood cells'];
		if (value && value !== "") {	
			conditions.show.push("Cyto Bacterial exam of urine Number of white blood cells Test Date");
		} else {	
			conditions.hide.push("Cyto Bacterial exam of urine Number of white blood cells Test Date");
		}	
		return conditions;	
	},		
	'Cyto Bacterial exam of urine Number of red blood cells': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Cyto Bacterial exam of urine Number of red blood cells'];
		if (value && value !== "") {	
			conditions.show.push("Cyto Bacterial exam of urine Number of red blood cells Test Date");
		} else {	
			conditions.hide.push("Cyto Bacterial exam of urine Number of red blood cells Test Date");
		}	
		return conditions;	
	},		
	'Cyto Bacterial exam of urine Crystals': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Cyto Bacterial exam of urine Crystals'];
		if (value && value !== "") {	
			conditions.show.push("Cyto Bacterial exam of urine Crystals Test Date");
		} else {	
			conditions.hide.push("Cyto Bacterial exam of urine Crystals Test Date");
		}	
		return conditions;	
	},		
	'Cyto Bacterial exam of urine Flagellés': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Cyto Bacterial exam of urine Flagellés'];
		if (value && value !== "") {	
			conditions.show.push("Cyto Bacterial exam of urine Flagellés Test Date");
		} else {	
			conditions.hide.push("Cyto Bacterial exam of urine Flagellés Test Date");
		}	
		return conditions;	
	},		
	'Cyto Bacterial exam of urine Yeast': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Cyto Bacterial exam of urine Yeast'];
		if (value && value !== "") {	
			conditions.show.push("Cyto Bacterial exam of urine Yeast Test Date");
		} else {	
			conditions.hide.push("Cyto Bacterial exam of urine Yeast Test Date");
		}	
		return conditions;	
	},		
	'Cyto Bacterial exam of urine Urinary germs count': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Cyto Bacterial exam of urine Urinary germs count'];
		if (value && value !== "") {	
			conditions.show.push("Cyto Bacterial exam of urine Urinary germs count Test Date");
		} else {	
			conditions.hide.push("Cyto Bacterial exam of urine Urinary germs count Test Date");
		}	
		return conditions;	
	},		
	'Cyto Bacterial exam of urine Isolated germs': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Cyto Bacterial exam of urine Isolated germs'];
		if (value && value !== "") {	
			conditions.show.push("Cyto Bacterial exam of urine Isolated germs Test Date");
		} else {	
			conditions.hide.push("Cyto Bacterial exam of urine Isolated germs Test Date");
		}	
		return conditions;	
	},		
	'Cyto Bacterial exam of urine Antibiogram S.I.R': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Cyto Bacterial exam of urine Antibiogram S.I.R'];
		if (value && value !== "") {	
			conditions.show.push("Cyto Bacterial exam of urine Antibiogram S.I.R Test Date");
		} else {	
			conditions.hide.push("Cyto Bacterial exam of urine Antibiogram S.I.R Test Date");
		}	
		return conditions;	
	},
	'Urine Sediments Epithelial cells': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urine Sediments Epithelial cells'];
		if (value && value !== "") {	
			conditions.show.push("Urine Sediments Epithelial cells Test Date");
		} else {	
			conditions.hide.push("Urine Sediments Epithelial cells Test Date");
		}	
		return conditions;	
	},	
	'Urine Sediments Number of leucocytes seen per field': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urine Sediments Number of leucocytes seen per field'];
		if (value && value !== "") {	
			conditions.show.push("Urine Sediments Number of leucocytes seen per field Test Date");
		} else {	
			conditions.hide.push("Urine Sediments Number of leucocytes seen per field Test Date");
		}	
		return conditions;	
	},	
	'Urine Sediments Number of erythrocytes seen per field': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urine Sediments Number of erythrocytes seen per field'];
		if (value && value !== "") {	
			conditions.show.push("Urine Sediments Number of erythrocytes seen per field Test Date");
		} else {	
			conditions.hide.push("Urine Sediments Number of erythrocytes seen per field Test Date");
		}	
		return conditions;	
	},	
	'Urine Sediments Cristals': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urine Sediments Cristals'];
		if (value && value !== "") {	
			conditions.show.push("Urine Sediments Cristals Test Date");
		} else {	
			conditions.hide.push("Urine Sediments Cristals Test Date");
		}	
		return conditions;	
	},	
	'Urine Sediments Flagellates': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urine Sediments Flagellates'];
		if (value && value !== "") {	
			conditions.show.push("Urine Sediments Flagellates Test Date");
		} else {	
			conditions.hide.push("Urine Sediments Flagellates Test Date");
		}	
		return conditions;	
	},	
	'Urine Sediments Yeast cells': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urine Sediments Yeast cells'];
		if (value && value !== "") {	
			conditions.show.push("Urine Sediments Yeast cells Test Date");
		} else {	
			conditions.hide.push("Urine Sediments Yeast cells Test Date");
		}	
		return conditions;	
	},	
	'Urine Sediments Bacteria': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urine Sediments Bacteria'];
		if (value && value !== "") {	
			conditions.show.push("Urine Sediments Bacteria Test Date");
		} else {	
			conditions.hide.push("Urine Sediments Bacteria Test Date");
		}	
		return conditions;	
	},
	'CSF Aspect': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['CSF Aspect'];
		if (value && value !== "") {	
			conditions.show.push("CSF Aspect Test Date");
		} else {	
			conditions.hide.push("CSF Aspect Test Date");
		}	
		return conditions;	
	},	
	'CSF Number of epithelial cells per ml': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['CSF Number of epithelial cells per ml'];
		if (value && value !== "") {	
			conditions.show.push("CSF Number of epithelial cells per ml Test Date");
		} else {	
			conditions.hide.push("CSF Number of epithelial cells per ml Test Date");
		}	
		return conditions;	
	},	
	'CSF Number of leucocytes per ml': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['CSF Number of leucocytes per ml'];
		if (value && value !== "") {	
			conditions.show.push("CSF Number of leucocytes per ml Test Date");
		} else {	
			conditions.hide.push("CSF Number of leucocytes per ml Test Date");
		}	
		return conditions;	
	},	
	'CSF Number of erythrocytes per ml': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['CSF Number of erythrocytes per ml'];
		if (value && value !== "") {	
			conditions.show.push("CSF Number of erythrocytes per ml Test Date");
		} else {	
			conditions.hide.push("CSF Number of erythrocytes per ml Test Date");
		}	
		return conditions;	
	},	
	'CSF Cryptococcus': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['CSF Cryptococcus'];
		if (value && value !== "") {	
			conditions.show.push("CSF Cryptococcus Test Date");
		} else {	
			conditions.hide.push("CSF Cryptococcus Test Date");
		}	
		return conditions;	
	},	
	'CSF Identified germ': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['CSF Identified germ'];
		if (value && value !== "") {	
			conditions.show.push("CSF Identified germ Test Date");
		} else {	
			conditions.hide.push("CSF Identified germ Test Date");
		}	
		return conditions;	
	},	
	'CSF Antibiogram': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['CSF Antibiogram'];
		if (value && value !== "") {	
			conditions.show.push("CSF Antibiogram Test Date");
		} else {	
			conditions.hide.push("CSF Antibiogram Test Date");
		}	
		return conditions;	
	},
	'Puncture liquid Aspect': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Puncture liquid Aspect'];
		if (value && value !== "") {	
			conditions.show.push("Puncture liquid Aspect Test Date");
		} else {	
			conditions.hide.push("Puncture liquid Aspect Test Date");
		}	
		return conditions;	
	},	
	'Puncture liquid Cytology': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Puncture liquid Cytology'];
		if (value && value !== "") {	
			conditions.show.push("Puncture liquid Cytology Test Date");
		} else {	
			conditions.hide.push("Puncture liquid Cytology Test Date");
		}	
		return conditions;	
	},	
	'Puncture liquid Biochemestry': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Puncture liquid Biochemestry'];
		if (value && value !== "") {	
			conditions.show.push("Puncture liquid Biochemestry Test Date");
		} else {	
			conditions.hide.push("Puncture liquid Biochemestry Test Date");
		}	
		return conditions;	
	},	
	'Puncture liquid Yeast cells per field': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Puncture liquid Yeast cells per field'];
		if (value && value !== "") {	
			conditions.show.push("Puncture liquid Yeast cells per field Test Date");
		} else {	
			conditions.hide.push("Puncture liquid Yeast cells per field Test Date");
		}	
		return conditions;	
	},	
	'Puncture liquid Gram + bacilli': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Puncture liquid Gram + bacilli'];
		if (value && value !== "") {	
			conditions.show.push("Puncture liquid Gram + bacilli Test Date");
		} else {	
			conditions.hide.push("Puncture liquid Gram + bacilli Test Date");
		}	
		return conditions;	
	},	
	'Puncture liquid Gram - bacilli': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Puncture liquid Gram - bacilli'];
		if (value && value !== "") {	
			conditions.show.push("Puncture liquid Gram - bacilli Test Date");
		} else {	
			conditions.hide.push("Puncture liquid Gram - bacilli Test Date");
		}	
		return conditions;	
	},	
	'Puncture liquid Gram + cocci': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Puncture liquid Gram + cocci'];
		if (value && value !== "") {	
			conditions.show.push("Puncture liquid Gram + cocci Test Date");
		} else {	
			conditions.hide.push("Puncture liquid Gram + cocci Test Date");
		}	
		return conditions;	
	},	
	'Puncture liquid Gram - cocci': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Puncture liquid Gram - cocci'];
		if (value && value !== "") {	
			conditions.show.push("Puncture liquid Gram - cocci Test Date");
		} else {	
			conditions.hide.push("Puncture liquid Gram - cocci Test Date");
		}	
		return conditions;	
	},	
	'Puncture liquid Identified germ': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Puncture liquid Identified germ'];
		if (value && value !== "") {	
			conditions.show.push("Puncture liquid Identified germ Test Date");
		} else {	
			conditions.hide.push("Puncture liquid Identified germ Test Date");
		}	
		return conditions;	
	},	
	'Puncture liquid Antibiogram': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Puncture liquid Antibiogram'];
		if (value && value !== "") {	
			conditions.show.push("Puncture liquid Antibiogram Test Date");
		} else {	
			conditions.hide.push("Puncture liquid Antibiogram Test Date");
		}	
		return conditions;	
	},	
	'Sputum excudates Aspect': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Sputum excudates Aspect'];
		if (value && value !== "") {	
			conditions.show.push("Sputum excudates Aspect Test Date");
		} else {	
			conditions.hide.push("Sputum excudates Aspect Test Date");
		}	
		return conditions;	
	},	
	'Sputum excudates Epithelial cells per field': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Sputum excudates Epithelial cells per field'];
		if (value && value !== "") {	
			conditions.show.push("Sputum excudates Epithelial cells per field Test Date");
		} else {	
			conditions.hide.push("Sputum excudates Epithelial cells per field Test Date");
		}	
		return conditions;	
	},	
	'Sputum excudates Leucocytes per field': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Sputum excudates Leucocytes per field'];
		if (value && value !== "") {	
			conditions.show.push("Sputum excudates Leucocytes per field Test Date");
		} else {	
			conditions.hide.push("Sputum excudates Leucocytes per field Test Date");
		}	
		return conditions;	
	},	
	'Sputum excudates Yeast cells per field': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Sputum excudates Yeast cells per field'];
		if (value && value !== "") {	
			conditions.show.push("Sputum excudates Yeast cells per field Test Date");
		} else {	
			conditions.hide.push("Sputum excudates Yeast cells per field Test Date");
		}	
		return conditions;	
	},	
	'Sputum excudates Gram + bacilli': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Sputum excudates Gram + bacilli'];
		if (value && value !== "") {	
			conditions.show.push("Sputum excudates Gram + bacilli Test Date");
		} else {	
			conditions.hide.push("Sputum excudates Gram + bacilli Test Date");
		}	
		return conditions;	
	},	
	'Sputum excudates Gram - bacilli': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Sputum excudates Gram - bacilli'];
		if (value && value !== "") {	
			conditions.show.push("Sputum excudates Gram - bacilli Test Date");
		} else {	
			conditions.hide.push("Sputum excudates Gram - bacilli Test Date");
		}	
		return conditions;	
	},	
	'Sputum excudates Gram + cocci': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Sputum excudates Gram + cocci'];
		if (value && value !== "") {	
			conditions.show.push("Sputum excudates Gram + cocci Test Date");
		} else {	
			conditions.hide.push("Sputum excudates Gram + cocci Test Date");
		}	
		return conditions;	
	},	
	'Sputum excudates Gram - cocci': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Sputum excudates Gram - cocci'];
		if (value && value !== "") {	
			conditions.show.push("Sputum excudates Gram - cocci Test Date");
		} else {	
			conditions.hide.push("Sputum excudates Gram - cocci Test Date");
		}	
		return conditions;	
	},	
	'Sputum excudates Identified germ': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Sputum excudates Identified germ'];
		if (value && value !== "") {	
			conditions.show.push("Sputum excudates Identified germ Test Date");
		} else {	
			conditions.hide.push("Sputum excudates Identified germ Test Date");
		}	
		return conditions;	
	},	
	'Sputum excudates Antibiogram': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Sputum excudates Antibiogram'];
		if (value && value !== "") {	
			conditions.show.push("Sputum excudates Antibiogram Test Date");
		} else {	
			conditions.hide.push("Sputum excudates Antibiogram Test Date");
		}	
		return conditions;	
	},
	'Blood Culture Germs': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Blood Culture Germs'];
		if (value && value !== "") {	
			conditions.show.push("Blood Culture Germs Test Date");
		} else {	
			conditions.hide.push("Blood Culture Germs Test Date");
		}	
		return conditions;	
	},	
	'Blood Culture Antibiogram': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Blood Culture Antibiogram'];
		if (value && value !== "") {	
			conditions.show.push("Blood Culture Antibiogram Test Date");
		} else {	
			conditions.hide.push("Blood Culture Antibiogram Test Date");
		}	
		return conditions;	
	},	
	'Stool Culture Gram': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Stool Culture Gram'];
		if (value && value !== "") {	
			conditions.show.push("Stool Culture Gram Test Date");
		} else {	
			conditions.hide.push("Stool Culture Gram Test Date");
		}	
		return conditions;	
	},	
	'Stool Culture Germs': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Stool Culture Germs'];
		if (value && value !== "") {	
			conditions.show.push("Stool Culture Germs Test Date");
		} else {	
			conditions.hide.push("Stool Culture Germs Test Date");
		}	
		return conditions;	
	},	
	'Stool Culture Antibiogram': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Stool Culture Antibiogram'];
		if (value && value !== "") {	
			conditions.show.push("Stool Culture Antibiogram Test Date");
		} else {	
			conditions.hide.push("Stool Culture Antibiogram Test Date");
		}	
		return conditions;	
	},	
	'Total Leucocyte count': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Total Leucocyte count'];
		if (value && value !== "") {	
			conditions.show.push("Total Leucocyte count Test Date");
		} else {	
			conditions.hide.push("Total Leucocyte count Test Date");
		}	
		return conditions;	
	},	
	'RBC': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['RBC'];
		if (value && value !== "") {	
			conditions.show.push("RBC Test Date");
		} else {	
			conditions.hide.push("RBC Test Date");
		}	
		return conditions;	
	},	
	'Platelets': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Platelets'];
		if (value && value !== "") {	
			conditions.show.push("Platelets Test Date");
		} else {	
			conditions.hide.push("Platelets Test Date");
		}	
		return conditions;	
	},	
	'MCV': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['MCV'];
		if (value && value !== "") {	
			conditions.show.push("MCV Test Date");
		} else {	
			conditions.hide.push("MCV Test Date");
		}	
		return conditions;	
	},	
	'MCH': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['MCH'];
		if (value && value !== "") {	
			conditions.show.push("MCH Test Date");
		} else {	
			conditions.hide.push("MCH Test Date");
		}	
		return conditions;	
	},	
	'Neutrolphils': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Neutrolphils'];
		if (value && value !== "") {	
			conditions.show.push("Neutrolphils Test Date");
		} else {	
			conditions.hide.push("Neutrolphils Test Date");
		}	
		return conditions;	
	},	
	'Lymphocytes': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Lymphocytes'];
		if (value && value !== "") {	
			conditions.show.push("Lymphocytes Test Date");
		} else {	
			conditions.hide.push("Lymphocytes Test Date");
		}	
		return conditions;	
	},	
	'Monocytes': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Monocytes'];
		if (value && value !== "") {	
			conditions.show.push("Monocytes Test Date");
		} else {	
			conditions.hide.push("Monocytes Test Date");
		}	
		return conditions;	
	},	
	'Eosinophils': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Eosinophils'];
		if (value && value !== "") {	
			conditions.show.push("Eosinophils Test Date");
		} else {	
			conditions.hide.push("Eosinophils Test Date");
		}	
		return conditions;	
	},	
	'Basophils': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Basophils'];
		if (value && value !== "") {	
			conditions.show.push("Basophils Test Date");
		} else {	
			conditions.hide.push("Basophils Test Date");
		}	
		return conditions;	
	},
	'Haemoglobin': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Haemoglobin'];
		if (value && value !== "") {	
			conditions.show.push("Haemoglobin Test Date");
		} else {	
			conditions.hide.push("Haemoglobin Test Date");
		}	
		return conditions;	
	},
	'Haematocrit': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Haematocrit'];
		if (value && value !== "") {	
			conditions.show.push("Haematocrit Test Date");
		} else {	
			conditions.hide.push("Haematocrit Test Date");
		}	
		return conditions;	
	},
	'Reticulocytes': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Reticulocytes'];
		if (value && value !== "") {	
			conditions.show.push("Reticulocytes Test Date");
		} else {	
			conditions.hide.push("Reticulocytes Test Date");
		}	
		return conditions;	
	},
	'Erythrocyte Sedimentation Rate': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Erythrocyte Sedimentation Rate'];
		if (value && value !== "") {	
			conditions.show.push("Erythrocyte Sedimentation Rate Test Date");
		} else {	
			conditions.hide.push("Erythrocyte Sedimentation Rate Test Date");
		}	
		return conditions;	
	},
	'ABO': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['ABO'];
		if (value && value !== "") {	
			conditions.show.push("ABO Test Date");
		} else {	
			conditions.hide.push("ABO Test Date");
		}	
		return conditions;	
	},
	'Rh +/-': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Rh +/-'];
		if (value && value !== "") {	
			conditions.show.push("Rh +/- Test Date");
		} else {	
			conditions.hide.push("Rh +/- Test Date");
		}	
		return conditions;	
	},	
	'Bleeding time': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Bleeding time'];
		if (value && value !== "") {	
			conditions.show.push("Bleeding time Test Date");
		} else {	
			conditions.hide.push("Bleeding time Test Date");
		}	
		return conditions;	
	},
	'Clotting time': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Clotting time'];
		if (value && value !== "") {	
			conditions.show.push("Clotting time Test Date");
		} else {	
			conditions.hide.push("Clotting time Test Date");
		}	
		return conditions;	
	},
	'INR': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['INR'];
		if (value && value !== "") {	
			conditions.show.push("INR Test Date");
		} else {	
			conditions.hide.push("INR Test Date");
		}	
		return conditions;	
	},
	'Prothrombin time (PT)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Prothrombin time (PT)'];
		if (value && value !== "") {	
			conditions.show.push("Prothrombin time (PT) Test Date");
		} else {	
			conditions.hide.push("Prothrombin time (PT) Test Date");
		}	
		return conditions;	
	},
	'Thrombin Time': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Thrombin Time'];
		if (value && value !== "") {	
			conditions.show.push("Thrombin Time Test Date");
		} else {	
			conditions.hide.push("Thrombin Time Test Date");
		}	
		return conditions;	
	},
	'APTT test': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['APTT test'];
		if (value && value !== "") {	
			conditions.show.push("APTT test Test Date");
		} else {	
			conditions.hide.push("APTT test Test Date");
		}	
		return conditions;	
	},
	'Cephalin-Kaolin time': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Cephalin-Kaolin time'];
		if (value && value !== "") {	
			conditions.show.push("Cephalin-Kaolin time Test Date");
		} else {	
			conditions.hide.push("Cephalin-Kaolin time Test Date");
		}	
		return conditions;	
	},
	'Emmel test (P/N)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Emmel test (P/N)'];
		if (value && value !== "") {	
			conditions.show.push("Emmel test (P/N) Test Date");
		} else {	
			conditions.hide.push("Emmel test (P/N) Test Date");
		}	
		return conditions;	
	},
	'CD4': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['CD4'];
		if (value && value !== "") {	
			conditions.show.push("CD4 Test Date");
		} else {	
			conditions.hide.push("CD4 Test Date");
		}	
		return conditions;	
	},
	'Myelogramm': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Myelogramm'];
		if (value && value !== "") {	
			conditions.show.push("Myelogramm Test Date");
		} else {	
			conditions.hide.push("Myelogramm Test Date");
		}	
		return conditions;	
	},
	'VDRL': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['VDRL'];
		if (value && value === "Positive") {	
			conditions.show.push("VDRL Comment");
		} else {	
			conditions.hide.push("VDRL Comment");
		}	
		return conditions;	
	},
	'TPHA': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['TPHA'];
		if (value && value === "Positive") {	
			conditions.show.push("TPHA Comment");
		} else {	
			conditions.hide.push("TPHA Comment");
		}	
		return conditions;	
	},	
	'TO': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['TO'];
		if (value && value === "Positive") {
			conditions.show.push("TO Test Date");
			conditions.show.push("TO Titre");
		} else {	
			conditions.hide.push("TO Test Date");
			conditions.hide.push("TO Titre");
		}	
		return conditions;	
	},
	'TH': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['TH'];
		if (value && value === "Positive") {
			conditions.show.push("TH Test Date");
			conditions.show.push("TH Titre");
		} else {	
			conditions.hide.push("TH Test Date");
			conditions.hide.push("TH Titre");
		}	
		return conditions;	
	},
	'AO': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['AO'];
		if (value && value === "Positive") {
			conditions.show.push("AO Test Date");
			conditions.show.push("AO Titre");
		} else {	
			conditions.hide.push("AO Test Date");
			conditions.hide.push("AO Titre");
		}	
		return conditions;	
	},
	'AH': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['AH'];
		if (value && value === "Positive") {	
			conditions.show.push("AH Test Date");
			conditions.show.push("AH Titre");
		} else {	
			conditions.hide.push("AH Test Date");
			conditions.hide.push("AH Titre");
		}	
		return conditions;	
	},
	'BO': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['BO'];
		if (value && value === "Positive") {	
			conditions.show.push("BO Test Date");
			conditions.show.push("BO Titre");
		} else {	
			conditions.hide.push("BO Test Date");
			conditions.hide.push("BO Titre");
		}	
		return conditions;	
	},
	'BH': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['BH'];
		if (value && value === "Positive") {	
			conditions.show.push("BH Test Date");
			conditions.show.push("BH Titre");
		} else {	
			conditions.hide.push("BH Test Date");
			conditions.hide.push("BH Titre");
		}	
		return conditions;	
	},
	'CO': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['CO'];
		if (value && value === "Positive") {
			conditions.show.push("CO Test Date");
			conditions.show.push("CO Titre");
		} else {	
			conditions.hide.push("CO Test Date");
			conditions.hide.push("CO Titre");
		}	
		return conditions;	
	},
	'CH': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['CH'];
		if (value && value === "Positive") {
			conditions.show.push("CH Test Date");
			conditions.show.push("CH Titre");
		} else {	
			conditions.hide.push("CH Test Date");
			conditions.hide.push("CH Titre");
		}	
		return conditions;	
	},	
	'Anti Strepto Lysine O / A.S.L.O.': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Anti Strepto Lysine O / A.S.L.O.'];
		if (value && value !== "") {	
			conditions.show.push("Anti Strepto Lysine O / A.S.L.O. Test Date");
		} else {	
			conditions.hide.push("Anti Strepto Lysine O / A.S.L.O. Test Date");
		}	
		return conditions;	
	},
	'Rheumatoid factors': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Rheumatoid factors'];
		if (value && value !== "") {	
			conditions.show.push("Rheumatoid factors Test Date");
		} else {	
			conditions.hide.push("Rheumatoid factors Test Date");
		}	
		return conditions;	
	},
	'1st Test / Determine': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['1st Test / Determine'];
		if (value && value !== "") {	
			conditions.show.push("1st Test / Determine Test Date");
		} else {	
			conditions.hide.push("1st Test / Determine Test Date");
		}	
		return conditions;	
	},
	'2nd Test / Oraquick or KHB': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['2nd Test / Oraquick or KHB'];
		if (value && value !== "") {	
			conditions.show.push("2nd Test / Oraquick or KHB Test Date");
		} else {	
			conditions.hide.push("2nd Test / Oraquick or KHB Test Date");
		}	
		return conditions;	
	},
	'Retest 1': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Retest 1'];
		if (value && value !== "") {	
			conditions.show.push("Retest 1 Test Date");
		} else {	
			conditions.hide.push("Retest 1 Test Date");
		}	
		return conditions;	
	},
	'Retest 2': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Retest 2'];
		if (value && value !== "") {	
			conditions.show.push("Retest 2 Test Date");
		} else {	
			conditions.hide.push("Retest 2 Test Date");
		}	
		return conditions;	
	},	
	'HBs Antigen': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['HBs Antigen'];
		if (value && value !== "") {	
			conditions.show.push("HBs Antigen Test Date");
		} else {	
			conditions.hide.push("HBs Antigen Test Date");
		}	
		return conditions;	
	},
	'HVC antibodies': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['HVC antibodies'];
		if (value && value !== "") {	
			conditions.show.push("HVC antibodies Test Date");
		} else {	
			conditions.hide.push("HVC antibodies Test Date");
		}	
		return conditions;	
	},
	'Chlamydia': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Chlamydia'];
		if (value && value !== "") {	
			conditions.show.push("Chlamydia Test Date");
		} else {	
			conditions.hide.push("Chlamydia Test Date");
		}	
		return conditions;	
	},
	'Toxoplasmosis': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Toxoplasmosis'];
		if (value && value !== "") {	
			conditions.show.push("Toxoplasmosis Test Date");
		} else {	
			conditions.hide.push("Toxoplasmosis Test Date");
		}	
		return conditions;	
	},
	'Rubella': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Rubella'];
		if (value && value !== "") {	
			conditions.show.push("Rubella Test Date");
		} else {	
			conditions.hide.push("Rubella Test Date");
		}	
		return conditions;	
	},
	'Other Haematology tests': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Other Haematology tests'];
		if (value && value !== "") {	
			conditions.show.push("Other Haematology tests Test Date");
		} else {	
			conditions.hide.push("Other Haematology tests Test Date");
		}	
		return conditions;	
	},
	'Viral Load': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Viral Load'];
		if (value && value !== "") {	
			conditions.show.push("Viral Load Test Date");
		} else {	
			conditions.hide.push("Viral Load Test Date");
		}	
		return conditions;	
	},
	'Creatinemia': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Creatinemia'];
		if (value && value !== "") {	
			conditions.show.push("Creatinemia Test Date");
		} else {	
			conditions.hide.push("Creatinemia Test Date");
		}	
		return conditions;	
	},
	'Uric acid': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Uric acid'];
		if (value && value !== "") {	
			conditions.show.push("Uric acid Test Date");
		} else {	
			conditions.hide.push("Uric acid Test Date");
		}	
		return conditions;	
	},
	'Creatinine': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Creatinine'];
		if (value && value !== "") {	
			conditions.show.push("Creatinine Test Date");
		} else {	
			conditions.hide.push("Creatinine Test Date");
		}	
		return conditions;	
	},
	'Phosphate': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Phosphate'];
		if (value && value !== "") {	
			conditions.show.push("Phosphate Test Date");
		} else {	
			conditions.hide.push("Phosphate Test Date");
		}	
		return conditions;	
	},
	'Total cholesterol': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Total cholesterol'];
		if (value && value !== "") {	
			conditions.show.push("Total cholesterol Test Date");
		} else {	
			conditions.hide.push("Total cholesterol Test Date");
		}	
		return conditions;	
	},
	'Triglycerides': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Triglycerides'];
		if (value && value !== "") {	
			conditions.show.push("Triglycerides Test Date");
		} else {	
			conditions.hide.push("Triglycerides Test Date");
		}	
		return conditions;	
	},
	'Total Bilirubin': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Total Bilirubin'];
		if (value && value !== "") {	
			conditions.show.push("Total Bilirubin Test Date");
		} else {	
			conditions.hide.push("Total Bilirubin Test Date");
		}	
		return conditions;	
	},
	'Direct or conjugate Bilirubin': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Direct or conjugate Bilirubin'];
		if (value && value !== "") {	
			conditions.show.push("Direct or conjugate Bilirubin Test Date");
		} else {	
			conditions.hide.push("Direct or conjugate Bilirubin Test Date");
		}	
		return conditions;	
	},
	'Glucose (fasting)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Glucose (fasting)'];
		if (value && value !== "") {	
			conditions.show.push("Glucose (fasting) Test Date");
		} else {	
			conditions.hide.push("Glucose (fasting) Test Date");
		}	
		return conditions;	
	},
	'Urea': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urea'];
		if (value && value !== "") {	
			conditions.show.push("Urea Test Date");
		} else {	
			conditions.hide.push("Urea Test Date");
		}	
		return conditions;	
	},
	'S. AST': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['S. AST'];
		if (value && value !== "") {	
			conditions.show.push("S. AST Test Date");
		} else {	
			conditions.hide.push("S. AST Test Date");
		}	
		return conditions;	
	},
	'S. ALT': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['S. ALT'];
		if (value && value !== "") {	
			conditions.show.push("S. ALT Test Date");
		} else {	
			conditions.hide.push("S. ALT Test Date");
		}	
		return conditions;	
	},	
	'ALP': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['ALP'];
		if (value && value !== "") {	
			conditions.show.push("ALP Test Date");
		} else {	
			conditions.hide.push("ALP Test Date");
		}	
		return conditions;	
	},	
	'Amylase': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Amylase'];
		if (value && value !== "") {	
			conditions.show.push("Amylase Test Date");
		} else {	
			conditions.hide.push("Amylase Test Date");
		}	
		return conditions;	
	},
	'Sodium': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Sodium'];
		if (value && value !== "") {	
			conditions.show.push("Sodium Test Date");
		} else {	
			conditions.hide.push("Sodium Test Date");
		}	
		return conditions;	
	},
	'Potassium': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Potassium'];
		if (value && value !== "") {	
			conditions.show.push("Potassium Test Date");
		} else {	
			conditions.hide.push("Potassium Test Date");
		}	
		return conditions;	
	},
	'Magnésium': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Magnésium'];
		if (value && value !== "") {	
			conditions.show.push("Magnésium Test Date");
		} else {	
			conditions.hide.push("Magnésium Test Date");
		}	
		return conditions;	
	},
	'Calcium': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Calcium'];
		if (value && value !== "") {	
			conditions.show.push("Calcium Test Date");
		} else {	
			conditions.hide.push("Calcium Test Date");
		}	
		return conditions;	
	},
	'Chloride': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Chloride'];
		if (value && value !== "") {	
			conditions.show.push("Chloride Test Date");
		} else {	
			conditions.hide.push("Chloride Test Date");
		}	
		return conditions;	
	},
	'Prostate specific antigen (PSA)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Prostate specific antigen (PSA)'];
		if (value && value !== "") {	
			conditions.show.push("Prostate specific antigen (PSA) Test Date");
		} else {	
			conditions.hide.push("Prostate specific antigen (PSA) Test Date");
		}	
		return conditions;	
	},
	'CO2 (total)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['CO2 (total)'];
		if (value && value !== "") {	
			conditions.show.push("CO2 (total) Test Date");
		} else {	
			conditions.hide.push("CO2 (total) Test Date");
		}	
		return conditions;	
	},
	'Protein (serum) - Total': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Protein (serum) - Total'];
		if (value && value !== "") {	
			conditions.show.push("Protein (serum) - Total Test Date");
		} else {	
			conditions.hide.push("Protein (serum) - Total Test Date");
		}	
		return conditions;	
	},
	'Protein (serum) - Albumin': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Protein (serum) - Albumin'];
		if (value && value !== "") {	
			conditions.show.push("Protein (serum) - Albumin Test Date");
		} else {	
			conditions.hide.push("Protein (serum) - Albumin Test Date");
		}	
		return conditions;	
	},
	'Creatinuria (24 hours)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Creatinuria (24 hours)'];
		if (value && value !== "") {	
			conditions.show.push("Creatinuria (24 hours) Test Date");
		} else {	
			conditions.hide.push("Creatinuria (24 hours) Test Date");
		}	
		return conditions;	
	},
	'Albumin-Sugar-Aceton-Bile salt-Bile-pigment': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Albumin-Sugar-Aceton-Bile salt-Bile-pigment'];
		if (value && value !== "") {	
			conditions.show.push("Albumin-Sugar-Aceton-Bile salt-Bile-pigment Test Date");
		} else {	
			conditions.hide.push("Albumin-Sugar-Aceton-Bile salt-Bile-pigment Test Date");
		}	
		return conditions;	
	},
	'Pregnancy test': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Pregnancy test'];
		if (value && value !== "") {	
			conditions.show.push("Pregnancy test Test Date");
		} else {	
			conditions.hide.push("Pregnancy test Test Date");
		}	
		return conditions;	
	},
	'Protein (CSF)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Protein (CSF)'];
		if (value && value !== "") {	
			conditions.show.push("Protein (CSF) Test Date");
		} else {	
			conditions.hide.push("Protein (CSF) Test Date");
		}	
		return conditions;	
	},
	'Glucose (CSF)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Glucose (CSF)'];
		if (value && value !== "") {	
			conditions.show.push("Glucose (CSF) Test Date");
		} else {	
			conditions.hide.push("Glucose (CSF) Test Date");
		}	
		return conditions;	
	},
	'Chloride (CSF)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Chloride (CSF)'];
		if (value && value !== "") {	
			conditions.show.push("Chloride (CSF) Test Date");
		} else {	
			conditions.hide.push("Chloride (CSF) Test Date");
		}	
		return conditions;	
	},	
	'Urine dipstick': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Urine dipstick'];
		if (value && value !== "") {	
			conditions.show.push("Urine dipstick Test Date");
		} else {	
			conditions.hide.push("Urine dipstick Test Date");
		}	
		return conditions;	
	},
	'Sodium (urine)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Sodium (urine)'];
		if (value && value !== "") {	
			conditions.show.push("Sodium (urine) Test Date");
		} else {	
			conditions.hide.push("Sodium (urine) Test Date");
		}	
		return conditions;	
	},
	'Hemoglobin electrophoresis': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Hemoglobin electrophoresis'];
		if (value && value !== "") {	
			conditions.show.push("Hemoglobin electrophoresis Test Date");
		} else {	
			conditions.hide.push("Hemoglobin electrophoresis Test Date");
		}	
		return conditions;	
	},
	'Protein electrophoresis': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Protein electrophoresis'];
		if (value && value !== "") {	
			conditions.show.push("Protein electrophoresis Test Date");
		} else {	
			conditions.hide.push("Protein electrophoresis Test Date");
		}	
		return conditions;	
	},
	'HbA1C': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['HbA1C'];
		if (value && value !== "") {	
			conditions.show.push("HbA1C Test Date");
		} else {	
			conditions.hide.push("HbA1C Test Date");
		}	
		return conditions;	
	},
	'Iron level': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Iron level'];
		if (value && value !== "") {	
			conditions.show.push("Iron level Test Date");
		} else {	
			conditions.hide.push("Iron level Test Date");
		}	
		return conditions;	
	},
	'Iron binding capacity (TIBC)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Iron binding capacity (TIBC)'];
		if (value && value !== "") {	
			conditions.show.push("Iron binding capacity (TIBC) Test Date");
		} else {	
			conditions.hide.push("Iron binding capacity (TIBC) Test Date");
		}	
		return conditions;	
	},
	'Ferritin': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Ferritin'];
		if (value && value !== "") {	
			conditions.show.push("Ferritin Test Date");
		} else {	
			conditions.hide.push("Ferritin Test Date");
		}	
		return conditions;	
	},
	'Bicarbonate (HCO3)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Bicarbonate (HCO3)'];
		if (value && value !== "") {	
			conditions.show.push("Bicarbonate (HCO3) Test Date");
		} else {	
			conditions.hide.push("Bicarbonate (HCO3) Test Date");
		}	
		return conditions;	
	},
	'Calcium Ionized': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Calcium Ionized'];
		if (value && value !== "") {	
			conditions.show.push("Calcium Ionized Test Date");
		} else {	
			conditions.hide.push("Calcium Ionized Test Date");
		}	
		return conditions;	
	},
	'Creatine kinase': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Creatine kinase'];
		if (value && value !== "") {	
			conditions.show.push("Creatine kinase Test Date");
		} else {	
			conditions.hide.push("Creatine kinase Test Date");
		}	
		return conditions;	
	},
	'Osmolality (serum)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Osmolality (serum)'];
		if (value && value !== "") {	
			conditions.show.push("Osmolality (serum) Test Date");
		} else {	
			conditions.hide.push("Osmolality (serum) Test Date");
		}	
		return conditions;	
	},
	'Chloride (urine)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Chloride (urine)'];
		if (value && value !== "") {	
			conditions.show.push("Chloride (urine) Test Date");
		} else {	
			conditions.hide.push("Chloride (urine) Test Date");
		}	
		return conditions;	
	},
	'Creatinine (urine)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Creatinine (urine)'];
		if (value && value !== "") {	
			conditions.show.push("Creatinine (urine) Test Date");
		} else {	
			conditions.hide.push("Creatinine (urine) Test Date");
		}	
		return conditions;	
	},
	'Magnesium (urine)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Magnesium (urine)'];
		if (value && value !== "") {	
			conditions.show.push("Magnesium (urine) Test Date");
		} else {	
			conditions.hide.push("Magnesium (urine) Test Date");
		}	
		return conditions;	
	},
	'Osmolality (urine)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Osmolality (urine)'];
		if (value && value !== "") {	
			conditions.show.push("Osmolality (urine) Test Date");
		} else {	
			conditions.hide.push("Osmolality (urine) Test Date");
		}	
		return conditions;	
	},
	'Protein (urine)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Protein (urine)'];
		if (value && value !== "") {	
			conditions.show.push("Protein (urine) Test Date");
		} else {	
			conditions.hide.push("Protein (urine) Test Date");
		}	
		return conditions;	
	},
	'Cortisol (plasma) 8 AM': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Cortisol (plasma) 8 AM'];
		if (value && value !== "") {	
			conditions.show.push("Cortisol (plasma) 8 AM Test Date");
		} else {	
			conditions.hide.push("Cortisol (plasma) 8 AM Test Date");
		}	
		return conditions;	
	},
	'Cortisol (plasma) 4 PM': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Cortisol (plasma) 4 PM'];
		if (value && value !== "") {	
			conditions.show.push("Cortisol (plasma) 4 PM Test Date");
		} else {	
			conditions.hide.push("Cortisol (plasma) 4 PM Test Date");
		}	
		return conditions;	
	},
	'Oxygen (arterial saturation)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Oxygen (arterial saturation)'];
		if (value && value !== "") {	
			conditions.show.push("Oxygen (arterial saturation) Test Date");
		} else {	
			conditions.hide.push("Oxygen (arterial saturation) Test Date");
		}	
		return conditions;	
	},
	'pCO2 (arterial)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['pCO2 (arterial)'];
		if (value && value !== "") {	
			conditions.show.push("pCO2 (arterial) Test Date");
		} else {	
			conditions.hide.push("pCO2 (arterial) Test Date");
		}	
		return conditions;	
	},
	'pO2 (arterial)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['pO2 (arterial)'];
		if (value && value !== "") {	
			conditions.show.push("pO2 (arterial) Test Date");
		} else {	
			conditions.hide.push("pO2 (arterial) Test Date");
		}	
		return conditions;	
	},
	'pH (arterial)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['pH (arterial)'];
		if (value && value !== "") {	
			conditions.show.push("pH (arterial) Test Date");
		} else {	
			conditions.hide.push("pH (arterial) Test Date");
		}	
		return conditions;	
	},
	'Growth hormone (hGH) fasting': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Growth hormone (hGH) fasting'];
		if (value && value !== "") {	
			conditions.show.push("Growth hormone (hGH) fasting Test Date");
		} else {	
			conditions.hide.push("Growth hormone (hGH) fasting Test Date");
		}	
		return conditions;	
	},
	'FSH Males': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['FSH Males'];
		if (value && value !== "") {	
			conditions.show.push("FSH Males Test Date");
		} else {	
			conditions.hide.push("FSH Males Test Date");
		}	
		return conditions;	
	},
	'FSH Females premenopausal': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['FSH Females premenopausal'];
		if (value && value !== "") {	
			conditions.show.push("FSH Females premenopausal Test Date");
		} else {	
			conditions.hide.push("FSH Females premenopausal Test Date");
		}	
		return conditions;	
	},
	'FSH Females postmenopausal': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['FSH Females postmenopausal'];
		if (value && value !== "") {	
			conditions.show.push("FSH Females postmenopausal Test Date");
		} else {	
			conditions.hide.push("FSH Females postmenopausal Test Date");
		}	
		return conditions;	
	},
	'LH - Males': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['LH - Males'];
		if (value && value !== "") {	
			conditions.show.push("LH - Males Test Date");
		} else {	
			conditions.hide.push("LH - Males Test Date");
		}	
		return conditions;	
	},
	'LH - Females (follicular)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['LH - Females (follicular)'];
		if (value && value !== "") {	
			conditions.show.push("LH - Females (follicular) Test Date");
		} else {	
			conditions.hide.push("LH - Females (follicular) Test Date");
		}	
		return conditions;	
	},
	'LH - Females (mid-cycle)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['LH - Females (mid-cycle)'];
		if (value && value !== "") {	
			conditions.show.push("LH - Females (mid-cycle) Test Date");
		} else {	
			conditions.hide.push("LH - Females (mid-cycle) Test Date");
		}	
		return conditions;	
	},
	'LH - Females (luteal)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['LH - Females (luteal)'];
		if (value && value !== "") {	
			conditions.show.push("LH - Females (luteal) Test Date");
		} else {	
			conditions.hide.push("LH - Females (luteal) Test Date");
		}	
		return conditions;	
	},
	'LH - Females (postmenopausal)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['LH - Females (postmenopausal)'];
		if (value && value !== "") {	
			conditions.show.push("LH - Females (postmenopausal) Test Date");
		} else {	
			conditions.hide.push("LH - Females (postmenopausal) Test Date");
		}	
		return conditions;	
	},
	'PTH': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['PTH'];
		if (value && value !== "") {	
			conditions.show.push("PTH Test Date");
		} else {	
			conditions.hide.push("PTH Test Date");
		}	
		return conditions;	
	},
	'Progesterone (serum) (adult) - Males': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Progesterone (serum) (adult) - Males'];
		if (value && value !== "") {	
			conditions.show.push("Progesterone (serum) (adult) - Males Test Date");
		} else {	
			conditions.hide.push("Progesterone (serum) (adult) - Males Test Date");
		}	
		return conditions;	
	},
	'Progesterone (serum) (adult) - Females (follicular)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Progesterone (serum) (adult) - Females (follicular)'];
		if (value && value !== "") {	
			conditions.show.push("Progesterone (serum) (adult) - Females (follicular) Test Date");
		} else {	
			conditions.hide.push("Progesterone (serum) (adult) - Females (follicular) Test Date");
		}	
		return conditions;	
	},
	'Progesterone (serum) (adult) - Females (luteal)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Progesterone (serum) (adult) - Females (luteal)'];
		if (value && value !== "") {	
			conditions.show.push("Progesterone (serum) (adult) - Females (luteal) Test Date");
		} else {	
			conditions.hide.push("Progesterone (serum) (adult) - Females (luteal) Test Date");
		}	
		return conditions;	
	},
	'Prolactin (serum) - Males': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Prolactin (serum) - Males'];
		if (value && value !== "") {	
			conditions.show.push("Prolactin (serum) - Males Test Date");
		} else {	
			conditions.hide.push("Prolactin (serum) - Males Test Date");
		}	
		return conditions;	
	},
	'Prolactin (serum) Females': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Prolactin (serum) Females'];
		if (value && value !== "") {	
			conditions.show.push("Prolactin (serum) Females Test Date");
		} else {	
			conditions.hide.push("Prolactin (serum) Females Test Date");
		}	
		return conditions;	
	},
	'Testosterone - Males': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Testosterone - Males'];
		if (value && value !== "") {	
			conditions.show.push("Testosterone - Males Test Date");
		} else {	
			conditions.hide.push("Testosterone - Males Test Date");
		}	
		return conditions;	
	},
	'Testosterone - Females': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Testosterone - Females'];
		if (value && value !== "") {	
			conditions.show.push("Testosterone - Females Test Date");
		} else {	
			conditions.hide.push("Testosterone - Females Test Date");
		}	
		return conditions;	
	},
	'Testosterone - Pregnant females': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Testosterone - Pregnant females'];
		if (value && value !== "") {	
			conditions.show.push("Testosterone - Pregnant females Test Date");
		} else {	
			conditions.hide.push("Testosterone - Pregnant females Test Date");
		}	
		return conditions;	
	},
	'TSH - Adults': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['TSH - Adults'];
		if (value && value !== "") {	
			conditions.show.push("TSH - Adults Test Date");
		} else {	
			conditions.hide.push("TSH - Adults Test Date");
		}	
		return conditions;	
	},
	'TSH -Term infants: (0-1 day)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['TSH -Term infants: (0-1 day)'];
		if (value && value !== "") {	
			conditions.show.push("TSH -Term infants: (0-1 day) Test Date");
		} else {	
			conditions.hide.push("TSH -Term infants: (0-1 day) Test Date");
		}	
		return conditions;	
	},
	'TSH -Term infants: (1-4 days)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['TSH -Term infants: (1-4 days)'];
		if (value && value !== "") {	
			conditions.show.push("TSH -Term infants: (1-4 days) Test Date");
		} else {	
			conditions.hide.push("TSH -Term infants: (1-4 days) Test Date");
		}	
		return conditions;	
	},
	'TSH -Term infants: (2-20 weeks)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['TSH -Term infants: (2-20 weeks)'];
		if (value && value !== "") {	
			conditions.show.push("TSH -Term infants: (2-20 weeks) Test Date");
		} else {	
			conditions.hide.push("TSH -Term infants: (2-20 weeks) Test Date");
		}	
		return conditions;	
	},
	'TSH -Term infants: (21 weeks to 20 years)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['TSH -Term infants: (21 weeks to 20 years)'];
		if (value && value !== "") {	
			conditions.show.push("TSH -Term infants: (21 weeks to 20 years) Test Date");
		} else {	
			conditions.hide.push("TSH -Term infants: (21 weeks to 20 years) Test Date");
		}	
		return conditions;	
	},
	'Triiodothyronine total (T3)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Triiodothyronine total (T3)'];
		if (value && value !== "") {	
			conditions.show.push("Triiodothyronine total (T3) Test Date");
		} else {	
			conditions.hide.push("Triiodothyronine total (T3) Test Date");
		}	
		return conditions;	
	},
	'Triiodothyronine free (FT3)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Triiodothyronine free (FT3)'];
		if (value && value !== "") {	
			conditions.show.push("Triiodothyronine free (FT3) Test Date");
		} else {	
			conditions.hide.push("Triiodothyronine free (FT3) Test Date");
		}	
		return conditions;	
	},
	'Thyroxine total (T4)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Thyroxine total (T4)'];
		if (value && value !== "") {	
			conditions.show.push("Thyroxine total (T4) Test Date");
		} else {	
			conditions.hide.push("Thyroxine total (T4) Test Date");
		}	
		return conditions;	
	},
	'Thyroxine free (FT4)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Thyroxine free (FT4)'];
		if (value && value !== "") {	
			conditions.show.push("Thyroxine free (FT4) Test Date");
		} else {	
			conditions.hide.push("Thyroxine free (FT4) Test Date");
		}	
		return conditions;	
	},
	'Specific gravity': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Specific gravity'];
		if (value && value !== "") {	
			conditions.show.push("Specific gravity Test Date");
		} else {	
			conditions.hide.push("Specific gravity Test Date");
		}	
		return conditions;	
	},
	'Sperm count': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Sperm count'];
		if (value && value !== "") {	
			conditions.show.push("Sperm count Test Date");
		} else {	
			conditions.hide.push("Sperm count Test Date");
		}	
		return conditions;	
	}, 
	'Lipid profile Total cholesterol': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Lipid profile Total cholesterol'];
		if (value && value !== "") {	
			conditions.show.push("Lipid profile Total cholesterol Test Date");
		} else {	
			conditions.hide.push("Lipid profile Total cholesterol Test Date");
		}	
		return conditions;	
	},
	'HDL': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['HDL'];
		if (value && value !== "") {	
			conditions.show.push("HDL Test Date");
		} else {	
			conditions.hide.push("HDL Test Date");
		}	
		return conditions;	
	},
	'Lipid profile Triglycerides': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Lipid profile Triglycerides'];
		if (value && value !== "") {	
			conditions.show.push("Lipid profile Triglycerides Test Date");
		} else {	
			conditions.hide.push("Lipid profile Triglycerides Test Date");
		}	
		return conditions;	
	},
	'LDL': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['LDL'];
		if (value && value !== "") {	
			conditions.show.push("LDL Test Date");
		} else {	
			conditions.hide.push("LDL Test Date");
		}	
		return conditions;	
	},
	'C reactive protein': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['C reactive protein'];
		if (value && value !== "") {	
			conditions.show.push("C reactive protein Test Date");
		} else {	
			conditions.hide.push("C reactive protein Test Date");
		}	
		return conditions;	
	},	
	'Crachants': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Crachants'];
		if (value && value !== "") {	
			conditions.show.push("Crachants Test Date");
		} else {	
			conditions.hide.push("Crachants Test Date");
		}	
		return conditions;	
	},
	'CSF parasitology': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['CSF parasitology'];
		if (value && value !== "") {	
			conditions.show.push("CSF parasitology Test Date");
		} else {	
			conditions.hide.push("CSF parasitology Test Date");
		}	
		return conditions;	
	},
	'Coprology': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Coprology'];
		if (value && value !== "") {	
			conditions.show.push("Coprology Test Date");
		} else {	
			conditions.hide.push("Coprology Test Date");
		}	
		return conditions;	
	},
	'Rapid Diagnosis Malaria Test': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Rapid Diagnosis Malaria Test'];
		if (value && value !== "") {	
			conditions.show.push("Rapid Diagnosis Malaria Test Test Date");
		} else {	
			conditions.hide.push("Rapid Diagnosis Malaria Test Test Date");
		}	
		return conditions;	
	},
	'Malaria Test (GE)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Malaria Test (GE)'];
		if (value && value !== "") {	
			conditions.show.push("Malaria Test (GE) Test Date");
		} else {	
			conditions.hide.push("Malaria Test (GE) Test Date");
		}	
		return conditions;	
	},
	'Recherche des Micro Filaires': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Recherche des Micro Filaires'];
		if (value && value !== "") {	
			conditions.show.push("Recherche des Micro Filaires Test Date");
		} else {	
			conditions.hide.push("Recherche des Micro Filaires Test Date");
		}	
		return conditions;	
	},
	'Skin snip': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Skin snip'];
		if (value && value !== "") {	
			conditions.show.push("Skin snip Test Date");
		} else {	
			conditions.hide.push("Skin snip Test Date");
		}	
		return conditions;	
	},
	/**
	 * Handling conditions for PATIENT WITH HIV - CHILD INITIAL form
	 */
	'Opportunist Infections': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Opportunist Infections'];
		if (value === "Yes full name") {	
			conditions.show.push("Opportunist Infection duration?");
			conditions.show.push("Opportunist Infection complications?");
			conditions.show.push("Opportunist Infection treatment?");
		} else {	
			conditions.hide.push("Opportunist Infection duration?");
			conditions.hide.push("Opportunist Infection complications?");
			conditions.hide.push("Opportunist Infection treatment?");
		}	
		return conditions;	
	},
	'Opportunist Infections': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Opportunist Infections'];
		if (value === "Yes full name") {	
			conditions.show.push("Opportunist Infection duration?");
			conditions.show.push("Opportunist Infection complications?");
			conditions.show.push("Opportunist Infection treatment?");
		} else {	
			conditions.hide.push("Opportunist Infection duration?");
			conditions.hide.push("Opportunist Infection complications?");
			conditions.hide.push("Opportunist Infection treatment?");
		}	
		return conditions;	
	},
	'Chronic diarrhea': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Chronic diarrhea'];
		if (value === "Yes full name") {	
			conditions.show.push("Chronic diarrhea duration?");
			conditions.show.push("Chronic diarrhea complications?");
			conditions.show.push("Chronic diarrhea treatment?");
		} else {	
			conditions.hide.push("Chronic diarrhea duration?");
			conditions.hide.push("Chronic diarrhea complications?");
			conditions.hide.push("Chronic diarrhea treatment?");
		}	
		return conditions;	
	},
	'Chronic Cough': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Chronic Cough'];
		if (value === "Yes full name") {	
			conditions.show.push("Chronic Cough duration?");
			conditions.show.push("Chronic Cough complications?");
			conditions.show.push("Chronic Cough treatment?");
		} else {	
			conditions.hide.push("Chronic Cough duration?");
			conditions.hide.push("Chronic Cough complications?");
			conditions.hide.push("Chronic Cough treatment?");
		}	
		return conditions;	
	},
	'Shingles': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Shingles'];
		if (value === "Yes full name") {	
			conditions.show.push("Shingles duration?");
			conditions.show.push("Shingles complications?");
			conditions.show.push("Shingles treatment?");
		} else {	
			conditions.hide.push("Shingles duration?");
			conditions.hide.push("Shingles complications?");
			conditions.hide.push("Shingles treatment?");
		}	
		return conditions;	
	},
	'Hepatitis B?': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Hepatitis B?'];
		if (value === "Yes full name") {	
			conditions.show.push("Hepatitis B duration?");
			conditions.show.push("Hepatitis B complications?");
			conditions.show.push("Hepatitis B treatment?");
		} else {	
			conditions.hide.push("Hepatitis B duration?");
			conditions.hide.push("Hepatitis B complications?");
			conditions.hide.push("Hepatitis B treatment?");
		}	
		return conditions;	
	},
	'Hepatitis C': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Hepatitis C'];
		if (value === "Yes full name") {	
			conditions.show.push("Hepatitis C duration?");
			conditions.show.push("Hepatitis C complications?");
			conditions.show.push("Hepatitis C treatment?");
		} else {	
			conditions.hide.push("Hepatitis C duration?");
			conditions.hide.push("Hepatitis C complications?");
			conditions.hide.push("Hepatitis C treatment?");
		}	
		return conditions;	
	},
	'Diabetes?': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		if (formName === "PATIENT WITH HIV - CHILD INITIAL") {
			var value = formFieldValues['Diabetes?'];
			if (value === "Yes full name") {	
				conditions.show.push("Diabetes duration?");
				conditions.show.push("Diabetes complications?");
				conditions.show.push("Diabetes treatment?");
			} else {	
				conditions.hide.push("Diabetes duration?");
				conditions.hide.push("Diabetes complications?");
				conditions.hide.push("Diabetes treatment?");
			}	
		}
		return conditions;	
	},
	'Recent TB contact': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Recent TB contact'];
		if (value === "Yes full name") {	
			conditions.show.push("Contact with?");
		} else {	
			conditions.hide.push("Contact with?");
		}	
		return conditions;	
	},
	'TB screened?': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['TB screened?'];
		if (value === "Yes full name") {	
			conditions.show.push("TB screened date");
		} else {	
			conditions.hide.push("TB screened date");
		}	
		return conditions;	
	},
	'Contact with?': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Contact with?'];
		if (value === "Other") {	
			conditions.show.push("If other specify");
		} else {	
			conditions.hide.push("If other specify");
		}	
		return conditions;	
	},
	'Multiple pregnancy': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Multiple pregnancy'];
		if (value === "Yes full name") {	
			conditions.show.push("If yes, Order at Birth");
		} else {	
			conditions.hide.push("If yes, Order at Birth");
		}	
		return conditions;	
	},
	'History of Tuberculosis': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['History of Tuberculosis'];
		if (value === "Yes full name") {	
			conditions.show.push("Treatment start date");
			conditions.show.push("If Yes");
			conditions.show.push("End date");
		} else {	
			conditions.hide.push("Treatment start date");
			conditions.hide.push("If Yes");
			conditions.hide.push("End date");
		}	
		return conditions;	
	},
	'ARV treatment': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['ARV treatment'];
		if (value === "Yes full name") {	
			conditions.show.push("If Yes since");
			conditions.show.push("Specify the protocol");
		} else {	
			conditions.hide.push("If Yes since");
			conditions.hide.push("Specify the protocol");
		}	
		return conditions;	
	},
	'Path of transmission': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Path of transmission'];
		if (value === "Other routes") {
			conditions.show.push("If other routes specify");
		} else {	
			conditions.hide.push("If other routes specify");
		}	
		return conditions;	
	},
	'Exposure to ARVs other than PMTCT?': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Exposure to ARVs other than PMTCT?'];
		if (value === "Yes") {
			conditions.show.push("If yes, select ARV used");
		} else {	
			conditions.hide.push("If yes, select ARV used");
		}	
		return conditions;	
	},
	'Complications': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Complications'];
		if (value === "Premature rupture of the membranes") {	
			conditions.show.push("If Premature Membrane Rupture, Duration (in hours)");
		} else {	
			conditions.hide.push("If Premature Membrane Rupture, Duration (in hours)");
		}
		if (value === "Other complications") {	
			conditions.show.push("If other complications, specify");
		} else {	
			conditions.hide.push("If other complications, specify");
		}
		return conditions;	
	},
	'Presentation': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Presentation'];
		if (value === "Other") {	
			conditions.show.push("If other presentation, specify");
		} else {	
			conditions.hide.push("If other presentation, specify");
		}	
		return conditions;	
	},
	'Entry Point': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Entry Point'];
		if (value === "Other") {	
			conditions.show.push("If other specify");
		} else {	
			conditions.hide.push("If other specify");
		}	
		return conditions;	
	},
	/**
	 * Handling conditions for CHILD EXPOSED TO HIV form
	 */
	'PCR 1': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['PCR 1'];
		if (value === "Yes full name") {	
			conditions.show.push("PCR 1 sample date");
			conditions.show.push("PCR 1 result");
			conditions.show.push("PCR 1 result date");
		} else {	
			conditions.hide.push("PCR 1 sample date");
			conditions.hide.push("PCR 1 result");
			conditions.hide.push("PCR 1 result date");
		}	
		return conditions;	
	},
	'PCR 2': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['PCR 2'];
		if (value === "Yes full name") {	
			conditions.show.push("PCR 2 sample date");
			conditions.show.push("PCR 2 result");
			conditions.show.push("PCR 2 result date");
		} else {	
			conditions.hide.push("PCR 2 sample date");
			conditions.hide.push("PCR 2 result");
			conditions.hide.push("PCR 2 result date");
		}	
		return conditions;	
	},
	'PCR 3': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['PCR 3'];
		if (value === "Yes full name") {	
			conditions.show.push("PCR 3 sample date");
			conditions.show.push("PCR 3 result");
			conditions.show.push("PCR 3 result date");
		} else {	
			conditions.hide.push("PCR 3 sample date");
			conditions.hide.push("PCR 3 result");
			conditions.hide.push("PCR 3 result date");
		}	
		return conditions;	
	},
	'Rapid Test 1 (9 to 18 months)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Rapid Test 1 (9 to 18 months)'];
		if (value === "Yes full name") {	
			conditions.show.push("Rapid Test 1 sample date");
			conditions.show.push("Rapid Test 1 result");
			conditions.show.push("Rapid Test 1 result date");
		} else {	
			conditions.hide.push("Rapid Test 1 sample date");
			conditions.hide.push("Rapid Test 1 result");
			conditions.hide.push("Rapid Test 1 result date");
		}	
		return conditions;	
	},
	'Rapid Test 2 (>/= 18 MOIS)': function(formName, formFieldValues) {
		var conditions = {show: [], hide: []};	
		var value = formFieldValues['Rapid Test 2 (>/= 18 MOIS)'];
		if (value === "Yes full name") {	
			conditions.show.push("Rapid Test 2 sample date");
			conditions.show.push("Rapid Test 2 result");
			conditions.show.push("Rapid Test 2 result date");
		} else {	
			conditions.hide.push("Rapid Test 2 sample date");
			conditions.hide.push("Rapid Test 2 result");
			conditions.hide.push("Rapid Test 2 result date");
		}	
		return conditions;	
	},
};