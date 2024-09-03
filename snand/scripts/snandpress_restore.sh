#!/bin/sh
# restore script for snand's WordPress site.
# This script restores a WordPress site and its database from backup files 
# this is meant as a companion to snand's backup script:
# [snandpress_backup.md](https://raw.githubusercontent.com/gpeterson78/snand.org/main/snand/scripts/snandpress_backup.sh)
# The script intentionally requires manual renaming of the backup files before running, 
# allowing you to selectively restore content and database files.

# How it works:
# 1. Before running the script, manually rename the backup files to the following:
#    - WordPress files backup: wordpress_files.tar.gz
#    - Database backup: wordpress_db.sql
# 2. The script restores the WordPress files from the specified backup file into the container's web root directory.
# 3. The script restores the MariaDB database from the specified backup file into the database container.

# Usage:
# 1. Rename the backup files as described above.
# 2. Set the variables as needed.
# 3. Run the script manually to restore your WordPress site and database.

# Variables
BACKUP_PATH="."  # Ppath to the backup files (default is current directory)
WORDPRESS_CONTAINER="wordpress"  # name of the WordPress Docker container
DB_CONTAINER="wordpressdb"  # name of the MariaDB Docker container
DB_NAME="wordpress" # name of the WordPress database (usually 'wordpress')
DB_USER="wordpress" # database username (usually 'wordpress')
DB_PASSWORD="REDACTED" # password for the database user

# Restore the WordPress files
docker exec -i "$WORDPRESS_CONTAINER" tar -xzf - -C /var/www/html < "$BACKUP_PATH/wordpress_files.tar.gz"

# Restore the MySQL database
#docker exec -i "$DB_CONTAINER" mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$BACKUP_PATH/wordpress_db.sql"
docker exec -i "$DB_CONTAINER" mariadb -h "$DB_CONTAINER" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$BACKUP_PATH/wordpress_db.sql"

echo "Restore completed."