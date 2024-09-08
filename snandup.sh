#!/bin/sh
# snand.org setup and launch script.
#
# author: Grady Peterson
# website: https://snand.org
# license: MIT License
# feel free to use and modify this script for any purpose.
# this script comes with no warranty or guarantees.
#
# last Updated: 2024-09-08

# ------------------------------------------
# Environment Variables
# ------------------------------------------

# wordpress
# snandpress environment variables
WORDPRESS_DATA=./config
WORDPRESS_URL=www.snand.org
WEB_SERVER_PORT=4321
#database configuration
MYSQL_DATABASE_USER_NAME=wordpress
MYSQL_DATABASE_PASSWORD=$(openssl rand -base64 36)
MYSQL_DATABASE_ROOT_PASSWORD=$(openssl rand -base64 48)
MYSQL_DATA=./db
#php admin variables
MYPHPADMIN_URL=db.snand.org

# immich
# snandich environment Variables
ENV_NAME=immich
IMMICH_VERSION=release
IMMICH_URL="immich.snand.org"
NETWORK_NAME=traefik-network
# directories
UPLOAD_LOCATION=./library
DB_DATA_LOCATION=/postgres
BACKUP_DIR=../backup/immich/db_dumps
# PostgreSQL Configuration
DB_DATABASE_NAME=immich
DB_PASSWORD=postgres
DB_USERNAME=postgres

# Traefik
# traefik environment variables
LETSENCRYPT_EMAIL=gradyp@snand.org
LETSENCRYPT_PATH=./letsencrypt
CLOUDFLARE_EMAIL=grady@gradyp.com
CLOUDFLARE_DNS_API_TOKEN=
TRAEFIK_LOG_LEVEL=info

# ------------------------------------------
# WordPress .env File Generation
# ------------------------------------------

# Check if .env file exists
if [ ! -f "./docker/wordpress/.env" ]; then
    echo "wordpress .env file does not exist creating..."
    
    # Write all variables at once to the .env file
    {
        echo "WORDPRESS_DATA=$WORDPRESS_DATA"
        echo "WORDPRESS_URL=$WORDPRESS_URL"
        echo "WEB_SERVER_PORT=$WEB_SERVER_PORT"
        echo "MYSQL_DATABASE_USER_NAME=$MYSQL_DATABASE_USER_NAME"
        echo "MYSQL_DATABASE_PASSWORD=$MYSQL_DATABASE_PASSWORD"
        echo "MYSQL_DATABASE_ROOT_PASSWORD=$MYSQL_DATABASE_ROOT_PASSWORD"
        echo "MYSQL_DATA=$MYSQL_DATA"
        echo "MYPHPADMIN_URL=$MYPHPADMIN_URL"
    } > "./docker/wordpress/.env"

else
    echo "wordpress .env file already exists, creating a backup and moving on..."
fi

# Backup .env file - ensure backup directory exists
mkdir -p ./backup/wordpress/
cp "./docker/wordpress/.env" "./backup/wordpress/wordpress_env_$(date +%Y%m%d%H%M%S)"
echo "wordpress .env file created and backed up."

# ------------------------------------------
# Immich .env File Generation
# ------------------------------------------

# Check if .env file exists
if [ ! -f "./docker/immich/.env" ]; then
    echo "immich .env file does not exist, creating..."
    
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
    echo "immich .env file already exists, creating a backup and moving on..."
fi

# Backup .env file - ensure backup directory exists
mkdir -p "./backup/immich"
cp "./docker/immich/.env" "./backup/immich/immich_env_$(date +%Y%m%d%H%M%S)"
echo "immich .env file created and backed up."

# ------------------------------------------
# Traefik .env File Generation
# ------------------------------------------

# Check if .env file exists
if [ ! -f "./docker/traefik/.env" ]; then
    echo "traefik .env file does not exist, creating..."
    
    # Write all variables at once to the .env file
    {
        echo "LETSENCRYPT_EMAIL=$LETSENCRYPT_EMAIL"
        echo "LETSENCRYPT_PATH=$LETSENCRYPT_PATH"
        echo "CLOUDFLARE_EMAIL=$CLOUDFLARE_EMAIL"
        echo "CLOUDFLARE_DNS_API_TOKEN=$CLOUDFLARE_DNS_API_TOKEN"
        echo "TRAEFIK_LOG_LEVEL=$TRAEFIK_LOG_LEVEL"
    } > "$TRAEFIK_ENV_PATH/.env"

else
    echo "traefik .env file already exists, creating a backup and moving on..."
fi

# Backup .env file - ensure backup directory exists
mkdir -p "./backup/traefik"
cp "./docker/traefik/.env" "./backup/traefik/traefik_env_$(date +%Y%m%d%H%M%S)"
echo "Traefik .env file created and backed up."

# iterate over each folder under ./docker and check if snand projects are running.
# if running, pull new versions and update; otherwise, launch the project.
for PROJECT in ./docker/*; do
    if [ -f "$PROJECT/docker-compose.yaml" ]; then
        echo "Checking Docker Compose project in $PROJECT"

        cd "$PROJECT"

        # Check if the project is already running
        RUNNING=$(docker compose ps -q)

        if [ -n "$RUNNING" ]; then
            echo "Project is already running. Pulling the latest images and updating..."
            docker compose pull
            docker compose up -d
            echo "Project in $PROJECT updated successfully."
        else
            echo "Project is not running. Launching..."
            docker compose up -d
            echo "Project in $PROJECT launched successfully."
        fi
    else
        echo "No docker-compose.yaml found in $PROJECT, skipping."
    fi
done

# ------------------------------------------
# Completion Messages
# ------------------------------------------
echo "open a web browser to https://$WORDPRESS_URL, https://$IMMICH_URL, or check your Traefik dashboard at https://127.0.0.1:8080."