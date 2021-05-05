#!/bin/bash

#verify that a file name has been provided and it exists
if [ ! -f "$1" ]; then
    echo "The file \"$1\" does not exist"
    exit 1
fi

#verify that a valid period has been provided
if [ "`date '+%Y-%m-%d' -d $2 2>/dev/null`" != "$2" ] || [ "`date '+%Y-%m-%d' -d $3 2>/dev/null`" != "$3" ] || [ -z "$2" ] || [ -z "$3" ]
then
  echo "Please provide valid start and end dates with the format (yyyy-mm-dd)"
  echo "ex: ./dispense_script.sh $1 2020-12-01 2020-12-31"
  exit 1
fi

#capture the password for mysql
echo -n Please enter mysql root password: 
read -s mysql_password
echo
echo
export MYSQL_PWD=$mysql_password

#verify that the mysql password is correct
test_db=$(mysql openmrs -uroot<<<"SELECT 1")
if [[ $test_db != *"1"* ]]; then
  echo "Password incorrect"
  exit 1
fi

echo "*** Validating csv file"

#read the csv file into arrays
readarray -t ePatientId < <(cut -d, -f1 $1)
readarray -t eDispenseDate < <(cut -d, -f2 $1)
readarray -t eDrugName < <(cut -d, -f3 $1)

validation_failed=false

