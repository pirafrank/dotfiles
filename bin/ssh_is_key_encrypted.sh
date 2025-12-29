#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Check if an SSH private key is encrypted."
    echo "Usage: $0 <private_key_file>"
    exit 1
fi

KEYFILE="$1"

# we check by trying to extract the public key without a passphrase
# and see if it succeeds or not.
ssh-keygen -y -P "" -f ${KEYFILE} > /dev/null 2>&1 \
    && echo "${KEYFILE} is NOT encrypted" \
    || echo "${KEYFILE} is encrypted"

