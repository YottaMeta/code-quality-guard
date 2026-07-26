#!/usr/bin/env bash
#
# code-quality-guard — portable cross-agent installer.
#
# Copies the code-quality-guard/ skill folder (SKILL.md + references/) into the
# skills directory of the target agent. Single-level layout, so relative reads
# (references/*.md) always resolve.
#
# Usage:
#   ./install.sh <platform> [--project] [--dir PATH]
#
# Platforms: workbuddy codex claude cursor agents opencode gemini
#   agents = vendor-neutral ~/.agents/skills (read by Cursor, Copilot, pi, Gemini, Codex)
#
set -euo pipefail

PLATFORMS="workbuddy codex claude cursor agents opencode gemini"

err()  { printf '\033[31merror:\033[0m %s\n' "$*" >&2; }
info() { printf '\033[36m›\033[0m %s\n' "$*"; }
ok()   { printf '\033[32m✓\033[0m %s\n' "$*"; }

global_dir() {
  case "$1" in
    workbuddy) printf '%s' "$HOME/.workbuddy/skills" ;;
    codex)     printf '%s' "$HOME/.codex/skills" ;;
    claude)    printf '%s' "$HOME/.claude/skills" ;;
    cursor)    printf '%s' "$HOME/.cursor/skills" ;;
    agents)    printf '%s' "$HOME/.agents/skills" ;;
    opencode)  printf '%s' "$HOME/.config/opencode/skills" ;;
    gemini)    printf '%s' "$HOME/.gemini/skills" ;;
    *)         return 1 ;;
  esac
}

project_dir() {
  case "$1" in
    workbuddy) printf '%s' "$PWD/.workbuddy/skills" ;;
    codex)     printf '%s' "$PWD/.codex/skills" ;;
    claude)    printf '%s' "$PWD/.claude/skills" ;;
    cursor)    printf '%s' "$PWD/.cursor/skills" ;;
    agents)    printf '%s' "$PWD/.agents/skills" ;;
    opencode)  printf '%s' "$PWD/.opencode/skills" ;;
    gemini)    printf '%s' "$PWD/.gemini/skills" ;;
    *)         return 1 ;;
  esac
}

PLATFORM=""
SCOPE="global"
EXPLICIT_DIR=""
while [ $# -gt 0 ]; do
  case "$1" in
    --project|--here) SCOPE="project" ;;
    --dir)            shift; EXPLICIT_DIR="${1:-}" ;;
    --list)           printf 'Supported platforms: %s\n' "$PLATFORMS"; exit 0 ;;
    -h|--help)        sed -n '2,22p' "${BASH_SOURCE[0]:-$0}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*)               err "unknown flag: $1"; exit 2 ;;
    *)                PLATFORM="$1" ;;
  esac
  shift
done

if [ -z "$PLATFORM" ] && [ -z "$EXPLICIT_DIR" ]; then
  err "no platform given. Example: ./install.sh workbuddy"
  printf 'Supported platforms: %s\n' "$PLATFORMS" >&2
  exit 2
fi

if [ -n "$EXPLICIT_DIR" ]; then
  DEST="$EXPLICIT_DIR"
elif [ "$SCOPE" = "project" ]; then
  DEST="$(project_dir "$PLATFORM")" || { err "unknown platform: $PLATFORM"; exit 2; }
else
  DEST="$(global_dir "$PLATFORM")" || { err "unknown platform: $PLATFORM"; exit 2; }
fi

# resolve this skill's folder (adjacent to install.sh)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" >/dev/null 2>&1 && pwd || true)"
SRC="$SCRIPT_DIR"

[ -f "$SRC/SKILL.md" ] || { err "SKILL.md not found next to install.sh ($SRC)"; exit 1; }

mkdir -p "$DEST/code-quality-guard"
cp -R "$SRC/." "$DEST/code-quality-guard/"

ok "Installed code-quality-guard -> $DEST/code-quality-guard"
info "Next: open the agent and say 'review this PR' / 'audit the architecture'."
