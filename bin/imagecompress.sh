#!/bin/bash

# one argument given, assume is path, default quality 
if [[ $# == 1 ]]; then
WORKDIR="${1%/}"
QUALITY=85
# two args given, 1st is quality, 2nd is path
elif [[ $# == 2 ]]; then
QUALITY="$1"
WORKDIR="${2%/}"
else 
echo "Error: no rightnumber of args given. Exiting..."
exit 1
fi

cd "$WORKDIR"
if [[ ! ./ -ef $WORKDIR ]]; then
  echo "Error: cannot open given dir ($WORKDIR). Exiting..."
  exit 1
fi

# creating ./output folder as subdir of input
mkdir "$WORKDIR"/output
if [ ! -d "$WORKDIR"/output ];then
    echo "Error: cannot create output folder. Exiting..."
    exit 1
fi

# shrinking image and setting modification date to shot time
for f in *.jpg *.JPG *.jpeg *.JPEG
do
  echo "Processing $f ..."
  fullname=$(basename "$f")
  extension="${fullname##*.}"
  filename="${fullname%.*}"
  #convert -format "jpg" -quality 85 $f output/"$filename""_lite.""$extension"
  convert -format "jpg" -quality "$QUALITY" $f output/"$filename""_lite.""$extension"
  exiftool "-filemodifydate<datetimeoriginal" output/"$filename""_lite.""$extension"
  #exiftool -overwrite_original_in_place -tagsFromFile $f output/"$filename""_lite.""$extension"
done

### output exif data to shell
# identify -format "%[EXIF:*]" $SOURCE
# exiftool -s
