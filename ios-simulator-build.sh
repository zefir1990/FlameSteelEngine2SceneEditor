#!/bin/bash

# Configuration
APP_NAME="FlameSteelEngine2SceneEditor"
BUNDLE_ID="com.demensdeum.FlameSteelEngine2SceneEditor"
TARGET_TRIPLE="arm64-apple-ios-simulator"
BUILD_DIR=".build/$TARGET_TRIPLE/debug"
DEPLOY_DIR=".build/deploy-ios/$APP_NAME.app"

# Ensure we are using SwiftUI frontend
export PresentationKitFrontend=SwiftUI

# Build
echo "Building for iOS Simulator with SwiftUI frontend..."
swift build --destination ios-simulator.json || exit 1

# Package
echo "Packaging application..."
rm -rf "$DEPLOY_DIR"
mkdir -p "$DEPLOY_DIR"

# Copy binary
cp "$BUILD_DIR/$APP_NAME" "$DEPLOY_DIR/$APP_NAME"

# Copy Info.plist
cp src/Info.plist "$DEPLOY_DIR/Info.plist"

# Boot simulator if needed
echo "Finding available simulator..."
DEVICE_ID=$(xcrun simctl list devices available | grep "iPhone" | grep -v "unavailable" | head -n 1 | sed -E 's/.*\(([A-F0-9-]+)\).*/\1/')

if [ -z "$DEVICE_ID" ]; then
    echo "No available iOS Simulator found."
    exit 1
fi

echo "Using device IDE: $DEVICE_ID"
xcrun simctl boot "$DEVICE_ID" 2>/dev/null
open -a Simulator

# Install and Launch
echo "Installing application..."
xcrun simctl install "$DEVICE_ID" "$DEPLOY_DIR"

echo "Launching application..."
xcrun simctl launch --console "$DEVICE_ID" "$BUNDLE_ID"

echo "Build and launch complete!"
