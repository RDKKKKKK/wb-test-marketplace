---
name: hello-world
description: Minimal smoke-test skill that proves the WorkBuddy custom-marketplace install pipeline works end-to-end. Use this skill when the user says "run hello world skill", "smoke test marketplace plugin", or "verify skill install" — the skill simply greets the user and confirms which marketplace version is active.
agent_created: true
---

# Hello World Skill

This is the simplest possible skill designed as a **smoke test** for a custom WorkBuddy marketplace.

## What this skill does

When invoked, the skill:

1. Confirms that the marketplace-installed plugin loaded successfully (skill metadata is in the registry).
2. Prints a friendly greeting that includes the active version (read from `plugin.json`).
3. Lists the bundled `scripts/` and `references/` directories to prove the full directory was copied.

## When to use this skill

Trigger phrases include:

- "run hello world skill"
- "smoke test the marketplace"
- "verify the custom marketplace install works"
- "load hello-world skill"

## How WorkBuddy uses this skill

The skill is intentionally trivial — it does **not** call any external API, write any file, or run any destructive command. It is safe to invoke on a fresh install just to confirm:

- The marketplace was added correctly.
- The plugin's `plugin.json` was parsed.
- The `SKILL.md` frontmatter (this file) was loaded into context.
- Bundled resources (if any) are reachable from `${CODEBUDDY_PLUGIN_ROOT}`.

## Bundled resources

- `scripts/` — empty placeholder, kept to validate the bundle copy.
- `references/` — empty placeholder, kept to validate the bundle copy.

## Expected output

```
[hello-world v0.2.0] Skill loaded successfully from custom marketplace.
Marketplace: shuoqi-wb-test-marketplace
Active plugin version: 0.2.0
```

## Changelog

- **v0.2.0** — Added version-update verification: the greeting now echoes the
  plugin version so a marketplace-triggered update is immediately visible in
  the output (0.1.0 → 0.2.0 confirms the update pipeline works).
- **v0.1.0** — Initial release.
