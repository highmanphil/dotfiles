# Fleet hosts

## Mac

- Role: controller and managed host
- User: `phil`
- Tailscale DNS: `philipps-macbook-air.tail3a5980.ts.net`
- Tailscale IP: `100.123.207.72`
- Dotfiles: `/Users/phil/dotfiles`
- Global instructions: `/Users/phil/.codex/AGENTS.md`
- Controller identity for Home PC and VPS: `/Users/phil/.ssh/id_rsa`
- Public-key fingerprint: `SHA256:+gf0KIh3MdgE595L5jTef8odF9mhkID3TU/SJqAnuh0`
- SSH server authorized keys: `/Users/phil/.ssh/authorized_keys`

## Home PC

- Role: controller and managed host
- Hostname: `phil-cachyos`
- User: `phil`
- Tailscale IP: `100.104.47.26`
- Dotfiles: `/home/phil/dotfiles`
- Global instructions: `/home/phil/.codex/AGENTS.md`
- Controller identity for Mac and VPS: `/home/phil/.ssh/id_gmx`
- Public key: `/home/phil/.ssh/id_gmx.pub`
- Public-key fingerprint: `SHA256:qUuWL111bnVyvVHAgKWVbdv3bMjwGYLpQszRHkBDpHk`

## VPS

- Role: managed host
- Hostname: `ubuntu`
- User: `root`
- Public IP: `217.160.186.7`
- Dotfiles: `/root/dotfiles`
- Global instructions: `/root/.codex/AGENTS.md`
- No Tailscale address is currently configured.

## Connectivity matrix

| Controller | Mac | Home PC | VPS |
|---|---|---|---|
| Mac | local | `phil@100.104.47.26` using `~/.ssh/id_rsa` | `root@217.160.186.7` using `~/.ssh/id_rsa` |
| Home PC | `phil@100.123.207.72` using `~/.ssh/id_gmx` | local | `root@217.160.186.7` using `~/.ssh/id_gmx` |

Private keys remain machine-local. Never add them to this repository or transmit them between hosts.
