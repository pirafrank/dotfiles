#!/bin/bash

ssh_key_file="$1"

# Calculate ssh key fingerprint in md5 format
md5_fingerprint=$(ssh-keygen -E md5 -lf $ssh_key_file)
echo "MD5 Fingerprint   : $md5_fingerprint"

# Calculate ssh key fingerprint in sha1 format
sha1_fingerprint=$(ssh-keygen -E sha1 -lf $ssh_key_file)
echo "SHA1 Fingerprint  : $sha1_fingerprint"

# Calculate ssh key fingerprint in sha256 format
sha256_fingerprint=$(ssh-keygen -E sha256 -lf $ssh_key_file)
echo "SHA256 Fingerprint: $sha256_fingerprint"

