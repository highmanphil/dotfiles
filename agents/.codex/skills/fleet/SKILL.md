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

1. Inspect all hosts with `fleetctl status all`. An unavailable host is reported as pending without preventing inspection of the remaining hosts.
2. Work in the controller's `~/dotfiles` checkout and preserve unrelated changes.
3. Commit and push only the intended files.
4. Run `fleetctl converge all` for immediate best-effort deployment. Every host also runs `fleet-converge.sh` at boot or login and every 15 minutes, so offline machines converge after they return.
5. Convergence refuses dirty repositories and fast-forwards from the canonical Git origins. Inspect desired versus applied skill revisions with another `status all`.
6. Validate global AGENTS and fleet skill symlinks, then validate shell changes with `zsh -n ~/.zshrc` and a genuine interactive PTY. For Powerlevel10k and direnv, keep `direnv export zsh` before the instant-prompt preamble and install the hook immediately after it.

`~/dotfiles/scripts/setup-fleet.sh` manages global AGENTS, this skill, zsh links, and platform-specific cmux/limux configuration. It never creates backup files. Replacing a non-symlink managed file requires the explicit `--replace-managed` flag.

## Skill synchronization

Skill contents and their runtime manifest live in the private `highmanphil/fleet-skills` GitHub repository, checked out at `~/.local/share/fleet-skills/`. Each host authenticates with its own machine-local deploy key. Mac and Home PC have publish access; VPS is read-only. The public `~/dotfiles/agents/skills-manifest.txt` remains a non-sensitive mirror. `setup-fleet.sh` links the private store into `~/.agents/skills/` and removes personal skills outside the manifest.

Install a skill from interactive zsh with the wrapped `skills` command. It invokes the official Skills CLI, captures the resulting personal skill package, commits and publishes one private Git revision, updates the non-sensitive manifest mirror when needed, and attempts immediate convergence. Offline peers remain pending and retry automatically.

After installing or editing a skill by another method, run either equivalent command:

```sh
~/dotfiles/scripts/fleet-skills.sh capture-and-publish
~/dotfiles/scripts/fleet-skills.sh capture-and-sync
```

Never copy internal skill contents into the public dotfiles repository. In particular, keep `a1-jira-confluence` and `company-brain` only in the direct SSH-synchronized store.

Do not synchronize these as ordinary personal skills:

- `.system` and product-managed runtime/plugin skills.
- Broken or temporary symlinks.

The uniform selected personal set is: `a1-jira-confluence`, `company-brain`, `diagnose`, `grill-me`, `grill-with-docs`, `grilling`, `handoff`, `hatch-pet`, `prototype`, `research`, `to-spec`, `to-tickets`, `wayfinder`, `wizard`, and `writing-for-agents`. `$fleet` remains managed directly by dotfiles. Product-managed `.system`, plugin-cache, and `codex-*` runtime skills are outside this personal manifest and may vary by platform.

## Platform scope

- Mac: cmux and its remote workspace keeper, Mac zsh/P10k, fleet controller.
- Home PC: limux settings, Linux zsh/P10k, fleet controller.
- VPS: server zsh/P10k and shared agent configuration; no desktop terminal configuration.

When a desktop setting differs intentionally by platform, store both canonical variants in dotfiles and select by detected host. Do not make one machine's local UI configuration overwrite another's.
