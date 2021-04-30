#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 tar_archive_name volume_name"
  exit 1
fi

tararchive="$1"
volname="$2"

docker volume rm $volname
docker volume create $volname

src="$(pwd)"
dest="$volname"

docker run --rm -it \
           -v $src:/from \
           -v $dest:/to \
           alpine ash -c "cd /from ; tar -xzf $tararchive -C /to/"

echo "Done."

