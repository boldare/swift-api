#!/bin/bash

set -e

gem install cocoapods --version='1.1.1'
gem install xcpretty-travis-formatter

# Update cocoapods repo
CURRENT_DIR="$PWD"
cd ../../../.cocoapods/repos/master
git pull &> /dev/null
cd "$CURRENT_DIR"
# / Update cocoapods repo

if [[ -z $PODS_PROJECT_DIRECTORY ]]; then
  pod install
else
  pod install --project-directory="$PODS_PROJECT_DIRECTORY"
fi
