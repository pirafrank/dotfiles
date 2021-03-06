#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Please specify an image version to run."
    echo "You can optionally add parameters to 'docker run' as \$2."
    echo "\$3 is to enable DOCKERCLI socket, optional. It can be anything, just not blank."
    exit 1
fi

PARAMS="$2"

# add a default name if none provided
if [[ $PARAMS != *"--name "* ]]; then
  PARAMS="--name workspace $PARAMS"
fi

# if $3 is present, add value to DOCKERCLI
DOCKERCLI="" && [[ $3 != "" ]] && DOCKERCLI="-v /var/run/docker.sock:/var/run/docker.sock"

mkdir -p $HOME/work_temp/Code
mkdir -p $HOME/work_temp/secrets

docker run -it $PARAMS $DOCKERCLI \
-v $HOME/work_temp/Code:/home/work/Code \
-v $HOME/work_temp/secrets:/home/work/secrets \
-p "8380-8390:8080-8090" \
-p "4300-4310:4000-4010" \
-p "3300-3310:3000-3010" \
pirafrank/workspace:"$1"


