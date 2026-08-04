<!-- BEGIN company-brain routing -->
## Company knowledge

- For implementation, debugging, tests, runtime behavior, repository architecture, APIs, prompts, configuration, and deployment questions, inspect the current source code, tests, configuration, and repository documentation first.
- Do not invoke `$company-brain` merely because code belongs to A1 or KARA, or refers to an internal project or system.
- Invoke `$company-brain` when explicitly requested, or when the answer materially depends on non-code company knowledge such as people, reporting lines, accountability, cross-team ownership, business or product decisions, or internal terminology not established by the current repository.
- For mixed requests, use `$company-brain` only for the company-dependent portion and keep technical conclusions grounded in the current code.
- An empty or inconclusive Codex memory lookup is not a reason to invoke `$company-brain`.
- Treat the company-brain repository as canonical for organizational and business facts; cite its files and do not guess when knowledge is missing, stale, or conflicting.
- Use `$company-brain-maintainer` for explicit capture, ingestion, correction, or maintenance work.
<!-- END company-brain routing -->

## File handling

- Do not create `.bak`, `.backup`, timestamped backup copies, `codex-backup` files, or similar duplicate safety files.
- Use version control, an explicit diff, or the operating system Trash for recoverability. If a tool or workflow truly requires a backup file, ask before creating it.

## Fleet

- Invoke `$fleet` for work involving the Mac, Home PC, VPS, fleet SSH, fleet synchronization, global AGENTS.md, shared skills, dotfiles, cmux, or limux.
- Keep shared fleet configuration canonical in `~/dotfiles`; link managed files into their standard locations rather than maintaining divergent copies.
- Never commit private SSH keys, access tokens, passwords, or other secrets to dotfiles. Distribute only public SSH keys.
