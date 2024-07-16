#!/bin/sh

# Check if git is installed
command -v git > /dev/null
if [ "$?" -ne 0 ]; then
    echo "Fatal: git is not installed. Quitting."
    exit 100
fi

# Get the SSH URL of the remote repository
url=$(git config --get remote.origin.url)

# Use exit code to check if this is a git repo.
# This make the script work in repo subdirs.
if [ "$?" -ne 0 ]; then
    echo "Fatal: Not a git repository, quitting."
    exit 103
fi

# Check if the URL uses the SSH protocol
if echo "$url" | grep -q "@"; then
    # Extract the repository path
    repo_path="${url#*:}"
    repo_path="${repo_path%.git}"

    # Convert the SSH URL to an HTTPS URL for different services
    if echo "$url" | grep -q "github.com:"; then
        url="https://github.com/$repo_path"
    elif echo "$url" | grep -q "gitlab.com:"; then
        url="https://gitlab.com/$repo_path"
    elif echo "$url" | grep -qE "vs-ssh.visualstudio.com:|dev.azure.com:"; then
        last_part=$(basename "$repo_path")
        repo_path="${repo_path%/*}/_git/$last_part"
        # Azure DevOps SSH URLs have an extra 'v3' in the path
        url="https://dev.azure.com/${repo_path#*v3/}"
    else
        # Custom hosting
        host="${url%@*}"
        host="${host#*:}"
        url="https://$host/$repo_path"
    fi
fi

echo "Opening ${url} in the default web browser..."

# Determine the operating system and open the URL in a web browser
os=$(uname)

# Open the URL in a web browser
case "$os" in
    "Linux")
        # Check if 'xdg-open' is installed
        if command -v xdg-open > /dev/null; then
            xdg-open "$url"
        else
            x-www-browser "$url"
        fi
        ;;
    "Darwin"|"FreeBSD"|"OpenBSD")
        open "$url"
        ;;
    *)
        echo "Unsupported operating system: $os"
        ;;
esac

