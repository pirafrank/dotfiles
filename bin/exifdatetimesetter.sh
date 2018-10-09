#!/bin/bash

# Simple script to parse JPG photo filename and set exif datetime, 
# creation date and file modification date accordingly. 
# Filename pattern is YYYYMMDD_hhmmss. 
# Timezone is taken by your PC.

# exec this script by searching for .JPG and .jpg files in given folder
# find . -type f -name "*.JPG" -o -name "*.jpg" -exec /path/to/exif_datetime_setter.sh {} \;

if [ -z "$1" ]; then
  echo "Error: no input file as argument. Exiting..."
  exit 1
fi

filepath="$1"

echo "Working on: $filepath ..."

filename="${1##*/}"

year=$(echo "$filename" | cut -c1-4)
month=$(echo "$filename" | cut -c5-6)
day=$(echo "$filename" | cut -c7-8)

hour=$(echo "$filename" | cut -c10-11)
mins=$(echo "$filename" | cut -c12-13)
secs=$(echo "$filename" | cut -c14-15)

arg2="$year:$month:$day $hour:$mins:$secs"

echo "Parsed data: $arg2"

# from exiftool docs:
# "If the Geotime tag is not specified, the value of DateTimeOriginal 
# is used for geotagging. Local system time is assumed unless 
# DateTimeOriginal contains a timezone."

# if datetimeoriginal is set, set file modification and file creation dates to datetimeoriginal value
#exiftool -if 'defined $datetimeoriginal and not $datetimeoriginal =~ /(^\s*$)/' \

exiftool -if 'defined $datetimeoriginal and not $datetimeoriginal =~ /(^\s*$)/' \
"-FileCreateDate<DateTimeOriginal" "-FileModifyDate<DateTimeOriginal" "$filepath"

# if datetimeoriginal is missing, is empty or contains only spaces, set datetimeoriginal from data parsed from filename
exiftool -if 'not defined $datetimeoriginal or $datetimeoriginal =~ /(^\s*$)/' \
-overwrite_original -DateTimeOriginal="$arg2" -filemodifydate="$arg2" \
-FileCreateDate="$arg2" -createdate="$arg2" -modifydate="$arg2" "$filepath"




