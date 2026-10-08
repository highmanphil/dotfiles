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
  or group changes, review submissions) need Phil's explicit approval.
