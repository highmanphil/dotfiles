#!/usr/bin/env bash
set -euo pipefail

dotfiles_dir="${DOTFILES_DIR:-$HOME/dotfiles}"
replace_managed=0
[[ "${1:-}" == "--replace-managed" ]] && replace_managed=1

link_managed() {
  local source="$1" destination="$2"
  mkdir -p "$(dirname "$destination")"

  if [[ -L "$destination" ]]; then
    if [[ "$(readlink "$destination")" == "$source" ]]; then
      return
    fi
    rm "$destination"
  elif [[ -e "$destination" ]]; then
    if cmp -s "$source" "$destination" || [[ "$replace_managed" -eq 1 ]]; then
      rm "$destination"
    else
      printf 'Refusing to replace unmanaged file: %s\n' "$destination" >&2
      printf 'Review it, then rerun with --replace-managed. No backup file was created.\n' >&2
      return 1
    fi
  fi

  ln -s "$source" "$destination"
}

link_managed "$dotfiles_dir/agents/.codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
link_managed "$dotfiles_dir/agents/.codex/skills/fleet" "$HOME/.codex/skills/fleet"

skill_manifest="$dotfiles_dir/agents/skills-manifest.txt"
skill_store="$HOME/.local/share/fleet-skills"
mkdir -p "$HOME/.agents/skills" "$HOME/.codex/skills" "$skill_store"

skill_selected() {
  grep -Fqx "$1" "$skill_manifest"
}

prune_personal_skills() {
  local root="$1" mode="$2" entry name
  for entry in "$root"/* "$root"/.[!.]* "$root"/..?*; do
    [[ -e "$entry" || -L "$entry" ]] || continue
    name="$(basename "$entry")"
    if [[ "$mode" == agents ]]; then
      skill_selected "$name" && continue
    else
      case "$name" in
        .system|codex-*|fleet) continue ;;
      esac
    fi
    find "$entry" -depth -delete
  done
}

prune_personal_skills "$HOME/.agents/skills" agents
prune_personal_skills "$HOME/.codex/skills" codex

link_shared_skill() {
  local source="$1" destination="$2"
  if [[ -L "$destination" && "$(readlink "$destination")" == "$source" ]]; then
    return
  fi
  if [[ -e "$destination" || -L "$destination" ]]; then
    find "$destination" -depth -delete
  fi
  ln -s "$source" "$destination"
}

while IFS= read -r skill_name; do
  [[ -n "$skill_name" && "$skill_name" != \#* ]] || continue
  if [[ -f "$skill_store/$skill_name/SKILL.md" ]]; then
    link_shared_skill "$skill_store/$skill_name" "$HOME/.agents/skills/$skill_name"
  else
    printf 'Shared skill content is not present on this machine: %s\n' "$skill_name" >&2
  fi
done < "$skill_manifest"

for name in .zshrc .envs.zsh .p10k.zsh .aliases.zsh .p10k-mac-ssh.zsh; do
  link_managed "$dotfiles_dir/zsh/$name" "$HOME/$name"
done

case "$(uname -s):$(hostname -s 2>/dev/null || hostname)" in
  Darwin:*)
    link_managed "$dotfiles_dir/cmux/.config/cmux/cmux.json" "$HOME/.config/cmux/cmux.json"
    ;;
  Linux:phil-cachyos)
    link_managed "$dotfiles_dir/limux/.config/limux/settings.json" "$HOME/.config/limux/settings.json"
    ;;
esac

printf 'Fleet configuration linked from %s\n' "$dotfiles_dir"
