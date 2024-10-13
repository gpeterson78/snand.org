#!/bin/sh
# Immich restore script for snand.org
#
# author: Grady Peterson
# version: 1.0  
# last updated: 2024-10-13
# license: MIT License
#
# description:
# This script restores the Immich database and uploads data.
# It restores the database from the immich_db_dump.sql.gz file in the /snand/scripts directory.
# It restores upload data from /snand/backup/immich/library and /snand/backup/immich/upload.
# This script will run Docker Compose functions from /snand/docker/immich.

# Load environment variables from the .env file
ENV_FILE="/snand/docker/immich/.env"  # Path to the .env file for Immich
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "Error: .env file not found at $ENV_FILE"
    exit 1
fi

# Paths
BACKUP_FILE="./immich_db_dump.sql.gz"  # Generic named database backup file in /snand/scripts
DOCKER_COMPOSE_PATH="/snand/docker/immich"  # Path to the Docker Compose file for Immich
LIBRARY_BACKUP="/snand/backup/immich/library"  # Backup path for library files
UPLOAD_BACKUP="/snand/backup/immich/upload"  # Backup path for upload files
UPLOAD_DIR="$UPLOAD_LOCATION"  # Local path for Immich uploads as defined in .env

# Check if the backup file exists in the current directory
if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Database backup file not found in ./"
    exit 1
fi

# Restore the PostgreSQL database
cd "$DOCKER_COMPOSE_PATH"
docker compose down -v  # CAUTION! Deletes all Immich data to start from scratch.
docker compose pull     # Update to the latest version of Immich (if desired)
docker compose create   # Create Docker containers for Immich apps without running them.
docker start immich_postgres  # Start Postgres server
sleep 10  # Wait for Postgres to start up

# Restore the database using credentials from the .env file
echo "Restoring the PostgreSQL database..."
gunzip < "$BACKUP_FILE" | \
  sed "s/SELECT pg_catalog.set_config('search_path', '', false);/SELECT pg_catalog.set_config('search_path', 'public, pg_catalog', true);/g" | \
  docker exec -i "$DB_HOSTNAME" psql -U "$DB_USERNAME" -d "$DB_DATABASE_NAME"

# Rsync the upload data from the backup directory
echo "Restoring Immich upload data from backups..."
rsync -avhP --ignore-existing "$LIBRARY_BACKUP/" "$UPLOAD_DIR/library/"
rsync -avhP --ignore-existing "$UPLOAD_BACKUP/" "$UPLOAD_DIR/upload/"
# Uncomment the next line if you want to restore the profile directory
# rsync -avhP --ignore-existing "/snand/backup/immich/profile/" "$UPLOAD_DIR/profile/"

# Start the remainder of Immich apps
docker compose up -d

echo "Restore process completed successfully."