for ((i=1; i<${#ePatientId[@]}; i++)); do #loop through patient records
  j=$((i+1))

  # the patient id must not be empty
  if [ -z "${ePatientId[$i]}" ]
  then
    echo "Line ${j} error: the patient id cannot be empty"
    validation_failed=true
    continue
  fi

  # the date of dispensation must not be empty
  if [ -z "${eDispenseDate[$i]}" ]
  then
    echo "Line ${j} error: the date of dispensation cannot be empty"
    validation_failed=true
    continue
  fi

  # the drug name must not be empty
  if [ -z "${eDrugName[$i]}" ]
  then
    echo "Line ${j} error: the drug name cannot be empty"
    validation_failed=true
    continue
  fi

  # the date of dispensation must be valid and have the format yyyy-mm-dd
  if [ "`date '+%Y-%m-%d' -d ${eDispenseDate[$i]} 2>/dev/null`" != "${eDispenseDate[$i]}" ]
  then
    echo "Line ${j} error: incorrect date (${eDispenseDate[$i]}), please ensure that the date is valid and has the correct format (yyyy-mm-dd)"
    validation_failed=true
    continue
  fi

  # the patient id must exist
  patient_id=$(mysql openmrs -uroot<<<"SELECT patient_id FROM patient_identifier WHERE identifier = '${ePatientId[$i]}' AND voided= 0 LIMIT 1")
  if [[ $patient_id != *"patient_id"* ]]; then
    echo "Line ${j} error: patient id ${ePatientId[$i]} not found, please ensure that the patient exists in the db and it is not voided"
    validation_failed=true
    continue
  fi
  readarray -t array_patient_id <<<"$patient_id"

  # the drug name must exist
  drug_concept_id=$(mysql openmrs -uroot<<<"SELECT concept_id FROM drug WHERE name = '${eDrugName[$i]}' AND retired=0 LIMIT 1")
  if [[ $drug_concept_id != *"concept_id"* ]]; then
    echo "Line ${j} error: drug name '${eDrugName[$i]}' not found, please ensure that the drug name exists in the db and it is not voided"
    validation_failed=true
    continue
  fi
  readarray -t array_drug_concept_id <<<"$drug_concept_id"

  # the drug must be an ARV
  drug_is_arv=$(mysql openmrs -uroot<<<"SELECT drugIsARV(${array_drug_concept_id[1]}) AS 'drug_is_arv'")
  readarray -t array_drug_is_arv <<<"$drug_is_arv"
  if [[ ${array_drug_is_arv[1]} != 1 ]]; then
    echo "Line ${j} error: drug name '${eDrugName[$i]}' (with drug concept id ${array_drug_concept_id[1]}) is not an ARV" >> outputHRB.txt
    echo "Line ${j} error: drug name '${eDrugName[$i]}' (with drug concept id ${array_drug_concept_id[1]}) is not an ARV"
    validation_failed=true
    continue
  fi

  # verify that there exists an ARV order (checks the most recent one)
  order_id=$(mysql openmrs -uroot<<<"SELECT o.order_id FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = ${array_patient_id[1]} AND o.voided = 0
        AND d.concept_id = ${array_drug_concept_id[1]}
        AND drugIsARV(d.concept_id)
        AND o.scheduled_date BETWEEN '$2' AND '$3'
    GROUP BY o.patient_id")
  readarray -t array_order_id <<<"$order_id"
  if [[ $order_id != *"order_id"* ]]; then
    echo "Line ${j} error: patient id ${ePatientId[$i]} does not have an ARV prescription"
    echo "Line ${j} error: patient id ${ePatientId[$i]} does not have an ARV prescription" >> outputHRB.txt
   validation_failed=true
  else
    # verify that the most recent ARV order has not been dispensed
    drug_dispensed=$(mysql openmrs -uroot<<<"SELECT drugOrderIsDispensed(${array_patient_id[1]},${array_order_id[1]}) AS 'drug_dispensed'")
    readarray -t array_drug_dispensed <<<"$drug_dispensed"
    if [[ ${array_drug_dispensed[1]} != 0 ]]; then
      echo "Line ${j} error: patient id ${ePatientId[$i]} most recent ARV order (order id = ${array_order_id[1]}) has been already dispensed" >> outputHRB.txt
      echo "Line ${j} error: patient id ${ePatientId[$i]} most recent ARV order (order id = ${array_order_id[1]}) has been already dispensed" 
      validation_failed=true
    fi
  fi

done

# display an error message and stop the execution if the validation failed
if [ "$validation_failed" = true ]; then
  echo "The validation has failed, no record has been updated. Please fix the above errors in the csv file and try again"
  exit -1
else
  echo
  echo "Data validation successfully completed"
  echo
fi

echo "*** Dispensing"
echo

dispensation_failed=false

concept_id=$(mysql openmrs -uroot<<<"SELECT concept_id FROM concept WHERE uuid = 'ff0d6d6a-e276-11e4-900f-080027b662ec'")
readarray -t array_concept_id <<<"$concept_id"

fail_count=0
success_count=0
for ((i=1; i<${#ePatientId[@]}; i++)); do #loop through patient records
  j=$((i+1))

  patient_id=$(mysql openmrs -uroot<<<"SELECT patient_id FROM patient_identifier WHERE identifier = '${ePatientId[$i]}' AND voided= 0 LIMIT 1")
  readarray -t array_patient_id <<<"$patient_id"

  drug_concept_id=$(mysql openmrs -uroot<<<"SELECT concept_id FROM drug WHERE name = '${eDrugName[$i]}' AND retired=0 LIMIT 1")
  readarray -t array_drug_concept_id <<<"$drug_concept_id"

  encounter_id=$(mysql openmrs -uroot<<<"SELECT o.encounter_id FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = ${array_patient_id[1]} AND o.voided = 0
        AND drugIsARV(d.concept_id)
    GROUP BY o.patient_id")
  readarray -t array_encounter_id <<<"$encounter_id"

  order_id=$(mysql openmrs -uroot<<<"SELECT o.order_id FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = ${array_patient_id[1]} AND o.voided = 0
        AND drugIsARV(d.concept_id) AND d.concept_id = ${array_drug_concept_id[1]}
    GROUP BY o.patient_id")
  readarray -t array_order_id <<<"$order_id"

  location_id=$(mysql openmrs -uroot<<<"SELECT location_id FROM encounter WHERE encounter_id = ${array_encounter_id[1]}")
  readarray -t array_location_id <<<"$location_id"

  dispensed=$(mysql openmrs -uroot -vvv<<<"INSERT INTO obs
    (person_id,concept_id,encounter_id,order_id,obs_datetime,location_id,value_coded,creator,date_created,voided,uuid,status) VALUES
    (${array_patient_id[1]},${array_concept_id[1]},${array_encounter_id[1]},${array_order_id[1]},'${eDispenseDate[$i]}',${array_location_id[1]},1,4,'${eDispenseDate[$i]}',0,UUID(),'FINAL')")
  if [[ $dispensed == *"Query OK"* ]];
  then
    success_count=$((success_count+1))
    echo "Patient id ${ePatientId[$i]} dispensed successfully"
  else
    fail_count=$((fail_count+1))
    echo "Patient id ${ePatientId[$i]} dispensation failed!"
    echo "$dispensed"
    dispensation_failed=true
  fi

done

if [ "$dispensation_failed" = true ]; then
  echo
  echo "$success_count dispensation(s) saved successfully, and $fail_count dispensation(s) have failed. The error log above shows the patient ids that failed"
  exit -1
else
  echo
  echo "All $success_count dispensation(s) successfully saved"
  echo
fi