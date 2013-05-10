#!/usr/bin/env bash
set -ex

cd
mkdir -p Library/KeyBindings/
cp ~/dotfiles/DefaultKeyBinding.dict Library/KeyBindings/
find dotfiles/home -mindepth 1 -maxdepth 1 -exec ln -s {} . \;
