# Nagios configuration
Nagios configuration to monitor bahmni services and server status.

## Install Nagios

1- Add nagios properties to setup file `/etc/bahmni-installer/setup.yml`:

```
nagios_contact_email: xx@gmail.com
ssmtp_auth_user: xx
ssmtp_auth_pass: xx
```

2- Add the nagios server host in inventory file `/etc/bahmni-installer/local`:

```
[nagios-server]
localhost
```

3- Install

```
bahmni -i local install-nagios
```

## Deploy

From the nagios folder in this repo run:

```
./deploy.sh
```
