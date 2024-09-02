#!/bin/sh
# launch.sh
# Script to launch Docker Compose projects by pulling the latest images and bringing up the services.
#
# Author: Grady Peterson & ChatGPT
# License: MIT License
#
# Define the paths to your Docker Compose projects
PROJECTS="/snand/docker/traefik /snand/docker/wordpress /snand/docker/immich"

# Iterate over each project and launch it
for PROJECT in $PROJECTS; do
    if [ -f "$PROJECT/docker-compose.yaml" ]; then
        echo "Launching Docker Compose project in $PROJECT"
        cd "$PROJECT"
        
        # Pull the latest images
        docker-compose pull
        
        # Start the services in detached mode
        docker-compose up -d
        
        echo "Docker Compose project in $PROJECT launched successfully."
    else
        echo "No docker-compose.yaml found in $PROJECT, skipping."
    fi
done
