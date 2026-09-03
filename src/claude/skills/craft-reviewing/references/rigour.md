# Rigour: making an inline pass repeatable

The inline path has one reviewer and no automatic verification, so it
under-covers in predictable ways: a credit asserted without checking its
counterexamples; a smell reported for its first instance and never swept; a file
listed in scope but never actually analysed; the long low-severity tail dropped.
This file turns those failure modes into artifacts you fill in, so an omission
becomes visible instead of silent. The swarm earns the equivalents from its
Verify and subject-pivot stages; inline, you produce them by hand.

**Artifacts are scaffolding, not deliverables - but for an exhaustive inline
review they must actually exist.** The failure this whole file guards against is
an *attestation without an artifact behind it*: writing "swept all N
controllers; 3 flagged" or "all files covered" when the census/matrix was only
ever done in your head. An attestation the reader cannot trace back to a filled
cell or a pasted command is unfalsifiable, and that is exactly where a single
pass silently under-covers. So the rule that makes a run repeatable:

> Produce the catalogue-load ledger, the credits ledger, census, and coverage
> matrix as a **retained sidecar file** (e.g. `<report-name>.coverage.md`)
> *before* writing the report, and make every attestation in the report point at
> a cell or a pasted command in it. No artifact, no attestation.

The *report* still carries only the outputs - the findings and the one-line
attestations - never the grids themselves. For a headline or subtree review the
sidecar scales down to what's in scope (see Proportionality) but the same
"artifact before attestation" rule holds for whatever you do claim.

## Proportionality

Match the apparatus to the review. For an inline **exhaustive whole-surface**
review, all of it is mandatory. For a **headline** or **subtree** review, the
catalogue-load ledger, credits ledger, and self-grill still earn their place; the
full census and matrix scale down to what's in scope. If filling the matrix by hand is impractical
because the surface is too large, that is the signal to offer the swarm (see
`protocol.md`), not to drop coverage silently.

## 1. Catalogue-load ledger - prove you opened every catalogue

