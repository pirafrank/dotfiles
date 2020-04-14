#!/bin/bash
file="$1"
if [[ ! -z $file ]] || [[ -f $file ]]; then
  bash "$1"
else
  echo "Error: no vs_code_restore_extensions.sh file found in folder."
  echo "Please copy the file here before executing this script. Exiting..."
  exit 1
fi
