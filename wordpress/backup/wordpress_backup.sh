#!/bin/sh
# wordpress backup script for snand.org
#
# this is non-functional - do not use
#
docker exec CONTAINER_NAME sh -c 'exec mysqldump -u"$MARIADB_USER" -p"$MARIADB_PASSWORD" "$MARIADB_DATABASE"' > backup_db.sql
