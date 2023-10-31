#!/bin/bash

sudo osqueryctl stop
brew services stop telegraf
sudo launchctl stop fluent-bit

BREW=$(which brew)
if [ $BREW != "/opt/homebrew/bin/brew" ] && [ $BREW != "/usr/local/bin/brew" ]; then
    echo "This script is only supported with the homebrew package manager"
    exit
elif [ $BREW = "/opt/homebrew/bin/brew" ]; then
    BASE_BREW="/opt/homebrew/"
else
    BASE_BREW="/usr/local"
fi

if [ "$1" == "CLEAN" ];
then
    sudo rm -rf $BASE_BREW/fluent-bit
    sudo rm -rf $BASE_BREW/var/fluent-bit
    sudo rm -rf $BASE_BREW/etc/fluent-bit
    sudo rm -rf /var/osquery
    sudo rm /Library/LaunchDaemons/fluent-bit.plist
    sudo rm -rf $BASE_BREW/etc/telegraf.*
fi

brew uninstall osquery
brew uninstall telegraf
brew uninstall fluent-bit
