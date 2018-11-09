# Xcode parameters
BUILDTOOL=xcodebuild

FRAMEWORK_PATH=.
APP_PATH=Demo/$(APP_PROJECT_NAME)

CARTHAGE_COMMAND=carthage
CARTHAGE_UPDATE=$(CARTHAGE_COMMAND) update

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


open:
	open $(WORKSPACE_FILENAME)

deps-all:
	make deps-framework
	make deps-app
deps-framework:
	cd $(FRAMEWORK_PATH); $(CARTHAGE_UPDATE)
deps-app:
	cd $(FRAMEWORK_PATH); carthage build --no-skip-current --platform iOS
	cd $(APP_PATH); $(CARTHAGE_UPDATE) --platform $(TARGET_IOS)

build:
	make release-build-frameworks
release-build-frameworks:
	$(BUILDTOOL) \
		-workspace $(WORKSPACE_FILENAME) \
		-configuration Release \
		-verbose \
		-scheme "$(SCHEME_FRAMEWORK_MACOS)"
	$(BUILDTOOL) \
		-workspace $(WORKSPACE_FILENAME) \
		-configuration Release \
		-verbose \
		-scheme "$(SCHEME_FRAMEWORK_IOS)"
	$(BUILDTOOL) \
		-workspace $(WORKSPACE_FILENAME) \
		-configuration Release \
		-verbose \
		-scheme "$(SCHEME_FRAMEWORK_TVOS)"
	$(BUILDTOOL) \
		-workspace $(WORKSPACE_FILENAME) \
		-configuration Release \
		-verbose \
		-scheme "$(SCHEME_FRAMEWORK_WATCHOS)"

test-all:
	make deps-all
	make test-framework-all
	make test-app-all
test-framework-all:
	make test-framework-macos
	make test-framework-ios
	make test-framework-tvos
test-app-all:
	make test-app-ios
test-framework-macos:
	set -o pipefail
	$(BUILDTOOL) test \
		-verbose \
		-scheme "$(SCHEME_FRAMEWORK_MACOS)" \
		ONLY_ACTIVE_ARCH=NO \
		| xcpretty
test-framework-ios:
	set -o pipefail
	$(BUILDTOOL) test \
		-workspace $(WORKSPACE_FILENAME) \
		-configuration Release \
		-verbose \
		-scheme "$(SCHEME_FRAMEWORK_IOS)" \
		-destination "platform=iOS Simulator,OS=12.1,name=iPhone XS Max" \
		ONLY_ACTIVE_ARCH=NO \
		| xcpretty
test-framework-tvos:
	set -o pipefail
	$(BUILDTOOL) test \
		-workspace $(WORKSPACE_FILENAME) \
		-verbose \
		-scheme "$(SCHEME_FRAMEWORK_TVOS)" \
		-destination "platform=tvOS Simulator,OS=12.1,name=Apple TV 4K" \
		ONLY_ACTIVE_ARCH=NO \
		| xcpretty
test-app-ios:
	set -o pipefail
	$(BUILDTOOL) test \
		-workspace $(WORKSPACE_FILENAME) \
		-configuration Release \
		-verbose -scheme "$(SCHEME_APP_IOS)" \
		-destination "platform=iOS Simulator,OS=12.1,name=iPhone XS Max" \
		ONLY_ACTIVE_ARCH=NO \
		| xcpretty

clean:
	$(BUILDTOOL) clean