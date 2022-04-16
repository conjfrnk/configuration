#!/usr/bin/env bash

command_exists () {
  type "$1" &> /dev/null ;
}

if command_exists stow; then
  stow config
else
  echo "install stow"
fi
