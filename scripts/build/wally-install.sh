#!/bin/sh
set -e
echo "Building project..."
wally install
: "${SOURCEMAP:=sourcemap.json}"
: "${PROJECT:=dev.project.json}"
rojo sourcemap "$PROJECT" --output "$SOURCEMAP"
set +e
: "${DEV_WALLY_PACKAGE_DIR:=DevPackages}"
wally-package-types "$DEV_WALLY_PACKAGE_DIR" --sourcemap "$SOURCEMAP"
: "${WALLY_PACKAGE_DIR:=Packages}"
wally-package-types "$WALLY_PACKAGE_DIR" --sourcemap "$SOURCEMAP"
set -e