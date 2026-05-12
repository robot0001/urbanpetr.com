#!/usr/bin/env bash
# Usage: ./bump-foundation.sh v1.2.0
set -euo pipefail
VERSION=${1:?Usage: $0 <version>}
DIR="$(cd "$(dirname "$0")" && pwd)/modules"
find "$DIR" -name "*.tf" -exec \
  sed -i '' "s|urbanpetr-foundation//\(.*\)?ref=v[0-9.]*|urbanpetr-foundation//\1?ref=$VERSION|g" {} +
echo "Bumped foundation modules to $VERSION"
