# The report format (shared)

How to lay out a craft-review report so it reads consistently and can be worked
through by a human *and* by a coding agent picking up the findings later. This is
the *shape* of the deliverable only; `protocol.md` owns what goes in it (the
sweep, the two aggregations, severities) and `rigour.md` owns the sidecar. This
file exists because report layout has drifted between reviews - the same finding
written five different ways across versions makes a report hard to diff, hard to
track, and hard to action. One schema fixes that.

Applies to both lenses and both execution modes. Inline produces one file per
lens (`protocol.md`, "Delivering the report"); the swarm produces the
summary/findings pair. Either way the finding schema, the index, and the section
order below are the same.

## Fixed section order

1. **Header** - lens, scope (with exclusions), depth, execution, passes, date,
   and the commit SHA the review was run against.
2. **Coverage caveat** - the standing "a review samples a larger space" paragraph
   (`protocol.md`, "Delivering the report").
3. **Findings index** - the one-row-per-finding table (below). At-a-glance for a
   human; the machine-readable summary for tooling.
4. **Findings** - grouped under a `### High` / `### Medium` / `### Low` subheading
   (in that order; omit an empty band), each finding a `#### <ID>` block in the
   schema below. The outline is `## Findings` -> `### <Severity>` -> `#### <ID>`;
   never jump `## Findings` straight to `#### <ID>`. A skipped heading level is the
   very fault the ui-craft lens flags (WCAG 1.3.1), and it garbles the outline a
   human or agent reads the report by, so the report must hold to it too.
5. **Themes** - the by-symptom aggregation (`protocol.md` step 5).
6. **Subject grid** - the by-subject aggregation (`protocol.md` step 6).
7. **Leverage-ordered fix list** - ordered by findings dissolved (step 7).
8. **Credits** - what already works, each falsified before writing (`rigour.md`).

The coverage sidecar stays a separate `*.coverage.md` file - never fold the
census/matrix/searches into the report body.

## The finding schema

Every finding, same fields, same order. The `#### <ID>` block always sits under
its `### <Severity>` subheading (see the section order), never directly under
`## Findings`. Illustrative example (paths are placeholders):

```
### Medium

#### C-03 · Repeated Switch on type
**Severity** Medium · **Effort** Medium · **Confidence** High
**Dimension** Refactoring — Replace Conditional with Polymorphism (Fowler)
**Locations**
- app/foo/bar.rb:38  (`describe`)
- app/foo/baz.rb:65  (`serialise`)
**Problem** The same three-way type switch recurs in two places though the
subclasses already exist; each branch wants to be a polymorphic method. Adding a
fourth type means editing both sites. (What is wrong, and why it matters.)
**Fix** Give each subclass the method and delete the switch. (Concrete; names the
pattern / attribute / refactoring.)
**Verify** grep the type-dispatch idiom returns 0 app hits; a stub fourth subclass
needs no edits here. (The search / query-log count / axe check that proves the
fix landed.)
**Related** Theme T1; subjects bar.rb, baz.rb. #1 on the fix list.
**Status** open
```

### Field rules

- **ID** - `<LENS>-<NN>`: `C` code, `UI` ui, `S` for a security sub-pass.
  Referenced from the index, themes, subjects, and fix list, so nothing is an
  orphan. **Carry an ID forward unchanged across report versions** for a finding
  that persists - fresh per-version numbering is exactly what makes reports
  undiffable. A new finding takes the next free number; a retired one's number is
  not reused.
- **Severity** - High / Medium / Low: "how alarmed to be". Never the fix order
  (that is the leverage list). The two legitimately diverge (`protocol.md`
  step 8).
- **Effort** - Small / Medium / Large: rough cost. Feeds the leverage list; kept
  out of severity.
- **Confidence** - High / Medium / Low: how sure the finding is real. A
  Low-confidence finding signals a coding agent to re-verify before acting rather
  than assuming.
- **Dimension** - the catalogue dimension *and its source* (Fowler / Metz / GoF /
  Meyer / Liskov / WCAG x.y / Nielsen #n / OWASP). No un-sourced findings.
- **Locations** - a list; a finding spanning several sites lists **every** site
  (never just the first - that is the instance-census discipline, `rigour.md`),
  each a clickable `file:line` with the symbol in parens.
- **Problem** - what is wrong *and the impact*, 1-3 sentences.
- **Fix** - the concrete change; name the pattern, ARIA attribute, or refactoring.
- **Verify** - how to confirm it is fixed: a grep, a query-log count, an axe/
  contrast check, a repro. This is the field that makes the report drivable by an
  agent - a fix with no check is not done.
- **Related** - theme IDs, subject files, and finding IDs it dissolves or rolls
  into.
- **Status** - open / fixed / wontfix / accepted. Lets a later pass track what
  changed instead of re-deriving it.

## Findings index

One row per finding, ordered by severity then ID. This is both the human's
scan-in-ten-seconds view and the parseable summary.

| ID | Severity | Effort | Dimension | Location(s) | Title | Status |
|----|----------|--------|-----------|-------------|-------|--------|
| C-01 | High | Large | SRP / God Class | user.rb | `User` God Class | open |
| C-03 | Medium | Medium | Repeated Switch | 2 sites | Type switch | open |

## Theme block

```
### T1 · One-line name of the shared symptom
**Members** C-03, C-06. **Root** the single cause behind them.
**Leverage** what one fix dissolves across the members.
```

Every theme lists its member finding IDs; naming the theme then sweeping the whole
scope for more instances is the point (`protocol.md` step 5), so a theme with one
member is a prompt to look again, not a finished theme.

## Subject grid

| Subject | Dimensions (finding IDs) | # | Severity | Interpretation |
|---------|--------------------------|---|----------|----------------|
| user.rb | C-01, C-07, C-08 | 3 | High | God Class: auth+identity+graph+prefs |

State the convergence rule once under the grid and honour it: a subject at 3+
*distinct* dimensions gets its own finding at High or higher, naming the
responsibilities - and prose cannot lower that floor without evidence
(`protocol.md` step 6, `rigour.md` self-grill). The Interpretation column is where
you name the fault, not just count it.

## Leverage-ordered fix list

```
1. <action> → dissolves C-03, C-06 (2). Effort Medium.
2. <action> → dissolves C-04 (1). Effort Medium.
```

Each line: action -> finding IDs dissolved (count) -> effort. Ordered by findings
dissolved, not by cost; span genuine one-liners through the expensive structural
anchor. Don't title it "quick wins" (`protocol.md` step 7).

## Authoring checklist

- Every finding carries all schema fields; none is an example-only stand-in for a
  swept census.
- Severity is separate from the fix order; effort/leverage drive the fix list.
- Every credit is falsified before writing, scoped to what was checked
  (`rigour.md` ledger).
- Themes, subjects, and the fix list reference findings by ID; no orphans.
- Multi-site findings list every site, not the first one noticed.
- IDs are stable across versions; Status tracks change.
- The report carries outputs and one attestation line each; the census, matrix,
  and per-dimension searches live in the sidecar.
- Heading outline is valid: `## Findings` -> `### <Severity>` -> `#### <ID>`, no
  skipped levels (the ui-craft lens flags this).
