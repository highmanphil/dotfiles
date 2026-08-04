# dotfiles

The dotfiles are seperated by branch for each machine

# Setup

Clone this repo

```sh
git clone https://github.com/highmanphil/dotfiles.git
```

Then run the setup script

```sh
cd dotfiles
./setup.sh
```

# Notes

Turn off `select the previous input source` in mac settings

-  → System Settings → Keyboard → Shortcuts → Input Sources
- Uncheck “Select the previous input source” (or remap it to something else).

## Remote zsh and cmux SSH workspaces

The remote Powerlevel10k color overlay lives in `zsh/.p10k-mac-ssh.zsh`:

- VPS sessions from the Mac use a red prompt and an explicit `VPS` context.
- Home PC sessions from the Mac use a blue prompt and an explicit `HOME` context.
- Local terminals on the Home PC keep the normal theme.

On a Linux remote that has this repository at `~/dotfiles`, run:

```sh
~/dotfiles/scripts/setup-remote-zsh.sh
```

The setup script links the shared portable `zsh/.zshrc`, so shell startup
optimizations stay consistent across the Mac, Home PC, and VPS.

On the Mac, include `ssh/cmux-remotes.conf` from `~/.ssh/config`. The remote
sshd must accept the cosmetic marker with `AcceptEnv P10K_MAC_SSH`. cmux-managed
SSH workspaces also provide a fallback marker for Home PC sessions.
