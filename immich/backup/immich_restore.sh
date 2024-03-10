#!/bin/sh
# immich restore script
docker compose down -v  # CAUTION! Deletes all Immich data to start from scratch.
docker compose pull     # Update to latest version of Immich (if desired)
docker compose create   # Create Docker containers for Immich apps without running them.
docker start immich_postgres    # Start Postgres server
sleep 10    # Wait for Postgres server to start up
#gunzip < "/mnt/aggr1/backup/immich/db/dump.sql.gz" | docker exec -i immich_postgres psql -U postgres -d immich    # Restore Backup
gunzip < "/mnt/aggr1/backup/immich/db/dump.sql.gz" | \
  sed "s/SELECT pg_catalog.set_config('search_path', '', false);/SELECT pg_catalog.set_config('search_path', 'public, pg_catalog', true);/g" | \
  docker exec -i immich_postgres psql -U postgres -d immich    # Restore Backup
docker compose up -d    # Start remainder of Immich apps