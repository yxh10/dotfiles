#!/usr/bin/env bash
set -ex

mkdir -p $HOME/Library/KeyBindings/
cp $PWD/DefaultKeyBinding.dict $HOME/Library/KeyBindings/
find $PWD/mac -mindepth 1 -maxdepth 1 -exec ln -s {} $HOME/. \;
