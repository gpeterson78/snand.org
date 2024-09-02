#!/bin/sh
# wordpress backup script for snand.org
#
# Load environment variables from .env file
set -a
. ../.env
set +a
# Backup the WordPress database
docker exec wordpressdb sh -c 'exec mariadb-dump -u"wordpress" -p"fstLOLDM59nOHAyYplR1bclBt5oqmERG31TCUW0vf3mZTUiH" wordpress' | gzip > wp_backup_$(date +%Y%m%d).sql.gz

docker exec wordpressdb sh -c "exec mariadb-dump -u'wordpress' -p'fstLOLDM59nOHAyYplR1bclBt5oqmERG31TCUW0vf3mZTUiH' wordpress" | gzip > "wp_backup_$(date +%Y%m%d).sql.gz"
