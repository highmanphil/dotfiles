#!/usr/bin/env bash
set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

dotfiles_dir="${DOTFILES_DIR:-$HOME/dotfiles}"
skill_store="${FLEET_SKILL_STORE:-$HOME/.local/share/fleet-skills}"
skill_remote="${FLEET_SKILL_REMOTE:-git@github.com:highmanphil/fleet-skills.git}"
skill_identity="${FLEET_SKILL_IDENTITY:-$HOME/.ssh/id_fleet_skills_github}"
state_dir="${FLEET_STATE_DIR:-$HOME/.local/state/fleet}"
lock_dir="$state_dir/converge.lock"

controller() {
  case "$(hostname -s 2>/dev/null || hostname)" in
    Philipps-MacBook-Air|philipps-macbook-air|10) printf 'mac\n' ;;
    phil-cachyos) printf 'home\n' ;;
    ubuntu) printf 'vps\n' ;;
    *) [[ "$(uname -s)" == Darwin ]] && printf 'mac\n' || printf 'unknown\n' ;;
  esac
}

log() {
  printf '[fleet-converge] %s\n' "$*"
}

remove_path() {
  [[ ! -e "$1" && ! -L "$1" ]] || find "$1" -depth -delete
}

acquire_lock() {
  local owner_pid=''
  mkdir -p "$state_dir"
  if mkdir "$lock_dir" 2>/dev/null; then
    printf '%s\n' "$$" > "$lock_dir/pid"
    return
  fi

  [[ -f "$lock_dir/pid" ]] && IFS= read -r owner_pid < "$lock_dir/pid"
  if [[ "$owner_pid" =~ ^[0-9]+$ ]] && kill -0 "$owner_pid" 2>/dev/null; then
    log "another convergence run is active (pid $owner_pid)"
    exit 0
  fi

  remove_path "$lock_dir"
  mkdir "$lock_dir"
  printf '%s\n' "$$" > "$lock_dir/pid"
}

finish() {
  local exit_code="$?"
  mkdir -p "$state_dir"
  if [[ "$exit_code" -eq 0 ]]; then
    date -u '+%Y-%m-%dT%H:%M:%SZ' > "$state_dir/last-success"
    remove_path "$state_dir/last-error"
  else
    printf '%s exit=%s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$exit_code" > "$state_dir/last-error"
  fi
  remove_path "$lock_dir"
  exit "$exit_code"
}

configure_skill_remote() {
  [[ -f "$skill_identity" ]] || {
    printf 'Missing fleet skill GitHub identity: %s\n' "$skill_identity" >&2
    return 2
  }
  git -C "$skill_store" config core.sshCommand \
    "ssh -o BatchMode=yes -o IdentitiesOnly=yes -i $skill_identity"
  if git -C "$skill_store" remote get-url origin >/dev/null 2>&1; then
    git -C "$skill_store" remote set-url origin "$skill_remote"
  else
    git -C "$skill_store" remote add origin "$skill_remote"
  fi
}

converge_dotfiles() {
  local local_head remote_head
  [[ -d "$dotfiles_dir/.git" ]] || {
    printf 'Missing dotfiles checkout: %s\n' "$dotfiles_dir" >&2
    return 2
  }
  [[ -z "$(git -C "$dotfiles_dir" status --porcelain)" ]] || {
    printf 'Refusing to converge a dirty dotfiles checkout:\n' >&2
    git -C "$dotfiles_dir" status --short >&2
    return 20
  }

  git -C "$dotfiles_dir" fetch --quiet origin main
  local_head="$(git -C "$dotfiles_dir" rev-parse HEAD)"
  remote_head="$(git -C "$dotfiles_dir" rev-parse origin/main)"
  if [[ "$local_head" == "$remote_head" ]]; then
    return
  fi
  if git -C "$dotfiles_dir" merge-base --is-ancestor "$local_head" "$remote_head"; then
    git -C "$dotfiles_dir" merge --ff-only --quiet "$remote_head"
    return
  fi

  printf 'Dotfiles is ahead of or diverged from origin/main; publish or resolve it on a controller.\n' >&2
  return 20
}

converge_skills() {
  local local_head remote_head host_role
  if [[ ! -d "$skill_store/.git" ]]; then
    if [[ -d "$skill_store" && -n "$(find "$skill_store" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]; then
      printf 'Refusing to replace a non-empty, unmanaged skill store: %s\n' "$skill_store" >&2
      return 20
    fi
    remove_path "$skill_store"
    GIT_SSH_COMMAND="ssh -o BatchMode=yes -o IdentitiesOnly=yes -i $skill_identity" \
      git clone --quiet "$skill_remote" "$skill_store"
  fi

  configure_skill_remote
  [[ -z "$(git -C "$skill_store" status --porcelain)" ]] || {
    printf 'Refusing to converge a locally modified skill store:\n' >&2
    git -C "$skill_store" status --short >&2
    return 20
  }

  git -C "$skill_store" fetch --quiet origin main
  local_head="$(git -C "$skill_store" rev-parse HEAD)"
  remote_head="$(git -C "$skill_store" rev-parse origin/main)"
  if [[ "$local_head" == "$remote_head" ]]; then
    return
  fi
  if git -C "$skill_store" merge-base --is-ancestor "$local_head" "$remote_head"; then
    git -C "$skill_store" merge --ff-only --quiet "$remote_head"
    return
  fi

  host_role="$(controller)"
  if [[ "$host_role" == mac || "$host_role" == home ]] && \
     git -C "$skill_store" merge-base --is-ancestor "$remote_head" "$local_head"; then
    log "publishing queued skill revision from $host_role"
    git -C "$skill_store" push --quiet origin HEAD:main
    return
  fi

  printf 'Skill store has diverged from origin/main; resolve it on a controller.\n' >&2
  return 20
}

acquire_lock
trap finish EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

log "converging dotfiles"
converge_dotfiles
log "converging private skills"
converge_skills
log "applying fleet configuration"
"$dotfiles_dir/scripts/setup-fleet.sh"
log "converged dotfiles=$(git -C "$dotfiles_dir" rev-parse --short HEAD) skills=$(git -C "$skill_store" rev-parse --short HEAD)"
