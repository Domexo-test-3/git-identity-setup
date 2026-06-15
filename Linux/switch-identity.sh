#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo 'Usage: ./switch-identity.sh "Name" "email@example.com"'
  exit 1
fi

git config user.name "$1"
git config user.email "$2"

echo "Updated local repo identity:"
git config --show-origin --get user.name
git config --show-origin --get user.email
