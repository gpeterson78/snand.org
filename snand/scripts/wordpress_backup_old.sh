#!/bin/sh
# wordpress backup script for snand.org
#
# Load environment variables from .env file
set -a
. ../.env
set +a
# Backup the WordPress database
docker exec wordpressdb sh -c 'exec mariadb-dump -u"wordpress" -p"--redacted--" wordpress' | gzip > wp_backup_$(date +%Y%m%d).sql.gz

docker exec wordpressdb sh -c "exec mariadb-dump -u'wordpress' -p'--redacted--' wordpress" | gzip > "wp_backup_$(date +%Y%m%d).sql.gz"
