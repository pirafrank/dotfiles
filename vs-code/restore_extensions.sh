#!/bin/bash
if [[ -f vs_code_restore.sh ]]; then
  bash vs_code_restore.sh
else
  echo "Error: no vs_code_restore.sh file found."
  echo "Please copy the file here before executing this script. Exiting..."
  exit 1
fi
