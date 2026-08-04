# Color Powerlevel10k only for SSH sessions opened from Phil's Mac.
# The Mac sends P10K_MAC_SSH through SSH. cmux's managed remote workspace id is
# a fallback for hosts where AcceptEnv cannot be enabled without sudo.
_p10k_mac_ssh_origin="${P10K_MAC_SSH:-}"
if [[ -z "$_p10k_mac_ssh_origin" && "${SSH_CONNECTION%% *}" == "100.123.207.72" ]]; then
  _p10k_mac_ssh_origin=home
fi
if [[ -z "$_p10k_mac_ssh_origin" && -n "${SSH_CONNECTION:-}" && -n "${CMUX_WORKSPACE_ID:-}" ]]; then
  # cmux-managed SSH sessions currently don't forward the host-specific
  # SetEnv marker. Distinguish our two remotes by their login account instead
  # of treating every managed workspace as Home.
  if (( EUID == 0 )); then
    _p10k_mac_ssh_origin=vps
  else
    _p10k_mac_ssh_origin=home
  fi
fi

case "$_p10k_mac_ssh_origin" in
  vps)
    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=false
    typeset -g POWERLEVEL9K_BACKGROUND='#922B21'
    typeset -g POWERLEVEL9K_CONTEXT_{ROOT,REMOTE,REMOTE_SUDO}_FOREGROUND=255
    typeset -g POWERLEVEL9K_CONTEXT_{ROOT,REMOTE,REMOTE_SUDO}_TEMPLATE='%B⬢ VPS · %n@%m%b'
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=203
    ;;
  home)
    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=false
    typeset -g POWERLEVEL9K_BACKGROUND='#1565C0'
    typeset -g POWERLEVEL9K_CONTEXT_{ROOT,REMOTE,REMOTE_SUDO}_FOREGROUND=255
    typeset -g POWERLEVEL9K_CONTEXT_{ROOT,REMOTE,REMOTE_SUDO}_TEMPLATE='%B⌂ HOME · %n@%m%b'
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=39
    ;;
esac
unset _p10k_mac_ssh_origin
