#!/bin/sh
# launch.sh
# script to check if snand projects are running.  if running, pull new versions and update; otherwise, launch the project.
#
# Author: Grady Peterson
# License: MIT License
#
# Define the root directory where Docker projects live
DOCKER_ROOT="/snand/docker"

# Iterate over each directory in the root and check for docker-compose.yaml
for PROJECT in "$DOCKER_ROOT"/*; do
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
