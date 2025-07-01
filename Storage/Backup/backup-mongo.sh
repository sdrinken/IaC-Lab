#!/bin/bash

# Variables
STORAGE_ACCOUNT="mongodbbackupstestje"
CONTAINER_NAME="backups"
TARGET_DIR="/tmp/mongodump"
URI=${{ secrets.MONGO_URI }}

# Create DIR
sudo mkdir $TARGET_DIR

# Create backup
mongodump --uri="$URI" --archive="$TARGET_DIR/dump_$(date +%Y%m%d%h).txt" --db=employees --collection=employees

# Authenticate via Managed Identity
az login --identity

# Upload all files in SOURCE_DIR
az storage blob upload-batch \
  --account-name $STORAGE_ACCOUNT \
  --destination $CONTAINER_NAME \
  --source $TARGET_DIR \
  --overwrite

# Clean up folder
sudo rm -rf $TARGET_DIR
