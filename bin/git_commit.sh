#!/usr/bin/env zsh

# A script to commit at a different datetime by setting
# GIT_AUTHOR_DATE and GIT_COMMITTER_DATE.

# Function to show usage
usage() {
    echo "Usage: ./$0 [-N] [commit message]"
    echo "  -N: Sets dates to N hours ago in format '2024-01-01T00:00:00 +0200'"
    exit 1
}

if [[ $# -ne 2 ]]; then
    usage
elif [[ "$1" =~ ^-[0-9]+$ ]] && [[ "$2" != "" ]]; then
    # Extract the number (hours ago)
    hours_ago=${1#-}

    # Get timezone offset in +HHMM format
    tz_offset=$(date +%z)

    if [[ $( uname ) == "Linux" ]]; then
        # Format date as required for GNU date (Linux)
        formatted_date=$(date -d "${hours_ago} hours ago" "+%Y-%m-%dT%H:%M:%S ${tz_offset}")
    elif [[ $( uname ) == "Darwin" ]]; then
        # Format date as required for BSD date (macOS)
        formatted_date=$(date -v-${hours_ago}H "+%Y-%m-%dT%H:%M:%S ${tz_offset}")
    fi

    # Commit with the provided message
    echo "Committing with git dates set to $formatted_date (${hours_ago} hours ago)"
    GIT_AUTHOR_DATE="$formatted_date" GIT_COMMITTER_DATE="$formatted_date" git commit -S -m "$2"
else
    usage
fi
