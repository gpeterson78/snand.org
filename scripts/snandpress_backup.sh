#!/bin/sh
# backup script for snand wordpress
#
# author: Grady Peterson
# license: MIT License
#
# description:
# this script creates backups for snand's wordpress site, including wordpress files and the mariadb database . 
# it saves the files and database, along with a log, into one tar.gz archive in the backup directory.  
# it’s meant to be run manually or via cron for automated backups, and logs both to console and a log file.  
# if anything goes wrong, it logs it and exits.  
# current setup is full backups, but we plan on getting fancier later (see enhancements)
#
# usage:
# run it manually or set up a cron job (example cron job for daily backups at 2 am):  
# 0 2 * * * /path/to/snandpress_backup.sh  
# 
# backup bundles everything into a single tar.gz file:
# - wordpress files (/var/www/html)  
# - mariadb database dump  
# - a log of the backup process  
# 
# enhancements (coming soon, probably):
# - **incremental/delta backups**: back up only changed files instead of everything  
# - **separate content and db backups**: db backed up daily, files backed up weekly  
# - **auto-prune old backups**: clean up old backups after X days or keep only the last Y backups  
# - **notifications**: get alerts when a backup succeeds or fails  

# Define the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Load environment variables from the .env file located relative to the script directory
ENV_FILE="$SCRIPT_DIR/../docker/wordpress/.env"
if [ -f "$ENV_FILE" ]; then
    # Export all variables from the .env file to the environment
    set -a
    . "$ENV_FILE"
    set +a
else
    echo "Error: .env file not found at $ENV_FILE"
    exit 1
fi

# Variables
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_PATH="$SCRIPT_DIR/../backup/"  # Destination path for backups, relative to script location
LOG_FILE="$BACKUP_PATH/backup_$TIMESTAMP.log"  # Log file for this run
TEMP_BACKUP_DIR="$BACKUP_PATH/wptemp_$TIMESTAMP"  # Temp directory to store individual backups before archiving
FINAL_BACKUP_FILE="$BACKUP_PATH/snandpress_backup_$TIMESTAMP.tar.gz"  # Final tar.gz file
# these should not change
WORDPRESS_CONTAINER="wordpress"
DB_CONTAINER="wordpressdb"
DB_NAME="wordpress"  # hardcoded in the compose file for some reason

# get username and password variables from the .env file directly

# Create backup directories if not exist
mkdir -p "$BACKUP_PATH"
mkdir -p "$TEMP_BACKUP_DIR"

# Function to log both to console and log file
log() {
    echo "$1" | tee -a "$LOG_FILE"
}

# Log start time
log "Backup started at $(date)"

# Backup WordPress files
log "Starting WordPress files backup..."
docker exec "$WORDPRESS_CONTAINER" tar -czf - -C /var/www/html . > "$TEMP_BACKUP_DIR/wordpress_files_$TIMESTAMP.tar.gz"
if [ $? -ne 0 ]; then
    log "Error: WordPress files backup failed."
    exit 1
else
    log "WordPress files backup completed."
fi

# Backup MariaDB database
log "Starting MariaDB database backup..."
docker exec "$DB_CONTAINER" mariadb-dump -h "$DB_CONTAINER" -u"$MYSQL_DATABASE_USER_NAME" -p"$MYSQL_DATABASE_PASSWORD" "$DB_NAME" > "$TEMP_BACKUP_DIR/wordpress_db_$TIMESTAMP.sql"
if [ $? -ne 0 ]; then
    log "Error: MariaDB backup failed."
    exit 1
else
    log "MariaDB backup completed."
fi
# Move log file to the temp directory
cp "$LOG_FILE" "$TEMP_BACKUP_DIR"

# Create final tar.gz archive with WordPress files, DB, and log
log "Creating final backup archive..."
tar -czf "$FINAL_BACKUP_FILE" -C "$TEMP_BACKUP_DIR" .
if [ $? -ne 0 ]; then
    log "Error: Failed to create final tar.gz archive."
    exit 1
else
    log "Final backup archive created successfully: $FINAL_BACKUP_FILE"
fi

# Clean up temporary files
rm -rf "$TEMP_BACKUP_DIR"
log "Temporary files cleaned up."

log "Backup completed and saved as $FINAL_BACKUP_FILE."
log "Backup finished at $(date)"
