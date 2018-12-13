#!/bin/bash

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
        #echo "$FIRST_LETTER"
        #INFO=$(w | grep "^$FIRST_LETTER")
        #echo "$INFO"
        while read -r line
        do
            USER=$(echo $line | awk '{print $2}')
            TIMES=$(echo $line | awk '{print $1}')
            echo "$USER is logged $TIMES times."
        done < <(w | grep "^$FIRST_LETTER" | cut -f1 -d' ' | sort | uniq -c)
    fi
fi

