---
name: json-formatter
description: Pretty-print and JSON-schema-validate helper skill. Use this skill when the user asks to "format JSON", "validate JSON against schema", "prettify this JSON file", "lint JSON", or "check json schema". Works on inline strings and local `.json` files.
agent_created: true
---

# JSON Formatter Skill

Validate and pretty-print JSON. Ships with a sample JSON-Schema reference so WorkBuddy can load it on demand when validating API payloads.

## When to use this skill

Trigger phrases include:

- "format this JSON"
- "prettify this JSON file"
- "validate this JSON against the schema in references/"
- "lint json"
- "json schema check"

## How WorkBuddy uses this skill

1. **Pretty-print**: read the user's JSON string or `.json` file, then run through a one-liner. Examples:

   ```bash
   # Inline string
   echo '{"a":1,"b":[2,3]}' | python3 -m json.tool
   ```

   ```bash
   # Local file
   python3 -m json.tool < input.json > output.json
   ```

2. **Schema-validate**: load the bundled `references/example-schema.json` into context, then guide the user through mapping the user payload against it.

3. **Surface errors**: catch `json.decoder.JSONDecodeError` and report the line/column.

## Bundled resources

- `references/example-schema.json` — sample JSON-Schema (Draft 2020-12) for a `User` object. Used to demo schema loading when the user asks "what does your reference schema look like?".

## Notes

- Pure stdlib — no `npm install`, no `pip install` required.
- The skill does **not** mutate files in place. Always pipe through `python3 -m json.tool`.
