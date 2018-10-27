# Xcode parameters
BUILDTOOL=xcodebuild

FRAMEWORK_PATH=.
APP_PATH=Demo/$(APP_PROJECT_NAME)

CARTHAGE_COMMAND=carthage
CARTHAGE_UPDATE=$(CARTHAGE_COMMAND) update

FRAMEWORK_PROJECT_NAME=OperantKit
APP_PROJECT_NAME=OperantApp

TARGET_IOS=iOS
TARGET_MACOS=macOS

SCHEME_FRAMEWORK_IOS=$(FRAMEWORK_PROJECT_NAME) iOS
SCHEME_FRAMEWORK_MACOS=$(FRAMEWORK_PROJECT_NAME) macOS
SCHEME_APP_IOS=$(APP_PROJECT_NAME)


deps-all:
	make deps-framework
	make deps-app
deps-framework:
	cd $(FRAMEWORK_PATH) && $(CARTHAGE_UPDATE)
deps-app:
	make release-build-frameworks
	cd $(APP_PATH) && $(CARTHAGE_UPDATE) --platform $(TARGET_IOS)
build:
	$(BUILDTOOL) $(SCHEME_APP_IOS)
release-build-frameworks:
	$(BUILDTOOL) -configuration Release -verbose -scheme "$(SCHEME_FRAMEWORK_IOS)"
	$(BUILDTOOL) -configuration Release -verbose -scheme "$(SCHEME_FRAMEWORK_MACOS)"
test-all:
	make test-framework-all
test-framework-all:
	make test-framework-ios
	make test-framework-macos
test-framework-ios:
	set -o pipefail
	$(BUILDTOOL) test -configuration Release -verbose -scheme "$(FRAMEWORK_PROJECT_NAME) $(TARGET_IOS)" -destination "platform=iOS Simulator,OS=12.0,name=iPhone XS Max" ONLY_ACTIVE_ARCH=NO | xcpretty
test-framework-macos:
	set -o pipefail
	$(BUILDTOOL) test -verbose -scheme "$(FRAMEWORK_PROJECT_NAME) $(TARGET_MACOS)" ONLY_ACTIVE_ARCH=NO | xcpretty
clean:
	$(BUILDTOOL) clean