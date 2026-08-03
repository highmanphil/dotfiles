#!/usr/bin/env bash
set -euo pipefail

dotfiles_dir="${DOTFILES_DIR:-$HOME/dotfiles}"
timestamp="$(date +%Y%m%d-%H%M%S)"

if [[ "$(id -u)" -eq 0 ]]; then
  sudo_cmd=()
else
  sudo_cmd=(sudo)
fi

if command -v apt-get >/dev/null 2>&1; then
  "${sudo_cmd[@]}" apt-get update
  "${sudo_cmd[@]}" apt-get install -y zsh git curl ca-certificates
fi

clone_if_missing() {
  local url="$1" destination="$2"
  [[ -d "$destination/.git" ]] || git clone --depth 1 "$url" "$destination"
}

clone_if_missing https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
clone_if_missing https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/Aloxaf/fzf-tab.git "$HOME/.oh-my-zsh/custom/plugins/fzf-tab"

link_config() {
  local source="$1" destination="$2"
  if [[ -e "$destination" && ! -L "$destination" ]]; then
    mv "$destination" "$destination.codex-backup-$timestamp"
  fi
  ln -sfn "$source" "$destination"
}

link_config "$dotfiles_dir/zsh/.zshrc.remote" "$HOME/.zshrc"
link_config "$dotfiles_dir/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
link_config "$dotfiles_dir/zsh/.aliases.zsh" "$HOME/.aliases.zsh"
link_config "$dotfiles_dir/zsh/.p10k-mac-ssh.zsh" "$HOME/.p10k-mac-ssh.zsh"

zsh_path="$(command -v zsh)"
if [[ "$SHELL" != "$zsh_path" ]]; then
  "${sudo_cmd[@]}" chsh -s "$zsh_path" "$(id -un)"
fi

printf 'Remote zsh configured from %s\n' "$dotfiles_dir"
