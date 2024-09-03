#!/bin/sh
# Backup Script for Docker-based WordPress

# Variables
BACKUP_PATH="/path/to/backup"  # Set the backup destination path
WORDPRESS_CONTAINER="wordpress"  # Name of the WordPress container
DB_CONTAINER="mysql_container_name"  # Name of the MySQL container
DB_NAME="your_database_name"
DB_USER="your_database_user"
DB_PASSWORD="your_database_password"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_PATH"

# Backup the WordPress files
docker exec "$WORDPRESS_CONTAINER" tar -czf - -C /var/www/html . > "$BACKUP_PATH/wordpress_files_$(date +%Y%m%d%H%M%S).tar.gz"

# Backup the MySQL database
# docker exec "$DB_CONTAINER" mariadb-dump -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$BACKUP_PATH/wordpress_db_$(date +%Y%m%d%H%M%S).sql"

# Backup the MariaDB database using the container's internal hostname
docker exec "$DB_CONTAINER" mariadb-dump -h "$DB_CONTAINER" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$BACKUP_PATH/wordpress_db_$(date +%Y%m%d%H%M%S).sql"

echo "Backup completed and saved to $BACKUP_PATH."

