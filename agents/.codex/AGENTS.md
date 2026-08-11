<!-- BEGIN company-brain routing -->
## Company knowledge

- For implementation, debugging, tests, runtime behavior, repository architecture, APIs, prompts, configuration, and deployment questions, inspect the current source code, tests, configuration, and repository documentation first.
- Do not invoke `$company-brain` merely because code belongs to A1 or KARA, or refers to an internal project or system.
- Invoke `$company-brain` when explicitly requested, or when the answer materially depends on non-code company knowledge such as people, reporting lines, accountability, cross-team ownership, business or product decisions, or internal terminology not established by the current repository.
- For mixed requests, use `$company-brain` only for the company-dependent portion and keep technical conclusions grounded in the current code.
- An empty or inconclusive Codex memory lookup is not a reason to invoke `$company-brain`.
- Treat the company-brain repository as canonical for organizational and business facts; cite its files and do not guess when knowledge is missing, stale, or conflicting.
<!-- END company-brain routing -->

## File handling

- Do not create `.bak`, `.backup`, timestamped backup copies, `codex-backup` files, or similar duplicate safety files.
- Use version control, an explicit diff, or the operating system Trash for recoverability. If a tool or workflow truly requires a backup file, ask before creating it.

## Repository freshness

- Before answering a question whose correctness depends on repository contents, or before modifying a repository, establish the Git root, current branch or detached HEAD, worktree status, configured remotes, and upstream branch.
- Refresh the relevant upstream remote with `git fetch --prune <remote>` before treating local remote-tracking refs as current. A local `git status` without a fetch is not proof that the checkout matches the remote.
- Compare the checked-out commit with its upstream after fetching.
- For read-only questions: if the checked-out branch is behind or diverged, do not present the local checkout as current. Report the state and ask whether to update the checkout, or clearly label an answer based on the fetched remote-tracking branch.
- For requested changes: if the branch is strictly behind its upstream and the worktree can be updated safely, fast-forward with `git pull --ff-only` before editing.
- Never silently merge, rebase, reset, switch branches, discard changes, or stash user work. If the worktree is dirty and an update is needed, or the branch has diverged, stop and ask for direction.
- If fetching is unavailable, authentication fails, no upstream is configured, or HEAD is detached, state that freshness could not be verified and avoid claiming the repository is current.
- When the task materially depends on another local repository, apply the same freshness check to that repository before relying on it. Do not fetch or update unrelated repositories.
- For long-running work, fetch and compare again before committing, rebasing, opening a pull request, or giving a final current-state verdict.

## Fleet

- Invoke `$fleet` for work involving the Mac, Home PC, VPS, fleet SSH, fleet synchronization, global AGENTS.md, shared skills, dotfiles, cmux, or limux.
- Keep shared fleet configuration canonical in `~/dotfiles`; link managed files into their standard locations rather than maintaining divergent copies.
- After installing or updating a personal skill by any method, run `~/dotfiles/scripts/fleet-skills.sh capture-and-sync` so the same personal skill set is deployed to the whole fleet. In an interactive zsh, prefer the wrapped `skills` command, which performs this automatically.
- Never commit private SSH keys, access tokens, passwords, or other secrets to dotfiles. Distribute only public SSH keys.
