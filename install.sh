#!/usr/bin/env bash
set -ex

mkdir -p $HOME/Library/KeyBindings/
cp $PWD/DefaultKeyBinding.dict $HOME/Library/KeyBindings/
find $PWD/home -mindepth 1 -maxdepth 1 -exec ln -s {} $HOME/. \;
