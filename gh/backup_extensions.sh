#!/bin/sh

filename="gh_extensions.txt"

rm -f "$filename"
gh extension list | tail -n +1 | awk '{print $3}' > "$filename"

