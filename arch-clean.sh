#!/usr/bin/env bash
set -ex

find $PWD/arch -mindepth 1 -maxdepth 1 -execdir rm -f $HOME/{} \;
find $PWD/shared -mindepth 1 -maxdepth 1 -execdir rm -f $HOME/{} \;
