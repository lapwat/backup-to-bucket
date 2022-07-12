#!/bin/sh

backup_name="${BACKUP_PREFIX}_$(date +%Y%m%d%H%M%S).sql"
mysqldump --opt --single-transaction --host=${DATABASE_HOST} --user=${DATABASE_USER} --password=${DATABASE_PASSWORD} --databases ${DATABASE_NAME} > "${backup_name}"

mc mb "objectstorage/${BUCKET_NAME}"
if [ $? -eq 0 ]; then
    # bucket was just created, we create lifecycle rules
    mc ilm add --transition-days=${BUCKET_TRANSITION_DAYS} --storage-class=${BUCKET_TRANSITION_STORAGE_CLASS} "objectstorage/${BUCKET_NAME}"
    mc ilm add --expiry-days=${BUCKET_EXPIRY_DAYS} "objectstorage/${BUCKET_NAME}"
fi
mc cp "${backup_name}" "objectstorage/${BUCKET_NAME}"