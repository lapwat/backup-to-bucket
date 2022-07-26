# Backup to bucket

This Docker image let's you backup different types of data to a bucket using environment variables.

Actions performed by the script:
- create the backup
- create an archive of the backup
- create the bucket specified by `BUCKET_NAME` and `MC_HOST_object-storage` environment variables with transition and expiry lifecycle rules (if it does not exist yet)
- upload the archive to the bucket

## Run

```sh
docker build -t ghcr.io/lapwat/sql-backup-to-bucket .
docker run --env-file .env ghcr.io/lapwat/sql-backup-to-bucket
```

## Configuration

### Backup a file / folder

This configuration creates a `${BACKUP_PREFIX}_YYYYmmddHHMMSS.tar.gz` archive of a file or folder.

.env
```
BACKUP_TYPE=FILE
BACKUP_FILENAME=/etc/hosts
BACKUP_PREFIX=mybackup
MC_HOST_object-storage=https://<Access Key>:<Secret Key>@<YOUR-S3-ENDPOINT>
BUCKET_NAME=mybucket
BUCKET_TRANSITION_DAYS=7
BUCKET_TRANSITION_STORAGE_CLASS=GLACIER
BUCKET_EXPIRY_DAYS=90
```

### Backup a database

This configuration creates a `${BACKUP_PREFIX}_YYYYmmddHHMMSS.sql.gz` archive of a mysql database.

.env
```
BACKUP_TYPE=MYSQL
DATABASE_HOST=localhost
DATABASE_PORT=3306
DATABASE_USER=root
DATABASE_PASSWORD=password
DATABASE_NAME=mydatabase
BACKUP_PREFIX=mybackup
MC_HOST_objectstorage=https://<Access Key>:<Secret Key>@<YOUR-S3-ENDPOINT>
BUCKET_NAME=mybucket
BUCKET_TRANSITION_DAYS=7
BUCKET_TRANSITION_STORAGE_CLASS=GLACIER
BUCKET_EXPIRY_DAYS=90
```
