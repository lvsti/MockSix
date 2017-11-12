#!/bin/bash

set -e

if [[ "$TRAVIS_OS_NAME" != "linux" ]]; then
    echo "Not running on Travis and/or Linux, aborting."
    exit 1
fi

echo "Installing Swift for Linux..."

export SWIFT_VERSION=swift-4.0.2-RELEASE
wget https://swift.org/builds/swift-4.0.2-release/ubuntu1404/${SWIFT_VERSION}/${SWIFT_VERSION}-ubuntu14.04.tar.gz
tar xzf $SWIFT_VERSION-ubuntu14.04.tar.gz
export PATH="$(pwd)/${SWIFT_VERSION}-ubuntu14.04/usr/bin:${PATH}"

echo "Swift has been installed successfully."
