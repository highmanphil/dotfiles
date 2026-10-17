## Git attribution

- Write commit messages, PR titles, descriptions, and comments as if Phil
  wrote them: no `Co-Authored-By: Claude` trailer, no "Generated with Claude
  Code" line, no mention of Claude or AI. This overrides default attribution
  lines.

## Asking for input and approvals

- Ask Phil with `AskUserQuestion` rather than a question at the end of a
  turn. He works in T3 Code, and only the tool sends him a notification.
- Before an action that needs approval (production deploys, merges that
  deploy, store uploads, prod data changes, anything destructive or
  outward-facing not yet approved), ask with `AskUserQuestion`, naming the
  exact action and target, then keep working once he answers. Repo agent
  files can list actions that are already approved.
- If the auto-mode classifier blocks an action, ask the same way and retry
  that exact action once approved. Rerouting it through another tool would
  defeat the check.
- An approval covers routine follow-ups on the same action for the rest of
  the task, so don't ask twice.

## Editing files

- Edit files in place and rely on git for rollback. `.bak`, `.orig`, `~` or
  timestamped copies clutter repos and the file share and go stale; ask
  first if a change can't be undone with git.

## Definition of done

- Done means checked where it runs: apps on a device or emulator against the
  real dev backend, web pages at phone and desktop width. A green unit test or
  an HTTP 200 misses layout, data, and device problems, so it doesn't count
  on its own.
- In the final message, say what you verified and what you couldn't. If you
  can't reproduce a bug, say so and propose how to check it, and use a dev or
  preview deploy for an unconfirmed fix rather than production.
- Start long jobs (builds, archives, test suites, uploads) so they survive the
  end of your turn (`systemd-run --user`, `nohup … &`, a LaunchAgent on the
  Mac), and check the log before saying they run.
- Commit and push finished work before reporting. Phil switches between the
  Mac and the Home PC, and uncommitted work on one is invisible on the other.

## Doing it yourself

- Before handing Phil a manual step or calling something impossible, try
  another route (an API, a CLI, SSH to another machine, the docs) and say what
  you tried. Hand back only what needs him: a password, 2FA, a physical device.
- Check limitations in the docs or by testing, and mark claims you haven't
  checked.
- Re-check state (versions, processes, what's on main) before summarizing it;
  it may have changed since you last looked.
- For requests about how something should feel or behave, restate the
  intended outcome in one line first, and ask if two readings would lead to
  different builds.

## Careful deletes

- Before a broad delete (`find … -delete`, `rm -rf` with globs or several
  paths), list what it would remove and check the list.
- Kill processes by PID from `pgrep`. `pkill -f` can match your own shell
  command and kill the session.

## Delegation

- Use Claude subagents for work that splits into independent parts or needs
  its own context; do small or sequential work directly. When Phil asks for
  maximum parallelism, start as many as the work splits into.
- In worktree-isolated subagents, run git as plain single commands. The
  harness refuses `&&` chains, subshells, and heredocs around git there.
