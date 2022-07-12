# SQL backup to bucket

This Docker image let's you backup an SQL database using environment variables.

Actions performed by the script:
- create a backup of the database: `${BACKUP_PREFIX}_YYYYmmddHHMMSS.sql`
- create the bucket specified by `BUCKET_NAME` and `MC_HOST_object-storage` environment variables with trantion and expiry lffecycle rules (if it does not exist yet)
- upload the backup to the bucket

# Configure database and bucket access

.env
```
DATABASE_HOST=localhost
DATABASE_PORT=3306
DATABASE_USER=root
DATABASE_PASSWORD=password
DATABASE_NAME=mydatabase
BACKUP_PREFIX=mybackup
MC_HOST_object-storage=https://<Access Key>:<Secret Key>@<YOUR-S3-ENDPOINT>
BUCKET_NAME=mybucket
BUCKET_TRANSITION_DAYS=7
BUCKET_TRANSITION_STORAGE_CLASS=GLACIER
BUCKET_EXPIRY_DAYS=90
```

# Run

```sh
docker build -t ghcr.io/lapwat/sql-backup-to-bucket .
docker run --env-file .env ghcr.io/lapwat/sql-backup-to-bucket
```