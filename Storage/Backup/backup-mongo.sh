#!/bin/bash

# Variables
STORAGE_ACCOUNT="mongodbbackupstestje"
CONTAINER_NAME="backups"
SOURCE_DIR="/tmp/archive"
TARGET_DIR="/tmp/mongodump"
URI='$MONGO_URI'

# Create DIR
mkdir $TARGET_DIR
mkdir $SOURCE_DIR

# Create backup
mongodump --uri="$URI" --archive="$TARGET_DIR/dump_$(date +%Y%m%d%h).txt" --db=employees --collection=employees

# Copy files
mv $TARGET_DIR/* $SOURCE_DIR

# Authenticate via Managed Identity
az login --identity

# Upload all files in SOURCE_DIR
az storage blob upload-batch \
  --account-name $STORAGE_ACCOUNT \
  --destination $CONTAINER_NAME \
  --source $SOURCE_DIR \
  --overwrite

# Clean up folder
rm -rf $SOURCE_DIR
rm -rf $TARGET_DIR
