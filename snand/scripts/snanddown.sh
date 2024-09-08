#!/bin/sh
#
# script to bring down snand projects safely.
#
# Author: Grady Peterson
# License: MIT License
#
# Path to Docker projects
DOCKER_PROJECTS_PATH="/snand/docker"

# Iterate over all directories in the docker projects path
for PROJECT in "$DOCKER_PROJECTS_PATH"/*; do
    if [ -d "$PROJECT" ] && [ -f "$PROJECT/docker-compose.yaml" ]; then
        echo "Stopping Docker Compose project in $PROJECT"
        
        # Stop the Docker Compose project
        cd "$PROJECT"
        docker compose down
        
        echo "Docker Compose project in $PROJECT stopped successfully."
    else
        echo "No Docker Compose project found in $PROJECT, skipping."
    fi
done