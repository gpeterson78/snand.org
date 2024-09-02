#!/bin/sh
# Environment generation Script for snand.org's Self-Hosted Immich photo and backup site
#
# This script assists in the initial setup for Immich in snand's suite of self-hosted applications.
#
# Author: Grady Peterson
# Website: https://snand.org
# License: MIT License
# Feel free to use and modify this script for any purpose.
# This script comes with no warranty or guarantees.
#
# Last Updated: 2024-03-09
#
# Check if .env file exists
if [ ! -f ".env" ]; then
    echo ".env file does not exist, creating..."
    
    # Generate random database password
    DB_PASSWORD=$(openssl rand -base64 36)

    # Prompt user for Upload location
    read -p "Please enter the location where the uploaded files are stored (./upload as default): " UPLOAD_LOCATION
    UPLOAD_LOCATION=${UPLOAD_LOCATION:-'./upload'}

    # Prompt user for Immich URL
    read -p "Please provide the Immich URL (default immich.snand.org): " IMMICH_URL
    IMMICH_URL=${IMMICH_URL:-'immich.snand.org'}

    # Prompt user for Immich version
    read -p "Please enter the Immich version to use. You can pin this to a specific version like \"v1.71.0\" (default release): " IMMICH_VERSION
    IMMICH_VERSION=${IMMICH_VERSION:-release}

    # Prompt user for environment name
    read -p "Please enter the environment name (default immich): " ENV_NAME
    ENV_NAME=${ENV_NAME:-immich}

    # Write all variables at once to the .env file
    {
        echo "DB_PASSWORD=$DB_PASSWORD"
        echo "UPLOAD_LOCATION=$UPLOAD_LOCATION"
        echo "IMMICH_VERSION=$IMMICH_VERSION"
        echo "ENV_NAME=$ENV_NAME"
        echo "IMMICH_URL=$IMMICH_URL"
        # The values below do not need to be changed
        echo "DB_HOSTNAME=immich_postgres"
        echo "DB_USERNAME=postgres"
        echo "DB_DATABASE_NAME=immich"
        echo "REDIS_HOSTNAME=immich_redis"
    } > .env

else
    echo ".env file already exists, creating a backup and moving on..."
    # Ensure backup directory exists
    mkdir -p ./backup
    # Create a backup of the current .env file
    cp .env "./backup/.env_backup_$(date +%Y%m%d%H%M%S)"
fi

# Additional code that needs to run after this script
echo "Please run 'docker compose up -d' to start the application..."
echo "Then open a web browser to https://$IMMICH_URL"
