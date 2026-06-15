#!/usr/bin/env bash
set -euo pipefail

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Repository: $(git rev-parse --show-toplevel)"
else
  echo "Repository: not in a git repo"
fi

echo "user.name : $(git config --show-origin --get user.name || true)"
echo "user.email: $(git config --show-origin --get user.email || true)"
echo
echo "Author ident:"
git var GIT_AUTHOR_IDENT 2>/dev/null || true
