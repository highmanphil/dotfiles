export EDITOR="nvim"
export HOMEBREW_NO_ENV_HINTS="1"

# bun
export BUN_INSTALL="$HOME/.bun"

export LC_CTYPE="en_US.UTF-8"
# export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
export ZSH="$HOME/.oh-my-zsh"

export NVM_DIR="$HOME/.nvm"
export PATH="/Users/phil/.local/bin:/opt/homebrew/opt/dotnet@8/bin:/opt/homebrew/opt/openjdk@21/bin:/Users/$USER/.codeium/windsurf/bin:$BUN_INSTALL/bin:/Users/$USER/.bin:/opt/homebrew/opt/node@12/bin:/Users/$USER/go/bin:/home/phil/bin:$PATH"

auto_source_dot_envs() {
  local envs_dir=".envs" # Define the directory name we're looking for

  # Check if the .envs directory exists in the current path
  if [[ -d "$PWD/$envs_dir" ]]; then
    # Check if we have read permissions and it's not empty
    # The `(N)` glob qualifier makes the glob expand to nothing if no files match,
    # preventing errors. The `.` qualifier ensures we only match regular files.
    local env_files=($PWD/$envs_dir/*(.N))

    if (( ${#env_files[@]} > 0 )); then
      for env_file in $env_files; do
        # Ensure it's a readable file (though `.` glob qualifier mostly handles this)
        if [[ -f "$env_file" && -r "$env_file" ]]; then
          # Use `source` or `.` to load the file into the current shell
          source "$env_file"
        fi
      done
    fi
  fi
}

# Add the function to chpwd_functions if it's not already there
# This ensures it's only added once even if .zshrc is sourced multiple times.
if [[ -z "${chpwd_functions[(r)auto_source_dot_envs]}" ]]; then
  chpwd_functions+=("auto_source_dot_envs")
fi

auto_source_dot_envs

export VOXINPUT_BASE_URL="http://127.0.0.1:8080/v1"
export VOXINPUT_TRANSCRIPTION_MODEL="whisper-large-v3"
# export VOXINPUT_LANG="de"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

