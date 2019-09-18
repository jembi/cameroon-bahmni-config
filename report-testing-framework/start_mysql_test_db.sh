#!/bin/bash
docker-compose up -d
sleep 200
docker exec -i bahmni_report_test_db mysql -uroot -pdbtest  <<< "UPDATE mysql.user SET host = '%' WHERE user = 'root';"
docker restart bahmni_report_test_db
