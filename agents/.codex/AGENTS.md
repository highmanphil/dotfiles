## Code quality

- Write readable, maintainable code with clear names, focused functions, and
  straightforward control flow. Avoid compressed code, duplication, and
  unnecessary abstractions.
- Review and simplify your changes before finishing; code cleanup is part of
  implementation, not a separate follow-up task.
- Verify meaningful behavior rather than implementation details, and test the
  actual user flow when available.

## Git

Check remote state when the task depends on it; preserve local work and avoid
unrequested branch or history changes.

## Fleet

Use $fleet for shared configuration, cross-machine work, and personal skill
installation or updates.

## App Store Connect

- An App Store Connect team API key (Admin role) is set up on the MacBook Air
  and the Home PC under `~/.appstoreconnect/private_keys/`. The `asc` CLI
  (asccli.sh) is installed on both machines with the default profile `admin`
  (`~/.asc/config.json`, so it works over SSH too). Use it in any iOS project
  to check apps, builds, processing state, and TestFlight groups yourself, e.g.
  `asc apps list` or `asc builds list --app <id> --output table`.
- Read-only checks need no approval. Writes (uploads, expiring builds, tester
  or group changes, review submissions) need Phil's explicit approval, except
  the TofuLove internal TestFlight uploads covered below.

## Sandbox

- In T3's auto mode the sandbox has no network and can only write inside the
  workspace. For anything that needs the network (`gh`, `git fetch`/`push`,
  package installs, `curl`, `asc`, `ssh`, `fleetctl`) or writes outside the
  workspace (other worktrees, `~/.t3`, simulators, tool caches in `/tmp`),
  request escalated permissions on the first try with a short justification
  instead of trying inside the sandbox first. Inside the sandbox, ssh fails
  with "Bad owner or permissions on /etc/ssh/ssh_config.d/…".

## Definition of done

- A change is done when you've checked it where it actually runs, not when
  tests pass. For apps, look at it on a device or emulator (T3 device tools,
  `adb exec-out screencap`, `xcrun simctl io booted screenshot`) against the
  real dev backend, not demo data. For web pages, check phone width as well as
  desktop. An HTTP 200 or a green unit test alone doesn't count.
- In the final message, say what you verified and what you couldn't.
- If you can't reproduce a bug (iOS Safari scrolling, real-device performance,
  smoothness), say so and propose how to check it. Don't deploy a guessed fix
  to production; use a dev or preview deploy first.
- Start long jobs (archives, builds, test suites, uploads) so they survive the
  end of your turn: `systemd-run --user`, `nohup … > log 2>&1 &`, or a
  LaunchAgent on the Mac. Check the log or process before saying it's running.
- Commit and push finished work before reporting, so the Mac and Home PC stay
  in sync. Don't leave fixes or version bumps uncommitted on one machine.

## Doing it yourself

- Before telling Phil he has to do something by hand, or that something isn't
  possible, try at least one other route (an API, a CLI, `adb shell input`,
  SSH to another machine, the docs) and say what you tried. Hand a step back
  only when it really needs him: a password, 2FA, or a physical device.
- Check a limitation in the docs or by testing before stating it, and mark
  claims you haven't checked.
- Re-check state before summarizing it (swap, versions, running processes,
  what's on main) instead of repeating what was true earlier in the thread.
- When a request is about how something should feel or behave ("sounds
  natural", "the model decides when"), restate the intended outcome in one
  line first. If two readings would lead to different builds, ask.

## UI work

- Mobile first unless told otherwise; Phil's apps are used mostly on phones.
- No AI smell: no sub-texts under every control, hint text, restated
  headings, badges without information, card-heavy layouts, or generic
  gradient palettes. Keep copy short and human.
- For new UI or a redesign, use the `frontend-design` skill, and show two
  directions as screenshots before building one out.
- Before finishing UI work, look at screenshots at phone width for overflow,
  clipped text, and filler copy.

## Machines and devices

- MacBook Air: the Xcode build, signing, and simulator host. Run at most two
  iOS simulators at once, check the load and leftover `xcodebuild` processes
  before starting more, and clean up your own.
- Home PC: 32 GB RAM shared with a CI runner VM. Avoid running several heavy
  builds at once.
- The OnePlus test phone is paired with the Home PC over wireless ADB. Check
  `adb devices` there before asking for a USB cable.
- The newest media (videos, renders, exported assets) are on the Home PC file
  share (`share-files` skill). Check it before reusing files from older
  projects.

## Careful deletes

- Before a broad delete (`find … -delete`, `rm -rf` with globs or several
  paths), list what would be removed and check it first.
- Don't use `pkill -f` with a pattern that can match your own shell command;
  find PIDs with `pgrep` and kill those.

## TofuLove

- In the TofuLove iOS, web, and Android repos, merge reviewed PRs yourself
  (review clean, CI and tests green), including web merges that deploy to
  production, and upload verified internal TestFlight builds without asking.
- Still ask before a public App Store release, an external beta submission,
  tester or group changes, new legal agreements, or destructive prod data
  changes.
