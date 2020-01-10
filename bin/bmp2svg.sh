#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ./script.sh [bitmap_file]"
  exit 1
fi

filename="$1"

if [ -z $(command -v potrace) ]; then
echo "'potrace' command not found. Please install potrace first".
exit 1
fi

if [ -z $(command -v convert) ]; then
echo "'convert' command not found. Please install imagemagick first".
exit 1
fi

convert "$filename" "$filename"".ppm"
potrace -s "$filename"".ppm" -o "$filename"".svg"

