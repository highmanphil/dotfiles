autoload -Uz compinit
compinit
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
source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f "$HOME/.zsh_home" ] && source "$HOME/.zsh_home"
[ -f "$HOME/.zsh_work" ] && source "$HOME/.zsh_work"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/mc mc

# Added by Windsurf
export PATH="/Users/phil/.codeium/windsurf/bin:$PATH"

. "$HOME/.local/bin/env"

# bun completions
[ -s "/home/phil/.bun/_bun" ] && source "/home/phil/.bun/_bun"

# OpenClaw Completion
source "/home/phil/.openclaw/completions/openclaw.zsh"

eval "$(direnv hook zsh)"

# pnpm
export PNPM_HOME="/home/phil/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# opencode
export PATH=/home/phil/.opencode/bin:$PATH
