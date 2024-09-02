#!/bin/sh
# wordpress restore script for snand.org
#
# this is non-functional - do not use
#
docker exec -i NEW_CONTAINER_NAME sh -c 'exec mysql -u"$MARIADB_USER" -p"$MARIADB_PASSWORD" "$MARIADB_DATABASE"' < backup_db.sql
