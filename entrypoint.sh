#!/bin/sh

# create backup
backup_name="${BACKUP_PREFIX}_$(date +%Y%m%d%H%M%S)"
case "${BACKUP_TYPE}" in
    MYSQL)
        backup_name="${backup_name}.sql"
        mysqldump --opt --single-transaction --host="${DATABASE_HOST}" --port="${DATABASE_PORT}" --user="${DATABASE_USER}" --password="${DATABASE_PASSWORD}" --databases "${DATABASE_NAME}" > "${backup_name}"
        ;;
    POSTGRES)
        backup_name="${backup_name}.sql"
        PGPASSWORD="${DATABASE_PASSWORD}" pg_dump --host="${DATABASE_HOST}" --port="${DATABASE_PORT}" --username="${DATABASE_USER}" --no-password "${DATABASE_NAME}" > "${backup_name}"
        ;;
    FILE)
        backup_name="${backup_name}.tar"
        tar cf "${backup_name}" "${BACKUP_FILENAME}"
        ;;
    *)
        echo "Unknown backup type: ${BACKUP_TYPE}"
        echo 'Allowed backup types: MYSQL POSTGRES FILE'
        exit 1;;
esac

# compress backup
archive_name="${backup_name}.gz"
gzip "${backup_name}"

# create bucket
mc mb "objectstorage/${BUCKET_NAME}"

if [ $? -eq 0 ]; then
    # bucket was just created, we create lifecycle rules
    mc ilm add --transition-days=${BUCKET_TRANSITION_DAYS} --storage-class=${BUCKET_TRANSITION_STORAGE_CLASS} "objectstorage/${BUCKET_NAME}"
    mc ilm add --expiry-days=${BUCKET_EXPIRY_DAYS} "objectstorage/${BUCKET_NAME}"
fi

# upload archive
mc cp "${archive_name}" "objectstorage/${BUCKET_NAME}"