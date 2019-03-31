#!/bin/bash

# https://gist.github.com/pirafrank/df40b2b082b91ed79036b328a3f010da

keylist="/etc/ssh/ssh_host_rsa_key.pub /etc/ssh/ssh_host_dsa_key.pub /etc/ssh/ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ed25519_key.pub"

printf "\n%s\n" "$(hostname)"
for keyfile in $keylist; do
  if [ -f $keyfile ]; then
    printf "\n  $keyfile\n"
    printf "    %-6s -- %-6s -- " "SHA256" "HEX"
    awk '{print $2}' $keyfile | base64 -d | sha256sum -b | awk '{print $1}'
    printf "    %-6s -- %-6s -- " "SHA256" "BASE64"
    awk '{print $2}' $keyfile | base64 -d | sha256sum -b | awk '{print $1}' | xxd -r -p | base64

    printf "    %-6s -- %-6s -- " "MD5" "HEX"
    awk '{print $2}' $keyfile | base64 -d | md5sum -b | awk '{print $1}'
    printf "    %-6s -- %-6s -- " "MD5" "BASE64"
    awk '{print $2}' $keyfile | base64 -d | md5sum -b | awk '{print $1}' | xxd -r -p | base64

    printf "    %-6s -- %-6s -- " "SHA1" "HEX"
    awk '{print $2}' $keyfile | base64 -d | sha1sum -b | awk '{print $1}'
    printf "    %-6s -- %-6s -- " "SHA1" "BASE64"
    awk '{print $2}' $keyfile | base64 -d | sha1sum -b | awk '{print $1}' | xxd -r -p | base64
  fi
done


