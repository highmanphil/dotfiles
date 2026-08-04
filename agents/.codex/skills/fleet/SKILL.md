---
name: fleet
description: Manage Phil's Mac, Home PC, and VPS as one controlled fleet. Use for SSH connectivity between these machines, executing or inspecting commands across hosts, synchronizing global AGENTS.md, selected personal skills, and dotfiles, configuring Mac cmux or Home PC limux, auditing fleet state, or repairing fleet configuration drift.
---

# Fleet

Manage the three machines from either the Mac or Home PC while keeping shared configuration in the dotfiles Git repository. Read [references/hosts.md](references/hosts.md) before changing connectivity, keys, or machine-specific configuration.

## Safety rules

- Never read, print, copy, or commit private key material. Use only the documented private-key paths as SSH client arguments and distribute only `.pub` files.
- Never create `.bak`, `.backup`, timestamped backup copies, or `codex-backup` files. Use Git, an explicit diff, or Trash for recovery.
- Inspect `git status --short --branch` before pulling or deploying dotfiles. Stop on a dirty target instead of overwriting its changes.
- Treat the Mac and Home PC as controllers. Do not make the VPS a controller unless Phil explicitly asks and approves the required key distribution.
- Use Tailscale addresses for Mac/Home traffic. The VPS currently uses its public address.
- Re-check the exact host and user immediately before a privileged or destructive command.

## Quick start

Run the bundled controller from either controller machine:

```sh
~/.codex/skills/fleet/scripts/fleetctl status all
~/.codex/skills/fleet/scripts/fleetctl exec vps -- uptime
~/.codex/skills/fleet/scripts/fleetctl exec home -- git -C ~/dotfiles status --short --branch
```

Targets are `mac`, `home`, `vps`, or `all` where supported. The controller chooses the correct machine-local identity file; do not replace this with copied private keys.

## Synchronization workflow

1. Inspect all hosts with `fleetctl status all`.
2. Work in the controller's `~/dotfiles` checkout and preserve unrelated changes.
3. Commit and push only the intended files.
4. Run `fleetctl sync home`, `fleetctl sync vps`, and `fleetctl sync mac` as appropriate. Sync refuses dirty repositories and uses `git pull --ff-only`.
5. Validate global AGENTS and fleet skill symlinks with another `status all`.
6. Validate shell changes with `zsh -n ~/.zshrc` and a genuine interactive PTY. For Powerlevel10k and direnv, keep `direnv export zsh` before the instant-prompt preamble and install the hook immediately after it.

`~/dotfiles/scripts/setup-fleet.sh` manages global AGENTS, this skill, zsh links, and platform-specific cmux/limux configuration. It never creates backup files. Replacing a non-symlink managed file requires the explicit `--replace-managed` flag.

## Skill synchronization

Keep custom shared skills in the `agents/.codex/skills/` dotfiles package. Link them into `~/.codex/skills/` with the setup script.

Do not synchronize these as ordinary personal skills:

- `.system` and product-managed runtime/plugin skills.
- Repository-local skills such as `company-brain` whose canonical source is another checkout; preserve their repository symlinks.
- Broken or temporary symlinks.

Use the official `skills` CLI for provenance and updates of third-party skills when appropriate. Use the dotfiles repo for Phil's own fleet skill and other custom skills. Do not install the union of discovered skills everywhere until Phil selects which ones should be global.

## Platform scope

- Mac: cmux and its remote workspace keeper, Mac zsh/P10k, fleet controller.
- Home PC: limux settings, Linux zsh/P10k, fleet controller.
- VPS: server zsh/P10k and shared agent configuration; no desktop terminal configuration.

When a desktop setting differs intentionally by platform, store both canonical variants in dotfiles and select by detected host. Do not make one machine's local UI configuration overwrite another's.
