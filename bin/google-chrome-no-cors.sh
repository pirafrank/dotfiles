#!/bin/bash
if [ ! -d "/home/$(whoami)/temp-google-chrome" ]; then
  mkdir -p "/home/$(whoami)/temp-google-chrome"
fi
google-chrome --disable-web-security --user-data-dir="/home/$(whoami)/temp-google-chrome"

