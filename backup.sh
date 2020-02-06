#!/bin/sh

if [ ! -d $(dirname "$BACKUP_FILE") ]
then
  mkdir -p $(dirname "$BACKUP_FILE")
fi

if [ $TIMESTAMP = true ]
then
  FINAL_BACKUP_FILE="$(echo "$BACKUP_FILE")_$(date "+%F-%H%M%S")"
else
  rm $BACKUP_FILE
  FINAL_BACKUP_FILE=$BACKUP_FILE
fi

/usr/bin/sqlite3 $DB_FILE ".backup $FINAL_BACKUP_FILE"
if [ $? -eq 0 ] 
then 
  echo "$(date "+%F %T") - Backup successfull, Uploading to Exoscale..."
  zip --encrypt -P $(cat /run/secrets/sqlite_encryptionpw) database.zip $FINAL_BACKUP_FILE
  python upload.py
  if [ $? -eq 0 ]
  then 
     echo "$(date "+%F %T") - Upload to Exoscale Successful." 
  else
     echo "Upload to Exoscale Failed." 
  fi
else
  echo "$(date "+%F %T") - Backup unsuccessfull"
fi

if [ ! -z $DELETE_AFTER ] && [ $DELETE_AFTER -gt 0 ]
then
  find $(dirname "$BACKUP_FILE") -name "$(basename "$BACKUP_FILE")*" -type f -mtime +$DELETE_AFTER -exec rm -f {} \; -exec echo "Deleted {} after $DELETE_AFTER days" \;
fi
