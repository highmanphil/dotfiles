# Color Powerlevel10k only for SSH sessions opened from Phil's Mac.
# The Mac sends P10K_MAC_SSH through SSH. cmux's managed remote workspace id is
# a fallback for hosts where AcceptEnv cannot be enabled without sudo.
_p10k_mac_ssh_origin="${P10K_MAC_SSH:-}"
if [[ -z "$_p10k_mac_ssh_origin" && -n "${SSH_CONNECTION:-}" && -n "${CMUX_WORKSPACE_ID:-}" ]]; then
  _p10k_mac_ssh_origin=home
fi

case "$_p10k_mac_ssh_origin" in
  vps)
    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=false
    typeset -g POWERLEVEL9K_BACKGROUND=52
    typeset -g POWERLEVEL9K_CONTEXT_{ROOT,REMOTE,REMOTE_SUDO}_FOREGROUND=255
    typeset -g POWERLEVEL9K_CONTEXT_{ROOT,REMOTE,REMOTE_SUDO}_TEMPLATE='%B⬢ VPS · %n@%m%b'
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=203
    ;;
  home)
    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=false
    typeset -g POWERLEVEL9K_BACKGROUND=24
    typeset -g POWERLEVEL9K_CONTEXT_{ROOT,REMOTE,REMOTE_SUDO}_FOREGROUND=255
    typeset -g POWERLEVEL9K_CONTEXT_{ROOT,REMOTE,REMOTE_SUDO}_TEMPLATE='%B⌂ HOME · %n@%m%b'
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=39
    ;;
esac
unset _p10k_mac_ssh_origin
