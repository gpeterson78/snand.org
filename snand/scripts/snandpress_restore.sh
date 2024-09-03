#!/bin/sh
# restore ccript for snand's WordPress site.
# This script restores a WordPress site and its database from backup files and is meant
# as a companion to snand's backup script (wordpress restore)
# The script intentionally requires manual renaming of the backup files before running, 
# allowing you to selectively restore content and database files.

# Variables:
# BACKUP_PATH: Path to the backup files (default is current directory)
# WORDPRESS_CONTAINER: Name of the WordPress Docker container
# DB_CONTAINER: Name of the MariaDB Docker container
# DB_NAME: Name of the WordPress database
# DB_USER: Database username
# DB_PASSWORD: Password for the database user

# How it works:
# 1. Before running the script, manually rename the backup files to the following:
#    - WordPress files backup: wordpress_files.tar.gz
#    - Database backup: wordpress_db.sql
# 2. The script restores the WordPress files from the specified backup file into the container's web root directory.
# 3. The script restores the MariaDB database from the specified backup file into the database container.
# 4. Manual intervention ensures you can choose which files to restore, providing flexibility in recovery scenarios.

# Usage:
# 1. Rename the backup files as described above.
# 2. Set the variables as needed.
# 3. Run the script manually to restore your WordPress site and database.





# Variables
BACKUP_PATH="."  # Path to the backup files
WORDPRESS_CONTAINER="wordpress"  # Name of the WordPress container
DB_CONTAINER="wordpressdb"  # Name of the MySQL container
DB_NAME="wordpress"
DB_USER="wordpress"
DB_PASSWORD="REDACTED"

# Restore the WordPress files
docker exec -i "$WORDPRESS_CONTAINER" tar -xzf - -C /var/www/html < "$BACKUP_PATH/wordpress_files.tar.gz"

# Restore the MySQL database
#docker exec -i "$DB_CONTAINER" mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$BACKUP_PATH/wordpress_db.sql"
docker exec -i "$DB_CONTAINER" mariadb -h "$DB_CONTAINER" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$BACKUP_PATH/wordpress_db.sql"

echo "Restore completed."