#!/bin/bash

# check platform
if [ $(uname) == 'Darwin' ]; then
    RAND_SRC='/dev/random'
elif [ $(uname) == 'Linux' ]; then
    RAND_SRC='/dev/urandom'
else
    echo "Unsupported platform"
    exit 3
fi

# check args
if [ $# -eq 0 ]; then
  echo 'Missing 1 arg (string length)'
  exit 1
elif [ $# -eq 1 ]; then
    LENGTH="$1"
    CHARS="[A-Za-z]0-9"
elif [[ ! -z "$2" && "$1" == '-l' ]]; then
    LENGTH="$2"
    CHARS="[a-z]0-9"
else
  echo "Use '-l' parameter for lowercase letters and numbers.
Current set of arguments is not supported."
  exit 2
fi

echo -e "$( cat $RAND_SRC | LC_CTYPE=C tr -dc "$CHARS" | head -c $LENGTH )"
