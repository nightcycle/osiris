#!/bin/sh
set -e
echo "Building project..."
wally install
rojo sourcemap "$PROJECT" --output "$SOURCEMAP"
set +e
wally-package-types "$DEV_WALLY_PACKAGE_DIR" --sourcemap "$SOURCEMAP"
set -e