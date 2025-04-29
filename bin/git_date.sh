#!/usr/bin/env zsh

# Script to set GIT_AUTHOR_DATE and GIT_COMMITTER_DATE at earlier datetime

# Function to show usage
usage() {
    echo "Usage: source ./$0 [-N] OR ./$0 unset"
    echo "  -N: Sets dates to N hours ago in format '2024-01-01T00:00:00 +0200'"
    echo "  'unset': Unsets GIT_AUTHOR_DATE and GIT_COMMITTER_DATE"
    exit 1
}

if [[ $# -lt 1 ]] || [[ $# -gt 2 ]]; then
    usage
elif [[ "$1" -eq "unset" ]]; then
    # No arguments, unset the variables
    unset GIT_AUTHOR_DATE
    unset GIT_COMMITTER_DATE
    echo "Git date variables unset."
elif [[ "$1" =~ ^-[0-9]+$ ]]; then
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

    # Export the variables
    export GIT_AUTHOR_DATE="$formatted_date"
    export GIT_COMMITTER_DATE="$formatted_date"

    # Output
    echo "Git dates set to $formatted_date (${hours_ago} hours ago)"
    echo GIT_AUTHOR_DATE=$GIT_AUTHOR_DATE
    echo GIT_COMMITTER_DATE=$GIT_COMMITTER_DATE
else
    usage
fi
