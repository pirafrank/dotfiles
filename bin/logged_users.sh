#!/bin/bash

#
# logged_users.sh
# Lists who and how many times is logged
#
# Francesco Pira <dev[at]fpira[dot]com>
# Released under the terms of GNU GPLv3
#

if [[ $# > 1 ]]; then
    echo "Error: wrong number of arguments"
    exit -1
else
    if [[ $1 == "" ]]; then
        while read -r line
        do
            USER=$(echo $line | awk '{print $2}')
            TIMES=$(echo $line | awk '{print $1}')
            echo "$USER is logged $TIMES times."
        done < <(w | sed '1,2d' | cut -f1 -d' ' | sort | uniq -c)
    else
        FIRST_LETTER=$1
        while read -r line
        do
            USER=$(echo $line | awk '{print $2}')
            TIMES=$(echo $line | awk '{print $1}')
            echo "$USER is logged $TIMES times."
        done < <(w | grep "^$FIRST_LETTER" | cut -f1 -d' ' | sort | uniq -c)
    fi
fi

