export EDITOR="nvim"
export HOMEBREW_NO_ENV_HINTS="1"

# bun
export BUN_INSTALL="$HOME/.bun"

export LC_CTYPE="en_US.UTF-8"
# export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
export ZSH="$HOME/.oh-my-zsh"

export NVM_DIR="$HOME/.nvm"

# Keep PATH portable and idempotent across local, nested and re-sourced shells.
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$BUN_INSTALL/bin"
  "$HOME/bin"
  "$HOME/go/bin"
  $path
)

if [[ "$OSTYPE" == darwin* ]]; then
  path=(
    "/opt/homebrew/opt/dotnet@8/bin"
    "/opt/homebrew/opt/openjdk@21/bin"
    "/opt/homebrew/opt/node@12/bin"
    $path
  )
fi

[[ -d "$HOME/.codeium/windsurf/bin" ]] && path=("$HOME/.codeium/windsurf/bin" $path)

export VOXINPUT_BASE_URL="http://127.0.0.1:8080/v1"
export VOXINPUT_TRANSCRIPTION_MODEL="whisper-large-v3"
# export VOXINPUT_LANG="de"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
