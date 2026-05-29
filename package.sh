#!/usr/bin/env bash
set -euo pipefail

MOD_NAME="$(jq -r .name info.json)"
VERSION="$(jq -r .version info.json)"
DIR="${MOD_NAME}_${VERSION}"
ZIP="${DIR}.zip"

rm -rf "$DIR" "$ZIP"
mkdir "$DIR"

rsync -a \
  --exclude '.git' \
  --exclude "$DIR" \
  --exclude "$ZIP" \
  --exclude 'package.sh' \
  --exclude 'temp' \
  ./ "$DIR/"

zip -r "$ZIP" "$DIR"

rm -rf "$DIR"

echo "Created $ZIP"
