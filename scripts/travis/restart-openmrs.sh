#!/bin/bash
echo "*** Restarting openmrs. This might take up to 20 minutes."
OPEMRSLOGDIR="/opt/openmrs/log"
OPEMRSBACKUPLOGDIR="/opt/openmrs/old_logs"
HOUR=`date +%d_%m_%Y_%H_%M_%S`
mkdir -p $OPEMRSBACKUPLOGDIR/$HOUR
counter=0
mv $OPEMRSLOGDIR/* $OPEMRSBACKUPLOGDIR/$HOUR
/sbin/service openmrs restart
while ! grep "InitializerActivator - Start of initializer module." /opt/openmrs/log/openmrs.log;
do 
echo "Openmrs busy restarting..."
counter=$((counter+1))
echo "*** Time elapsed : " $counter
sleep 60
done
sleep 10
echo "*** Completed restarting openmrs"
