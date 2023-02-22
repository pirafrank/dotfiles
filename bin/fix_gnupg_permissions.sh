#!/bin/bash

find ~/.gnupg -type f -exec chmod 600 {} \;
find ~/.gnupg -type d -exec chmod 700 {} \;
chown -R $(whoami) ~/.gnupg/
chmod 700 ~/.gnupg

