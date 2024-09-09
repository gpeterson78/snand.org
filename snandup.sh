#!/bin/sh
# snandup script for snand.org
#
# author: grady peterson
# version: 1.2
# last updated: 2024-09-10
#
# description:
# this is the install and update script for snand.org, responsible for checking docker compose projects, pulling updates from git (optional), and launching the services.  
# it pulls the latest docker images for any running projects and brings up any that are stopped.  
# the script is designed to be run manually but could be scheduled via cron if needed.  
# it logs minimal output, unless run with the --verbose flag, in which case it gives you all the juicy details.  
# git pull is also optional, run with --git-pull to sync from the repo first and back up any old files before overwriting.
#
# usage:
# - manual run without pulling git:  
#   ./snandup.sh  
# 
# - manual run with git pull:  
#   ./snandup.sh --git-pull  
# 
# - run in verbose mode:  
#   ./snandup.sh --verbose  
# 
# the script does the following:  
# - backs up existing files before overwriting with the latest version from git  
# - checks for docker-compose.yaml files in the docker root directory  
# - pulls latest images for running services  
# - launches stopped services  
# - (optional) pulls the latest changes from the repo if --git-pull is used
#
# enhancements (coming soon, probably):
# - **auto-recompose**: watch for changes in docker-compose files and automatically recompose services  
# - **auto-notify**: send an alert if any service fails to launch or update  
# - **better logging**: more detailed logs for troubleshooting or cron-based runs  
#
# license:
# MIT License - use it, change it, share it, but don’t call us if it breaks

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
        echo "$1" >&3
    fi
}

# ------------------------------------------
# Backup and Overwrite Handling
# ------------------------------------------
log "Backing up existing files before updating if they exist..."

TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_DIR="./backup"
TEMP_BACKUP_DIR="$BACKUP_DIR/temp_backup_$TIMESTAMP"
FINAL_BACKUP_FILE="$BACKUP_DIR/snand_config_$TIMESTAMP.tar.gz"
GIT_TEMP_REPO_DIR="/tmp/snand-repo"  # Temporary directory for git files

# Create backup directories if they don't exist
mkdir -p "$BACKUP_DIR"
mkdir -p "$TEMP_BACKUP_DIR"

# ------------------------------------------
# Optional Git Clone/Pull from Remote
# ------------------------------------------
if [ "$1" = "--git-pull" ] || [ "$2" = "--git-pull" ]; then
    echo "Pulling latest changes from remote GitHub repository..." >&3

    # If the repo already exists in the temp directory, pull the latest changes
    if [ -d "$GIT_TEMP_REPO_DIR/.git" ]; then
        cd "$GIT_TEMP_REPO_DIR" || exit 1
        git pull origin main
        if [ $? -ne 0 ]; then
            echo "Error: Git pull failed." >&3
            exit 1
        fi
        cd - >/dev/null
        echo "Git pull successful." >&3
    else
        # If the temp repo directory doesn't exist, clone it fresh
        git clone https://github.com/gpeterson78/snand.org.git "$GIT_TEMP_REPO_DIR"
        if [ $? -ne 0 ]; then
            echo "Error: Git clone failed." >&3
            exit 1
        fi
        echo "Git clone successful." >&3
    fi

    # Check for each file in the git temp repo and back it up if it exists in the canonical location
    while IFS= read -r -d '' FILE_PATH; do
        RELATIVE_PATH=${FILE_PATH#"$GIT_TEMP_REPO_DIR/"}  # Strip the temp repo prefix to get relative path

        # Check if file exists in canonical location
        if [ -f "$RELATIVE_PATH" ]; then
            # Backup the original file
            log "Backing up $RELATIVE_PATH to $TEMP_BACKUP_DIR"
            cp "$RELATIVE_PATH" "$TEMP_BACKUP_DIR"
        fi

        # Copy the new file from Git repo to canonical location
        log "Copying $RELATIVE_PATH to canonical location"
        cp "$FILE_PATH" "$RELATIVE_PATH"

    done < <(find "$GIT_TEMP_REPO_DIR" -type f -print0)

    # Tar up the backed-up files if any exist
    if [ "$(ls -A "$TEMP_BACKUP_DIR")" ]; then
        tar -czf "$FINAL_BACKUP_FILE" -C "$TEMP_BACKUP_DIR" .
        log "Backup created: $FINAL_BACKUP_FILE"
    fi

    # Cleanup the temporary backup directory
    rm -rf "$TEMP_BACKUP_DIR"
    log "Temporary backup files cleaned up."
fi

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
        echo "Creating $PROJECT_NAME .env file..." >&3
        echo "$ENV_VARS" > "$ENV_FILE"
    else
        echo "$PROJECT_NAME .env file already exists, creating a backup." >&3
    fi

    mkdir -p "$BACKUP_PATH/$PROJECT_NAME"
    cp "$ENV_FILE" "$BACKUP_PATH/$PROJECT_NAME/${PROJECT_NAME}_env_$(date +%Y%m%d%H%M%S)" 2>/dev/null
    echo "$PROJECT_NAME .env file backed up." >&3
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
        PROJECT_NAME=$(basename "$PROJECT")
        echo "Checking $PROJECT_NAME in $PROJECT" >&3

        cd "$PROJECT"

        RUNNING=$(docker compose ps -q)

        if [ -n "$RUNNING" ]; then
            echo "$PROJECT_NAME is running. Pulling latest images and updating..." >&3
            docker compose pull
            docker compose up -d
        else
            echo "$PROJECT_NAME is not running. Launching..." >&3
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

echo "Setup and launch complete." >&3
echo "Open your web browser to access services:" >&3
echo "WordPress: https://$WORDPRESS_URL" >&3
echo "Immich: https://$IMMICH_URL" >&3
echo "Traefik dashboard: https://127.0.0.1:8080" >&3

# Disable verbose mode after the script runs (if it was enabled)
if [ "$VERBOSE" -eq 1 ]; then
    set +x  # Turn off verbose mode
else
    exec 1>&3 2>&4  # Restore stdout and stderr
fi
