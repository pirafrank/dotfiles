#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 tar_archive_name volume_name"
  exit 1
fi

tararchive="$1"
volname="$2"
BASEDIR="$HOME/docker_vol_exports"

mkdir -p "$BASEDIR"
if [[ -f " $BASEDIR/$tararchive" ]]; then
	echo 'removing old export'
	rm -rf "$BASEDIR/$tararchive"
fi

echo 'creating new dir'
mkdir -p $BASEDIR

echo 'exporting data to tar archive'
src="$volname"
dest="$BASEDIR"

docker run --rm -it \
           -v $src:/from \
           -v $dest:/to \
           alpine ash -c "cd /from ; tar -czf /to/$tararchive ."

echo "Volume $volname has been exported to $BASEDIR"

