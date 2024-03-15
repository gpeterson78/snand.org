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
    
    # generate random database password
    MYSQL_DATABASE_PASSWORD=$(openssl rand -base64 36)

    # generate random database password
    MYSQL_DATABASE_ROOT_PASSWORD=$(openssl rand -base64 48)

    # prompt user for Upload location
    read -p "please enter the location for the databse (./db as default): " MYSQL_DATA
    MYSQL_DATA=${MYSQL_DATA:-'./db'}

    # prompt user for Upload location
    read -p "please enter the location for the wordpress content (./config as default): " WORDPRESS_DATA
    WORDPRESS_DATA=${WORDPRESS_DATA:-'./config'}

    # prompt user for wordpress URL
    read -p "please provide the wordpress URL (default www.snand.org): " WORDPRESS_URL
    WORDPRESS_URL=${WORDPRESS_URL:-'www.snand.org'}

    # prompt user for myphpadmin URL
    read -p "please provide the myphpadmin URL (default db.snand.org): " MYPHPADMIN_URL
    MYPHPADMIN_URL=${MYPHPADMIN_URL:-'db.snand.org'}

    # write all variables at once to the .env file
    {
        echo "MYSQL_DATABASE_PASSWORD=$MYSQL_DATABASE_PASSWORD"
        echo "MYSQL_DATABASE_ROOT_PASSWORD=$MYSQL_DATABASE_ROOT_PASSWORD"
        echo "MYSQL_DATA=$MYSQL_DATA"
        echo "WORDPRESS_DATA=$WORDPRESS_DATA"
        echo "WORDPRESS_URL=$WORDPRESS_URL"
        echo "MYPHPADMIN_URL=$MYPHPADMIN_URL"
        # the values below do not need to be changed
        echo "MYSQL_DATABASE_USER_NAME=wordpress"
        echo "WEB_SERVER_PORT=4321"
    } > .env

else
    echo ".env file already exists, creating a backup and moving on..."
fi
# backup .env file - ensure backup directory exists
mkdir -p ./backup
cp .env "./backup/env_$(date +%Y%m%d)"
# additional code that needs to run after this script
echo "please run 'docker compose up -d' to start the application..."
echo "then open a web browser to https://$WORDPRESS_URL"
