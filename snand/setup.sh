#!/bin/sh
# setup Script for snand.org.
# download this script for execution with the following command:  
# wget https://raw.githubusercontent.com/gpeterson78/snand.org/main/snand/setup.sh && chmod +x setup.sh
#
# author: Grady Peterson
# website: https://snand.org
# license: MIT License
# feel free to use and modify this script for any purpose.
# this script comes with no warranty or guarantees.
#
# this is hugely work in progress and I'm sure it is essentially worst practice.
#
# Last Updated: 2024-09-02
#
# Create directories if they don't exist
for DIR in /snand/scripts /snand/docker/wordpress /snand/docker/immich; do
    if [ ! -d "$DIR" ]; then
        sudo mkdir -p "$DIR"
        echo "Created $DIR directory."
    else
        echo "$DIR directory already exists."
    fi
done

# List of scripts to download
SCRIPTS="genenv.sh wordpress_backup.sh wordpress_restore.sh"
SCRIPT_URL_BASE="https://raw.githubusercontent.com/gpeterson78/snand.org/main/snand/scripts"

# Download scripts
for SCRIPT in $SCRIPTS; do
    if [ ! -f "/snand/scripts/$SCRIPT" ]; then
        sudo wget -P /snand/scripts/ "$SCRIPT_URL_BASE/$SCRIPT"
        sudo chmod +x "/snand/scripts/$SCRIPT"
        echo "Downloaded and made $SCRIPT executable."
    else
        echo "$SCRIPT already exists, skipping download."
    fi
done

# List of Docker Compose files to download
COMPOSE_FILES="traefik/docker-compose.yaml wordpress/docker-compose.yaml immich/docker-compose.yaml"
COMPOSE_URL_BASE="https://raw.githubusercontent.com/gpeterson78/snand.org/main/snand/docker"

# Download Docker Compose files
for COMPOSE_FILE in $COMPOSE_FILES; do
    TARGET_PATH="/snand/docker/$COMPOSE_FILE"
    if [ ! -f "$TARGET_PATH" ]; then
        sudo wget -P "$(dirname "$TARGET_PATH")" "$COMPOSE_URL_BASE/$COMPOSE_FILE"
        echo "Downloaded $(basename "$COMPOSE_FILE")."
    else
        echo "$(basename "$COMPOSE_FILE") already exists, skipping download."
    fi
done
