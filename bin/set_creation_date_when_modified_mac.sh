#!/bin/bash

cd "$1"

# set file creation date (create date) the same as file modification date in macOS
for f in *; do t="$(GetFileInfo -m "$f")"; SetFile -d "$t" "$f"; done
