#!/bin/sh
# wordpress backup script for snand.org
#
# Load environment variables from .env file
set -a
source ../.env
set +a
# Backup the WordPress database
docker exec wordpressdb sh -c 'exec mysqldump -u"$MYSQL_DATABASE_USER_NAME" -p"$MYSQL_DATABASE_PASSWORD" wordpress' | gzip > "wp_backup_$(date +%Y%m%d).sql.gz"

