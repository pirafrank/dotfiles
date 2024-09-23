export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="devcontainers"

plugins=(git nvm docker)

source $ZSH/oh-my-zsh.sh

# load interactive env
source $HOME/dotfiles/zsh/common/zsh_env_interactive

# Set personal aliases.
# For a full list of active aliases, run `alias`.
source $HOME/dotfiles/zsh/common/zsh_aliases

DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true

# custom history size
export HISTSIZE=20000
# save history after logout
export SAVEHIST=20000
# history file
export HISTFILE=~/.zsh_history

autoload zmv
