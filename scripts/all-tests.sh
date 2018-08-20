#!/bin/sh

if [ "$1" == "iOS" ]; then
	set -o pipefail && xcodebuild test -verbose -scheme "OperantKit iOS" -destination "platform=iOS Simulator,OS=10.0,name=iPhone 7 Plus" ONLY_ACTIVE_ARCH=NO | xcpretty
elif [ "$1" == "macOS" ]; then
	set -o pipefail && xcodebuild test -verbose -scheme "OperantKit macOS" ONLY_ACTIVE_ARCH=NO | xcpretty
else
	echo "wrong parameters. (iOS|macOS)"
	exit 1
fi