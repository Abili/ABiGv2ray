#!/usr/bin/env bash
set -euo pipefail

# Build Android V2Ray library and place the resulting AAR in the app libs folder.
# XRAY_CORE_VERSION environment variable can be set to specify a version or commit.

WORKDIR=$(pwd)
BUILD_DIR="$WORKDIR/build"
LIB_REPO=https://github.com/2dust/AndroidLibXrayLite.git

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

if [ ! -d AndroidLibXrayLite ]; then
    git clone --depth=1 -b main "$LIB_REPO"
fi

cd AndroidLibXrayLite

if [ -n "${XRAY_CORE_VERSION:-}" ]; then
    go get github.com/xtls/xray-core@"$XRAY_CORE_VERSION" || true
fi

gomobile init

go mod tidy -v
gomobile bind -v -androidapi 19 -ldflags='-s -w' ./

cp ./*.aar "$WORKDIR/V2rayNG/app/libs/"

echo "AAR copied to V2rayNG/app/libs" 
