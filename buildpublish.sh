#!/bin/sh

echo "Verifying tree is clean"
status="$(git status --porcelain)"
if [ ! -z "$status" ]; then
  echo "working tree is not clean, this script would be dangerous so not doing anything until you clean it up." > /dev/stderr
  exit 1
fi

echo "Switching to branch build"
git checkout build

echo "Building..."
jekyll build -q

echo "Moving built site to safety"
tmp=$(mktemp -d)
mv _site/* $tmp

echo "Pivoting to master for content replacement"
git checkout -B master
rm -rf *
mv $tmp/* .

echo "Committing new build"

git add .
git commit -am "$(date -Iseconds)"


echo "Pushing new build"
git push origin master --force

echo "Returning you to build branch"
git checkout build
