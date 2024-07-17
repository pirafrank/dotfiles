#!/bin/sh

####################### variables #######################

repo_url=""
pipeline_url=""
task_url=""

####################### functions #######################

extract_vars() {
    url="$1"
    # Check if the URL uses the SSH protocol
    if echo "$url" | grep -q "@"; then
        # Extract the repository path
        repo_path="${url#*:}"
        repo_path="${repo_path%.git}"

        # Convert the SSH URL to an HTTPS URL for different services
        if echo "$url" | grep -q "github.com:"; then
            repo_url="https://github.com/$repo_path"
            pipeline_url="$repo_url/actions"
            task_url="$repo_url/issues"
        elif echo "$url" | grep -q "gitlab.com:"; then
            repo_url="https://gitlab.com/$repo_path"
            pipeline_url="$repo_url/-/jobs"
            task_url="$repo_url/-/issues"
        elif echo "$url" | grep -qE "vs-ssh.visualstudio.com:|dev.azure.com:"; then
            repo_name=$(basename "$repo_path")
            repo_path="${repo_path%/*}"
            repo_path="${repo_path#*v3/}"
            # Azure DevOps SSH URLs have an extra 'v3' in the path
            base_url="https://dev.azure.com/${repo_path}"
            repo_url="$base_url/_git/$repo_name"
            pipeline_url="$base_url/_build"
            task_url="$base_url/_workitems"
        else
            # Custom hosting
            host="${url%@*}"
            host="${host#*:}"
            repo_url="https://$host/$repo_path"
            # falling back to repo url
            pipeline_url="$repo_url"
            task_url="$repo_url"
        fi
    else
        echo "Sorry, HTTP/S endpoints are unsupported".
        exit 106
    fi
}

open_in_default_browser() {
    # Determine the operating system and open the URL in a web browser
    os="$(uname)"
    weburl="$1"

    # Open the URL in a web browser
    case "$os" in
        "Linux")
            # Check if 'xdg-open' is installed
            if command -v xdg-open > /dev/null; then
                xdg-open "$weburl"
            else
                x-www-browser "$weburl"
            fi
            ;;
        "Darwin"|"FreeBSD"|"OpenBSD")
            open "$weburl"
            ;;
        *)
            echo "Unsupported operating system: $os"
            ;;
    esac
}

####################### script #######################

# Check if git is installed
if ! command -v git > /dev/null ; then
    echo "Fatal: git is not installed. Quitting."
    exit 100
fi

# Get the SSH URL of the remote repository
remote_url=$(git config --get remote.origin.url)
# Use exit code to check if this is a git repo.
# This make the script work in repo subdirs.
if [ "$?" -ne 0 ]; then
    echo "Fatal: Not a git repository, quitting."
    exit 103
fi

# Set vars based on repo remote
extract_vars "$remote_url"

if [ "$#" -eq 0 ]; then
    # If no args, open repo url
    url="$repo_url"
else
    # Otherwise, get args
    while getopts "ip" opt; do
        case $opt in
            i)
                url="$task_url"
                ;;
            p)
                url="$pipeline_url"
                ;;
            *)
                echo "Usage: $0 [-i] [-p]" >&2
                exit 1
                ;;
        esac
    done
    shift $((OPTIND - 1))
fi

# Opening in the default web browser
echo "Opening ${url} in the default web browser..."
open_in_default_browser "$url" 

