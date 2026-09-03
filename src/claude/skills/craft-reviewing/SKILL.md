---
name: craft-reviewing
description: >-
  The shared entry point, protocol, and rigour apparatus for a code-craft or
  ui-craft review that spans more than one file or screen. Load this alongside a
  lens (code-craft or ui-craft): the lens brings the dimensions to sweep for,
  this brings the how - confirming scope/lens/depth/execution, choosing between
  an inline pass and the multi-agent swarm, the coverage-first protocol, the
  by-dimension and by-subject aggregations, and the rigour steps (catalogue-load
  ledger, credits ledger, instance census, coverage attestation, self-grill) that
  stop a single-pass review reading as complete when it isn't. Invoked by the Review
  mode of code-craft and ui-craft; not needed for building, refactoring, or
  architecting. Use when reviewing or auditing a whole codebase or whole
  interface, or any review broader than one file.
---

# craft-reviewing

The lens-agnostic methodology for a multi-file craft review. It is deliberately
separate from the two craft skills so the protocol lives in one place: a
code-craft review and a ui-craft review differ in *what* they sweep for (the
dimensions), not in *how* a rigorous review is run.

- **This skill owns the "how":** the confirm step (including which execution
  mode to use), the protocol, the two aggregations (by dimension, by subject),
  and the rigour apparatus.
- **The lens owns the "what":** the dimension catalogues (`refactoring.md`,
  `solid.md`, … for code; `accessible-code.md`, `usability.md`, … for UI) plus
  the lens-specific list of dimensions that need a whole-scope sweep, which each
  lens keeps in its own `references/reviewing.md`.

So a real review reads three things: the lens SKILL.md (how the lens works and
how to cite), this skill's `references/protocol.md` and `references/rigour.md`
(the shared how), and the lens's dimension references (the what).

## When this applies

Any review broader than a single file or single diff, in either lens. For a
single file, the ordinary lens Review mode is enough - skip this. For a
whole-codebase or whole-interface review, this is mandatory: a review run
file-by-file from the lens overview alone reliably misses the structural
findings (God Object, inverted dependencies, repeated switches; for UI, an
overloaded shared partial or a colour-only state repeated across screens).

## Entry point and the swarm

This skill is the entry point for any multi-file craft review, whichever way it
runs. Its confirm step (`protocol.md`) is where you pick the *execution* mode:

- **inline** - a single reviewer works through this skill's `protocol.md` and
  `rigour.md` by hand.
- **multi-agent fan-out** - hand off to the `craft-review-swarm` workflow, which
  implements the same protocol by fanning out one agent per dimension, verifying
  each finding, and pivoting by subject, so it earns much of the rigour
  structurally rather than by hand.

So always start here - confirm scope, lens, depth, and execution - then either
run inline or route to the swarm. The rigour apparatus matters most on the
inline path, where nothing else forces completeness; the swarm gets its
equivalents from its Verify and subject-pivot stages.

## Which reference to read

| Situation | Read |
|---|---|
| The confirm step, protocol, coverage/sweep, aggregations, severities, execution choice | `references/protocol.md` |
| Making the pass repeatable - catalogue-load ledger, credits ledger, instance census, coverage attestation, self-grill, independent passes | `references/rigour.md` |
| Laying out the report - fixed section order, the per-finding schema, the findings index | `references/report-format.md` |

Then read your lens's `references/reviewing.md` for the dimensions to sweep.

## Maintaining these skills without overfitting

These skills get revised when a review misses something. Three rules keep that
loop from degrading them into a checklist tuned to one codebase:

- **Dimension or finding?** For every candidate edit ask: is this a new
  *dimension or discipline*, or a specific finding in disguise? Encode only the
  former. A check that names a file, symbol, or literal from one codebase is
  overfit - it makes the next review of that repo look thorough while teaching
  nothing transferable, and skews the skill for other codebases and future
  states. Generalise to the class, or don't add it.
- **Was it missing, or just unrun?** Before adding anything, check whether an
  existing dimension - run as a census (`rigour.md`) - would already have caught
  it. Most misses are present checks left unrun, not absent ones; those call for
  stronger forcing in `rigour.md`, not new content. Reserve new dimension text
  for genuine gaps.
- **Sourced, not invented.** Every check must trace to a reference's stated
  sources. If a genuinely useful check doesn't, it either belongs in a different
  reference whose sources *do* cover it, or you introduce a new cited source and
  name it (as `code-craft`'s `security.md` cites OWASP and Saltzer & Schroeder).
  An un-sourced check is an opinion, and opinions drift; a cited one can be
  checked and argued with. And when a reference reproduces a source's taxonomy,
  either enumerate it fully (with its version) or mark the shown items as a
  non-exhaustive selection and point to the source for the rest - a partial list
  that reads as complete is a false-completeness trap.

The catalogues draw their authority from their source frameworks (Fowler, Metz,
WCAG, Nielsen), not from findings observed in any one repo - keep it that way,
and put revision energy into the forcing machinery.
