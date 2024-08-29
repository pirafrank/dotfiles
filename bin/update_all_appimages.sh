#!/bin/sh

# per each folder in $PATH, look for AppImage files and update them

if ! command -v appimageupdatetool > /dev/null ; then
  echo "Error: appimageupdatetool not found. Install it and try again. Aborting."
  exit 1
fi

update() {
    folder="$1"
    echo "Checking $folder for AppImage files..."
    for appimage in "$folder"/*.[aA]pp[iI]mage; do
        if [ -f "$appimage" ]; then
            printf "\n\nUpdating %s\n" "$appimage"
            appimageupdatetool -O "$appimage"
        fi
    done
}

original_IFS="$IFS"
IFS=":"
for path in $PATH; do
    if [ -d "$path" ]; then
        update "$path"
    fi
done
IFS="$original_IFS"
