# Backup to bucket

This Docker image let's you create different types of backup and upload it to a bucket.

Backup types
- [x] file / folder `.tar`
- [x] MySQL `.sql`
- [x] PostgreSQL `.sql`

Transformations
- [x] compression `.gz`
- [x] encryption `.age`

Actions performed by the script:
- create the backup
- compress the backup (optional)
- encrypt the backup (optional)
- create the bucket based on `BUCKET_NAME` and `MC_HOST_object-storage` environment variables with transition and expiry lifecycle rules (if it does not exist yet)
- upload the archive to the bucket

## Run

```sh
docker build -t ghcr.io/lapwat/sql-backup-to-bucket .
docker run --env-file .env ghcr.io/lapwat/sql-backup-to-bucket
```

## Compression

Enable backup compression by setting `COMPRESS` environment variable to `true`.

Default: No compression

## Encryption

Enable backup encryption by setting `AGE_PUBLIC_KEY` environment variable.

Default: No encryption

### Decrypt the backup

```
age --decrypt -i key.txt CIPHER_NAME > BACKUP_NAME
```

## Configuration examples

### Backup a file / folder

This configuration creates a `${BACKUP_PREFIX}_YYYYmmddHHMMSS.tar.gz.age` archive of a file or folder.

.env
```
COMPRESS=true
AGE_PUBLIC_KEY=agexxx
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

This configuration creates a `${BACKUP_PREFIX}_YYYYmmddHHMMSS.sql.gz.age` archive of a mysql database.

.env
```
COMPRESS=true
AGE_PUBLIC_KEY=agexxx
BACKUP_TYPE=MYSQL|POSTGRES
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
