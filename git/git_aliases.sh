#!/bin/bash
git config --global alias.co checkout
git config --global alias.st "status -s"
git config --global alias.br branch
git config --global alias.cm commit
git config --global alias.pl pull
git config --global alias.ps push
git config --global alias.unstage 'reset HEAD --'
git config --global alias.tree "log --all --decorate --oneline --graph"
git config --global alias.adog "log --all --decorate --oneline --graph"

# %h = abbreviated commit hash
# %x09 = tab (character for code 9)
# %an = author name
# %ad = author date (format respects --date= option)
# %s = subject
# %ce = author email
# %cr = relative date (e.g. 2 month ago)
git config --global alias.ll 'log --graph --pretty=format:"%C(yellow)%h%Creset%C(cyan)%C(bold)%d%Creset %C(cyan)(%ad)%Creset %C(green)%an%Creset %s"'
