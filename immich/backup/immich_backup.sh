#!/bin/sh
# immich backup script

docker exec -t immich_postgres pg_dumpall -c -U postgres | gzip > "/mnt/aggr1/backup/immich/db/dump.sql-$(date +%Y%m%d).gz"
find /mnt/aggr1/backup/immich/db/* -mtime +31 -delete
rsync /mnt/raid1/docker/immich/library/ -avhP /mnt/aggr1/backup/immich
rsync /mnt/raid1/docker/immich/upload/ -avhP /mnt/aggr1/backup/immich

#    UPLOAD_LOCATION/profile