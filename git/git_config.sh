#!/bin/bash

echo "Setting git global config..."

####################
# setting aliases  #
####################

# basic aliases
git config --global alias.co checkout
git config --global alias.cp cherry-pick
git config --global alias.st "status -s"
git config --global alias.br branch
git config --global alias.cm commit
git config --global alias.pl pull
git config --global alias.ps push
git config --global alias.unstage 'reset HEAD --'
git config --global alias.refresh 'remote update origin --prune'
git config --global alias.rename 'branch -m' # oldname newname

# git push, setting upstream automatically with same name of local counterpart (git >= 2.37.0)
git config --global --add --bool push.autoSetupRemote true

# log pretty print
git config --global alias.tree "log --all --decorate --oneline --graph"
git config --global alias.adog "log --all --decorate --oneline --graph"

# list files in a commit (limits history to given commit '-1')
# usage: git ls [commit hash]
git config --global alias.ls "log -1 --name-status --show-signature"

# custom log pretty print
#
# %h = abbreviated commit hash
# %x09 = tab (character for code 9)
# %an = author name
# %ad = author date (format respects --date= option)
# %s = subject
# %ce = author email
# %cr = relative date (e.g. 2 month ago)
# %G? = show "G" for a good (valid) signature
#            "B" for a bad signature
#            "U" for a good signature with unknown validity
#            "X" for a good signature that has expired
#            "Y" for a good signature made by an expired key
#            "R" for a good signature made by a revoked key
#            "E" if the signature cannot be checked (e.g. missing key)
#            "N" for no signature
#
git config --global alias.ll '!git log --graph --pretty=format:"%C(yellow)%h%Creset %C(yellow)%G?%Creset%C(cyan)%C(bold)%d%Creset %C(cyan)(%ad)%Creset %C(green)%an%Creset %s" $(git rev-parse --abbrev-ref HEAD) $(git rev-parse --abbrev-ref @{u})'
git config --global alias.la 'log --all --graph --pretty=format:"%C(yellow)%h%Creset %C(yellow)%G?%Creset%C(cyan)%C(bold)%d%Creset %C(cyan)(%ad)%Creset %C(green)%an%Creset %s"'
git config --global alias.lg 'log --pretty=fuller --show-signature'

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

# follow renames
git config --global log.follow true

# global git hooks
git config --global core.hooksPath "$HOME/dotfiles/git/hooks"

# terminate lines the unix way
git config --global core.autocrlf false
git config --global core.eol lf

# default editor
if command -v nvim > /dev/null; then
  git config --global core.editor nvim
else
  git config --global core.editor vim
fi

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
  git config --global pager.blame delta

  git config --global diff.colorMoved default
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
