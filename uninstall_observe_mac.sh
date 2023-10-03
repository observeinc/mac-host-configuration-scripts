#!/bin/bash

sudo osqueryctl stop
brew services stop telegraf
sudo launchctl stop fluent-bit

sudo rm -rf /etc/fluent-bit
sudo rm -rf /opt/homebrew/etc/fluent-bit
sudo rm -rf /opt/homebrew/var/fluent-bit
sudo rm -rf /usr/local/etc/fluent-bit
sudo rm -rf /usr/local/var/fluent-bit
sudo rm -rf /var/osquery
sudo rm /Library/LaunchDaemons/fluent-bit.plist
sudo rm -rf /opt/homebrew/etc/telegraf.*
sudo rm -rf /usr/local/brew/etc/telegraf.*

brew uninstall osquery
brew uninstall telegraf
brew uninstall fluent-bit
