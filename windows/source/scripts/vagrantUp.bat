echo vagrant up & backup
vagrant up
vagrant ssh -c 'sudo /home/bahmni/cameroon-backups.sh'
exit