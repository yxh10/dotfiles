#!/usr/bin/env bash
set -ex

cd
mkdir -p Library/KeyBindings/
cp ~/Dropbox/Steven/dotfiles/DefaultKeyBinding.dict Library/KeyBindings/
find Dropbox/Steven/dotfiles/home -mindepth 1 -maxdepth 1 -exec ln -s {} . \;
