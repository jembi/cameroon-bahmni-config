#!/bin/bash

run_command(){

        DATE=`date +%Y-%m-%d -d "yesterday"`

        COMMAND=`/usr/lib64/nagios/plugins/check_mysql_query -H 127.0.0.1 --username=root --password=password --database=openmrs -w=0 --query="$QUERY"`
        RESULT=$(echo $COMMAND | cut -d'|' -f 2 | cut -d. -f 1)

        if [[ "$RESULT" == *result\=0* ]]; then
                echo "No results for $DATE"
                exit 0
        else
                echo $RESULT " for $DATE"
                exit 1
        fi
}
 
if [[ -z "$1" ]] 
then
        echo "Missing parameter: query"
        exit 3
else
        QUERY=$1
fi

run_command