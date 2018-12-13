#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ./script.sh [bitmap_file]"
  exit 1
fi

filename="$1"

convert "$filename" "$filename"".ppm"
potrace -s "$filename"".ppm" -o "$filename"".svg"

