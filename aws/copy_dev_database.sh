#!/bin/bash

SOURCE_DB_HOST="add-new-mexico-state-policy-b7ucs6kb-db.c1xjnpy2aknr.us-west-2.rds.amazonaws.com"
SOURCE_DB_PORT="5432"
SOURCE_DB_NAME="ourpetpolicy"
SOURCE_DB_USER="postgres"
SOURCE_DB_PASSWORD=$1

TARGET_DB_HOST="dev-xuj0ouyv-db.c1xjnpy2aknr.us-west-2.rds.amazonaws.com"
TARGET_DB_PORT="5432"
TARGET_DB_NAME="ourpetpolicy"
TARGET_DB_USER="postgres"
TARGET_DB_PASSWORD=$2

DUMP_FILE="./source_db_dump.sql"


echo "downloading database: $SOURCE_DB_HOST"

# Export data from the source database
export PGPASSWORD=$SOURCE_DB_PASSWORD
# # pg_dump -h $SOURCE_DB_HOST -p $SOURCE_DB_PORT -U $SOURCE_DB_USER -F p -d $SOURCE_DB_NAME > "$DUMP_FILE"
pg_dump -h $SOURCE_DB_HOST -p $SOURCE_DB_PORT -U $SOURCE_DB_USER -F c -d $SOURCE_DB_NAME -f "$DUMP_FILE"

# echo "yo"

if [ $? -eq 0 ]; then
    echo "uploading database: $TARGET_DB_HOST"

    # Prepare to import data: Disable FK constraints on the target database
    export PGPASSWORD=$TARGET_DB_PASSWORD
    # psql -h $TARGET_DB_HOST -p $TARGET_DB_PORT -U $TARGET_DB_USER -d $TARGET_DB_NAME -c "SET session_replication_role = 'replica';"
    # psql -h $TARGET_DB_HOST -p $TARGET_DB_PORT -U $TARGET_DB_USER -d $TARGET_DB_NAME -f "$DUMP_FILE"
    # pg_restore: Disable FK constraints and use single transaction for atomicity
    # pg_restore -h $TARGET_DB_HOST -p $TARGET_DB_PORT -U $TARGET_DB_USER -d $TARGET_DB_NAME --no-owner --role=$TARGET_DB_USER --single-transaction -v "$DUMP_FILE"
    pg_restore --clean  --if-exists  -h $TARGET_DB_HOST -p $TARGET_DB_PORT -U $TARGET_DB_USER -d $TARGET_DB_NAME --no-owner --role=$TARGET_DB_USER --single-transaction -v "$DUMP_FILE"

    if [ $? -eq 0 ]; then
        echo "Data import successful!"
    else
        echo "Data import failed."
    fi
    # psql -h $TARGET_DB_HOST -p $TARGET_DB_PORT -U $TARGET_DB_USER -d $TARGET_DB_NAME -c "SET session_replication_role = 'origin';"

else
    echo "Data export failed."
fi

# Cleanup
unset PGPASSWORD
# rm -f "$DUMP_FILE"
