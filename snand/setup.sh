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
for DIR in /snand/scripts /snand/docker/wordpress; do
    if [ ! -d "$DIR" ]; then
        sudo mkdir -p "$DIR"
        echo "Created $DIR directory."
    else
        echo "$DIR directory already exists."
    fi
done

# Download scripts and mark them executable if they don't already exist
for SCRIPT in genenv.sh wordpress_backup.sh wordpress_restore.sh; do
    if [ ! -f "/snand/scripts/$SCRIPT" ]; then
        sudo wget -P /snand/scripts/ "https://raw.githubusercontent.com/gpeterson78/snand.org/main/snand/scripts/$SCRIPT"
        sudo chmod +x "/snand/scripts/$SCRIPT"
        echo "Downloaded and made $SCRIPT executable."
    else
        echo "$SCRIPT already exists in /snand/scripts, skipping download."
    fi
done

# Download docker-compose.yml files if they don't already exist
for COMPOSE_FILE in /snand/docker/wordpress/docker-compose.yaml; do
    if [ ! -f "$COMPOSE_FILE" ]; then
        sudo wget -P "$(dirname "$COMPOSE_FILE")" "https://raw.githubusercontent.com/gpeterson78/snand.org/main/$(basename "$(dirname "$COMPOSE_FILE")")/docker-compose.yaml"
        echo "Downloaded $(basename "$COMPOSE_FILE")."
    else
        echo "$(basename "$COMPOSE_FILE") already exists in $(dirname "$COMPOSE_FILE"), skipping download."
    fi
done
