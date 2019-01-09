#!/bin/bash

# @Description: A simple notetaking solution in your CLI
# @Author: Francesco Pira (dev[at]fpira[dot]com)
#
# Usage:
# 1) set an alias like this in your .zshrc or .bashrc:
# alias notes='bash /where/your-script-is/notes.sh'
# 2) notes (ls|new|del|sync|syncinit) [note title]"
#
# Auto-sync:
# Customize the line below and paste it (uncommented) in cron for auto-sync.
# You need to setup sync using 'syncinit' first
# */5 * * * * /where/your-script-is/notes.sh sync


### Script HEADER: customize me ###
notesroot="$HOME/Notes/"

### Script body ###

if [ ! -d "$notesroot" ]; then
  echo "ERROR:
'notesroot' variable is not set or set directory does not exists.
Edit the script header or let me create it in $HOME/Notes to fix."
  read -r -p "Should I create it now? [y/N] " choose
  case "$choose" in
  [yY][eE][sS]|[yY])
  mkdir $HOME/Notes1
  echo "Notes directory created!"
  ;;
  *)
  echo "Please edit the script header to fix. Exiting..."
  exit 1
  ;;
  esac
fi

case "$1" in
ls)
    ls -Alht $notesroot
;;

new)
    vim $notesroot/"$2"
;;

del)
    rm $notesroot/"$2"
    if [ ! -f $notesroot/"$2" ]; then echo "Note \"$2\" deleted."
    else echo "Error: cannot delete note \"$2\""; fi
;;

sync)
    cd $notesroot
    git pull origin master
    git add .
    git commit -m 'sync'
    git push origin master
    cd -
;;

syncinit)
    echo ""; echo "--- Sync-setup mode ---"
    echo "A remote repo and access to it by this machine and user are required."
    echo "You have to perform those steps before proceeding."
    read -r -p "Continue? [y/N] " response
    case "$response" in
    [yY][eE][sS]|[yY])
    hash git 2>/dev/null || { echo >&2 "git required but not currently installed. Aborted."; exit 1; }
    IFS= read -r -p "Enter remote repo URL: " remoterepo
    cd $notesroot
    git init
    git add .
    git commit -m 'sync'
    git remote add origin "$remoterepo"
    git push origin master
    cd -
    ;;
    *)
    echo "Aborted."
    exit 1
    ;;
    esac
;;

*) echo "Usage: notes (ls|new|del|sync|syncinit) [note title]"
;;
esac
