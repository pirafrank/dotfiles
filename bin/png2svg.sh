#!/bin/bash

# this script allows to convert PNG images with alpha channels to SVG.
# using convert from imagemagick would cause a black image out of potrace.
# more info and credits here: https://stackoverflow.com/questions/32779584/png-with-alpha-transparency-to-svg-with-potrace

if [ -z "$1" ]; then
  echo "Usage: ./script.sh [png_file]"
  exit 1
fi

filename="$1"

if [ -z $(command -v potrace)]; then
echo "'potrace' command not found. Please install potrace first".
exit 1
fi

if [ -z $(command -v convert)]; then
echo "'pngtopnm' command not found. Please install netpbm first".
exit 1
fi

pngtopnm -mix "$filename"".png" > "$filename"".pnm"
potrace "$filename"".pnm" -s -o "$filename"".svg"
