#!/usr/bin/env bash
set -euo pipefail

HOME_GITCONFIG="${HOME}/.gitconfig"
BACKUP_SUFFIX="$(date +%Y%m%d-%H%M%S)"

ORG_A_CONFIG="${HOME}/.gitconfig-organisation-a"
ORG_B_CONFIG="${HOME}/.gitconfig-organisation-b"

ORG_A_NAME="Organisation A Name"
ORG_A_EMAIL="you@organisation-a.example"

ORG_B_NAME="Organisation B Name"
ORG_B_EMAIL="you@organisation-b.example"

ORG_A_REPO_DIR="${HOME}/work/organisation-a/"
ORG_B_REPO_DIR="${HOME}/work/organisation-b/"

backup_if_needed() {
  if [[ -f "$HOME_GITCONFIG" ]]; then
    cp "$HOME_GITCONFIG" "${HOME_GITCONFIG}.backup-${BACKUP_SUFFIX}"
  else
    touch "$HOME_GITCONFIG"
  fi
}

write_org_config() {
  local path="$1"
  local name="$2"
  local email="$3"

  cat > "$path" <<EOF
[user]
    name = ${name}
    email = ${email}
EOF
}

append_include_if_missing() {
  local marker="$1"
  local rule="$2"
  local path="$3"

  if ! grep -Fq "$marker" "$HOME_GITCONFIG"; then
    {
      echo ""
      echo "# $marker"
      echo "[includeIf \"$rule\"]"
      echo "    path = $path"
    } >> "$HOME_GITCONFIG"
  fi
}

mkdir -p "${HOME}/work/organisation-a" "${HOME}/work/organisation-b"

backup_if_needed
write_org_config "$ORG_A_CONFIG" "$ORG_A_NAME" "$ORG_A_EMAIL"
write_org_config "$ORG_B_CONFIG" "$ORG_B_NAME" "$ORG_B_EMAIL"

append_include_if_missing "Git identity: organisation-a" "gitdir:${ORG_A_REPO_DIR}" "$ORG_A_CONFIG"
append_include_if_missing "Git identity: organisation-b" "gitdir:${ORG_B_REPO_DIR}" "$ORG_B_CONFIG"

chmod 600 "$HOME_GITCONFIG" "$ORG_A_CONFIG" "$ORG_B_CONFIG"

cat <<EOF
Installed.

Updated:
  $HOME_GITCONFIG
  $ORG_A_CONFIG
  $ORG_B_CONFIG

Backup:
  ${HOME_GITCONFIG}.backup-${BACKUP_SUFFIX}

Next:
  1. Edit the names, emails, and repo folder paths if needed.
  2. Put repositories under:
     ${ORG_A_REPO_DIR}
     ${ORG_B_REPO_DIR}
  3. Verify with:
     git config --show-origin --get user.name
     git config --show-origin --get user.email
EOF
