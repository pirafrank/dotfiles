#!/bin/bash

file="$1"

magick "${file}" -resize '1280x>' -quality 90 "${file%.png}-1280.jpg"
magick "${file}" -resize '960x>' -quality 90 "${file%.png}-960.jpg"
magick "${file}" -resize '640x>' -quality 90 "${file%.png}-640.jpg"

