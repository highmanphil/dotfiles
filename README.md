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

The `cmux` stow package keeps pinned SSH workspaces alive when their final tab
is closed. cmux itself inserts a local shell in that case, so the
`com.phil.cmux-remote-workspace-keeper` LaunchAgent watches `surface.closed`
events and replaces only that final placeholder with a terminal using the
workspace's existing SSH transport. It is limited to the configured Home and
VPS destinations and requires cmux's local `automation` socket mode.

## Fleet management

The Mac, Home PC, and VPS share global Codex instructions and the fleet skill
from the `agents` package. From either the Mac or Home PC:

```sh
~/.codex/skills/fleet/scripts/fleetctl status all
~/.codex/skills/fleet/scripts/fleetctl exec vps -- uptime
```

Run `~/dotfiles/scripts/setup-fleet.sh` after pulling changes. It links global
AGENTS.md, the fleet skill, shared zsh/P10k files, Mac cmux settings, and Home
PC limux settings. It never creates backup copies; an unmanaged conflicting
file is refused unless `--replace-managed` is explicitly supplied.
