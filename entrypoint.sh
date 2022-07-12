#!/bin/sh
backup_name="${BACKUP_PREFIX}_$(date +%Y%m%d%H%M%S).sql"
mysqldump --opt --single-transaction --host=${DATABASE_HOST} --user=${DATABASE_USER} --password=${DATABASE_PASSWORD} --databases ${DATABASE_NAME} > "${backup_name}"
mc mb "objectstorage/${BUCKET_NAME}"
mc cp "${backup_name}" "objectstorage/${BUCKET_NAME}"