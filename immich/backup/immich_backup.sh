#!/bin/sh
# immich backup script

docker exec -t immich_postgres pg_dumpall -c -U postgres | gzip > "/mnt/aggr1/backup/immich/db/dump.sql-$(date +%Y%m%d).gz"
find /mnt/aggr1/backup/immich/db/* -mtime +31 -delete
rsync ../library/ -avhP /mnt/aggr1/backup/immich
rsync ../upload/ -avhP /mnt/aggr1/backup/immich