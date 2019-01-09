#!/bin/bash

# Simple script to parse JPG photo filename and set exif datetime, 
# creation date and file modification date accordingly. 
# Filename pattern is YYYYMMDD_hhmmss. 
# Timezone is taken by your PC.

if [ -z "$1" ]; then
  echo "Error: no folder argument given. Exiting..."
  exit 1
fi

if [ ! -d "$1" ]; then
  echo "Error: given folder doesn't exist. Exiting..."
  exit 1
fi

dirpath="$1"
cd "$dirpath"
echo "Working in dir: $dirpath"

for file in $(ls -1A *.JPEG *.jpeg *.jpg *.JPG  2>/dev/null);
do

  echo "Working on: $file ..."

  year=$(echo "$file" | cut -c1-4)
  month=$(echo "$file" | cut -c5-6)
  day=$(echo "$file" | cut -c7-8)

  hour=$(echo "$file" | cut -c10-11)
  mins=$(echo "$file" | cut -c12-13)
  secs=$(echo "$file" | cut -c14-15)

  arg2="$year:$month:$day $hour:$mins:$secs"

  # from exiftool docs:
  # "Since the Geotime tag is not specified, the value of DateTimeOriginal 
  # is used for geotagging. Local system time is assumed unless 
  # DateTimeOriginal contains a timezone."
  
  #exiftool -overwrite_original -DateTimeOriginal="$arg2" "$file"
  #exiftool -overwrite_original -DateTimeOriginal="$arg2" -filemodifydate="$arg2" -createdate="$arg2" -modifydate="$arg2" "$file"
  
  # if datetimeoriginal is missing, is empty or contains only spaces, set datetimeoriginal from data parsed from filename
  exiftool -if 'not defined $datetimeoriginal or $datetimeoriginal =~ /(^\s*$)/' \
  -overwrite_original -DateTimeOriginal="$arg2" -filemodifydate="$arg2" \
  -FileCreateDate="$arg2" -createdate="$arg2" -modifydate="$arg2" "$file"

  # if datetimeoriginal is set, set file modification and file creation dates to datetimeoriginal value
  exiftool -if 'defined $datetimeoriginal and not $datetimeoriginal =~ /(^\s*$)/' \
  "-FileCreateDate<DateTimeOriginal" "-FileModifyDate<DateTimeOriginal" "$file"
  
done

echo "Job finished,"
echo "Bye!"

