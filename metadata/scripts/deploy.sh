#!/bin/bash
ENV=$1
MYSQL_PWD=$2
ssh bahmni@cmr-$ENV.jembi.org "
cd ~/git/cameroon-bahmni-metadata
git reset --hard origin/$ENV
git checkout $ENV
git pull
scripts/restart-openmrs.sh
mysql -uroot -p$MYSQL_PWD openmrs < <(cat sql/*.sql);
mysql -uroot -p$MYSQL_PWD openmrs < <(cat reportssql/*.sql);
psql -U clinlims -d clinlims -a -f postgresql/activate_departments_and_sample_types.sql
psql -U clinlims -d clinlims -a -f postgresql/add_test_ranges.sql
/sbin/service bahmni-lab restart"