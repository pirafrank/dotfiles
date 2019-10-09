#!/bin/sh
PORT=$1
SSH_SERVER=$2
NC_COMMAND="nc -x 127.0.0.1:$PORT %h %p"
echo $NC_COMMAND
sftp -o ProxyCommand=''"$NC_COMMAND"'' $SSH_SERVER
