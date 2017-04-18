#!/bin/bash

set -e

. scripts/helpers.sh

if [[ -z $TRAVIS_XCODE_WORKSPACE ]]; then
    echo "Error: \$TRAVIS_XCODE_WORKSPACE is not set."
    exit 1
fi
if [[ -z $TRAVIS_XCODE_SCHEME ]]; then
    echo "Error: \$TRAVIS_XCODE_SCHEME is not set!"
    exit 1
fi
if [[ -z $BUILD_SDK ]]; then
    BUILD_SDK="iphonesimulator"
fi
if [[ -z $BUILD_DESTINATION ]]; then
    BUILD_DESTINATION="platform=iOS Simulator,name=iPad Air 2"
fi

BUILD_CONFIGURATION="Debug"
BUILD_ACTION="build-for-testing test-without-building"

set -o pipefail
xcodebuild -workspace "$TRAVIS_XCODE_WORKSPACE" \
    -scheme "$TRAVIS_XCODE_SCHEME" \
    -sdk "$BUILD_SDK" \
    -destination "$BUILD_DESTINATION" \
    -configuration "$BUILD_CONFIGURATION" \
    $BUILD_ACTION | xcpretty -f `xcpretty-travis-formatter`

exitIfLastStatusWasUnsuccessful

if [[ -n $PODSPEC ]]; then
    pod lib lint --private --sources=master --allow-warnings

    exitIfLastStatusWasUnsuccessful
fi
