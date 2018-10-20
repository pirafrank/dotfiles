#!/bin/bash

#########################################################################
# strcompare <https://github.com/pirafrank/CLI_utils>
# Compare two string in bash
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



S1="$1"
S2="$2"

if [[ $S1 == "" || $S2 == "" ]]; then
     echo "Error: not enough arguments"
     exit -1
else
     if [[ $S1 == $S2 ]]; then
          echo "$(tput setaf 2)SUCCESS: strings match$(tput sgr 0)"
          exit 0
     else
          echo "$(tput setaf 1)Strings DO NOT match$(tput sgr 0)"
     fi
          exit 1
fi