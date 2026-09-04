## Repository freshness

- Before answering a question whose correctness depends on repository contents, or before modifying a repository, establish the Git root, current branch or detached HEAD, worktree status, configured remotes, and upstream branch.
- Refresh the relevant upstream remote with `git fetch --prune <remote>` before treating local remote-tracking refs as current. A local `git status` without a fetch is not proof that the checkout matches the remote.
- Compare the checked-out commit with its upstream after fetching.
- For read-only questions: if the checked-out branch is behind or diverged, do not present the local checkout as current. Report the state and ask whether to update the checkout, or clearly label an answer based on the fetched remote-tracking branch.
- For requested changes: if the branch is strictly behind its upstream and the worktree can be updated safely, fast-forward with `git pull --ff-only` before editing.
- Never silently merge, rebase, reset, switch branches, discard changes. A temporary stash is acceptable when it safely preserves user work. Restore it after the operation and verify restoration; ask for guidance if conflicts or uncertain ownership prevent safe restoration.
- If it is a GitHub upstream and it is not authenticated (or says the remote does not exist), keep in mind that I am logged in with two accounts via the `gh` cli, try to switch to the other one and check if that one has permissions for that remote (normally ~/workspace-work is for `hochmannA1` and everything else is for `highmanphil`)
- If fetching is unavailable, authentication fails, no upstream is configured, or HEAD is detached, state that freshness could not be verified and avoid claiming the repository is current.
- When the task materially depends on another local repository, apply the same freshness check to that repository before relying on it. Do not fetch or update unrelated repositories.
- For long-running work, fetch and compare again before committing, rebasing, opening a pull request, or giving a final current-state verdict.

## Fleet

- Invoke `$fleet` when the task requires coordination between machines, fleet SSH, fleet synchronization or convergence, or a change to shared fleet-managed configuration such as global AGENTS.md, shared personal skills, dotfiles, cmux, or limux.
- Do not invoke `$fleet` merely because work runs on or mentions the Mac, Home PC, or VPS. Ordinary single-machine diagnosis, package/app maintenance, hardware troubleshooting, and local configuration inspection should use the directly relevant workflow unless the result will be made canonical in dotfiles or deployed to another machine.
- Keep shared fleet configuration canonical in `~/dotfiles`; link managed files into their standard locations rather than maintaining divergent copies.
- After installing or updating a personal skill by any method, run `~/dotfiles/scripts/fleet-skills.sh capture-and-sync` so the same personal skill set is deployed to the whole fleet. In an interactive zsh, prefer the wrapped `skills` command, which performs this automatically.
- Never commit private SSH keys, access tokens, passwords, or other secrets to dotfiles. Distribute only public SSH keys.

## Working preferences

- Carry an authorized task through implementation and relevant validation. Resolve routine choices from context; ask only when missing information materially changes the outcome or an action needs new authorization.
- Use skills for their task-specific knowledge and workflows. Do not turn a mention, a suggested skill, or a generic writing/debugging habit into a mandatory workflow. Existing user authorization remains valid inside a skill.
- Lead with the result and the evidence needed to assess it. Use plain prose, precise technical terms, and lists where they aid comparison. Avoid canned praise, filler, forced personality, and repeated conclusions. Preserve required detail and the requested format.
- Match validation to the changed behavior and repository requirements. Once those checks pass, expand them only for a concrete unresolved risk or new failure.
