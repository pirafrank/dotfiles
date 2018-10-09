#!/bin/bash

convert -format "jpg" -quality 90 -strip -resize 25% "$1" "$1_lite".jpg

