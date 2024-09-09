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
#
# ------------------------------------------
# Verbose mode flag
# ------------------------------------------
VERBOSE=0

# Check if --verbose flag is passed
if [ "$1" = "--verbose" ]; then
    VERBOSE=1
    set -x  # Enable verbose mode
else
    exec 3>&1 4>&2 >/dev/null 2>&1  # Silence all command output except echoes
fi

# Function for verbose logging (optional extra logs)
log() {
    if [ "$VERBOSE" -eq 1 ]; then
        echo "$1"
    fi
}

# ------------------------------------------
# Environment Variables
# ------------------------------------------
# Root Path for Docker Projects
DOCKER_ROOT="./docker"
BACKUP_PATH="./backup"
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

# snandich environment Variables
ENV_NAME=immich
IMMICH_VERSION=release
IMMICH_URL="immich2.snand.org"
NETWORK_NAME=traefik-network
# directories
UPLOAD_LOCATION=.
DB_DATA_LOCATION=/db
BACKUP_DIR=../backup/immich/db_dumps
# PostgreSQL Configuration
DB_DATABASE_NAME=immich
DB_USERNAME=postgres
DB_PASSWORD=postgres

# traefik environment variables
LETSENCRYPT_EMAIL=gradyp@snand.org
LETSENCRYPT_PATH=./letsencrypt
CLOUDFLARE_EMAIL=grady@gradyp.com
CLOUDFLARE_DNS_API_TOKEN= # Add your Cloudflare API token here
TRAEFIK_LOG_LEVEL=info

# ------------------------------------------
# .env File Generation Helper
# ------------------------------------------

generate_env_file() {
    PROJECT_NAME=$1
    ENV_VARS=$2

    PROJECT_PATH="$DOCKER_ROOT/$PROJECT_NAME"
    ENV_FILE="$PROJECT_PATH/.env"

    if [ ! -f "$ENV_FILE" ]; then
        echo "Creating $PROJECT_NAME .env file..."
        echo "$ENV_VARS" > "$ENV_FILE"
    else
        echo "$PROJECT_NAME .env file already exists, creating a backup."
    fi

    mkdir -p "$BACKUP_PATH/$PROJECT_NAME"
    cp "$ENV_FILE" "$BACKUP_PATH/$PROJECT_NAME/${PROJECT_NAME}_env_$(date +%Y%m%d%H%M%S)" 2>/dev/null
    log "$PROJECT_NAME .env file backed up."
}

# ------------------------------------------
# WordPress .env Generation
# ------------------------------------------

WORDPRESS_ENV_VARS="WORDPRESS_DATA=$WORDPRESS_DATA
WORDPRESS_URL=$WORDPRESS_URL
WEB_SERVER_PORT=$WEB_SERVER_PORT
MYSQL_DATABASE_USER_NAME=$MYSQL_DATABASE_USER_NAME
MYSQL_DATABASE_PASSWORD=$MYSQL_DATABASE_PASSWORD
MYSQL_DATABASE_ROOT_PASSWORD=$MYSQL_DATABASE_ROOT_PASSWORD
MYSQL_DATA=$MYSQL_DATA
MYPHPADMIN_URL=$MYPHPADMIN_URL"

generate_env_file "wordpress" "$WORDPRESS_ENV_VARS"

# ------------------------------------------
# Immich .env Generation
# ------------------------------------------

IMMICH_ENV_VARS="DB_PASSWORD=$DB_PASSWORD
UPLOAD_LOCATION=$UPLOAD_LOCATION
IMMICH_VERSION=$IMMICH_VERSION
ENV_NAME=$ENV_NAME
IMMICH_URL=$IMMICH_URL
DB_HOSTNAME=immich_postgres
DB_USERNAME=$DB_USERNAME
DB_DATABASE_NAME=$DB_DATABASE_NAME
REDIS_HOSTNAME=immich_redis"

generate_env_file "immich" "$IMMICH_ENV_VARS"

# ------------------------------------------
# Traefik .env Generation
# ------------------------------------------

TRAEFIK_ENV_VARS="LETSENCRYPT_EMAIL=$LETSENCRYPT_EMAIL
LETSENCRYPT_PATH=$LETSENCRYPT_PATH
CLOUDFLARE_EMAIL=$CLOUDFLARE_EMAIL
CLOUDFLARE_DNS_API_TOKEN=$CLOUDFLARE_DNS_API_TOKEN
TRAEFIK_LOG_LEVEL=$TRAEFIK_LOG_LEVEL"

generate_env_file "traefik" "$TRAEFIK_ENV_VARS"

# ------------------------------------------
# Launch Docker Compose Projects
# ------------------------------------------
for PROJECT in "$DOCKER_ROOT"/*; do
    if [ -f "$PROJECT/docker-compose.yaml" ]; then
        echo "Checking Docker Compose project in $PROJECT"

        cd "$PROJECT"

        RUNNING=$(docker compose ps -q)

        if [ -n "$RUNNING" ]; then
            echo "Project is running. Pulling latest images and updating..."
            docker compose pull
            docker compose up -d
        else
            echo "Project is not running. Launching..."
            docker compose up -d
        fi

        cd - >/dev/null
    else
        log "No docker-compose.yaml found in $PROJECT, skipping."
    fi
done

# ------------------------------------------
# Completion Messages
# ------------------------------------------

echo "Setup and launch complete."
echo "Open your web browser to access services:"
echo "WordPress: https://$WORDPRESS_URL"
echo "Immich: https://$IMMICH_URL"
echo "Traefik dashboard: https://127.0.0.1:8080"

# Disable verbose mode after the script runs (if it was enabled)
if [ "$VERBOSE" -eq 1 ]; then
    set +x  # Turn off verbose mode
else
    exec 1>&3 2>&4  # Restore stdout and stderr
fi