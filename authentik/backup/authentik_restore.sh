#!/bin/sh
# Authentik restore script
# presently non-functional
#
# Docker container name for the PostgreSQL database
DB_CONTAINER_NAME="authentik-postgresql"
# Filename for the backup
BACKUP_FILENAME="authentik_db_dump_$(date +%Y%m%d).sql.gz"

docker compose down -v  # CAUTION! Deletes all data to start from scratch.
docker compose pull     # Update to latest version
docker compose create   # Create Docker containers without running them.
docker start "$DB_CONTAINER_NAME"    # Start Postgres server
sleep 10    # Wait for Postgres server to start up
gunzip < "$BACKUP_FILENAME" | docker exec -i $DB_CONTAINER_NAME psql -U postgres -d authentik    # Restore Backup
docker compose up -d    # Start remainder of apps