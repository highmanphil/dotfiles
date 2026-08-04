# Codex snapshots source .zshrc non-interactively. Export the portable
# environment without loading the interactive prompt and plugin stack.
if [[ ! -o interactive ]]; then
  [[ ! -f ~/.envs.zsh ]] || source ~/.envs.zsh
  return
fi

# Keep Powerlevel10k's instant prompt before anything that can perform I/O.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  fzf-tab
)

[[ ! -f ~/.envs.zsh ]] || source ~/.envs.zsh
[[ ! -f ~/.aliases.zsh ]] || source ~/.aliases.zsh
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
source "$ZSH/oh-my-zsh.sh"

# direnv's hook applies allowed environments on the first prompt and on every
# directory change. Avoid a second eager `direnv export` during shell startup.
if (( ${+commands[direnv]} )); then
  eval "$(direnv hook zsh)"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f ~/.p10k-mac-ssh.zsh ]] || source ~/.p10k-mac-ssh.zsh

[ -f "$HOME/.zsh_home" ] && source "$HOME/.zsh_home"
[ -f "$HOME/.zsh_work" ] && source "$HOME/.zsh_work"

# NVM is the dominant shell-startup cost. Load it only when a Node/NVM command
# is first used, while preserving the previous default-version behaviour.
_load_nvm() {
  unfunction nvm node npm npx corepack 2>/dev/null
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
  else
    print -u2 "nvm is not installed at $NVM_DIR"
    return 127
  fi
}

nvm() { _load_nvm && nvm "$@" }
node() { _load_nvm && command node "$@" }
npm() { _load_nvm && command npm "$@" }
npx() { _load_nvm && command npx "$@" }
corepack() { _load_nvm && command corepack "$@" }

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# if [[ $TERM != "linux" && $TERM_PROGRAM != "vscode" && -z "$TMUX" ]]; then
#   # Auto attach to tmux session
#   if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
#     # Only attach if not inside tmux already
#     if tmux has-session -t main 2>/dev/null; then
#       tmux attach-session -t main
#     else
#       tmux new-session -s main
#     fi
#   fi
# fi

if (( ${+commands[mc]} )); then
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C "${commands[mc]}" mc
fi

[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# OpenClaw Completion
_openclaw_completion="$HOME/.openclaw/completions/openclaw.zsh"
if [[ -r "$_openclaw_completion" ]]; then
  [[ "$_openclaw_completion.zwc" -nt "$_openclaw_completion" ]] || zcompile "$_openclaw_completion" 2>/dev/null
  source "$_openclaw_completion"
fi
unset _openclaw_completion

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
path=("$PNPM_HOME" $path)
# pnpm end

# opencode
path=("$HOME/.opencode/bin" "${KREW_ROOT:-$HOME/.krew}/bin" $path)
[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
typeset -U path PATH
