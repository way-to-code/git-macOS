#!/bin/sh
#
#  Copyright (c) 2023 Max A. Akhmatov
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#  http:#www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

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
