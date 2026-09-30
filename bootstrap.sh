#!/usr/bin/env bash
# Idempotent setup for this repo: run it after cloning and whenever pins or
# lockfiles change. A second run changes nothing and prints only `ok:` lines.
#
#   ./bootstrap.sh
#
# It installs only what this repo declares: runtimes from mise.toml, system
# tools from Brewfile (via brew bundle), and project-local dependencies from
# the lockfiles. Global rules and the shared host tools: ~/dev-rules/README.md.
#
# Env:
#   SIMULATOR_NAME   iOS Simulator to boot when .xcode-version exists (default "iPhone 17")
set -euo pipefail

# Directories holding their own lockfile (npm workspaces share the root one).
DEP_DIRS=(.)

cd "$(dirname "$0")"
ROOT=$PWD
changed=0

step() { echo "==> $*"; changed=$((changed + 1)); }
ok() { echo "ok: $*"; }
warn() { echo "warn: $*" >&2; }
die() { echo "error: $*" >&2; exit 1; }

# `stale MARKER SOURCE...`: true when MARKER is missing or older than any SOURCE.
stale() {
  local marker=$1 src
  shift
  [ -e "$marker" ] || return 0
  for src in "$@"; do
    if [ -e "$src" ] && [ "$src" -nt "$marker" ]; then return 0; fi
  done
  return 1
}

# ---- (a) mise ---------------------------------------------------------------
command -v mise >/dev/null || {
  echo 'mise is not installed: run `brew bundle install --file=~/dev-rules/Brewfile` (see ~/dev-rules/README.md)' >&2
  exit 1
}

# ---- (b) runtimes from mise.toml ------------------------------------------------
if [ -f mise.toml ]; then
  if mise trust --show 2>/dev/null | grep ': untrusted' >/dev/null; then
    step "mise trust"
    mise trust --quiet
  else
    ok "mise.toml trusted"
  fi
  if [ -z "$(mise ls --current --local --missing 2>/dev/null)" ]; then
    ok "runtimes installed ($(mise ls --current --local 2>/dev/null | awk '{printf "%s%s %s", sep, $1, $2; sep=", "}'))"
  else
    step "mise install"
    mise install
  fi
else
  warn "no mise.toml: runtimes are not pinned (create one from ~/dev-rules/templates/mise.toml)"
fi

# ---- (c) system tools from the repo Brewfile --------------------------------------
if [ -f Brewfile ]; then
  if ! grep -qvE '^[[:space:]]*(#|$)' Brewfile; then
    ok "Brewfile declares nothing"
  elif HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file=Brewfile --no-upgrade >/dev/null 2>&1; then
    ok "Brewfile satisfied"
  else
    step "brew bundle install --file=Brewfile"
    HOMEBREW_NO_AUTO_UPDATE=1 brew bundle install --file=Brewfile --no-upgrade
  fi
fi

