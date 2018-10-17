# convert hex string to base64 string
 | xxd -r -p | base64

# convert base64 string to hex string
 | base64 -d | od -t  x1 -An

# Example: the whole circle in one command
# convert base64 to binary, to sha256 checksum (string in hex format), to decoded hex data (xxd -r),
# to base64 string, to base64 decoded data (base64 -d), back to hex string
awk '{print $2}' /etc/ssh/ssh_host_ecdsa_key.pub | base64 -d | sha256sum -b | awk '{print $1}' | xxd -r -p | base64 | base64 -d | od -t  x1 -An
