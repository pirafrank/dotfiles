#!/bin/zsh

if [[ -z "$1" ]]; then
    echo "Please specify the python version."
    exit 1
fi

PYTHON3VERSION="$1"

# installing dependencies to compile python shims
# (only if run as standard user, assume interactive install.
# These deps are installed via Dockerfile during Docker image build)
if [[ $EUID -ne 0 && $(command -v sudo) ]]; then
  sudo apt-get clean && sudo apt-get update && \
  sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
fi

# installing pyenv
curl -sSL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

# load pyenv in current session
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv install $PYTHON3VERSION
pyenv global $PYTHON3VERSION

python3 -m pip install --upgrade pip

