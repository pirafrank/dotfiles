#!/usr/bin/env bash

set -euo pipefail

MAX_WIDTH=1200
MAX_SIZE=$((500 * 1024)) # 500 KiB
MIN_QUALITY=35
MIN_WIDTH=400
SUFFIX="social"

usage() {
    echo "Usage: $0 INPUT_IMAGE [OUTPUT_IMAGE]"
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
    usage
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

    if [[ "$filename" == *.* ]]; then
        extension="${filename##*.}"
        basename="${filename%.*}"
        output="${directory}/${basename}-${SUFFIX}.${extension}"
    else
        output="${directory}/${filename}-${SUFFIX}.jpg"
    fi
fi

input_abs="$(realpath "$input")"
output_abs="$(realpath -m "$output")"

if [[ "$input_abs" == "$output_abs" ]]; then
    echo "Error: input and output paths must be different." >&2
    exit 1
fi

mkdir -p "$(dirname "$output")"

tmp_directory="$(mktemp -d)"
trap 'rm -rf "$tmp_directory"' EXIT

working="$tmp_directory/working.miff"

get_size() {
    stat -c '%s' "$1"
}

human_size() {
    numfmt --to=iec-i --suffix=B "$1"
}

format="$(magick identify -format '%m' "$input" | head -n 1)"
width="$(magick identify -format '%w' "$input" | head -n 1)"

echo "Input: ${width}px wide, $(human_size "$(get_size "$input")"), format ${format}"

#
# Pass 1: auto-orient and resize only when wider than 1200 px.
#
magick "$input" \
    -auto-orient \
    -resize "${MAX_WIDTH}x>" \
    "$working"

write_lossy_candidate() {
    local source="$1"
    local destination="$2"
    local quality="$3"

    case "${format^^}" in
        JPEG|JPG)
            magick "$source" \
                -strip \
                -sampling-factor 4:2:0 \
                -interlace Plane \
                -quality "$quality" \
                "$destination"
            ;;

        WEBP)
            magick "$source" \
                -strip \
                -define webp:method=6 \
                -quality "$quality" \
                "$destination"
            ;;

        AVIF|HEIC)
            magick "$source" \
                -strip \
                -quality "$quality" \
                "$destination"
            ;;

        *)
            magick "$source" \
                -strip \
                -quality "$quality" \
                "$destination"
            ;;
    esac
}

write_png_candidate() {
    local source="$1"
    local destination="$2"

    magick "$source" \
        -strip \
        -define png:compression-level=9 \
        -define png:compression-strategy=1 \
        -define png:exclude-chunk=all \
        "$destination"
}

finish() {
    local file="$1"

    mv "$file" "$output"

    local final_width
    local final_height
    local final_size

    final_width="$(magick identify -format '%w' "$output")"
    final_height="$(magick identify -format '%h' "$output")"
    final_size="$(get_size "$output")"

    echo "Output: ${final_width}x${final_height}, $(human_size "$final_size")"
    echo "Saved to: $output"
}

#
# PNG path: preserve full color and alpha.
# Only reduce dimensions when lossless compression is insufficient.
#
if [[ "${format^^}" == "PNG" ]]; then
    current_width="$(magick identify -format '%w' "$working")"

    while true; do
        candidate="$tmp_directory/png-${current_width}.png"

        write_png_candidate "$working" "$candidate"

        candidate_size="$(get_size "$candidate")"

        echo "PNG attempt: ${current_width}px wide, $(human_size "$candidate_size")"

        if (( candidate_size <= MAX_SIZE )); then
            finish "$candidate"
            exit 0
        fi

        next_width=$((current_width * 90 / 100))

        if (( next_width < MIN_WIDTH )); then
            echo "Error: could not reduce PNG below $(human_size "$MAX_SIZE")" >&2
            echo "Last attempt: $(human_size "$candidate_size") at ${current_width}px wide" >&2
            exit 1
        fi

        current_width="$next_width"

        magick "$working" \
            -filter Lanczos \
            -resize "${current_width}x>" \
            "$tmp_directory/scaled.miff"

        mv "$tmp_directory/scaled.miff" "$working"
    done
fi

#
# Lossy formats: reduce quality first, then dimensions if necessary.
#
quality=90
current_width="$(magick identify -format '%w' "$working")"

while true; do
    candidate="$tmp_directory/candidate.${output##*.}"

    write_lossy_candidate "$working" "$candidate" "$quality"

    candidate_size="$(get_size "$candidate")"

    echo "Attempt: ${current_width}px wide, quality ${quality}, $(human_size "$candidate_size")"

    if (( candidate_size <= MAX_SIZE )); then
        finish "$candidate"
        exit 0
    fi

    if (( quality > MIN_QUALITY )); then
        quality=$((quality - 5))
        continue
    fi

    next_width=$((current_width * 90 / 100))

    if (( next_width < MIN_WIDTH )); then
        echo "Error: could not reduce image below $(human_size "$MAX_SIZE")" >&2
        echo "Last attempt: $(human_size "$candidate_size") at ${current_width}px wide" >&2
        exit 1
    fi

    current_width="$next_width"
    quality=85

    magick "$working" \
        -filter Lanczos \
        -resize "${current_width}x>" \
        "$tmp_directory/scaled.miff"

    mv "$tmp_directory/scaled.miff" "$working"
done

