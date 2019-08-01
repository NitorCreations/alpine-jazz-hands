#!/usr/bin/env sh

set -e

bootstrap() {
  echo "bootstrap"
  [ -z "$RSA_PRIVATE_KEY" ] && echo "You need to set RSA_PRIVATE_KEY environent variable" && exit 1
  echo "$RSA_PRIVATE_KEY" > /home/builder/abuild.rsa
  echo "$RSA_PRIVATE_KEY" | openssl rsa -in /dev/stdin -pubout -out /dev/stdout > /etc/apk/keys/abuild.rsa.pub
  mkdir -p /home/builder/packages
}

buildall() {
  echo "building all packages in /main"
  for DIR in main/*
  do
    build $(basename $DIR)
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

