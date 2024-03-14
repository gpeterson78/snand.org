#!/bin/sh
# Immich restore script for snand.org
#
# By default this script will restore from a database named immich_db_dump.sql.gz in the ./backup directory
# If the file does not exist, it will prompt for the backup path and date in the format the standard snand backup script saves
# This companion script is installed by default with the setup.sh
# This script is intended to be run from the Immich source path (ie. ./)
#
# Author: Grady Peterson
# Website: https://snand.org
# License: MIT License
# Feel free to use and modify this script for any purpose.
# This script comes with no warranty or guarantees.
#
# Last Updated: 2024-03-09
#
# Check if backup file exists (default location: ./backup/immich_db_dump.sql.gz)
if [ ! -f "./backup/immich_db_dump.sql.gz" ]; then
    # Prompt user for the source directory
    read -p "Please enter the location where the backup files are stored (/mnt/raid1/snand/backup/ as default): " backup_location
    backup_location=${backup_location:-'/mnt/raid1/snand/backup/'}
    # Prompt user for date
    read -p "Enter the date for the file to copy (format YYYYMMDD): " file_date
    # Define file name and destination path
    file_name="immich_db_dump_${file_date}.sql.gz"
    destination_path="./backup/immich_db_dump.sql.gz"
    # Construct the full source path
    source_path="${backup_location}/${file_name}"
    # Copy the file
    echo "Copying $source_path to $destination_path"
    cp "$source_path" "$destination_path"
else
    echo "The file $destination_file already exists. Moving on."
fi
# basically bog standard immich restore script:
docker compose down -v  # CAUTION! Deletes all Immich data to start from scratch.
docker compose pull     # Update to latest version of Immich (if desired)
docker compose create   # Create Docker containers for Immich apps without running them.
docker start immich_postgres    # Start Postgres server
sleep 10    # Wait for Postgres server to start up
# gunzip < "./backup/immich_db_dump.sql.gz" | docker exec -i immich_postgres psql -U postgres -d immich    # Restore Backup
# temporary workaround
gunzip < "./backup/immich_db_dump.sql.gz" | \
  sed "s/SELECT pg_catalog.set_config('search_path', '', false);/SELECT pg_catalog.set_config('search_path', 'public, pg_catalog', true);/g" | \
  docker exec -i immich_postgres psql -U postgres -d immich    # Restore Backup
docker compose up -d    # Start remainder of Immich apps