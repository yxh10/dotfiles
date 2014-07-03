#!/usr/bin/env bash
set -ex

rm -f $HOME/Library/KeyBindings/DefaultKeyBinding.dict
find $PWD/home -mindepth 1 -maxdepth 1 -execdir rm -f $HOME/{} \;
