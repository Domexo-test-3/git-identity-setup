# Git identity setup for multiple organisations

This package helps you use different Git commit identities across organisations, projects, and individual repositories.

It supports:
- a default identity for personal or fallback use
- organisation-specific identity based on repository path
- one-off identities for a single commit
- Linux and Windows setup scripts
- safe integration with an existing `~/.gitconfig` or `%USERPROFILE%\.gitconfig`

Important:
- `user.name` and `user.email` control commit author and committer details
- authentication for push and pull is separate from commit identity
- Git for VS Code uses the same Git configuration as your terminal

## What this package contains

- `.gitconfig-base` — default identity template
- `.gitconfig-organisation-a.example` — example organisation identity template
- `.gitconfig-organisation-b.example` — example organisation identity template
- `Linux/install.sh` — Linux installer
- `Linux/switch-identity.sh` — Linux local repo override helper
- `Linux/verify-identity.sh` — Linux identity checker
- `Windows/install.ps1` — Windows installer
- `Windows/switch-identity.ps1` — Windows local repo override helper
- `Windows/verify-identity.ps1` — Windows identity checker
- `REPO-OVERRIDE-NOTE.txt` — one-off repo override reminder

## Recommended folder layout

Use a predictable path for repositories, for example:

```text
~/work/organisation-a/
~/work/organisation-b/
```

On Windows:

```text
C:\work\organisation-a\
C:\work\organisation-b\
```

A repository stored under one of those folders will automatically use the matching identity.

## Existing Git config

This package is designed to preserve an existing global config.

It does not delete or replace your current `~/.gitconfig` or `%USERPROFILE%\.gitconfig`.

It only:
- makes a backup before editing
- writes the organisation-specific include rules if they are not already present
- leaves your existing settings in place

If your current global config already contains `user.name`, `user.email`, aliases, editors, or other settings, they remain available unless a more specific repo or organisation rule overrides them.

## Setup

1. Edit the placeholder names, emails, and repository paths in the files.
2. Run the installer for your platform.
3. Place repositories in the correct organisation folders.
4. Verify inside a repository.

## One-off commit identity

For a single commit, use:

```bash
git -c user.name="Alt Name" -c user.email="alt@example.com" commit -m "Message"
```

Or set author and committer explicitly:

```bash
GIT_AUTHOR_NAME="Alt Name" GIT_AUTHOR_EMAIL="alt@example.com" GIT_COMMITTER_NAME="Alt Name" GIT_COMMITTER_EMAIL="alt@example.com" git commit -m "Message"
```

## Checking the active identity

Inside a repository:

```bash
git config --show-origin --get user.name
git config --show-origin --get user.email
```

Or:

```bash
git var GIT_AUTHOR_IDENT
```

## VS Code notes

VS Code uses the Git installation on your system. Once Git is configured, VS Code will use the same identity automatically.

If a commit shows the wrong name or email:
- confirm the repository is under the expected organisation folder
- confirm the repo does not have a local override in `.git/config`
- confirm the global config does not contain an older conflicting override above the included organisation block

## Switching an existing repo

If one repository needs a different identity from the folder rule, set a local override in that repository.

That override only applies to that repository.

## Good practice

- keep one default identity in your existing global Git config or in `.gitconfig-base`
- use `includeIf` for stable organisation identities
- use repo-local overrides only for exceptions
- keep email addresses aligned with the correct account or policy
