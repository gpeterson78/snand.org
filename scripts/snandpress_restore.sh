#!/bin/sh
# restore script for snand's wordpress site
#
# version: 1.3  
# last updated: 2024-09-10
#
# description:
# this script restores the wordpress site and its database from a single backup tar.gz archive  
# it is docker-compose aware and will stop services before restoring and restart them after  
# it unpacks the archive into a temp directory and restores both the wordpress files and the mariadb database  
# this script uses the .env file for database credentials (just like the backup script)
#
# usage:
# 1. make sure your backup file (tar.gz) is in the specified backup path  
# 2. set the variables below if needed  
# 3. run the script to restore your wordpress site and database
#
# planned enhancements:
# - add options for selective restores (just files, just db)  
# - add error logging and more robust restore validation

# Load environment variables from the .env file located relative to the script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../docker/wordpress/.env"
if [ -f "$ENV_FILE" ]; then
    set -a
    . "$ENV_FILE"
    set +a
else
    echo "error: .env file not found at $ENV_FILE"
    exit 1
fi

# variables
BACKUP_PATH="$SCRIPT_DIR/../backup"  # Path to the backup file
DOCKER_COMPOSE_PATH="$SCRIPT_DIR/../docker/wordpress"  # Path to the Docker Compose project
TEMP_RESTORE_DIR="$BACKUP_PATH/temp_restore"  # Temp directory for unpacking backup
DB_NAME="wordpress"  # Hardcoded DB name in compose
BACKUP_FILE="$BACKUP_PATH/snandpress_backup_*.tar.gz"  # Wildcard for the backup tar.gz file
TIMESTAMP=$(date +%Y%m%d%H%M%S)
# these should not change
WORDPRESS_CONTAINER="wordpress"
DB_CONTAINER="wordpressdb"

# check for backup file existence
if [ ! -f $BACKUP_FILE ]; then
    echo "error: backup file not found in $BACKUP_PATH"
    exit 1
fi

# create temp restore directory if not exists
mkdir -p "$TEMP_RESTORE_DIR"

# Function to prompt for confirmation
confirm() {
    echo -n "$1 [y/N]: "
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY]) true ;;
        *) false ;;
    esac
}

# Check if WordPress files exist in the container before stopping services
echo "Checking for existing WordPress files..."
EXISTING_FILES=$(docker exec "$WORDPRESS_CONTAINER" sh -c "[ -d /var/www/html ] && ls /var/www/html | wc -l")
if [ "$EXISTING_FILES" -gt 0 ]; then
    if ! confirm "Warning: WordPress files already exist. Do you want to overwrite them?"; then
        echo "Restore canceled."
        exit 0
    fi
fi

# Check if the WordPress database exists
echo "Checking for existing WordPress database..."
EXISTING_DB=$(docker exec "$DB_CONTAINER" mariadb -h "$DB_CONTAINER" -u"$MYSQL_DATABASE_USER_NAME" -p"$MYSQL_DATABASE_PASSWORD" -e "SHOW DATABASES LIKE '$DB_NAME';")
if echo "$EXISTING_DB" | grep -q "$DB_NAME"; then
    if ! confirm "Warning: WordPress database already exists. Do you want to overwrite it?"; then
        echo "Restore canceled."
        exit 0
    fi
fi

# Check if Docker Compose services are running and stop them after confirmation
cd "$DOCKER_COMPOSE_PATH"
RUNNING=$(docker compose ps -q)
if [ -n "$RUNNING" ]; then
    if ! confirm "Docker Compose services are running. Do you want to stop them for the restore?"; then
        echo "Restore canceled."
        exit 0
    else
        echo "Stopping Docker Compose services..."
        docker compose down
    fi
fi

# unpack backup file to temp directory
echo "unpacking backup file..."
tar -xzf "$BACKUP_FILE" -C "$TEMP_RESTORE_DIR"
if [ $? -ne 0 ]; then
    echo "error: failed to unpack the backup file"
    exit 1
else
    echo "backup file unpacked successfully"
fi

# restore the WordPress files
echo "restoring WordPress files..."
docker exec -i "$WORDPRESS_CONTAINER" tar -xzf - -C /var/www/html < "$TEMP_RESTORE_DIR/wordpress_files_*.tar.gz"
if [ $? -ne 0 ]; then
    echo "error: WordPress files restore failed"
    exit 1
else
    echo "WordPress files restored successfully"
fi

# restore the MariaDB database
echo "restoring MariaDB database..."
docker exec -i "$DB_CONTAINER" mariadb -h "$DB_CONTAINER" -u"$MYSQL_DATABASE_USER_NAME" -p"$MYSQL_DATABASE_PASSWORD" "$DB_NAME" < "$TEMP_RESTORE_DIR/wordpress_db_*.sql"
if [ $? -ne 0 ]; then
    echo "error: MariaDB restore failed"
    exit 1
else
    echo "MariaDB restored successfully"
fi

# clean up temporary restore files
rm -rf "$TEMP_RESTORE_DIR"

# Restart Docker Compose services
echo "Starting Docker Compose services..."
docker compose up -d

echo "restore completed successfully at $TIMESTAMP"
