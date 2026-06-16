# aliases
alias vic="vim -c 'execute \"silent \!echo \" . &fileencoding | q'"
alias k="kubectl"
alias kn="kubens"
alias kc="kubectx"
alias klogs='kubectl logs -f $(kubectl get pods | fzf | awk "{print \$1}")'
alias kdescribe='kubectl describe pod -f $(kubectl get pods | fzf | awk "{print \$1}")'
alias cls="clear"
alias vi="nvim"
alias vim="nvim"
alias lg="lazygit"
alias codex="codex --yolo"
alias copilot="copilot --yolo"
stowit() {
  (cd ~/dotfiles && stow "$@")
}
