#!/bin/sh
# environment generation Script for snand.org
#
# author: Grady Peterson
# website: https://snand.org
# license: MIT License
# feel free to use and modify this script for any purpose.
# this script comes with no warranty or guarantees.
#
# last Updated: 2024-03-14
#
# check if .env file exists
if [ ! -f ".env" ]; then
    echo ".env file does not exist, creating..."
    
    # Generate random database password
    MYSQL_DATABASE_PASSWORD=$(openssl rand -base64 36)

    # Generate random database password
    MYSQL_DATABASE_ROOT_PASSWORD=$(openssl rand -base64 48)

    # Prompt user for Upload location
    read -p "Please enter the location for the databse (./db as default): " MYSQL_DATA
    MYSQL_DATA=${MYSQL_DATA:-'./db'}

    # Prompt user for Upload location
    read -p "Please enter the location for the wordpress content (./config as default): " WORDPRESS_DATA
    WORDPRESS_DATA=${WORDPRESS_DATA:-'./db'

    # Prompt user for Immich URL
    read -p "Please provide the Immich URL (default immich.snand.org): " WORDPRESS_URL
    WORDPRESS_URL=${WORDPRESS_URL:-'www.snand.org'}

    # Prompt user for Immich URL
    read -p "Please provide the Immich URL (default immich.snand.org): " MYPHPADMIN_URL
    MYPHPADMIN_URL=${MYPHPADMIN_URL:-'db.snand.org'}

    # Write all variables at once to the .env file
    {
        echo "MYSQL_DATABASE_PASSWORD=$MYSQL_DATABASE_PASSWORD"
        echo "MYSQL_DATABASE_ROOT_PASSWORD=$MYSQL_DATABASE_ROOT_PASSWORD"
        echo "MYSQL_DATA=$MYSQL_DATA"
        echo "WORDPRESS_DATA=$WORDPRESS_DATA"
        echo "IMMICH_VERSION=$IMMICH_VERSION"
        echo "ENV_NAME=$ENV_NAME"
        echo "WORDPRESS_URL=$WORDPRESS_URL"
        echo "MYPHPADMIN_URL=$MYPHPADMIN_URL"
        # The values below do not need to be changed
        echo "MYSQL_DATABASE_USER_NAME=wordpress"
        echo "WEB_SERVER_PORT=4321"
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
echo "Then open a web browser to https://$WORDPRESS_URL"
