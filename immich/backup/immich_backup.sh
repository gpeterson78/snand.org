#!/bin/sh
# Immich backup script for snand.org
#
# this script creates a backup with today's date in the local "backup" folder
# this script will create a backup and remove any backups older than 1 month
# this script is intended to be run a on a user defined schedule as a cron job
#
# Author: Grady Peterson
# Website: https://snand.org
# License: MIT License
# Feel free to use and modify this script for any purpose.
# This script comes with no warranty or guarantees.
#
# Last Updated: 2024-03-09

# By default this script writes backups to the current directory
BACKUP_DIR="." # Change this variable to set the backup directory

# Filename for the backup
BACKUP_FILENAME="immich_db_dump_$(date +%Y%m%d).sql.gz"

# Docker container name for the PostgreSQL database
DB_CONTAINER_NAME="immich_postgres"

# Check if the PostgreSQL container is running
if [ $(docker inspect -f '{{.State.Running}}' "$DB_CONTAINER_NAME") = "true" ]; then
    # Execute pg_dumpall and compress the output, then store in the backup directory
    docker exec -t "$DB_CONTAINER_NAME" pg_dumpall -c -U postgres | gzip > "$BACKUP_DIR/$BACKUP_FILENAME"
else
    exit 1
fi

# Find and delete backups older than 31 days in the backup directory
find "$BACKUP_DIR"/* -mtime +31 -type f -name 'immich_db_dump_*.gz' -exec rm {} \;
#
# this is dumb but ok for testing:
#
sudo rsync ../upload/library -avhP /mnt/aggr1/backup/immich/
sudo rsync ../upload/upload -avhP /mnt/aggr1/backup/immich/
sudo rsync ../upload/profile -avhP /mnt/aggr1/backup/immich/