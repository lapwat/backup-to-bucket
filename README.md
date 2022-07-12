# SQL backup to bucket

This Docker image let's you backup an SQL database using environment variables.

Actions performed by the script:
- create a backup of the database: `${BACKUP_PREFIX}_YYYYmmddHHMMSS.sql`
- if it does not exist, create the bucket specified by `BUCKET_NAME` and `MC_HOST_object-storage` environment variables
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
BUCKET_NAME=mybucket
MC_HOST_object-storage=https://<Access Key>:<Secret Key>@<YOUR-S3-ENDPOINT>
```

# Run

```sh
docker run --env-file .env
```