# Shuoqi's WorkBuddy Test Marketplace

A minimal, self-contained **WorkBuddy plugin marketplace** used to validate the
"Add Marketplace" → "Install plugin" end-to-end flow.

> **Status:** smoke-test fixture. Plugins are deliberately trivial — they exist to
> prove the pipeline, not to deliver production functionality.

---

## Repository layout

```
.
├── .codebuddy-plugin/
│   └── marketplace.json          # marketplace manifest (declared at add-time)
├── plugins/
│   ├── hello-world-skill/        # 1) minimal SKILL.md, no bundle
│   │   ├── SKILL.md
│   │   └── .codebuddy-plugin/plugin.json
│   ├── pomodoro-timer-skill/     # 2) SKILL.md + scripts/ bundle
│   │   ├── SKILL.md
│   │   ├── scripts/pomodoro.sh
│   │   └── .codebuddy-plugin/plugin.json
│   └── json-formatter-skill/     # 3) SKILL.md + references/ bundle
│       ├── SKILL.md
│       ├── references/example-schema.json
│       └── .codebuddy-plugin/plugin.json
└── README.md (this file)
```

Each plugin follows the structure required by WorkBuddy's plugin system:

- `SKILL.md` — skill body with YAML frontmatter (`name`, `description`, `agent_created: true`).
- `.codebuddy-plugin/plugin.json` — plugin manifest (`name`, `version`, `description`, `category`).
- Optional `scripts/`, `references/`, `assets/` — bundle resources loaded from
  `${CODEBUDDY_PLUGIN_ROOT}` at runtime.

---

## Plugins

| Name                       | What it does                                                              | Bundle                       |
|----------------------------|---------------------------------------------------------------------------|------------------------------|
| `hello-world-skill`        | Smoke-test: confirms marketplace + install + SKILL.md load pipeline       | (empty placeholders)         |
| `pomodoro-timer-skill`     | 25/5 Pomodoro timer; calls bundled `scripts/pomodoro.sh`                  | `scripts/pomodoro.sh`        |
| `json-formatter-skill`     | Pretty-print + JSON-schema check; loads `references/example-schema.json`  | `references/example-schema.json` |

All three are declared in `.codebuddy-plugin/marketplace.json` with
`source: "./plugins/<dir>"` so they install from the same repo.

---

## How to add this marketplace to WorkBuddy

### Option A — from this folder, locally (fastest smoke test)

In WorkBuddy, click **Plugins → +** → **Add Marketplace**, paste:

```
.  (or absolute path to this directory)
```

then click **Submit**. After it registers, switch to the **Discover** tab and
the three plugins above should appear.

### Option B — from a public GitHub repo (the real test)

1. Push this folder to a new GitHub repo, e.g. `https://github.com/<you>/wb-test-marketplace`.
2. In WorkBuddy, click **Plugins → +** → **Add Marketplace**, paste:

   ```
   <your-github-username>/wb-test-marketplace
   ```

3. Click **Submit**, then **Discover** tab to confirm the plugins are listed.
4. Install any one (e.g. **pomodoro-timer-skill**), run `/reload-plugins`, and
   invoke it with "start a pomodoro".

---

## Local git + GitHub push cheatsheet

```bash
cd wb-test-marketplace

# 1) init + first commit
git init -b main
git add .
git commit -m "feat: initial test marketplace with 3 demo skills"

# 2) create empty GitHub repo via gh CLI (or do it in the browser)
gh repo create wb-test-marketplace --public --source=. --remote=origin --push

# 3) alternative: add remote manually, then push
git remote add origin git@github.com:<you>/wb-test-marketplace.git
git push -u origin main
```

After the push, paste `<you>/wb-test-marketplace` into the
**Add Marketplace** dialog in WorkBuddy.

---

## Regenerating or extending

- **Add another plugin**: copy `plugins/hello-world-skill/` to
  `plugins/<your-name>-skill/`, edit `SKILL.md` and `plugin.json`, then add an
  entry under `plugins[]` in `.codebuddy-plugin/marketplace.json`.
- **Bump version**: bump `version` in both `marketplace.json` and the plugin's
  `plugin.json` (marketplace + plugin version fields can be updated independently).
- **Format check**: run `cat .codebuddy-plugin/marketplace.json | jq` — invalid
  JSON will be rejected at install time with no useful error message.

---

## Why this exists

Custom marketplaces are the recommended path for sharing skills across a team
without pushing to a centralized registry. This repo is the smallest fixture
that still exercises all four interesting code paths:

1. **SKILL.md metadata-only load** (hello-world-skill)
2. **scripts/ bundle copy + executable permission** (pomodoro-timer-skill)
3. **references/ bundle copy + on-demand read** (json-formatter-skill)
4. **marketplace.json discovery + relative-path resolution** (the `source:
   "./plugins/<dir>"` lines)

When you can install all three of these via the WorkBuddy UI, the marketplace
pipeline is verified end-to-end.
