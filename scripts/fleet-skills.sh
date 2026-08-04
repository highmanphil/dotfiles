#!/usr/bin/env bash
set -euo pipefail

dotfiles_dir="${DOTFILES_DIR:-$HOME/dotfiles}"
manifest="$dotfiles_dir/agents/skills-manifest.txt"
skill_store="${FLEET_SKILL_STORE:-$HOME/.local/share/fleet-skills}"

controller() {
  case "$(hostname -s 2>/dev/null || hostname)" in
    Philipps-MacBook-Air|philipps-macbook-air) printf 'mac\n' ;;
    phil-cachyos) printf 'home\n' ;;
    *) [[ "$(uname -s)" == Darwin ]] && printf 'mac\n' || printf 'unsupported\n' ;;
  esac
}

endpoint() {
  case "$1" in
    mac) printf 'phil@100.123.207.72\n' ;;
    home) printf 'phil@100.104.47.26\n' ;;
    vps) printf 'root@217.160.186.7\n' ;;
    *) return 2 ;;
  esac
}

identity() {
  case "$(controller):$1" in
    mac:home|mac:vps) printf '%s/.ssh/id_rsa\n' "$HOME" ;;
    home:mac|home:vps) printf '%s/.ssh/id_gmx\n' "$HOME" ;;
    *) return 2 ;;
  esac
}

require_controller() {
  [[ "$(controller)" == mac || "$(controller)" == home ]] || {
    printf 'Install and synchronize personal skills from the Mac or Home PC.\n' >&2
    exit 2
  }
}

require_clean_current_repo() {
  [[ -d "$dotfiles_dir/.git" ]] || { printf 'Missing dotfiles checkout: %s\n' "$dotfiles_dir" >&2; exit 2; }
  [[ -z "$(git -C "$dotfiles_dir" status --porcelain)" ]] || {
    printf 'Refusing skill synchronization while dotfiles has local changes:\n' >&2
    git -C "$dotfiles_dir" status --short >&2
    exit 20
  }
  git -C "$dotfiles_dir" fetch origin
  [[ "$(git -C "$dotfiles_dir" rev-parse HEAD)" == "$(git -C "$dotfiles_dir" rev-parse origin/main)" ]] || {
    printf 'Dotfiles main is not aligned with origin/main; pull or resolve it first.\n' >&2
    exit 20
  }
}

managed_skill_name() {
  case "$1" in
    .system|codex-*|fleet) return 0 ;;
    *) return 1 ;;
  esac
}

capture_installed() {
  local root source name resolved destination
  mkdir -p "$skill_store"
  for root in "$HOME/.agents/skills" "$HOME/.codex/skills"; do
    [[ -d "$root" ]] || continue
    for source in "$root"/* "$root"/.[!.]* "$root"/..?*; do
      [[ -e "$source" || -L "$source" ]] || continue
      name="$(basename "$source")"
      managed_skill_name "$name" && continue
      [[ "$name" =~ ^[a-z0-9][a-z0-9_-]*$ ]] || {
        printf 'Skipping invalid skill directory name: %s\n' "$name" >&2
        continue
      }
      [[ -f "$source/SKILL.md" ]] || continue
      resolved="$(cd "$source" && pwd -P)"
      destination="$skill_store/$name"
      [[ "$resolved" == "$destination" ]] && continue
      mkdir -p "$destination"
      rsync -aL --delete --exclude '.git/' --exclude '.DS_Store' --exclude '__pycache__/' "$source/" "$destination/"
    done
  done
}

refresh_manifest() {
  local temporary
  temporary="$(mktemp)"
  find "$skill_store" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | LC_ALL=C sort -u > "$temporary"
  if ! cmp -s "$temporary" "$manifest"; then
    mv "$temporary" "$manifest"
  else
    find "$temporary" -delete
  fi
}

push_store_to() {
  local target="$1" key remote
  [[ "$target" == "$(controller)" ]] && return
  key="$(identity "$target")"
  remote="$(endpoint "$target")"
  ssh -o BatchMode=yes -o IdentitiesOnly=yes -i "$key" "$remote" 'mkdir -p "$HOME/.local/share/fleet-skills"'
  rsync -a --delete \
    -e "ssh -o BatchMode=yes -o IdentitiesOnly=yes -i $key" \
    "$skill_store/" "$remote:.local/share/fleet-skills/"
}

commit_manifest_if_changed() {
  if [[ -n "$(git -C "$dotfiles_dir" status --porcelain -- agents/skills-manifest.txt)" ]]; then
    git -C "$dotfiles_dir" add -- agents/skills-manifest.txt
    git -C "$dotfiles_dir" commit -m 'Synchronize fleet skill manifest'
    git -C "$dotfiles_dir" push origin main
  fi
}

capture_and_sync() {
  require_controller
  require_clean_current_repo
  capture_installed
  refresh_manifest
  commit_manifest_if_changed
  for target in mac home vps; do push_store_to "$target"; done
  "$HOME/.codex/skills/fleet/scripts/fleetctl" sync all
}

case "${1:-}" in
  install)
    shift
    require_controller
    require_clean_current_repo
    npx --yes skills "$@"
    capture_and_sync
    ;;
  capture-and-sync)
    capture_and_sync
    ;;
  *)
    printf 'Usage: fleet-skills.sh install <skills-cli arguments...>\n' >&2
    printf '       fleet-skills.sh capture-and-sync\n' >&2
    exit 2
    ;;
esac
