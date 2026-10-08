## Git attribution

- Never add yourself to commits: no `Co-Authored-By: Claude` trailer, no
  "Generated with Claude Code" line, and no other AI or assistant attribution
  in commit messages.
- Never mention Claude, Claude Code, or AI assistance in pull request titles,
  descriptions, or comments. Leave out the "🤖 Generated with Claude Code"
  footer.
- This overrides any default or system-provided attribution lines. Write commit
  messages and PR text as if Phil wrote them.

## Asking for input and approvals

- Phil works in T3 Code almost all the time. Whenever you need input from
  him (a decision, a missing value, approval for a risky step), ask with the
  `AskUserQuestion` tool instead of ending the turn with a question in prose.
  The tool sends him a notification; a prose question doesn't.
- Before an action you think needs approval (production deploys, merges that
  deploy, TestFlight/App Store uploads, prod data changes, anything
  destructive or outward-facing he hasn't already approved), ask with
  `AskUserQuestion` and name the exact action and target. Don't stop the
  task and hand it back.
- If the auto-mode classifier blocks an action, don't give up or end the
  turn. Ask with `AskUserQuestion`, naming the blocked action, its target,
  and why it's needed. Once he approves, retry that same action. Don't
  rephrase it or route it through another tool to dodge the check.
- Once approved, an action stays approved, including routine follow-ups on
  that same action (e.g. watching the deploy a merge started). Don't ask
  again for the same thing in the same task.

## App Store Connect

- An App Store Connect team API key (Admin role) is set up on the MacBook Air
  and the Home PC under `~/.appstoreconnect/private_keys/`. The `asc` CLI
  (asccli.sh) is installed on both machines with the default profile `admin`
  (`~/.asc/config.json`, so it works over SSH too). Use it in any iOS project
  to check apps, builds, processing state, and TestFlight groups yourself, e.g.
  `asc apps list` or `asc builds list --app <id> --output table`.
- Read-only checks need no approval. Writes (uploads, expiring builds, tester
  or group changes, review submissions) follow the approval rules above.
