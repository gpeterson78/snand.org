#!/bin/sh
# Setup Script for snand.org's Self-Hosted Immich photo sharing and backup platform
#
# Author: Grady Peterson
# Website: https://snand.org
# License: MIT License
# Feel free to use and modify this script for any purpose.
# This script comes with no warranty or guarantees.
#
# Last Updated: 2024-03-14

# Download scripts and mark them executable:
sudo wget https://raw.githubusercontent.com/gpeterson78/snand.org/main/immich/genenv.sh
sudo chmod +x genenv.sh

sudo mkdir -p ./backup
sudo wget -O ./backup/immich_backup.sh https://raw.githubusercontent.com/gpeterson78/snand.org/main/immich/backup/immich_backup.sh
sudo chmod +x ./backup/immich_backup.sh

# Download docker-compose.yml
sudo wget https://raw.githubusercontent.com/gpeterson78/snand.org/main/immich/docker-compose.yml

# Additional code that needs to run after this script
echo "please run docker compose up -d to start the application..."