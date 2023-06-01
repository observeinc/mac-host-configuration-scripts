#!/bin/bash
END_OUTPUT="END_OF_OUTPUT"

cd ~ || exit && echo "$SPACER $END_OUTPUT $SPACER"

config_file_directory="$HOME/observe_config_files"

log ()
{
    echo "`date` $1" | sudo tee -a "/tmp/observe-install.log"
}

getConfigurationFiles(){
    local branch_replace="$1"
    local SPACER
    SPACER=$(generateSpacer)
    if [ ! -d "$config_file_directory" ]; then
      mkdir "$config_file_directory"
      log "$SPACER $config_file_directory CREATED $SPACER"
    else
      rm -f "${config_file_directory:?}"/*
      log "$SPACER"
      log "$config_file_directory DELETED"
      log "$SPACER"
      ls "$config_file_directory"
      log "$SPACER"
    fi

    if [ ! -f "$config_file_directory/osquery.conf" ]; then
      url="https://raw.githubusercontent.com/observeinc/linux-host-configuration-scripts/${branch_replace}/config_files/osquery.conf"
      filename="$config_file_directory/osquery.conf"

      log "$SPACER"
      log "filename = $filename"
      log "$SPACER"
      log "url = $url"
      curl "$url" > "$filename"

      log "$SPACER"
      log "$filename created"
      log "$SPACER"
    fi

    if [ ! -f "$config_file_directory/telegraf.conf" ]; then
      url="https://raw.githubusercontent.com/observeinc/linux-host-configuration-scripts/${branch_replace}/config_files/telegraf.conf"
      filename="$config_file_directory/telegraf.conf"

      log "$SPACER"
      log "filename = $filename"
      log "$SPACER"
      log "url = $url"
      curl "$url" > "$filename"

      log "$SPACER"
      log "$filename created"
      log "$SPACER"
    fi

    if [ ! -f "$config_file_directory/td-agent-bit.conf" ]; then
      url="https://raw.githubusercontent.com/observeinc/linux-host-configuration-scripts/${branch_replace}/config_files/td-agent-bit.conf"
      filename="$config_file_directory/td-agent-bit.conf"

      log "$SPACER"
      log "filename = $filename"
      log "$SPACER"
      log "url = $url"
      curl "$url" > "$filename"

      log "$SPACER"
      log "$filename created"
      log "$SPACER"
    fi

    if [ ! -f "$config_file_directory/fluent-bit.conf" ]; then
      url="https://raw.githubusercontent.com/observeinc/linux-host-configuration-scripts/${branch_replace}/config_files/fluent-bit.conf"
      filename="$config_file_directory/fluent-bit.conf"

      log "$SPACER"
      log "filename = $filename"
      log "$SPACER"
      log "url = $url"
      curl "$url" > "$filename"

      log "$SPACER"
      log "$filename created"
      log "$SPACER"
    fi

    if [ ! -f "$config_file_directory/observe-mac-host.conf" ]; then
      url="https://raw.githubusercontent.com/observeinc/mac-host-configuration-scripts/${branch_replace}/observe-mac-host.conf"
      filename="$config_file_directory/observe-mac-host.conf"

      log "$SPACER"
      log "filename = $filename"
      log "$SPACER"
      log "url = $url"
      curl "$url" > "$filename"

      log "$SPACER"
      log "$filename created"
      log "$SPACER"
    fi

    if [ ! -f "$config_file_directory/fluent-bit.plist" ]; then
      url="https://raw.githubusercontent.com/observeinc/mac-host-configuration-scripts/${branch_replace}/fluent-bit.plist"
      filename="$config_file_directory/fluent-bit.plist"

      log "$SPACER"
      log "filename = $filename"
      log "$SPACER"
      log "url = $url"
      curl "$url" > "$filename"

      log "$SPACER"
      log "$filename created"
      log "$SPACER"
    fi

    if [ ! -f "$config_file_directory/osquery.flags" ]; then
      url="https://raw.githubusercontent.com/observeinc/linux-host-configuration-scripts/${branch_replace}/config_files/osquery.flags"
      filename="$config_file_directory/osquery.flags"

      log "$SPACER"
      log "filename = $filename"
      log "$SPACER"
      log "url = $url"
      curl "$url" > "$filename"

      log "$SPACER"
      log "$filename created"
      log "$SPACER"
    fi

    if [ ! -f "$config_file_directory/observe-installer.conf" ]; then
      url="https://raw.githubusercontent.com/observeinc/linux-host-configuration-scripts/${branch_replace}/config_files/observe-installer.conf"
      filename="$config_file_directory/observe-installer.conf"

      log "$SPACER"
      log "filename = $filename"
      log "$SPACER"
      log "url = $url"
      curl "$url" > "$filename"

      log "$SPACER"
      log "$filename created"
      log "$SPACER"
    fi

    if [ ! -f "$config_file_directory/parsers-observe.conf" ]; then
      url="https://raw.githubusercontent.com/observeinc/linux-host-configuration-scripts/${branch_replace}/config_files/parsers-observe.conf"
      filename="$config_file_directory/parsers-observe.conf"

      log "$SPACER"
      log "filename = $filename"
      log "$SPACER"
      log "url = $url"
      curl "$url" > "$filename"

      log "$SPACER"
      log "$filename created"
      log "$SPACER"
    fi
  
}

generateTestKey(){
  echo "${OBSERVE_TEST_RUN_KEY}"
}

# identify OS and architecture
OS=$(uname -s)
if [ $OS != "Darwin" ]; then
    echo "This script is only supported on MacOS"
    exit
fi
SYS_ARCH=$(uname -m)

# identify prerequisite. Without a system level equivalent of rpm or deb, there's no way to 
# ensure these installs are secured or updated in the event of a security flaw. Using the 
# homebrew package manager makes it easier to validate packages and update them in the future.
# A third party system manager can be used to deploy packages and config files instead.
BREW=$(which brew)
if [ $BREW != "/opt/homebrew/bin/brew" ]; then
    echo "This script is only supported with the homebrew package manager"
    exit
fi

# used for terminal output
generateSpacer(){
  echo "###########################################"
}

curlObserve(){
  local message="$1"
  local path_suffix="$2"
  local result="$3"

  curl https://"${OBSERVE_ENVIRONMENT}"/v1/http/script_validation/"${path_suffix}" \
  -H "Authorization: Bearer ${ingest_token}" \
  -H "Content-type: application/json" \
  -d "{\"data\": {\"datacenter\": \"${DEFAULT_OBSERVE_DATA_CENTER}\", \"host\": \"${DEFAULT_OBSERVE_HOSTNAME}\",\"result\": \"${result}\",\"message\": \"${message}\", \"os\": \"${OS}\" }}"

}

printHelp(){
      log "$SPACER"
      log "## HELP CONTENT"
      log "$SPACER"
      log "### Required inputs"
      log "- Required --customer_id YOUR_OBSERVE_CUSTOMERID "
      log "- Required --ingest_token YOUR_OBSERVE_DATA_STREAM_TOKEN "
      log "## Optional inputs"
      log "- Optional --observe_host_name - Defaults to https://<YOUR_OBSERVE_CUSTOMERID>.collect.observeinc.com/ "
      log "- Optional --config_files_clean TRUE or FALSE - Defaults to FALSE "
      log "    - controls whether to delete created config_files temp directory"
      log "- Optional --datacenter defaults to REMOTE"
      log "- Optional --appgroup id supplied sets value in fluentbit config"
      log "- Optional --branch_input branch of repository to pull scripts and config files from -Defaults to main"
      log "- Optional --validate_endpoint of observe_hostname using customer_id and ingest_token -Defaults to TRUE"
      log "- Optional --module to use for installs -Defaults to mac_host which installs osquery, fluentbit and telegraf"
      log "- Optional --custom_fluentbit_config add an additional configuration file for fluentbit"
      log "***************************"
      log "### Sample command:"
      log "\`\`\` curl \"https://raw.githubusercontent.com/observeinc/mac-host-configuration-scripts/main/observe_configure_mac_script.sh\" | zsh -s -- --customer_id YOUR_CUSTOMERID --ingest_token YOUR_DATA_STREAM_TOKEN --observe_host_name https://<YOUR_CUSTOMERID>.collect.observeinc.com/ --config_files_clean TRUE --datacenter MY_DATA_CENTER --appgroup MY_APP_GROUP\`\`\`"
      log "***************************"
}

requiredInputs(){
      log "$SPACER"
      log "* Error: Invalid argument.*"
      log "$SPACER"
      printVariables
      printHelp
      log "$SPACER"
      log "$END_OUTPUT"
      log "$SPACER"
      exit 1

}

printVariables(){
      log "$SPACER"
      log "* VARIABLES *"
      log "$SPACER"
      log "customer_id: $customer_id"
      log "ingest_token: $ingest_token"
      log "observe_host_name: $observe_host_name"
      log "config_files_clean: $config_files_clean"
      log "datacenter: $datacenter"
      log "appgroup: $appgroup"
      log "testeject: $testeject"
      log "validate_endpoint: $validate_endpoint"
      log "branch_input: $branch_input"
      log "module: $module"
      log "$SPACER"
}

testEject(){
local bail="$1"
local bailPosition="$2"
if [[ "$bail" == "$bailPosition" ]]; then
    log "$SPACER"
    log "$SPACER"
    log " TEST EJECTION "
    log "Position = $bailPosition"
    log "$SPACER"
    log "$END_OUTPUT"
    log "$SPACER"
    log "$SPACER"
    exit 0;
fi
}

removeConfigDirectory() {
      rm -f -R "$config_file_directory"
}

validateObserveHostName () {
  local url="$1"
  # check for properly formatted url input - assumes - https://<customer-id>.collect.observe[anything]/
  # we can modify this rule to be specific as needed
  regex='^(https?)://[0-9]+.collect.observe[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*\/'


  if [[ $url =~ $regex ]]
  then
      log "$SPACER"
      log "$url IS valid"
      log "$SPACER"
  else
      log "$SPACER"
      log "$url IS NOT valid - example valid input - https://123456789012.collect.observeinc.com/"
      log "$SPACER"
      exit 1
  fi
}

includeFiletdAgent(){
  # Process modules
  IFS=',' read -a CONFS <<< "$module"
  for i in "${CONFS[@]}"; do
        log "includeFiletdAgent - $i"

        sudo cp "$config_file_directory/observe-installer.conf" /etc/td-agent/observe-installer.conf;
        sudo cp "$config_file_directory/parsers-observe.conf" /etc/td-agent/parsers-observe.conf;

        case ${i} in
            mac_host)
              sudo cp "$config_file_directory/observe-mac-host.conf" /etc/td-agent/observe-mac-host.conf;
              ;;
            *)
              log "includeFiletdAgent function failed - i = $i"
              log "$SPACER"
              log "$END_OUTPUT"
              log "$SPACER"
              exit 1;
              ;;
        esac
  done

  #install custom config if exists
  if ! [ -z ${custom_fluentbit_config}]
  then
    sudo cp ${custom_fluentbit_config} /etc/td-agent/observe-custom-config.conf
  fi
}

includeFilefluentAgent(){
  # Process modules
  IFS=',' read -a CONFS <<< "$module"
  for i in "${CONFS[@]}"; do
        log "includeFilefluentAgent - $i"
        
        sudo mkdir -p /etc/fluent-bit
        sudo mkdir -p /opt/homebrew/var/fluent-bit
        sudo cp "$config_file_directory/observe-installer.conf" /etc/fluent-bit/observe-installer.conf
        sudo cp "$config_file_directory/parsers-observe.conf" /etc/fluent-bit/parsers-observe.conf

        case ${i} in
            mac_host)
              sudo cp "$config_file_directory/observe-mac-host.conf" /etc/fluent-bit/observe-mac-host.conf
              sudo cp "$config_file_directory/fluent-bit.plist" /Library/LaunchDaemons/fluent-bit.plist
              ;;
            *)
              log "includeFiletdAgent function failed - i = $i"
              log "$SPACER"
              log "$END_OUTPUT"
              log "$SPACER"
              exit 1;
              ;;
        esac
  done

  #install custom config if exists
  if ! [ -z ${custom_fluentbit_config}]
  then
    sudo cp ${custom_fluentbit_config} /etc/td-agent/observe-custom-config.conf
  fi
}

setInstallFlags(){
  # Process modules
  log "$SPACER"
  log "setInstallFlags - module=$module"
  log "$SPACER"

  IFS=',' read -a CONFS <<< "$module"
  for i in "${CONFS[@]}"; do
        log "setInstallFlags - $i"

        case ${i} in
            mac_host)
            log "setInstallFlags mac_host flags"
              osqueryinstall="TRUE"
              telegrafinstall="TRUE"
              fluentbitinstall="TRUE"
              ;;
            *)
              log "setInstallFlags function failed - i = $i"
              log "$SPACER"
              log "$END_OUTPUT"
              log "$SPACER"
              exit 1;
              ;;
        esac
  done
}

printMessage(){
  local message="$1"
  log
  log "$SPACER"
  log "$message"
  log "$SPACER"
  log
}

SPACER=$(generateSpacer)

log "$SPACER"
log "Script starting ..."

log "$SPACER"
log "Validate inputs ..."

customer_id=0
ingest_token=0
observe_host_name_base=
config_files_clean="FALSE"
datacenter="REMOTE"
testeject="NO"
appgroup="UNSET"
branch_input="main"
validate_endpoint="TRUE"
module="mac_host"
osqueryinstall="FALSE"
telegrafinstall="FALSE"
fluentbitinstall="FALSE"


if [ "$1" == "--help" ]; then
  printHelp
  log "$SPACER"
  log "$END_OUTPUT"
  log "$SPACER"
  exit 0
fi

if [ $# -lt 4 ]; then
  requiredInputs
fi

    # Parse inputs
    while [ $# -gt 0 ]; do
    echo "required inputs $1 $2 $# "
      case "$1" in
        --customer_id)
          customer_id="$2"
          ;;
        --ingest_token)
          ingest_token="$2"
          ;;
        --observe_host_name)
          observe_host_name_base="$2"
          ;;
        --config_files_clean)
          config_files_clean="$2"
          ;;
        --datacenter)
          datacenter="$2"
          ;;
        --appgroup)
          appgroup="$2"
          ;;
        --testeject)
          testeject="$2"
          ;;
        --branch_input)
          branch_input="$2"
          ;;
        --module)
          module="$2"
          ;;
        --validate_endpoint)
          validate_endpoint="$2"
          ;;
        --custom_fluentbit_config)
          custom_fluentbit_config="$2"
          ;;
        *)

      esac
      shift
      shift
    done

    if [ "$customer_id" == 0 ] || [ "$ingest_token" == 0 ]; then
      requiredInputs
    fi

# Construct the per-customer-id ingest host name.
if [ -z "$observe_host_name_base" ]; then
  observe_host_name_base="https://${customer_id}.collect.observeinc.com/"
fi

validateObserveHostName "$observe_host_name_base"

observe_host_name=$(echo "$observe_host_name_base" | sed -e 's|^[^/]*//||' -e 's|/.*$||')

log "$SPACER"
log "customer_id: ${customer_id}"
log "ingest_token: ${ingest_token}"
log "observe_host_name_base: ${observe_host_name_base}"
log "observe_host_name: ${observe_host_name}"
log "config_files_clean: ${config_files_clean}"
log "datacenter: ${datacenter}"
log "appgroup: ${appgroup}"
log "testeject: ${testeject}"
log "validate_endpoint: ${validate_endpoint}"
log "branch_input: ${branch_input}"
log "module: ${module}"
log "custom_fluentbit_config: ${custom_fluentbit_config}"

setInstallFlags

printMessage "osqueryinstall = $osqueryinstall"
printMessage "telegrafinstall = $telegrafinstall"
printMessage "fluentbitinstall = $fluentbitinstall"


OBSERVE_ENVIRONMENT="$observe_host_name"

DEFAULT_OBSERVE_HOSTNAME="${HOSTNAME}"

DEFAULT_OBSERVE_DATA_CENTER="$datacenter"

if [ "$validate_endpoint" == TRUE ]; then

    log "$SPACER"
    log "Validate customer_id / ingest token ..."
    log "$SPACER"
    log

    curl_endpoint=$(curl https://"${OBSERVE_ENVIRONMENT}"/v1/http/script_validation \
    -H "Authorization: Bearer ${ingest_token}" \
    -H "Content-type: application/json" \
    -d "{\"data\": {  \"datacenter\": \"${DEFAULT_OBSERVE_DATA_CENTER}\",\"host\": \"${DEFAULT_OBSERVE_HOSTNAME}\",\"message\": \"validating customer id and token\", \"os\": \"${OS}\", \"result\": \"SUCCESS\",  \"script_run\": \"${DEFAULT_OBSERVE_DATA_CENTER}\" ,  \"OBSERVE_TEST_RUN_KEY\": \"${OBSERVE_TEST_RUN_KEY}\"}}")

    # On a Mac... grep -P won't work
    validate_endpoint_result=$(echo "$curl_endpoint" | grep -c -o -e '"ok"\:true')

    if ((validate_endpoint_result != 1 )); then
        log "$SPACER"
        log "$validate_endpoint_result"
        log "Endpoint Validation failed with:"
        log "$curl_endpoint"
        log "$SPACER"
        log "$END_OUTPUT"
        log "$SPACER"
        exit 1
    else
        log "$SPACER"
        log "Successfully validated customer_id and ingest_token"
    fi

    log "$SPACER"

fi

log "$SPACER"
log "Values for configuration:"
log "$SPACER"
log "    Environment:  $OBSERVE_ENVIRONMENT"
log
log "    Data Center:  $DEFAULT_OBSERVE_DATA_CENTER"
log
log "    Hostname:  $DEFAULT_OBSERVE_HOSTNAME"
log
log "    Customer ID:  $customer_id"
log
log "    Customer Ingest Token:  $ingest_token"

testEject "${testeject}" "EJECT1"

log "$SPACER"

getConfigurationFiles "$branch_input"

log "$SPACER"

cd "$config_file_directory" || (exit && log "$SPACER CONFIG FILE DIRECTORY PROBLEM - $(pwd) - $config_file_directory - $END_OUTPUT $SPACER")

LC_ALL=C sed -i '' -e "s/REPLACE_WITH_DATACENTER/${DEFAULT_OBSERVE_DATA_CENTER}/g" ./*

LC_ALL=C sed -i '' -e "s/REPLACE_WITH_HOSTNAME/${DEFAULT_OBSERVE_HOSTNAME}/g" ./*

LC_ALL=C sed -i '' -e "s/REPLACE_WITH_CUSTOMER_INGEST_TOKEN/${ingest_token}/g" ./*

LC_ALL=C sed -i '' -e "s/REPLACE_WITH_OBSERVE_ENVIRONMENT/${OBSERVE_ENVIRONMENT}/g" ./*

if [ "$appgroup" != UNSET ]; then
    LC_ALL=C sed -i '' -e "s/#REPLACE_WITH_OBSERVE_APP_GROUP_OPTION/Record appgroup ${appgroup}/g" ./*
fi

testEject "${testeject}" "EJECT2"

# https://docs.observeinc.com/en/latest/content/integrations/linux/linux.html



#####################################
# BASELINEINSTALL - START
#####################################

log "Installation beginning"

#####################################
# osquery
#####################################
if [ "$osqueryinstall" == TRUE ]; then

  printMessage "osquery"

  # INSTALL
  brew install --cask osquery

  # CONFIGURE
  sudo mkdir -p /var/osquery/
  sourcefilename=$config_file_directory/osquery.conf
  filename=/var/osquery/osquery.conf
  osquery_conf_filename=/var/osquery/osquery.conf

  if [ -f "$filename" ]
  then
      sudo mv "$filename"  "$filename".OLD
  fi

  sudo cp "$sourcefilename" "$filename"

  sourcefilename=$config_file_directory/osquery.flags
  filename=/var/osquery/osquery.flags
  osquery_flags_filename=/var/osquery/osquery.flags

  if [ -f "$filename" ]
  then
      sudo mv "$filename"  "$filename".OLD
  fi

  sudo cp "$sourcefilename" "$filename"

  # ENABLE AND START
  sudo osqueryctl start 

fi

#####################################
# fluent
#####################################
if [ "$fluentbitinstall" == TRUE ]; then

  printMessage "fluent"
  
  # INSTALL
  brew install fluent-bit

  # CONFIGURE
  sourcefilename=$config_file_directory/td-agent-bit.conf
  filename=/etc/td-agent/td-agent-bit.conf

  td_agent_bit_filename=/etc/td-agent/td-agent-bit.conf

  if [ -f "$filename" ]; then
      sudo mv "$filename"  "$filename".OLD
  fi

  sudo cp "$sourcefilename" "$filename"

  includeFiletdAgent

  # ENABLE AND START
  sudo launchctl load -w /Library/LaunchDaemons/fluent-bit.plist

fi

#####################################
# telegraf
#####################################
if [ "$telegrafinstall" == TRUE ]; then

  printMessage "telegraf"

  # INSTALL
  brew install telegraf

  # CONFIGURE
  sudo mkdir -p /opt/homebrew/etc
  sourcefilename=$config_file_directory/telegraf.conf
  filename=/opt/homebrew/etc/telegraf.conf

  telegraf_conf_filename=/opt/homebrew/etc/telegraf.conf

  if [ -f "$filename" ]
  then
    sudo mv "$filename"  "$filename".OLD
  fi

  sudo cp "$sourcefilename" "$filename"

  # ENABLE AND START
  sleep 5
  brew services start telegraf

fi

################################################################################################
# VERIFY INSTALLATION
################################################################################################

if [ "$fluentbitinstall" == TRUE ]; then
  log "$SPACER"
  log "Check Services"
  log "$SPACER"
  log
  log "$SPACER"
  log "fluent-bit status"

  if sudo launchctl list fluent-bit | grep -c PID; then
    log fluent-bit is running

    curlObserve "fluent-bit is running" "fluent-bit" "SUCCESS"

  else
    log fluent-bit is NOT running

    curlObserve "fluent-bit is NOT running" "fluent-bit" "FAILURE"

    sudo launchctl list fluent-bit
  fi

  log "$SPACER"
  log "Check status - sudo launchctl list fluent-bit"
  log "Config file location: ${td_agent_bit_filename}"
  log
fi

log "$SPACER"

if [ "$osqueryinstall" == TRUE ]; then
  log "osqueryd status"

  if sudo osqueryctl status | grep -c -e "is running"; then
    log osqueryd is running

  curlObserve "osqueryd is running" "osqueryd" "SUCCESS"

  else
    log osqueryd is NOT running

    curlObserve "osqueryd is NOT running" "osqueryd" "FAILURE"

    sudo osqueryctl status
  fi
  log "$SPACER"
  log "Check status - sudo osqueryctl status"

  log "Config file location: ${osquery_conf_filename}"

  log "Flag file location: ${osquery_flags_filename}"
  log

fi

if [ "$telegrafinstall" == TRUE ]; then
    log "$SPACER"
    log "telegraf status"

    if brew services info telegraf | grep -c "Running: true"; then
      log telegraf is running

      curlObserve "telegraf is running" "telegraf" "SUCCESS"

    else
      log telegraf is NOT running

      curlObserve "telegraf is NOT running" "telegraf" "FAILURE"

      brew services info telegraf
    fi
    log "$SPACER"
    log "Check status - sudo service telegraf status"

    log "Config file location: ${telegraf_conf_filename}"
    log
    log "$SPACER"
    log
    log "$SPACER"
    log "Datacenter value:  ${DEFAULT_OBSERVE_DATA_CENTER}"
fi

if [ "$config_files_clean" == TRUE ]; then
  removeConfigDirectory
fi


#####################################
# BASELINEINSTALL - END
#####################################

log "$SPACER"
log "$END_OUTPUT"
log "$SPACER"
