# Dhis-integration configuration
Configuration to setup the dhis-integration app, that integrates bahmni reports with a dhis2 instance.

## Install dhis-integration

1- Install from rpm file:

```
wget https://github.com/jembi/cameroon-bahmni-config/releases/download/v1.2.1-draft/dhis-integration-1.0-1.noarch.rpm
yum install dhis-integration-1.0-1.noarch.rpm
```

2- Add ssl config:

```
cd /etc/httpd/conf.d/ 
wget https://raw.githubusercontent.com/Possiblehealth/possible-config/89662e8e823fac3dbcaf111aa72713a63139bb03/playbooks/roles/possible-dhis-integration/templates/dhis_integration_ssl.conf
sudo service httpd restart
```

3- Update configuration file:

```
vi /etc/dhis-integration/dhis-integration.yml (replace emr.com with server domain name, and any other info)
sudo service dhis-integration start
```

## Deploy

From the dhis2 folder in this repo run:

```
./deploy.sh
```
