#!/bin/sh

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <pubkey_file>"
	exit 1
fi

file="$1"
gpg --show-keys --with-colons "$file" 2>/dev/null | grep "^pub" | cut -d':' -f5

