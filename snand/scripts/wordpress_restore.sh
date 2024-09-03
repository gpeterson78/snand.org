#!/bin/sh
# Restore Script for Docker-based WordPress

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