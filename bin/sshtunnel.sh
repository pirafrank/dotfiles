#!/bin/sh

# first open a SOCKS to the bastion host:
#
# ssh -o ServerAliveInterval=60 -fN -D 8010 someone@somehost
#
# then use it to reach other machines through it:
#
# EXAMPLE:
#   ./ssh_tunnel.sh 8010 user@10.233.1.150
#   opens a shell to 10.233.1.150
# EXAMPLE 2: 
#   ./ssh_tunnel.sh 8010 user@10.233.1.150 "-D8011"
#   open an ssh connection through SOCKS on 8010, then creates a SOCKS through 10.233.1.150 on local port 8011
# EXAMPLE 2.1: 
#   you can chain the previous command with the following one to jump from host to host
#   ./ssh_tunnel.sh 8011 user@10.233.1.151 "-D8012"
#   open an ssh connection through SOCKS on 8011, then creates a SOCKS through 10.233.1.151 on local port 8012
#   you can chain as much commands as you want. they all bind to local ports.
# EXAMPLE 3: 
#   ./ssh_tunnel.sh 8010 user@10.233.1.150 "-L11521:10.233.1.151:1521"
#   open an ssh connection through SOCKS on 8010, then creates a tunnel to make LOCAL port 11521 point to 10.233.1.151:1521
# EXAMPLE 4:
#   ./ssh_tunnel.sh 8010 user@somehost.ddns.net -p7000
#   ./ssh_tunnel.sh 8010 user@somehost.ddns.net '-p7000 -L:8000:192.168.0.30:8000'
#   ./ssh_tunnel.sh 8010 user@somehost.ddns.net '-p7000 -L:4123:192.168.0.30:3389'


PORT=$1
SSH_SERVER=$2
NC_COMMAND="nc -x 127.0.0.1:$PORT %h %p"
echo $NC_COMMAND
PARAMETERS=
if [ $# -eq 3 ]; then
    PARAMETERS="$PARAMETERS $3"
    echo 'adding parameters: '$PARAMETERS
fi
ssh -o ProxyCommand=''"$NC_COMMAND"'' $PARAMETERS $SSH_SERVER
