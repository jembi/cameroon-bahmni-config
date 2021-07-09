#!/bin/bash
ENV=$1
MYSQL_PWD=$2
ssh bahmni@cmr-$ENV.jembi.org "
cd ~/git/cameroon-bahmni-config
cp openmrs/apps/home/whiteLabel.json ~
git reset --hard origin/$ENV
git checkout $ENV
git pull
cp ~/whiteLabel.json openmrs/apps/home/whiteLabel.json
scripts/travis/restart-openmrs.sh
mysql -uroot -p$MYSQL_PWD openmrs < <(cat metadata/sql/*.sql);
mysql -uroot -p$MYSQL_PWD openmrs < <(cat metadata/reportssql/*.sql);
psql -U clinlims -d clinlims -a -f metadata/postgresql/activate_departments_and_sample_types.sql
psql -U clinlims -d clinlims -a -f metadata/postgresql/add_test_ranges.sql
/sbin/service bahmni-lab restart"