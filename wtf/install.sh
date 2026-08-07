#!/bin/sh

mkdir -p ~/.config/wtf

if [ -f ~/.config/wtf/config.yml ]; then
  echo "Config file already exists at ~/.config/wtf/config.yml"
  exit 1
fi

ln -s "$(pwd -P)/config.yml" ~/.config/wtf/config.yml

if [ -z "${WTF_GITHUB_TOKEN}" ]; then
  echo "Please set WTF_GITHUB_TOKEN environment variable to a personal access token with repo scope"
  echo "or set it to 'gh auth token'"
  exit 1
fi
