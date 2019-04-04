#!/bin/bash

pid=$(ps -ax | grep jekyll | grep -v grep | cut -d' ' -f1)

if [ ! -z "$pid" ]; then 
echo "jekyll is running, killing it..."
kill $pid
else 
echo "jekyll not running, bye"
fi

