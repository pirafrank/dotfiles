#!/bin/bash

# usage:
# 1) add an entry in your crontab
#      0 * * * * (every hour) or */30 * * * * (every 30 mins)
# 2) set it to run at login

# notes:
# tested on ubuntu 19.10

#ubuntuversion=$(cat /etc/os-release | grep VERSION_ID | cut -d'=' -f2| cut -d'"' -f2 | sed -s 's/\.//')
now=$(date +%H%M)

dark_since='2300'
light_since='0700'

light_theme='Yaru'
dark_theme='Yaru-dark'

# if now is greater then light setting and less then dark setting, it's day time
if [[ $now -gt $light_since ]] && [[ $now -lt $dark_since ]]; then
  gsettings set org.gnome.desktop.interface gtk-theme $light_theme
else 
  # it's night time, go dark
  gsettings set org.gnome.desktop.interface gtk-theme $dark_theme 
fi

