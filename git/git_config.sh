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
git config --global alias.rename 'branch -m' # oldname newname

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
git config --global rebase.autoStash true

# set default branch name for new repos
git config --global init.defaultBranch main


####################
#  delta config    #
####################

# Note:
# Wide lines in the left or right panel are currently truncated. If the truncation is a problem,
# one approach is to set the width of Delta's output to be larger than your terminal (e.g.
# delta --width 250) and ensure that less doesn't wrap long lines (e.g. export LESS=-RS); 
# then one can scroll right to view the full content. (Another approach is to decrease font size
# in your terminal.)
#
# more info on delta docs: https://github.com/dandavison/delta

if [ $(command -v delta) ]; then
  git config --global pager.diff delta
  git config --global pager.log delta
  git config --global pager.reflog delta
  git config --global pager.show delta

  git config --global interactive.diffFilter 'delta --color-only --features=interactive'

  git config --global delta.features decorations
  git config --global delta.line-numbers true
  git config --global delta.side-by-side true
  git config --global delta.line-numbers-left-format ""
  git config --global delta.line-numbers-right-format '│ '

  git config --global delta.interactive.keep-plus-minus-markers false

  git config --global delta.decorations.commit-decoration-style 'blue ol'
  git config --global delta.decorations.commit-style 'raw'
  git config --global delta.decorations.file-style 'omit'
  git config --global delta.decorations.hunk-header-decoration-style 'blue box'
  git config --global delta.decorations.hunk-header-file-style 'red'
  git config --global delta.decorations.hunk-header-line-number-style '#067a00'
  git config --global delta.decorations.hunk-header-style 'file line-number syntax'
fi



echo "Done!"
exit 0
