#!/bin/bash
set -e

if [ -z "$MONGO_URI" ]; then
  echo "Error: MONGO_URI environment variable not set"
  exit 1
fi

if [ -z "$STORAGE_ACCOUNT" ] || [ -z "$STORAGE_KEY" ]; then
  echo "Error: Azure storage credentials not set"
  exit 1
fi

# Backup path and timestamp
BACKUP_DIR="/tmp/mongodump"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
ARCHIVE_FILE="employees_backup_$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR/archive"

# Create dump of employees collection
mongodump --uri="$MONGO_URI" --archive="$BACKUP_DIR/dump.archive" --gzip --collection=employees

mv "$BACKUP_DIR/dump.archive" "$BACKUP_DIR/archive/employees.archive.gz"

tar -czf "$BACKUP_DIR/$ARCHIVE_FILE" -C "$BACKUP_DIR/archive" .

# Upload to Azure Storage
az storage blob upload \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$STORAGE_KEY" \
  --container-name "backups" \
  --file "$BACKUP_DIR/$ARCHIVE_FILE" \
  --name "$ARCHIVE_FILE" \
  --overwrite

# Cleanup
rm -rf "$BACKUP_DIR"