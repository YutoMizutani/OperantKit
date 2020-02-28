PREFIX?=/usr/local

deps:
	swift build

gen:
	swift package generate-xcodeproj

build:
	swift build --disable-sandbox -c release -Xswiftc -static-stdlib
