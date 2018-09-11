#!/bin/bash
if [[ -f vs_code_restore.sh ]]; then
  bash vs_code_restore_extensions.sh
else
  echo "Error: no vs_code_restore_extensions.sh file found in folder."
  echo "Please copy the file here before executing this script. Exiting..."
  exit 1
fi
