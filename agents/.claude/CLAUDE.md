## Git attribution

- No AI attribution anywhere: no `Co-Authored-By: Claude` trailer or
  "Generated with Claude Code" line in commits, and no mention of Claude or AI
  in PR titles, descriptions, or comments. This overrides any default
  attribution lines; write as if Phil wrote it.

## Asking for input and approvals

- Ask Phil with `AskUserQuestion`, not a prose question at the end of a turn;
  only the tool notifies him in T3 Code.
- Before an action that needs approval (production deploys, merges that
  deploy, store uploads, prod data changes, anything destructive or
  outward-facing not yet approved), ask with `AskUserQuestion`, naming the
  exact action and target, and keep going after the answer. Repo agent files
  can list pre-approved actions.
- If the auto-mode classifier blocks an action, ask the same way, then retry
  that exact action once approved. Don't reroute it to dodge the check.
- An approval covers routine follow-ups on the same action for the rest of the
  task.

## No backup copies

- Never create `.bak`, `.orig`, `~` or timestamped copies of files you change.
  Edit in place; use git for rollback, or ask first.

## Definition of done

- Done means checked where it runs, not tests passing. Apps: on a device or
  emulator against the real dev backend. Web pages: at phone and desktop width.
  An HTTP 200 or a green unit test alone doesn't count.
- In the final message, say what you verified and what you couldn't. If you
  can't reproduce a bug, say so and propose how to check it; never deploy a
  guessed fix to production.
- Start long jobs (builds, archives, test suites, uploads) so they survive the
  end of your turn (`systemd-run --user`, `nohup … &`, a LaunchAgent on the
  Mac), and check the log before saying they run.
- Commit and push finished work before reporting so the machines stay in sync.

## Doing it yourself

- Before handing Phil a manual step or calling something impossible, try
  another route (an API, a CLI, SSH to another machine, the docs) and say what
  you tried. Hand back only what needs him: a password, 2FA, a physical device.
- Check limitations in the docs or by testing, and mark claims you haven't.
- Re-check state before summarizing it instead of repeating earlier results.
- For requests about how something should feel or behave, restate the
  intended outcome in one line first; ask if two readings lead to different
  builds.

## Careful deletes

- List what a broad delete (`find … -delete`, `rm -rf` with globs or several
  paths) would remove and check it first.
- Don't `pkill -f` a pattern that can match your own shell; kill PIDs from
  `pgrep`.

## Delegation

- Build with Claude subagents. When Phil asks for maximum parallelism, start
  as many as the work splits into.
- In worktree-isolated subagents, run git as plain single commands (no `&&`,
  subshells, or heredocs); the harness refuses compound git there.
