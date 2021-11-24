#!/bin/bash

if [ -z "${ENCRYPTED_PASSWORD}" ]
then
  echo "Environment variable ENCRYPTED_PASSWORD is not set"
  exit 1
fi

if [ -z "${PGP_PRIVATE_KEY}" ]
then
  echo "Environment variable PGP_PRIVATE_KEY is not set"
  exit 1
fi

TMP_PRIVATE_KEY_FILE="tmp_private_key.pem"

echo "-----BEGIN PGP PRIVATE KEY BLOCK-----" > ${TMP_PRIVATE_KEY_FILE}
echo ${PGP_PRIVATE_KEY} >> ${TMP_PRIVATE_KEY_FILE}
echo "-----END PGP PRIVATE KEY BLOCK-----" >> ${TMP_PRIVATE_KEY_FILE}

gpg --import ${TMP_PRIVATE_KEY_FILE}

base64 --decode <<<${ENCRYPTED_PASSWORD} | gpg --openpgp --decrypt 

rm ${TMP_PRIVATE_KEY_FILE}
