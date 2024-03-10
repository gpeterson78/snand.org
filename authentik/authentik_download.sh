#!/bin/sh
# Setup Script for snand.org's Self-Hosted Platform Authentication
#
# Author: Grady Peterson
# Website: https://snand.org
# License: MIT License
# Feel free to use and modify this script for any purpose.
# This script comes with no warranty or guarantees.
#
# Last Updated: 2024-03-09

# Download scripts and mark them executable:
sudo wget https://raw.githubusercontent.com/gpeterson78/snand.org/main/authentik/genenv.sh
sudo chmod +x genenv.sh

sudo mkdir backup
sudo wget -O ./backup/authentik_backup.sh https://raw.githubusercontent.com/gpeterson78/snand.org/main/authentik/backup/authentik_backup.sh
sudo chmod +x ./backup/authentik_backup.sh

# Download docker-compose.yml
sudo wget https://raw.githubusercontent.com/gpeterson78/snand.org/main/authentik/docker-compose.yml


