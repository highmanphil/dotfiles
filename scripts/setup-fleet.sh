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
