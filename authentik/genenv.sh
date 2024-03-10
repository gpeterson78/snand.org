#!/bin/sh
# Setup Script for snand.org's Self-Hosted Platform Authentication
#
# This script assists in the initial setup for the Authentik OAuth provider 
# in snand's suite of self-hosted applications.
#
# Author: Grady Peterson
# Website: https://snand.org
# License: MIT License
# Feel free to use and modify this script for any purpose.
# This script comes with no warranty or guarantees.
#
# Last Updated: 2024-03-09
PG_PASS=$(openssl rand -base64 36)
AUTHENTIK_SECRET_KEY=$(openssl rand -base64 48)

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

# Write all variables at once to the .env file
{
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
