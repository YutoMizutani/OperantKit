# Paths
FRAMEWORK_PATH=.
APP_PATH=Demo/$(APP_PROJECT_NAME)

# Commands
BUILD_COMMAND=xcodebuild
HOMEBREW_COMMAND=brew
GEM_COMMAND=sudo gem
BUNDLE_COMMAND=bundle
CARTHAGE_COMMAND=carthage
FASTLANE_COMMAND=bundle exec fastlane

FRAMEWORK_PROJECT_NAME=OperantKit
WORKSPACE_FILENAME=$(FRAMEWORK_PROJECT_NAME).xcworkspace
APP_PROJECT_NAME=OperantApp

TARGET_MACOS=macOS
TARGET_IOS=iOS
TARGET_TVOS=tvOS
TARGET_WATCHOS=watchOS

SCHEME_FRAMEWORK_MACOS=$(FRAMEWORK_PROJECT_NAME) $(TARGET_MACOS)
SCHEME_FRAMEWORK_IOS=$(FRAMEWORK_PROJECT_NAME) $(TARGET_IOS)
SCHEME_FRAMEWORK_TVOS=$(FRAMEWORK_PROJECT_NAME) $(TARGET_TVOS)
SCHEME_FRAMEWORK_WATCHOS=$(FRAMEWORK_PROJECT_NAME) $(TARGET_WATCHOS)
SCHEME_APP_IOS=$(APP_PROJECT_NAME)


# Open
open:
	open $(WORKSPACE_FILENAME)


# Dependencies
deps-all:
	make deps
	make install
deps:
	make deps-brew
	make deps-bundler
deps-brew:
	if ! type $(HOMEBREW_COMMAND) > /dev/null 2>&1; then /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; fi
deps-bundler:
	$(GEM_COMMAND) install bundler


# Install
install:
	make install-all
install-all:
	make install-gems
	make install-frameworks
install-gems:
	$(BUNDLE_COMMAND) install
install-frameworks:
	make install-framework-all
install-framework-all:
	make install-framework-carthage
install-framework-carthage:
	cd $(FRAMEWORK_PATH); $(CARTHAGE_COMMAND) bootstrap --no-use-binaries


# Update
update:
	make update-all
update-all:
	make update-gems
	make update-frameworks
update-gems:
	cd $(FRAMEWORK_PATH); $(BUNDLE_COMMAND) update
update-frameworks:
	make update-framework-all
update-framework-all:
	make update-framework-carthage
update-framework-carthage:
	cd $(FRAMEWORK_PATH); $(CARTHAGE_COMMAND) update --no-use-binaries


# Build
build-all:
	make build-carthage
	make build-release-frameworks
build-carthage:
	carthage build --no-skip-current
build-release-frameworks:
	make build-release-framework-all
build-release-framework-all:
	$(BUILD_COMMAND) \
		-workspace $(WORKSPACE_FILENAME) \
		-configuration Release \
		-verbose \
		-scheme "$(SCHEME_FRAMEWORK_MACOS)"
	$(BUILD_COMMAND) \
		-workspace $(WORKSPACE_FILENAME) \
		-configuration Release \
		-verbose \
		-scheme "$(SCHEME_FRAMEWORK_IOS)"
	$(BUILD_COMMAND) \
		-workspace $(WORKSPACE_FILENAME) \
		-configuration Release \
		-verbose \
		-scheme "$(SCHEME_FRAMEWORK_TVOS)"
	$(BUILD_COMMAND) \
		-workspace $(WORKSPACE_FILENAME) \
		-configuration Release \
		-verbose \
		-scheme "$(SCHEME_FRAMEWORK_WATCHOS)"


# Test
test:
	make test-all
test-all:
	make test-framework-all
	make test-app-all
test-framework-all:
	make test-framework-macos
	make test-framework-ios
	make test-framework-tvos
test-app-all:
	make test-app-ios
test-framework-macos:
	$(FASTLANE_COMMAND) test_framework_macos
test-framework-ios:
	$(FASTLANE_COMMAND) test_framework_ios
test-framework-tvos:
	$(FASTLANE_COMMAND) test_framework_tvos
test-app-ios:
	$(FASTLANE_COMMAND) test_app_ios

# Clean
clean:
	$(BUILD_COMMAND) clean