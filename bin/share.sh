#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: no arguments given"
    echo "Usage: ./share.sh file1 file2 file3 etc."
    exit 1
fi

# Script variables
basepath="/var/www/sharing.example.com"
dirname="$(cat /dev/random | LC_CTYPE=C tr -dc \"[:alpha:]0-9\" | head -c 256 | sha256sum | sha256sum | cut -d' ' -f1)"
baseurl="https://sharing.example.com/"

# Script body
if [ ! -d "$basepath" ]; then
  echo "Error: $basepath doesn't exist. Have you customized script variables?"
  exit 1
fi

printf "\nCreating new folder with random name..."
mkdir -p "$basepath/$dirname"

printf "\n\nUrls are:"
for arg
do printf "\n%s%s" "$baseurl" "$dirname"
done

printf "\n\nSFTP commands are:"
for arg
do printf "\nscp %s %s@%s:%s/%s/%s" "$arg" "$(whoami)" "$(hostname)" "$basepath" "$dirname" "$arg"
done
printf "\n\n"

