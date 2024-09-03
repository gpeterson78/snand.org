#!/bin/sh
# backup script for snand WordPress
#
# This script creates backups for a snand's WordPress site, including both WordPress files and the MariaDB database.
# The backups will be saved in the location specified by the BACKUP_PATH variable, with filenames that include the current date and time.
# Set the variables below, and you can run this script manually or as a cron job.

# How it works:
# 1. The script creates a backup of the WordPress files from the specified container.
#    - The files are archived into a .tar.gz file with a filename that includes the current date and time.
# 2. The script creates a backup of the MariaDB database.
#    - The database is dumped into a .sql file with a filename that includes the current date and time.
# 3. Both backups are saved in the directory specified by BACKUP_PATH.

# Usage:
# 1. Set the variables.
# 2. Run the script manually or set up a cron job:
#    Example cron job (runs daily at 2 AM):
#    0 2 * * * /path/to/backup_script.sh

# variables
BACKUP_PATH="/path/to/backup" # destination path for backups
WORDPRESS_CONTAINER="wordpress" # name of the WordPress Docker container
DB_CONTAINER="mysql_container_name" # name of the MariaDB Docker container
DB_NAME="your_database_name" # name of the WordPress database (usually 'wordpress')
DB_USER="your_database_user" # database username (usually 'wordpress')
DB_PASSWORD="your_database_password" # password for the database user

# create backup directory if it doesn't exist
mkdir -p "$BACKUP_PATH"

# backup the WordPress files
docker exec "$WORDPRESS_CONTAINER" tar -czf - -C /var/www/html . > "$BACKUP_PATH/wordpress_files_$(date +%Y%m%d%H%M%S).tar.gz"

# backup the MariaDB database using the container's internal hostname
docker exec "$DB_CONTAINER" mariadb-dump -h "$DB_CONTAINER" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$BACKUP_PATH/wordpress_db_$(date +%Y%m%d%H%M%S).sql"

echo "backup completed and saved to $BACKUP_PATH."

