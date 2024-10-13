#!/bin/sh
# snandup script for snand.org
#
# author: Grady Peterson
# version: 1.0  
# last updated: 2024-10-13
# license: MIT License
#
# description:
# this script is responsible for starting and updating snand.
# it will check docker compose projects, pulling updates from git (optional),
# generating .env files (if they don't exist), backing up existing files, and launching the services.
# it pulls the latest docker images for any running projects and brings up any that are stopped.  
# git pull is optional, use --git-pull to sync from the repo first and back up any old files before overwriting.
#
# usage:
# - ./snandup.sh          # regular run (starts services)
# - ./snandup.sh --git-pull # run with git pull
# - ./snandup.sh --verbose  # verbose mode
# - ./snandup.sh --update   # perform docker compose pull and start services
# note to self - add a --help flag
#
# license:
# MIT License - go nuts, you probably are if you use this.

# ------------------------------------------
# Verbose mode flag
# ------------------------------------------
VERBOSE=0
UPDATE=0

for arg in "$@"; do
    case $arg in
        --verbose)
            VERBOSE=1
            set -x  # Enable verbose mode
            ;;
        --update)
            UPDATE=1  # Set update flag for docker compose pull
            ;;
    esac
done

# Function for verbose logging
log() {
    if [ "$VERBOSE" -eq 1 ]; then
        echo "$1"
    fi
}

# ------------------------------------------
# Load Variables from snand.config
# ------------------------------------------
CONFIG_FILE="./snand.config"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file not found at $CONFIG_FILE"
    exit 1
fi

log "Loading configuration from $CONFIG_FILE"
. "$CONFIG_FILE"

# ------------------------------------------
# Backup and Overwrite Handling
# ------------------------------------------
log "Backing up existing files before updating if they exist..."

TIMESTAMP=$(date +%Y%m%d%H%M%S)
TEMP_BACKUP_DIR="$BACKUP_PATH/temp_backup_$TIMESTAMP"
FINAL_BACKUP_FILE="$BACKUP_PATH/snand_config_$TIMESTAMP.tar.gz"
GIT_TEMP_REPO_DIR="/tmp/snand-repo"  # note to self - clean this up

# Create backup directories if they don't exist
mkdir -p "$BACKUP_PATH"
mkdir -p "$TEMP_BACKUP_DIR"

# ------------------------------------------
# Optional Git Clone/Pull from Remote
# ------------------------------------------
if [ "$1" = "--git-pull" ] || [ "$2" = "--git-pull" ]; then
    log "Pulling latest changes from remote GitHub repository..."

    # If the repo already exists in the temp directory, pull the latest changes
    if [ -d "$GIT_TEMP_REPO_DIR/.git" ]; then
        cd "$GIT_TEMP_REPO_DIR" || exit 1
        git pull origin main
        if [ $? -ne 0 ]; then
            echo "Error: Git pull failed."
            exit 1
        fi
        cd - >/dev/null
        log "Git pull successful."
    else
        # If the temp repo directory doesn't exist, clone it fresh
        git clone "$GIT_REPO_URL" "$GIT_TEMP_REPO_DIR"
        if [ $? -ne 0 ]; then
            echo "Error: Git clone failed."
            exit 1
        fi
        log "Git clone successful."
    fi

    # Copy files from Git to Canonical Locations
    log "Copying files from Git repo to canonical locations..."

    # Copy files from ./docker/projectname/
    find "$GIT_TEMP_REPO_DIR/docker" -type f | while read -r FILE_PATH; do
        RELATIVE_PATH=${FILE_PATH#"$GIT_TEMP_REPO_DIR/"}  # Strip the temp repo prefix to get relative path

        # Check if file exists in canonical location
        if [ -f "$RELATIVE_PATH" ]; then
            # Backup the original file before overwriting
            log "Backing up $RELATIVE_PATH to $TEMP_BACKUP_DIR"
            cp "$RELATIVE_PATH" "$TEMP_BACKUP_DIR"
        fi

        # Copy the new file from Git repo to canonical location
        log "Copying $RELATIVE_PATH to canonical location"
        cp "$FILE_PATH" "$RELATIVE_PATH"
    done

    # Copy and set executable permissions for scripts
    find "$GIT_TEMP_REPO_DIR/scripts" -type f | while read -r FILE_PATH; do
        RELATIVE_PATH=${FILE_PATH#"$GIT_TEMP_REPO_DIR/"}  # Strip the temp repo prefix to get relative path

        # Check if file exists in canonical location
        if [ -f "$RELATIVE_PATH" ]; then
            # Backup the original file before overwriting
            log "Backing up $RELATIVE_PATH to $TEMP_BACKUP_DIR"
            cp "$RELATIVE_PATH" "$TEMP_BACKUP_DIR"
        fi

        # Copy the new file from Git repo to canonical location
        log "Copying $RELATIVE_PATH to canonical location"
        cp "$FILE_PATH" "$RELATIVE_PATH"

        # Mark script as executable
        log "Setting executable permission for $RELATIVE_PATH"
        chmod +x "$RELATIVE_PATH"
    done

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
# Generate .env Files Based on Project Prefixes (Only if not already present)
# ------------------------------------------
generate_env_file() {
    PROJECT_NAME=$1
    ENV_FILE="./docker/$PROJECT_NAME/.env"
    
    # Only generate the .env file if it doesn't exist
    if [ ! -f "$ENV_FILE" ]; then
        log "Generating .env for $PROJECT_NAME at $ENV_FILE"
        
        # Filter the variables that belong to the project (by prefix)
        env | grep "^${PROJECT_NAME^^}_" | sed "s/^${PROJECT_NAME^^}_//" > "$ENV_FILE"
        
        log "$PROJECT_NAME .env file created."
    else
        log "$ENV_FILE already exists. Skipping generation."
    fi
}

# Generate .env files for each project
generate_env_file "wordpress"
generate_env_file "immich"
generate_env_file "traefik"

# ------------------------------------------
# Docker Compose Projects Launch
# ------------------------------------------
for PROJECT in "$DOCKER_ROOT"/*; do
    if [ -f "$PROJECT/docker-compose.yaml" ]; then
        PROJECT_NAME=$(basename "$PROJECT")
        log "Processing $PROJECT_NAME in $PROJECT"

        cd "$PROJECT"

        if [ "$UPDATE" -eq 1 ]; then
            log "Pulling latest images for $PROJECT_NAME..."
            docker compose pull
        fi

        log "Starting or updating $PROJECT_NAME..."
        docker compose up -d

        cd - >/dev/null
    else
        log "No docker-compose.yaml found in $PROJECT, skipping."
    fi
done

# ------------------------------------------
# Completion Messages
# ------------------------------------------
log "setup and launch complete."
log "open your web browser to access services:"
log "WordPress: https://$WORDPRESS_URL"
log "immich: https://$IMMICH_URL"
log "traefik dashboard: https://127.0.0.1:8080"

# Disable verbose mode after the script runs (if it was enabled)
if [ "$VERBOSE" -eq 1 ]; then
    set +x
fi
