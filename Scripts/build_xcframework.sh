#!/bin/sh
#
#  Copyright (c) Max A. Akhmatov
#
#  MIT License
#  For full license text, see LICENSE file in the repository root.

#
# Script builds XCFramework archive for both ARM64 and x86 architectures
#

# Set failure condition to catch exit codes
set -e

LOG_PREFIX="[XCFramework]"
XCODE_PROJECT_PATH="$1"
RELEASE_SCHEME="$2"
ARTIFACT_FINAL_BUILD_PATH="${SRCROOT}/XCFramework/build"
FRAMEWORK_PRODUCT_NAME="${PRODUCT_NAME}"

ARCHIVE_PATH_ARM64="${BUILD_DIR}/${FRAMEWORK_PRODUCT_NAME}-macosx_arm64.xcarchive"

if [ -z "${XCODE_PROJECT_PATH}" ]
then
    echo "$LOG_PREFIX *** ERROR ***"
    echo "$LOG_PREFIX Please specify Xcode project path as the parameter #1";
    exit -1
fi

if [ -z "${RELEASE_SCHEME}" ]
then
    echo "$LOG_PREFIX *** ERROR ***"
    echo "$LOG_PREFIX Please specify scheme in Xcode project as the parameter #2";
    exit -1
fi

echo "$LOG_PREFIX Started XCFramework build for scheme: ${RELEASE_SCHEME}"

# ----------------------------------
# CLEAN UP PREVIOUS BUILD OUTPUT
# ----------------------------------

echo "$LOG_PREFIX Clean up previous build output"

rm -rf "${ARTIFACT_FINAL_BUILD_PATH}"
rm -rf "${BUILD_DIR}/${FRAMEWORK_PRODUCT_NAME}.xcframework"

# ----------------------------------
# BUILD PLATFORM SPECIFIC FRAMEWORKS
# ----------------------------------

echo "$LOG_PREFIX Started build for arm64"

# arm64
xcodebuild archive \
    -project "${XCODE_PROJECT_PATH}" \
    -scheme "${RELEASE_SCHEME}" \
    -destination "platform=macOS,arch=arm64" \
    -archivePath "${ARCHIVE_PATH_ARM64}" \
    -configuration Release \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
    
# ----------------------------------
# MAKE AN ARCHIVE
# ----------------------------------
    
echo "$LOG_PREFIX Combine archives into XCFramework"

xcodebuild -create-xcframework \
    -archive "${ARCHIVE_PATH_ARM64}" -framework "${FRAMEWORK_PRODUCT_NAME}.framework" \
    -output "${BUILD_DIR}/${FRAMEWORK_PRODUCT_NAME}.xcframework"

# ----------------------------------
# COPY OUTPUT
# ----------------------------------

echo "$LOG_PREFIX Copy new build output"

mkdir -p "${ARTIFACT_FINAL_BUILD_PATH}"
cp -rf "${BUILD_DIR}/${FRAMEWORK_PRODUCT_NAME}.xcframework" "${ARTIFACT_FINAL_BUILD_PATH}"
