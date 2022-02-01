#!/bin/bash

DEFAULT_DB_HOST=localhost
DEFAULT_DB_PORT=5432
DEFAULT_DB_USERNAME=postgres
DEFAULT_DB_NAME=postgres

usage () {
  echo "Export the following environment variables before running the script:"
  echo "    SOURCE_DB_PORT          (default = ${DEFAULT_DB_PORT})"
  echo "    SOURCE_DB_HOST          (default = ${DEFAULT_DB_HOST})"
  echo "    SOURCE_DB_USERNAME      (default = ${DEFAULT_DB_USERNAME})"
  echo "    SOURCE_DB_NAME          (default = ${DEFAULT_DB_NAME})"
  echo "    SOURCE_DB_PASSWORD      (no default)"
  echo "    DESTINATION_DB_PORT     (default = ${DEFAULT_DB_PORT})"
  echo "    DESTINATION_DB_HOST     (default = ${DEFAULT_DB_HOST})"
  echo "    DESTINATION_DB_USERNAME (default = ${DEFAULT_DB_USERNAME})"
  echo "    DESTINATION_DB_NAME     (default = ${DEFAULT_DB_NAME})"
  echo "    DESTINATION_DB_PASSWORD (no default)"
}

if [[ $1 == "-h" ]]; then
  usage
  exit 0
fi  

if [ -z "${SOURCE_DB_PORT}" ]; then
  SOURCE_DB_PORT=${DEFAULT_DB_PORT}
fi    

if [ -z "${SOURCE_DB_HOST}" ]; then
  SOURCE_DB_HOST=${DEFAULT_DB_HOST}
fi

if [ -z "${SOURCE_DB_USERNAME}" ]; then
  SOURCE_DB_USERNAME=${DEFAULT_DB_USERNAME}
fi

if [ -z "${SOURCE_DB_NAME}" ]; then
  SOURCE_DB_NAME=${DEFAULT_DB_NAME}
fi

if [ -z "${DESTINATION_DB_PORT}" ]; then
  DESTINATION_DB_PORT=${DEFAULT_DB_PORT}
fi

if [ -z "${DESTINATION_DB_HOST}" ]; then
  DESTINATION_DB_HOST=${DEFAULT_DB_HOST}
fi

if [ -z "${DESTINATION_DB_USERNAME}" ]; then
  DESTINATION_DB_USERNAME=${DEFAULT_DB_USERNAME}
fi

if [ -z "${DESTINATION_DB_NAME}" ]; then
  DESTINATION_DB_NAME=${DEFAULT_DB_NAME}
fi

DUMP_FILE_NAME="some-random-file-name.tar"

echo "Started source DB copying..."
export PGPASSWORD=${SOURCE_DB_PASSWORD}
pg_dump -F t -h ${SOURCE_DB_HOST} -p ${SOURCE_DB_PORT} -U ${SOURCE_DB_USERNAME} -f ${DUMP_FILE_NAME} ${SOURCE_DB_NAME}
echo "Completed source DB copying!!!"

echo "Started restoring..."
export PGPASSWORD=${DESTINATION_DB_PASSWORD}
pg_restore -h ${DESTINATION_DB_HOST} -p ${DESTINATION_DB_PORT} -U ${DESTINATION_DB_USERNAME} -c -d ${DESTINATION_DB_NAME}  ${DUMP_FILE_NAME} 
echo "Completed restoring!!!"

rm  ${DUMP_FILE_NAME}
