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

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo ".env file does not exist, creating..."

    # Your existing script to create the .env file
    PG_PASS=$(openssl rand -base64 36)
    AUTHENTIK_SECRET_KEY=$(openssl rand -base64 48)

    # Prompt user for site URL
    read -p "Provide the site URL (authentik.snand.org as default): " AUTH_URL
    AUTH_URL=${AUTH_URL:-authentik.snand.org}

    # Prompt user for SMTP settings
    read -p "Provide the SMTP provider (smtp.gmail.com as default): " SMTP_PROVIDER
    SMTP_PROVIDER=${SMTP_PROVIDER:-smtp.gmail.com}
    read -p "Provide the SMTP port (587 as default): " SMTP_PORT
    SMTP_PORT=${SMTP_PORT:-587}
    read -p "Provide the SMTP username: " SMTP_USERNAME
    read -p "Provide the SMTP password: " SMTP_PASSWORD

    # Select option for TLS
    while true; do
        read -p "Use TLS? [1] for true (default), [2] for false: " TLS_CHOICE
        case $TLS_CHOICE in
            1 | "" ) SMTP_USE_TLS="true"; break;;
            2 ) SMTP_USE_TLS="false"; break;;
            * ) echo "Invalid selection. Please choose 1 for true or 2 for false.";;
        esac
    done

    # Select option for SSL
    while true; do
        read -p "Use SSL? [1] for true, [2] for false (default): " SSL_CHOICE
        case $SSL_CHOICE in
            1 ) SMTP_USE_SSL="true"; break;;
            2 | "" ) SMTP_USE_SSL="false"; break;;
            * ) echo "Invalid selection. Please choose 1 for true or 2 for false.";;
        esac
    done

    read -p "Provide the SMTP timeout (10 as default): " SMTP_TIMEOUT
    SMTP_TIMEOUT=${SMTP_TIMEOUT:-10}

    read -p "Provide the SMTP from email (admin@snand.org as default): " SMTP_FROM
    SMTP_FROM=${SMTP_FROM:-admin@snand.org}

    # Write all variables to the .env file
    {
        echo "AUTH_URL=$AUTH_URL"
        echo "PG_PASS=$PG_PASS"
        echo "AUTHENTIK_SECRET_KEY=$AUTHENTIK_SECRET_KEY"
        echo "AUTHENTIK_EMAIL_HOST=$SMTP_PROVIDER"
        echo "AUTHENTIK_EMAIL_PORT=$SMTP_PORT"
        echo "AUTHENTIK_EMAIL_USERNAME=$SMTP_USERNAME"
        echo "AUTHENTIK_EMAIL_PASSWORD=\"$SMTP_PASSWORD\""
        echo "AUTHENTIK_EMAIL_USE_TLS=$SMTP_USE_TLS"
        echo "AUTHENTIK_EMAIL_USE_SSL=$SMTP_USE_SSL"
        echo "AUTHENTIK_EMAIL_TIMEOUT=$SMTP_TIMEOUT"
        echo "AUTHENTIK_EMAIL_FROM=$SMTP_FROM"
    } > .env
else
    echo ".env file already exists, moving on..."
fi

# Additional code that needs to run after this script
echo "please run docker compose up -d to start the application..."