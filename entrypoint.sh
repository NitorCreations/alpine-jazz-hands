#!/usr/bin/env sh

set -e

bootstrap() {
  echo "bootstrap"
  [ -z "$RSA_PRIVATE_KEY" ] && echo "You need to set RSA_PRIVATE_KEY environent variable" && exit 1
  echo "$RSA_PRIVATE_KEY" > /home/builder/abuild.rsa
  mkdir -p /home/builder/packages
}

buildall() {
  "building all packages in /main"
  for d in main/*
  do
    ( cd $d && abuild-apk update && abuild -r )
  done
}

build() {
    echo "Building /main/$1"
    ( cd main/$1 && abuild-apk update && abuild -r )
}

echo "$@"

bootstrap "$@"
if [[ $# -eq 0 ]]; then
    echo "No args"
    buildall "$@"
    exit 0
fi

build "$1"

