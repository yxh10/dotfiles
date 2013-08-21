#!/usr/bin/env bash
set -ex

cd
rm -f ~/Library/KeyBindings/DefaultKeyBinding.dict
find Dropbox/Steven/dotfiles/home -mindepth 1 -maxdepth 1 -execdir rm -f ~/{} \;
