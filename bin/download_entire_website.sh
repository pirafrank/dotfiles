#!/bin/bash

if [[ $# != 2 ]]; then
echo "Error: wrong number of arguments"
echo ""
echo "Usage: ./download-entire-website.sh <domain> <url>"
echo "Example ./download-entire-website.sh websitetodownload.com www.websitetodownload.com/page/"
echo ""
exit -1
fi

wget --recursive --no-clobber --page-requisites --html-extension --convert-links --restrict-file-names=windows --domain "$1" --no-parent "$2"

# Credits to techotopia.