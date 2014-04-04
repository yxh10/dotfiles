#!/usr/bin/env bash
set -ex

find $PWD/arch -mindepth 1 -maxdepth 1 -exec ln -s {} $HOME/. \;
find $PWD/shared -mindepth 1 -maxdepth 1 -exec ln -s {} $HOME/. \;
