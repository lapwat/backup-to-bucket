#!/usr/bin/env sh

# check that an argument was given
if [[ "$#" -eq 0 ]]; then
  printf 'You must specify an action.\nUsage: docker run --network=none ghcr.io/lapwat/backup-to-bucket backup|restore\n' >&2
  exit
fi

action=$1

case "${action}" in
    backup) ./backup.sh;;
    restore) ./restore.sh;;
    *)
        printf "Unknown action: %s\n" "${action}"
        printf 'Allowed actions: backup restore\n'
        exit
esac
