#!/bin/bash

# Configuration
APP_NAME="FlameSteelEngine2SceneEditor"
BUNDLE_ID="com.demensdeum.FlameSteelEngine2SceneEditor"
TARGET_TRIPLE="arm64-apple-ios-macabi"
BUILD_DIR=".build/$TARGET_TRIPLE/debug"
DEPLOY_DIR=".build/deploy/$APP_NAME.app/Contents"

# Build
PresentationKitFrontend=UIKit swift build --destination catalyst.json || exit 1

# Package
echo "Packaging application..."
mkdir -p "$DEPLOY_DIR/MacOS"
mkdir -p "$DEPLOY_DIR/Resources"

# Copy binary
cp "$BUILD_DIR/$APP_NAME" "$DEPLOY_DIR/MacOS/$APP_NAME"

# Copy Info.plist
cp src/Info.plist ".build/deploy/$APP_NAME.app/Contents/Info.plist"

# Codesign (ad-hoc)
echo "Codesigning application..."
codesign --force --deep --sign - ".build/deploy/$APP_NAME.app"

echo "Build and packaging complete!"
echo "To launch: open .build/deploy/$APP_NAME.app"