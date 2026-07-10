#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: $0 INPUT_IMAGE [OUTPUT_IMAGE]"
    echo "It will output an image resized to a maximum width of 1200 px, preserving the aspect ratio."
    exit 1
fi

input="$1"

if [[ ! -f "$input" ]]; then
    echo "Error: input file does not exist: $input" >&2
    exit 1
fi

if ! command -v magick >/dev/null 2>&1; then
    echo "Error: ImageMagick is not installed or 'magick' is not in PATH." >&2
    exit 1
fi

if [[ $# -eq 2 ]]; then
    output="$2"
else
    directory="$(dirname "$input")"
    filename="$(basename "$input")"
    extension="${filename##*.}"
    basename="${filename%.*}"
    output="${directory}/${basename}-1200.${extension}"
fi

width="$(magick identify -format '%w' "$input")"

if (( width > 1200 )); then
    # Width is fixed at 1200 px. Height is calculated automatically
    # to preserve the original aspect ratio.
    magick "$input" \
        -auto-orient \
        -resize '1200x' \
        "$output"

    echo "Resized: $input -> $output"
else
    # Do not enlarge images that are already 1200 px wide or smaller.
    magick "$input" \
        -auto-orient \
        "$output"

    echo "Image is already ${width}px wide; copied without enlargement: $output"
fi

