#!/bin/bash

# available as gist at https://gist.github.com/pirafrank/df40b2b082b91ed79036b328a3f010da

# keep it in this order to match SSHFP numbers
keylist="/etc/ssh/ssh_host_rsa_key.pub /etc/ssh/ssh_host_dsa_key.pub /etc/ssh/ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ed25519_key.pub"
SSHFP=0
algolist="sha256 sha1 md5"


function uppercase {
	tr [:lower:] [:upper:]
}

function hashit {
	# compose command name
	cmd="${1}sum"
	awk '{print $2}' $2 | base64 -d | eval $cmd -b | awk '{print $1}'
}


printf "\n\nPrinting SSH host key fingerprints and SSHFP DNS entries\n\n"
printf "\nHostname: %s\n" "$(hostname)"
for keyfile in $keylist; do
  SSHFP=$(($SSHFP + 1))
  if [ -f $keyfile ]; then
    printf "\n  $keyfile\n"
    for algo in $algolist; do
      HEXHASH=$(hashit $algo $keyfile)
      BASE64HASH=$(echo $HEXHASH | xxd -r -p | base64)
      printf "    %-6s -- %-6s -- %s\n" "$(echo ${algo}sum | uppercase)" "HEX" "$HEXHASH"
      printf "    %-6s -- %-6s -- %s\n" "$(echo ${algo}sum | uppercase)" "BASE64" "$BASE64HASH"
      printf "\n"
      if [ $algo == 'sha1' ]; then
        printf "    $(hostname) IN SSHFP $SSHFP 1 $HEXHASH\n"
      fi
      if [ $algo == 'sha256' ]; then
        printf "    $(hostname) IN SSHFP $SSHFP 2 $HEXHASH\n"
      fi
      printf "\n\n"
    done
  fi
done