# ---- (d) project-local dependencies, by lockfile ----------------------------------
# Every command runs through `mise exec` so the pinned runtime is used even
# before the shell hook is active. Package managers other than npm (pnpm,
# yarn, bun, uv) must be declared in mise.toml.
install_deps() {
  local dir=$1 label
  label=$([ "$dir" = . ] && echo "" || echo " in $dir")
  cd "$ROOT/$dir"
  if [ -f package-lock.json ]; then
    if ! grep -q '"node_modules/' package-lock.json; then
      ok "package-lock.json declares no packages$label"
    elif stale node_modules/.package-lock.json package-lock.json; then
      step "npm ci$label"
      mise exec -- npm ci
    else
      ok "node_modules up to date with package-lock.json$label"
    fi
  elif [ -f pnpm-lock.yaml ]; then
    if stale node_modules/.modules.yaml pnpm-lock.yaml; then
      step "pnpm install --frozen-lockfile$label"
      mise exec -- pnpm install --frozen-lockfile
    else
      ok "node_modules up to date with pnpm-lock.yaml$label"
    fi
  elif [ -f yarn.lock ]; then
    if stale node_modules/.yarn-state.yml yarn.lock && stale node_modules/.yarn-integrity yarn.lock; then
      step "yarn install --immutable$label"
      mise exec -- yarn install --immutable
    else
      ok "node_modules up to date with yarn.lock$label"
    fi
  elif [ -f bun.lockb ] || [ -f bun.lock ]; then
    if stale node_modules bun.lockb bun.lock; then
      step "bun install --frozen-lockfile$label"
      mise exec -- bun install --frozen-lockfile
    else
      ok "node_modules up to date with bun lockfile$label"
    fi
  elif [ -f package.json ]; then
    warn "package.json without a lockfile$label: create one with 'mise exec -- npm install' and commit it"
  fi

  if [ -f uv.lock ]; then
    if stale .venv/pyvenv.cfg uv.lock pyproject.toml; then
      step "uv sync$label"
      mise exec -- uv sync
    else
      ok ".venv up to date with uv.lock$label"
    fi
  elif [ -f requirements.txt ]; then
    if [ ! -d .venv ]; then
      step "python -m venv .venv$label"
      mise exec -- python3 -m venv .venv
    fi
    if stale .venv/.requirements-installed requirements.txt; then
      step "pip install -r requirements.txt$label"
      .venv/bin/python -m pip install -r requirements.txt
      touch .venv/.requirements-installed
    else
      ok ".venv up to date with requirements.txt$label"
    fi
  fi

  if [ -f Gemfile.lock ]; then
    if mise exec -- bundle check >/dev/null 2>&1; then
      ok "gems satisfy Gemfile.lock$label"
    else
      step "bundle install$label"
      mise exec -- bundle install
    fi
  fi

  if [ -f Package.swift ]; then
    if stale .build/workspace-state.json Package.swift Package.resolved; then
      step "swift package resolve$label"
      swift package resolve
    else
      ok "Swift packages resolved$label"
    fi
  fi
  cd "$ROOT"
}

for dir in "${DEP_DIRS[@]}"; do
  install_deps "$dir"
done

# CocoaPods: run through mise exec because React Native Podfiles call node.
for ios_dir in ios mobile/ios; do
  [ -f "$ios_dir/Podfile" ] || continue
  if [ -f "$ios_dir/Podfile.lock" ] && cmp -s "$ios_dir/Podfile.lock" "$ios_dir/Pods/Manifest.lock"; then
    ok "Pods up to date in $ios_dir"
  else
    command -v pod >/dev/null || die "pod not found: declare brew \"cocoapods\" in Brewfile and re-run"
    step "pod install in $ios_dir"
    (cd "$ios_dir" && mise exec -- pod install)
  fi
done

# ---- (e) iOS toolchain --------------------------------------------------------
if [ -f .xcode-version ]; then
  xcode_path=$(xcode-select -p 2>/dev/null) || die "no Xcode developer directory: install Xcode from the App Store, then 'xcode-select -s /Applications/Xcode.app'"
  want="Xcode $(tr -d '[:space:]' < .xcode-version)"
  have=$(xcodebuild -version 2>/dev/null | sed -n 1p)
  if [ "$have" = "$want" ]; then
    ok "$have ($xcode_path)"
  else
    warn "Xcode mismatch: .xcode-version wants '$want', xcodebuild reports '${have:-nothing}' ($xcode_path)"
  fi

  sim=${SIMULATOR_NAME:-iPhone 17}
  if xcrun simctl list devices booted | grep "^ *$sim (" >/dev/null; then
    ok "Simulator '$sim' booted"
  else
    udid=$(xcrun simctl list devices available | grep -E "^ *$sim \(" | sed -n 1p | grep -oE '[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}') \
      || die "no available Simulator named '$sim' (set SIMULATOR_NAME, see 'xcrun simctl list devices available')"
    step "boot Simulator '$sim'"
    out=$(xcrun simctl boot "$udid" 2>&1) || case "$out" in
      *Booted*) ;;
      *) die "Simulator '$sim' did not boot: $out" ;;
    esac
  fi
fi

# ---- (f) repo-specific extras -----------------------------------------------------
if [ -x scripts/bootstrap-extra.sh ]; then
  echo "==> scripts/bootstrap-extra.sh"
  ./scripts/bootstrap-extra.sh
fi

# ---- (g) summary --------------------------------------------------------------------
if [ "$changed" -eq 0 ]; then
  echo "ok: $ROOT is up to date (nothing to do)"
else
  echo "==> done: $changed step(s) ran in $ROOT"
fi
