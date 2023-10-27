#!/bin/bash

gnome_color () {
  AA=${1:1:2}
  BB=${1:3:2}
  CC=${1:5:2}

  echo "#${AA}${AA}${BB}${BB}${CC}${CC}"
}

rgb_color() {
  hexinput=$(echo $1 | cut -c2-7 | tr '[:lower:]' '[:upper:]')  # uppercase
  a=$(echo $hexinput | cut -c-2)
  b=$(echo $hexinput | cut -c3-4)
  c=$(echo $hexinput | cut -c5-6)

  r=$(echo "ibase=16; $a" | bc)
  g=$(echo "ibase=16; $b" | bc)
  b=$(echo "ibase=16; $c" | bc)

  echo "rgb(${r}, ${g}, ${b})"
}

COLOR_01=$(rgb_color "#13222e")              # HOST
COLOR_02=$(rgb_color "#ca3e5a")           # SYNTAX_STRING
COLOR_03=$(rgb_color "#81a559")           # COMMAND
COLOR_04=$(rgb_color "#ebb062")           # COMMAND_COLOR2
COLOR_05=$(rgb_color "#4496cd")           # PATH
COLOR_06=$(rgb_color "#b35d8d")           # SYNTAX_VAR
COLOR_07=$(rgb_color "#42abab")           # PROMPT
COLOR_08=$(rgb_color "#96a8b5")           #

COLOR_09=$(rgb_color "#293845")           #
COLOR_10=$(rgb_color "#d8843e")           # COMMAND_ERROR
COLOR_11=$(rgb_color "#42abab")           # EXEC
COLOR_12=$(rgb_color "#ebb062")           #
COLOR_13=$(rgb_color "#4496cd")           # FOLDER
COLOR_14=$(rgb_color "#b35d8d")           #
COLOR_15=$(rgb_color "#42abab")           #
COLOR_16=$(rgb_color "#acbecc")           #

BACKGROUND_COLOR=$(gnome_color '#13222e')
FOREGROUND_COLOR=$(gnome_color '#96a8b5')   # Text
CURSOR_COLOR=$(gnome_color '#9770b2') # Cursor

gnomeVersion="$(expr "$(gnome-terminal --version)" : '.* (.*[.].*[.].*)$')"
dircolors_checked=false

profiles_path=/org/gnome/terminal/legacy/profiles:

set_theme() {
  profile=$(get_uuid $1)
  profile_path=$profiles_path/$profile

  dconf write $profile_path/palette "['${COLOR_01}', '${COLOR_02}', '${COLOR_03}', '${COLOR_04}', '${COLOR_05}', '${COLOR_06}', '${COLOR_07}', '${COLOR_08}', '${COLOR_09}', '${COLOR_10}', '${COLOR_11}', '${COLOR_12}', '${COLOR_13}', '${COLOR_14}', '${COLOR_15}', '${COLOR_16}']"

  # set foreground, background and highlight color
  # dconf write $profile_path/bold-color "'$SOME_COLOR'"
  dconf write $profile_path/background-color "'$BACKGROUND_COLOR'"
  dconf write $profile_path/foreground-color "'$FOREGROUND_COLOR'"

  # make sure the profile is set to not use theme colors
  dconf write $profile_path/use-theme-colors "false"

  # set highlighted color to be different from foreground color
  dconf write $profile_path/bold-color-same-as-fg "true"
}


get_uuid() {
  profiles=($(dconf list $profiles_path/ | grep ^: | sed 's/\///g'))
  # Print the UUID linked to the profile name sent in parameter
  local profile_name=$1
  for i in ${!profiles[*]}
    do
      if [[ "$(dconf read $profiles_path/${profiles[i]}/visible-name)" ==           "'$profile_name'" ]]
        then echo "${profiles[i]}"
        return 0
      fi
    done
  echo "$profile_name"
}
set_theme $1