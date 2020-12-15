#!/bin/bash

# How to squash all history into a single commit.
# Useful before making your code public
# credits: https://twitter.com/mathias/status/1045312837671882752

cd "$1"

git reset $(git commit-tree HEAD^{tree} -m 'Initial commit')
