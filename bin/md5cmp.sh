#!/bin/bash

#########################################################################
# md5cmp <https://github.com/pirafrank/CLI_utils>
# calculate the md5 of given files and compare the results
# Supports OS X and Linux (tested on OS X 10.9.4 and Raspbian)
#
# Copyright (C) 2015 Francesco Pira <dev@fpira.com> 
#
# This file is part of CLI_utils.
#
# CLI_utils is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# CLI_utils is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with CLI_utils. If not, see <http://www.gnu.org/licenses/>.
#
#########################################################################


# CHANGELOG
# v 5.0
# Linux and OS X version merged
# fixed potential bug
# v 4.1
# tidier code
# v 4.0
# improved arguments check
# v 3.0
# improved output
# v 2.0
# added absolute path in output
# v 1.0
# initial release

# Features to include:
# proper error handling if file does not exist
# proper error handling if command is not found
# merge is OS X version ( $( uname -a | grep "Darwin" "Linux" ) )




# FUNCTIONS #

function get_abs_filename() {
  # $1 : relative filename
  if [ -d "$(dirname "$1")" ]; then
    echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
  fi
}

function mac_script() {
 echo "Calculating first file..."
 # sum1=$( md5 "$FILE1" | awk 'match($0,"="){print substr($0,RSTART+2)}' )
 sum1=$( md5 -q "$FILE1" 2>&1 )
 echo -n "Abs path: "
 get_abs_filename "$FILE1"
 echo "MD5 = $sum1"

 echo "Calculating second file..."
 # sum2=$( md5 "$FILE2" | awk 'match($0,"="){print substr($0,RSTART+2)}' )
 sum2=$( md5 -q "$FILE2" 2>&1 )
 echo -n "Abs path: "
 get_abs_filename "$FILE2"
 echo "MD5 = $sum2"
}

function linux_script() {
 echo "Calculating first file..."
 sum1=$( md5sum "$FILE1" | awk 'match($0," "){print substr($0,RSTART-32,RSTART-1)}' )
 echo -n "Abs path: "
 get_abs_filename "$FILE1"
 echo "MD5 = $sum1"

 echo "Calculating second file..."
 sum2=$( md5sum "$FILE2" | awk 'match($0," "){print substr($0,RSTART-32,RSTART-1)}' )
 echo -n "Abs path: "
 get_abs_filename "$FILE2"
 echo "MD5 = $sum2"
}

# MAIN SCRIPT #

if [[ $# != 2 ]]; then
  echo "Error: wrong number of arguments"
  exit -1
fi

FILE1="$1"
FILE2="$2"

if [[ $FILE1 == "" || $FILE2 == "" ]]; then
     echo "Error: wrong format of arguments"
     exit -1
fi

if [[ $( uname ) == "Darwin" ]]; then
 mac_script
else
  if [[ $( uname ) == "Linux" ]]; then
    linux_script
  else
    echo "Error: undefined operating system."
    exit -1
  fi
fi

if [[ $sum1 == $sum2 ]]; then
    echo "$(tput setaf 2)Hashes match. Files are the same.$(tput sgr 0)"
    exit 0
else
    echo "$(tput setaf 1)Hashes DO NOT match. Files are different.$(tput sgr 0)"
    exit 1
fi






