#!/bin/bash

echo "Setting git global config..."

####################
# setting aliases  #
####################

# basic aliases
git config --global alias.co checkout
git config --global alias.st "status -s"
git config --global alias.br branch
git config --global alias.cm commit
git config --global alias.pl pull
git config --global alias.ps push
git config --global alias.unstage 'reset HEAD --'
git config --global alias.refresh 'remote update origin --prune'

# log pretty print
git config --global alias.tree "log --all --decorate --oneline --graph"
git config --global alias.adog "log --all --decorate --oneline --graph"

# list files in a commit (limits history to given commit '-1')
# usage: git ls [commit hash]
git config --global alias.ls "log -1 --name-status"

# custom log pretty print
#
# %h = abbreviated commit hash
# %x09 = tab (character for code 9)
# %an = author name
# %ad = author date (format respects --date= option)
# %s = subject
# %ce = author email
# %cr = relative date (e.g. 2 month ago)
#
git config --global alias.ll 'log --graph --pretty=format:"%C(yellow)%h%Creset%C(cyan)%C(bold)%d%Creset %C(cyan)(%ad)%Creset %C(green)%an%Creset %s"'
git config --global alias.la 'log --all --graph --pretty=format:"%C(yellow)%h%Creset%C(cyan)%C(bold)%d%Creset %C(cyan)(%ad)%Creset %C(green)%an%Creset %s"'

# to list changes made on a particular file:
#   git log --follow [filename]
# or (if git ll is enabled):
#   git ll --follow [filename]

# to show changes inside files in a commit
#   git show [commit hash] 

####################
# editing defaults #
####################

# defaults to pull --rebase for all repos
git config --global pull.rebase true

echo "Done!"
exit 0
