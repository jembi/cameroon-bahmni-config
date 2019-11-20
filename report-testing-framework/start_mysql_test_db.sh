#!/bin/sh
docker-compose up -d
sleep 60
docker exec -i bahmni_report_test_db mysql -uroot -pdbtest  <<EOF
UPDATE mysql.user SET host = '%' WHERE user = 'root';
EOF
docker restart bahmni_report_test_db
