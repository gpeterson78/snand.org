#!/bin/sh
# setup Script for snand.org.
#
# author: Grady Peterson
# website: https://snand.org
# license: MIT License
# feel free to use and modify this script for any purpose.
# this script comes with no warranty or guarantees.
#
# Last Updated: 2024-03-14

# download scripts and mark them executable:
sudo wget https://raw.githubusercontent.com/gpeterson78/snand.org/main/wordpress/genenv.sh
sudo chmod +x genenv.sh

sudo mkdir -p ./backup
sudo wget -O ./backup/wordpress_backup.sh https://raw.githubusercontent.com/gpeterson78/snand.org/main/wordpress/backup/wordpress_backup.sh
sudo chmod +x ./backup/wordpress_backup.sh

# Download docker-compose.yml
sudo wget https://raw.githubusercontent.com/gpeterson78/snand.org/main/wordpress/docker-compose.yaml

# Additional code that needs to run after this script
echo "please run docker compose up -d to start the application..."