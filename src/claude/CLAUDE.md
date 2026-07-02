# Preferences

## Running commands

- Don't suppress or truncate command output — no piping through `tail`, `head`,
  etc. Show the full output.

## Running tests

- Target specific tests by `file:line` reference, not by test name/description
  (e.g. `rspec spec/foo_spec.rb:16`, not `rspec -e "does a thing"`).
- When fixing a bug, write the test first and confirm it fails for the right
  reason before implementing the fix.

## Git

- Use `git switch`, not `git checkout`, for branch operations.
- Don't commit directly to `main` — create a branch first.
- `git push` on its own is enough — upstream tracking is configured in the
  gitconfig, so don't add `-u origin <branch>`.

## Commit messages

- Subject line: describe what changed, 50 characters or fewer, imperative mood
  (e.g. "Show error when converting with no file").
- Body: wrap at 72 characters. Explain any useful extra detail and the reason
  for the change (the why), not just the what.
- Write the body in the present tense describing the commit ("This guards
  against…", "This re-renders…"), not the imperative.
- No trailing full stops on body paragraphs.
- Wrap code identifiers and symbols in backticks (e.g. `params.dig`, `@error`,
  `NoMethodError`).
- Attribute co-authorship as `Co-authored-by:` (sentence case).

## Pull requests

- Title: the Jira reference in square brackets followed by the commit subject,
  no colon between them (e.g. "[PP-7541] Show error when converting with no
  file").
- Body: concise prose that mirrors the commit body. No section headings, no
  separate "why"/"testing" sections, and no "Generated with Claude Code" or
  other Claude references.
- No trailing full stops on body paragraphs.

## Keeping this file current

- When you learn a new preference in a session — whether from a correction or
  an explicit request — add or update it here, don't just apply it for the
  current session.
