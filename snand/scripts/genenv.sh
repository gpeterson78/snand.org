#!/bin/sh
# Combined environment generation Script for snand.org
#
# author: Grady Peterson
# website: https://snand.org
# license: MIT License
# feel free to use and modify this script for any purpose.
# this script comes with no warranty or guarantees.
#
# last Updated: 2024-09-02
#

# ------------------------------------------
# Environment Variables
# ------------------------------------------

# WordPress .env variables
WORDPRESS_ENV_PATH="/snand/docker/wordpress"
WORDPRESS_BACKUP_PATH="/snand/backup/wordpress"

MYSQL_DATABASE_PASSWORD=$(openssl rand -base64 36)
MYSQL_DATABASE_ROOT_PASSWORD=$(openssl rand -base64 48)
MYSQL_DATA="./db"
WORDPRESS_DATA="./config"
WORDPRESS_URL="www.snand.org"
MYPHPADMIN_URL="db.snand.org"
MYSQL_DATABASE_USER_NAME="wordpress"
WEB_SERVER_PORT="4321"

# Immich .env variables
IMMICH_ENV_PATH="/snand/docker/immich"
IMMICH_BACKUP_PATH="/snand/backup/immich"

DB_PASSWORD=$(openssl rand -base64 36)
UPLOAD_LOCATION="./upload"
IMMICH_URL="immich.snand.org"
IMMICH_VERSION="release"
ENV_NAME="immich"

# ------------------------------------------
# WordPress .env File Generation
# ------------------------------------------

# Check if .env file exists
if [ ! -f "$WORDPRESS_ENV_PATH/.env" ]; then
    echo ".env file does not exist in $WORDPRESS_ENV_PATH, creating..."
    
    # Write all variables at once to the .env file
    {
        echo "MYSQL_DATABASE_PASSWORD=$MYSQL_DATABASE_PASSWORD"
        echo "MYSQL_DATABASE_ROOT_PASSWORD=$MYSQL_DATABASE_ROOT_PASSWORD"
        echo "MYSQL_DATA=$MYSQL_DATA"
        echo "WORDPRESS_DATA=$WORDPRESS_DATA"
        echo "WORDPRESS_URL=$WORDPRESS_URL"
        echo "MYPHPADMIN_URL=$MYPHPADMIN_URL"
        echo "MYSQL_DATABASE_USER_NAME=$MYSQL_DATABASE_USER_NAME"
        echo "WEB_SERVER_PORT=$WEB_SERVER_PORT"
    } > "$WORDPRESS_ENV_PATH/.env"

else
    echo ".env file already exists, creating a backup and moving on..."
fi

# Backup .env file - ensure backup directory exists
mkdir -p "$WORDPRESS_BACKUP_PATH"
cp "$WORDPRESS_ENV_PATH/.env" "$WORDPRESS_BACKUP_PATH/wordpress_env_$(date +%Y%m%d%H%M%S)"
echo "WordPress .env file created and backed up."

# ------------------------------------------
# Immich .env File Generation
# ------------------------------------------

# Check if .env file exists
if [ ! -f "$IMMICH_ENV_PATH/.env" ]; then
    echo ".env file does not exist in $IMMICH_ENV_PATH, creating..."
    
    # Write all variables at once to the .env file
    {
        echo "DB_PASSWORD=$DB_PASSWORD"
        echo "UPLOAD_LOCATION=$UPLOAD_LOCATION"
        echo "IMMICH_VERSION=$IMMICH_VERSION"
        echo "ENV_NAME=$ENV_NAME"
        echo "IMMICH_URL=$IMMICH_URL"
        echo "DB_HOSTNAME=immich_postgres"
        echo "DB_USERNAME=postgres"
        echo "DB_DATABASE_NAME=immich"
        echo "REDIS_HOSTNAME=immich_redis"
    } > "$IMMICH_ENV_PATH/.env"

else
    echo ".env file already exists, creating a backup and moving on..."
fi

# Backup .env file - ensure backup directory exists
mkdir -p "$IMMICH_BACKUP_PATH"
cp "$IMMICH_ENV_PATH/.env" "$IMMICH_BACKUP_PATH/immich_env_$(date +%Y%m%d%H%M%S)"
echo "Immich .env file created and backed up."

# Additional code that needs to run after this script
echo "Please run 'docker compose up -d' to start the WordPress and Immich applications."
echo "Then open a web browser to https://$WORDPRESS_URL or https://$IMMICH_URL"
