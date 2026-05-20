#!/bin/bash
set -euo pipefail

# Reverse sync: copy changes from ~/.kimi/skills/ back to this repo
# Use this after you edit skills locally and want to commit the changes.

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SRC="${HOME}/.kimi/skills"
SKILLS_DEST="$REPO_DIR/skills"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[update]${NC} $1"; }
warn() { echo -e "${YELLOW}[warn]${NC} $1"; }
error() { echo -e "${RED}[error]${NC} $1"; }

main() {
    if [[ ! -d "$SKILLS_SRC" ]]; then
        error "Local skills directory not found: $SKILLS_SRC"
        exit 1
    fi

    log "Syncing changes from ${SKILLS_SRC} to repo..."

    # Dry run first
    log "Dry run preview:"
    rsync -avn --delete "$SKILLS_SRC/" "$SKILLS_DEST/"

    echo ""
    read -rp "Proceed with sync? [y/N] " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rsync -av --delete "$SKILLS_SRC/" "$SKILLS_DEST/"
        log "Sync complete. Review changes with 'git diff' and commit."
    else
        warn "Sync cancelled."
    fi
}

main "$@"
