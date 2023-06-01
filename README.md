# Configuration script for MacOS
## Assumptions:
- Assumes user running script can use passwordless sudo
- Assumes homebrew has been installed
- Assumes Apple Silicon (ARM)
- Tested with MacOS Ventura (13)

## What does it do
- Creates a config_files directory in home of logged in user

- Downloads configuration files from this git repository and the Observe linux configuration git repository

- Installs osquery, fluentbit and telegraf

- Subsitutes values for data center, hostname, customer id, data ingest token and observe endpoint in configuration files

- Copies files to respective agent locations, renames existing files with suffix OLD

- Outputs status of services


## Steps to configure

1. Login to machine via ssh

2. Run script with flag values set

Run --help command for list of flags and options

###########################################
## HELP CONTENT
###########################################
### Required inputs
- Required --customer_id YOUR_OBSERVE_CUSTOMERID 
- Required --ingest_token YOUR_OBSERVE_DATA_STREAM_TOKEN 
## Optional inputs
- Optional --observe_host_name - Defaults to https://<YOUR_OBSERVE_CUSTOMERID>.collect.observeinc.com/ 
- Optional --config_files_clean TRUE or FALSE - Defaults to FALSE 
    - controls whether to delete created config_files temp directory
- Optional --datacenter defaults to REMOTE
- Optional --appgroup id supplied sets value in fluentbit config
- Optional --branch_input branch of repository to pull scripts and config files from -Defaults to main. This branch must exist in linux and mac repositories!
- Optional --validate_endpoint of observe_hostname using customer_id and ingest_token -Defaults to TRUE
- Optional --module to use for installs -Defaults to mac_host which installs osquery, fluentbit, and telegraf
- Optional --custom_fluentbit_config add an additional configuration file for fluentbit
***************************
### Sample command:
``` curl https://raw.githubusercontent.com/observeinc/mac-host-configuration-scripts/main/observe_configure_mac_script.sh  | zsh -s -- --customer_id YOUR_CUSTOMERID --ingest_token YOUR_DATA_STREAM_TOKEN --observe_host_name https://<YOUR_CUSTOMERID>.collect.observeinc.com/ --config_files_clean TRUE --datacenter MY_DATA_CENTER --appgroup MY_APP_GROUP```
***************************

