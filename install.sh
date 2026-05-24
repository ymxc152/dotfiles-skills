#!/bin/bash
set -euo pipefail

# dotfiles-skills installer
# Symlinks all skills from this repo to ~/.claude/skills/

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
SKILLS_DEST="${HOME}/.claude/skills"
BACKUP_DIR="${HOME}/.claude/skills-backup-$(date +%Y%m%d-%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() { echo -e "${GREEN}[install]${NC} $1"; }
warn() { echo -e "${YELLOW}[warn]${NC} $1"; }
error() { echo -e "${RED}[error]${NC} $1"; }

check_deps() {
    if ! command -v rsync &>/dev/null; then
        error "rsync is required but not installed."
        exit 1
    fi
}

main() {
    log "Installing dotfiles-skills to ${SKILLS_DEST}"

    if [[ ! -d "$SKILLS_SRC" ]]; then
        error "Skills source directory not found: $SKILLS_SRC"
        exit 1
    fi

    # Backup existing skills
    if [[ -d "$SKILLS_DEST" ]]; then
        log "Backing up existing skills to ${BACKUP_DIR}"
        mkdir -p "$BACKUP_DIR"
        rsync -a "$SKILLS_DEST/" "$BACKUP_DIR/"
    fi

    # Ensure destination exists
    mkdir -p "$SKILLS_DEST"

    # Copy (not symlink) to avoid issues with deleted repo or moved folders
    # If you prefer symlinks for live-editing, change -a to -as
    log "Copying skills from repo to ${SKILLS_DEST}..."
    rsync -av --delete "$SKILLS_SRC/" "$SKILLS_DEST/"

    # Count installed skills
    local count
    count=$(find "$SKILLS_DEST" -name "SKILL.md" | wc -l)
    log "Installed ${count} skills successfully."
    log "Backup saved to: ${BACKUP_DIR}"
    log "Done!"
}

check_deps
main "$@"
