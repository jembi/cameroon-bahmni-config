
#!/bin/bash

cd ~/git/cameroon-bahmni-config
git reset --hard
git checkout COM-171
git pull
mysql -u root -ppassword openmrs < openmrs/apps/reports/PECG_REPORT/sql/report_util_functions.sql
mysql -u root -ppassword openmrs < openmrs/apps/reports/PECG_REPORT/sql/indicator_functions.sql