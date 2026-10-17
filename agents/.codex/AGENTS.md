## Sandbox

- T3's auto-mode sandbox has no network and can only write inside the
  workspace. For network commands (`gh`, `git fetch`/`push`, installs, `curl`,
  `asc`, `ssh`, `fleetctl`) or writes outside the workspace (other worktrees,
  `~/.t3`, simulators, `/tmp` caches), request escalated permissions on the
  first try with a short reason. Inside the sandbox ssh fails with "Bad owner
  or permissions on /etc/ssh/ssh_config.d/…".

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
