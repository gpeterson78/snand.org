#!/bin/sh
#
# Author: Grady Peterson
# Website: https://snand.org
# License: MIT License
# This script comes with no warranty or guarantees.
#
# Last Updated: 2024-09-03
#
# Immich backup script for snand.org
#
# This script creates a backup with today's date in the specified backup folder.
# It retrieves database credentials and other configurations from the Immich .env file.
# It backs up the PostgreSQL database and removes backups older than a user-defined number of days.

# Load environment variables from the .env file
ENV_FILE="../docker/immich/.env"  # Adjust this path if needed
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "Error: .env file not found at $ENV_FILE"
    exit 1
fi

# Variables (based on the .env file)
BACKUP_DIR="/snand/backup/immich"  # Directory to store backups
UPLOAD_DIR="$UPLOAD_LOCATION"  # Location of Immich uploads from .env file
DB_CONTAINER_NAME="$DB_HOSTNAME"  # PostgreSQL container name from .env file
DB_USER="$DB_USERNAME"  # Database username from .env file
DB_PASSWORD="$DB_PASSWORD"  # Database password from .env file
BACKUP_FILENAME="immich_db_dump_$(date +%Y%m%d).sql.gz"
RETENTION_DAYS=30  # Number of days to keep backups

# Ensure the backup directory exists
mkdir -p "$BACKUP_DIR"

# Check if the PostgreSQL container is running
if [ "$(docker inspect -f '{{.State.Running}}' "$DB_CONTAINER_NAME")" = "true" ]; then
    echo "Backing up the PostgreSQL database..."
    # Dump the PostgreSQL database and compress it
    docker exec -t "$DB_CONTAINER_NAME" pg_dumpall -c -U "$DB_USER" -w | gzip > "$BACKUP_DIR/$BACKUP_FILENAME"
else
    echo "Error: PostgreSQL container '$DB_CONTAINER_NAME' is not running."
    exit 1
fi

# Clean up old backups (older than the retention period)
find "$BACKUP_DIR" -type f -name 'immich_db_dump_*.gz' -mtime +$RETENTION_DAYS -exec rm {} \;

# Sync Immich upload directories to the backup directory
rsync -avhP "$UPLOAD_DIR/library/" "$BACKUP_DIR/library/"
rsync -avhP "$UPLOAD_DIR/upload/" "$BACKUP_DIR/upload/"
# Uncomment the next line if you also want to back up the profile directory
# rsync -avhP "$UPLOAD_DIR/profile/" "$BACKUP_DIR/profile/"

echo "Backup completed successfully. Backups older than $RETENTION_DAYS days have been removed."
