#!/usr/bin/env bash
# Pull the latest refinery-forcefield library into this repo via git subtree.
#
# Usage:
#   ./scripts/update-forcefield.sh
#
# Prerequisites:
#   The 'forcefield' remote must exist. If not, run:
#     git remote add forcefield https://github.com/BioNanomics/refinery-forcefield.git

set -euo pipefail

REMOTE="forcefield"
PREFIX="refinery-forcefield"
BRANCH="main"

# Ensure the remote exists
if ! git remote get-url "$REMOTE" &>/dev/null; then
    echo "Error: remote '$REMOTE' not found."
    echo "Add it with:  git remote add $REMOTE https://github.com/BioNanomics/refinery-forcefield.git"
    exit 1
fi

echo "Pulling latest $REMOTE/$BRANCH into $PREFIX/ ..."
git subtree pull --prefix="$PREFIX" "$REMOTE" "$BRANCH" --squash

echo "Done. Run ./gradlew build to verify."