The censuses and the coverage matrix below force the *cross-scope sweep
dimensions* (the ones in your lens's `reviewing.md`) and the high-stakes flows.
They do **not** force the flat, single-subject catalogue checks - skip link and
landmark naming (`accessible-code.md`), required-field marking (`forms.md`), a
non-SQL injection sink like CSV formula injection (`security.md`), a fail-open
default (`reliability.md`) - because no *sweep* owns them. Those checks live only
in the catalogues, so a review that never opens a catalogue silently drops its
entire single-subject contribution while the matrix still looks full. That is the
exact gap that lets an exhaustive review miss a check every ordinary single-round
review catches.

So the first artifact, before any finding: a ledger with **one row per catalogue
your lens declares mandatory** for an exhaustive review, each marked with the
evidence that you actually read it - a pasted `Read` of the file (or its
`file:line`), not "considered". The lenses' mandatory sets:

- **code-craft**: `refactoring.md`, `solid.md`, `object-oriented-design.md`,
  `design-patterns.md`, `general-principles.md`, `performance.md`,
  `reliability.md`, `security.md`. (`testing.md` unless tests are out of scope -
  record `n/a: <reason>`.)
- **ui-craft**: `accessible-code.md`, `usability.md`, `forms.md`, `content.md`,
  `visual-design.md`.

| Catalogue | Read? (evidence) | Single-subject checks it contributed |
|---|---|---|
| security.md | Read 1-120 | CSV/formula injection, existence oracle, … |
| … | … | … |

A catalogue with no Read evidence is **unread**, full stop - open it now, before
writing the report. An exhaustive review may not attest completeness while a
mandatory catalogue row is blank. This is the artifact-before-attestation rule
applied to the catalogues themselves: reading a catalogue is not the same as
nodding at its name in the overview, and the overview/`reviewing.md` sweep list
is not a substitute for the catalogue (it deliberately omits the single-subject
checks). For a headline or subtree review the ledger scales to the catalogues in
scope, but every catalogue you *do* rely on needs its Read row.

## 2. Credits ledger - falsify every credit

A "what already works" line is a claim, and claims are where an inline pass most
often contradicts itself: crediting a pattern as consistent when a sibling
breaks it, or an operation as safe when a race breaks it. Before writing any
credit, falsify it - keyed to the *kind* of claim:

| Claim shape | The question that falsifies it |
|---|---|
| "X is done right" (a pattern/consistency claim) | List every site X applies to. Which fail? |
| "X is safe / idempotent" | What happens on the second concurrent call, the retry, the malformed input? |
| "contrast / theme / state is fine" | Which of the N cases (themes, states) did you actually compute or check? |
| "the fix is handled everywhere" | Search for the pattern; count the sites; are any missed? |
| "N+1 avoided / the eager-load works" | Trace the SQL the *templates* fire, not the loader in the controller. Which per-row call (an ordering, count, size, or a scope invoked on an already-loaded collection) re-queries and defeats the preload? |

A credit about performance is the one most often asserted from the wrong file:
the eager-load reads correct where it is declared, yet a per-row call in the
template re-fetches and reintroduces the N+1. Falsify it from the view, against
the query log if you have one, never from the loader alone.

A credit that survives goes in the report, scoped to what you checked
("confirmed for A and B, not C"). A credit that fails becomes a finding. Never
write an unfalsified credit.

## 3. Instance census - enumerate, don't exemplify

For each smell/issue you name, don't report the first instance and move on:
enumerate every candidate site across the smell's natural domain and mark each
hit/miss. "A fat controller" becomes "checked all N controllers; 3 are fat". The
report surfaces the finding plus one attestation line ("swept all N controllers;
3 flagged"); the full census goes in the sidecar.

**The census set is not yours to choose.** Run one census per whole-scope
dimension in your lens's `reviewing.md`, plus one per high-stakes flow you
enumerated (protocol step 1) - each a filled table, none skipped. Most misses in
practice are not missing checks but *present* checks left unrun: a dimension
read and nodded at, never censused. So a dimension with no filled table is
unswept, full stop, and the report may only attest what a table backs.

**Enumerate the whole domain, never a size-by-eye sample.** The census must
cover *every* unit of the relevant kind - every controller, model, service,
screen - independent of which ones look big or interesting. The responsibility
smell that reads as ordinary (a short controller doing three jobs across a few
terse methods) is precisely the one a "which files feel large" pass skips, so a
census that only lists the obvious suspects is not a census.

**Seed the roster mechanically, not from memory.** Before filling a census, paste
the enumeration that defines its universe - a directory or file listing (e.g.
every file under `app/controllers`), a glob, or a grep - and give every item it
returns a row. A roster typed from memory is where the unit that reads as
ordinary gets silently dropped; when the roster itself came from a pasted
listing, a unit can only be *marked* (swept / n/a / finding), never forgotten.
This is the artifact-before-attestation rule applied to the census's *input*, not
just its output.

Where the domain is mechanically searchable, use a search so the census can't
"forget" a site - and paste the search, not "I looked". The examples below are
*illustrative* (Ruby/Rails-flavoured); adapt the pattern, tool, and smell to the
stack in front of you - they are not a fixed checklist to run everywhere:

- a type switch (code): search the language's type-dispatch idioms, e.g. in Ruby
  `grep -rn 'is_a?\|case .* when [A-Z]\|\.class\b' <scope>`.
- a duplicated roster (code): list the domain's attributes, search each name,
  count the files it appears in.
- colour-only / unannounced state (UI): enumerate every active/current/selected
  cue (e.g. `.active`, `aria-current`, `selected`) and check each has a
  non-colour, announced equivalent.
- high-stakes flows (UI or code): list the ones this app actually has - auth,
  destructive actions, state changes - and sweep each.
- authorization / error paths (code): does the code reveal a resource exists
  *before* confirming access (a 404-vs-403 existence oracle), or does a
  lookup/sign-in form answer differently on hit vs miss (enumeration)? See
  `code-craft`'s `security.md`.
- links in running text (UI): each in-prose link carries a non-colour cue (an
  underline) that holds in *every* theme, not colour alone.
- shared partial emitting a heading (UI): the heading level is correct in
  *every* context the partial renders in, not just the one you opened.
- Divergent Change / God Class / fat controller (code): this one is *not*
  grep-able, which is exactly why it gets skipped. Enumerate every controller,
  model, and service and write each one's responsibility count (the axes it
  changes for) - do not sample by which files feel large, because the God Object
  that reads as ordinary is the one a size-by-eye pass misses. Count only
  app-authored axes: a framework persistence or auth mixin is one axis, not an
  exemption. The mechanical procedure is in `code-craft`'s
  `object-oriented-design.md`.

The point is one census per smell, whatever the search (or, for the last one,
the enumeration); the specific patterns are examples to adapt, not instructions
to run verbatim.

**The responsibility and high-stakes-flow censuses are not optional when the app
has the surface for them.** The patterns above adapt to the stack, but two
censuses are always required where the app has them: the responsibility census
(every unit, seeded per the roster rule above) and the high-stakes-flow census.
For the latter, produce a filled table with one row per high-stakes action the
app actually has - authentication, destructive actions, state changes - and
record the criterion each was swept against: for code, whether the action
loads-then-authorizes or reveals a resource's existence before confirming access
(the 404-vs-403 / enumeration oracle); for UI, that *every* screen in the flow,
including content assembled outside the template (a generated image, a token, an
emailed string), was swept against the full criteria. An auth or destructive flow
with no row is unswept, not safe.

## 4. Coverage matrix - one row per in-scope file/flow

Enumerating scope (protocol step 1) is not the same as sweeping it. Keep a
matrix in the sidecar - rows are in-scope files/flows, columns are the
dimensions - and mark each cell swept / n/a / finding. A blank *row* is a file
you listed but never analysed; a blank *cell* is a dimension you never ran
against that file (an auth flow you read but didn't check against the criteria, a
view you never checked for a page title). Both are gaps, and the grid exists so
they are visible rather than assumed away. Rows include the easily-forgotten
files - leaf/drill-down screens, error and empty states, config and manifest
files, not just the index screens and the obvious models. The report carries one
attestation line ("N in-scope files, all swept; auth and destructive flows swept
against their criteria"), not the grid.

## 5. Self-grill - a fixed, evidence-demanding final pass

Before finalising, answer a fixed question bank - fixed because model-generated
questions share the model's blind spots, and **every answer must be evidence (a
search result, a `file:line`, a computed value), never an assertion** (an
assertion can be hand-waved; a search result cannot). The bank is the failure
modes made interrogative:

- Catalogues: is the catalogue-load ledger filled, with a pasted `Read` (or
  `file:line`) for *every* mandatory catalogue your lens declares - not the
  `reviewing.md` sweep list, the catalogues themselves? Name any catalogue whose
  row is blank; a blank row is an unread catalogue, so its single-subject checks
  (skip link, required-field marking, a non-SQL injection sink, a fail-open
  default) were never run - open it now, before finalising. Reading the overview
  or the sweep dimensions is not reading the catalogue.
- Sidecar: does the coverage sidecar file actually exist, with the census,
  matrix, and per-dimension searches filled in? Every attestation in the report -
  name them - points at which cell or pasted command?
- Credits: for each credit, what is its falsifying answer (per the ledger)? For
  any performance/eager-load credit, from which file did you falsify it - the
  template, or (wrongly) the loader?
- Coverage: which in-scope file has neither a finding nor a "swept" mark, and
  which *cell* is blank? Name the high-stakes flows (auth, destructive,
  state-change) and the criterion each was swept against - as a filled table row
  per flow (#3), not a prose claim; an auth or destructive flow without a row is
  unswept. Did leaf/drill-down, error, empty-state, and config/manifest files get
  rows?
- Dimensions: for each whole-scope sweep dimension in the lens's `reviewing.md`,
  paste the command you ran. Any dimension with no recorded search is unswept -
  run it now. (The mandatory-catalogue check is the Catalogues bullet above,
  backed by the catalogue-load ledger - a sweep of `reviewing.md`'s cross-file
  dimensions does not stand in for reading the catalogues.)
- Census: for each smell you named, paste the search you used to find all its
  instances. One instance reported - is it genuinely singular, or unswept? Is the
  responsibility census filled for *every* controller/model/service/screen, or
  only the ones that looked big? Was each census's roster seeded from a pasted
  enumeration (#3), so no unit could be silently dropped?
- Performance: for every template that iterates a collection, which per-row call
  fires I/O? Paste the per-template trace, including any scope invoked on an
  already-loaded association.
- Aggregation: does every subject in the grid across 2+ dimensions have its
  responsibility/fault named, not just a count? For every subject at 3+
  dimensions, is there a finding at High or higher? If any sits below that
  convergence floor, what is the *evidence* for the downgrade (a search, a
  `file:line`, a computed value)? "Feels cohesive", "it's a normal framework
  class", or "only trending" is not evidence - it is the flinch, so restore the
  floor.

What the grill catches goes into the findings. For the first few reviews, record
what it caught (a one-line "surfaced in self-review: …") so its value is
visible; quiet that once it's proven.

## 6. Independent passes - the strongest omission check

The grill catches artifacts you didn't fill; it can't catch a category you never
tabulated. The only reliable cure for that is an **independent** pass: a
**fresh** agent (never a fork - a fork inherits your blind spots) that audits
the code cold against this protocol and the lens dimensions. Independent passes
have different blind spots, so their findings are closer to a *union* than a
max - two passes catch far more together than one larger pass, and the evidence
is that even a many-agent swarm, sharing one dimension list, misses what a
differently-run pass finds. So treat this as the highest-leverage coverage move,
not a luxury: **recommend it for any exhaustive or high-stakes review** - still
user-approved and never launched on your own, since each pass costs roughly
another review.

How it runs (set at the confirm step, protocol.md's *passes*):

- **Ask up front how many passes to run simultaneously,** then run that many
  independent passes in parallel (fresh agents, not forks) and **diff, verify
  each disagreement against the code, and synthesise** into a single report.
- **If the user chose a single pass, offer a second one after the report.**
  Don't present a sequential pass as an up-front option, but flag up front that
  it will be available on completion; then, once the single pass has landed,
  offer it and fold what it confirms into a follow-up.

Either way these are inline, interactively-initiated passes you spawn and
reconcile by hand, not the `craft-review-swarm` workflow (a separate, heavier
opt-in).
