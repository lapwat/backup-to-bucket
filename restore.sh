#!/usr/bin/env sh

backup_name=${BACKUP_NAME}

# download
mc cp --recursive "objectstorage/${BUCKET_NAME}/${backup_name}" .

# decrypt
if [[ ! -z "${AGE_PRIVATE_KEY}" ]]; then
    printf '%s' "${AGE_PRIVATE_KEY}" > key.txt
    plain_name="${backup_name%.*}"
    age --decrypt --identity key.txt "${backup_name}" > "${plain_name}"
    backup_name="${plain_name}"
fi

# extract
if [[ "${EXTRACT}" = true ]]; then
    gunzip "${backup_name}"
    backup_name="${backup_name%.*}"
fi

# restore
case "${BACKUP_TYPE}" in
    FILE)
        tar --extract --file "${backup_name}" --directory "${RESTORE_DIRECTORY}"
        ;;
    MYSQL)
        mysql --host="${DATABASE_HOST}" --port="${DATABASE_PORT}" --user="${DATABASE_USER}" --password="${DATABASE_PASSWORD}" --dbname="${DATABASE_NAME}" < "${backup_name}"
        ;;
    POSTGRES)
        PGPASSWORD="${DATABASE_PASSWORD}" psql --host="${DATABASE_HOST}" --port="${DATABASE_PORT}" --username="${DATABASE_USER}" --no-password --dbname="${DATABASE_NAME}" < "${backup_name}"
        ;;
    *)
        printf 'Unknown restore type: %s\n' "${BACKUP_TYPE}"
        printf 'Allowed restore types: FILE MYSQL POSTGRES\n'
        exit
esac
