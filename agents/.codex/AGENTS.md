## Sandbox

- T3's auto-mode sandbox has no network and can only write inside the
  workspace. For network commands (`gh`, `git fetch`/`push`, installs, `curl`,
  `asc`, `ssh`, `fleetctl`) or writes outside the workspace (other worktrees,
  `~/.t3`, simulators, `/tmp` caches), request escalated permissions on the
  first try with a short reason; trying inside the sandbox first only wastes a
  round. Inside the sandbox, ssh fails with "Bad owner or permissions on
  /etc/ssh/ssh_config.d/…".

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
