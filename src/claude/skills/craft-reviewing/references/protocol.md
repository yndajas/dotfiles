# The craft review protocol (shared)

How to run a review that spans several files or screens, so it finds the
structural and systematic issues, not just the ones on the line you happened to
read. Both craft lenses share this protocol; each supplies its own sweep
dimensions and severity flavour. Read this together with `rigour.md` and your
lens's `references/reviewing.md`.

## Confirm scope, lens, depth, execution, and passes first

Pin down these five before starting. Lens, scope, and depth are the parameters
the `craft-review-swarm` workflow takes, so they carry over unchanged whether
you review inline or fan out; execution is the separate inline-or-fan-out
choice itself. If any is ambiguous, ask (prefer a single `AskUserQuestion`); if
the request already fixes them, proceed.

- **Lens** - code craft, UI craft, or both. A whole-app review usually wants
  both, run as separate passes over the same files (they read the same files
  and ask different questions).
- **Scope** - the whole codebase/interface, a subtree, or changed files only,
  plus anything to exclude (e.g. tests / `testing.md`). State what's in and out.
- **Depth** (the workflow's `depth` arg) - how far down the severity tail:
  - *headline* - the highest-impact, high-confidence findings; stops before the
    long low-severity tail. Say plainly it can drop high-severity structural
    findings (code) or task-blocking accessibility failures (UI).
  - *exhaustive* - works the full catalogue and reports the tail too.
- **Execution** - how that depth is delivered:
  - *inline (single pass)* - you review the whole scope yourself in one pass,
    references as checklists. Cheapest; one reviewer's blind spots;
    self-checked, not independently verified. This is the path the rigour
    apparatus is for.
  - *multi-agent fan-out* - hand off to the `craft-review-swarm` workflow: one
    agent per reference sweeping the whole scope, each finding adversarially
    verified, then clustered. Independent blind spots and verification; the most
    costly. Offer it for broad or high-stakes scope. It takes the same
    lens/scope/depth, so fan-out + exhaustive is the definitive audit; fan-out +
    headline is the rare "verify the big findings only" case.
- **Passes** - how many independent passes to run, orthogonal to all of the
  above. A single pass (inline *or* swarm) reliably under-covers: one reviewer's
  blind spots are correlated, so whole checks go unrun - sometimes high-severity
  ones - and coverage across passes is closer to their *union* than to any
  single pass. Rough guide to offer the user: **1** pass gets the obvious and
  the structural but leaves known gaps (fine for low-stakes or quick reviews);
  **2** independent passes (a pass plus one fresh critic) catch most of what one
  misses, at roughly double the cost; **3+** hits diminishing returns, for
  high-stakes audits only. Ask up front how many independent passes to run
  *simultaneously*, and run that many in parallel, then diff/verify/synthesise
  into one report. If they choose a single pass, don't present a sequential
  second as an up-front option, but flag that one will be available once the
  report lands, and offer it then (see `rigour.md`'s independent-passes step).
  These are inline, interactively-initiated passes, not the `craft-review-swarm`
  workflow.

Depth, execution, and passes are orthogonal: depth for how far down the tail,
execution for independence/cost within one pass, passes for how many independent
looks. Don't silently pick any of them, and never let a single pass read as
exhaustive - one reviewer can't reliably reach the tail, so even an exhaustive
single pass should say gaps are likely. **State the chosen lens, scope (with
exclusions), depth, execution, and passes at the top of the report** so a reader
knows what was and wasn't covered.

## The protocol

1. **Establish and enumerate the scope, then go deep.** List every file in
   scope up front and state what's in and out. Coverage comes before depth.
   Never sample silently: if you review a subset, say so and say what you left
   out. A review that skipped files but reads as complete is worse than one that
   admits its gaps. **Scope by lens, not by file type:** the two lenses read the
   same files and ask different questions, so a file is in scope for whichever
   dimensions live in it - a query or N+1 fired from a view (code) and the
   error/label/alt-text wording assembled in a controller or config (UI) are
   both in scope even though the markup is "just a view".
2. **Load the dimension references as checklists.** Read your lens's sweep
   references before forming conclusions (code: `refactoring.md`, `solid.md`,
   `object-oriented-design.md`, `design-patterns.md`, `reliability.md`,
   `performance.md`, `general-principles.md`; UI: `accessible-code.md`,
   `usability.md`, `forms.md`, `content.md`, `visual-design.md`). These turn "I
   notice this" into "I swept for all of these". **For an exhaustive review every
   catalogue is mandatory, not "as scope warrants":** the word "optional" is how
   a whole dimension gets skipped (e.g. `performance.md` on a query-driven app,
   which is where the N+1s live). If a catalogue genuinely does not apply, record
   `n/a: <reason>` in the sidecar rather than skipping it silently - and an app
   that does any I/O can never mark `performance.md` or `reliability.md` n/a. For
   a headline or subtree review, scope the catalogues to what is in scope, but
   say which you set aside. **Record this in the catalogue-load ledger
   (`rigour.md` #1) with a pasted `Read` per catalogue** - "mandatory" without an
   artifact is what let the flat single-subject checks (skip link,
   required-field marking, CSV-injection) get dropped while the sweep censuses
   still read as complete. Reading `reviewing.md`'s cross-file sweep list is not
   reading the catalogues; that list deliberately omits the single-subject checks.
3. **Sweep by dimension, not by file.** For each dimension, pass over the whole
   scope. Sweeping by dimension is what surfaces the cross-file findings a
   file-by-file read cannot see (see your lens file for which dimensions those
   are).
4. **Run the lens's orthogonal passes over the same code.** They ask different
   questions and one does not imply the other. Code: correctness *and*,
   separately, security - the canonical trap is raw SQL that is injection-safe
   (parameterised) yet still wrong because unescaped `%`/`_` act as wildcards.
   UI: walk it twice - once as a first-time sighted mouse user, once as an
   assistive-technology user.
5. **Aggregate by symptom (the theme view). Write it down.** Group findings by
   the smell/idea they share and, for each theme, sweep the whole scope again
   for every instance. This is the *across-files, same-problem* axis. Naming a
   theme surfaces more instances than listing them one at a time (code: "type
   switches that want polymorphism"; UI: "state shown but not announced").
6. **Aggregate by subject (the hotspot view). Write it down as a grid.** The
   orthogonal axis: *within one file, different problems*. Re-index the same
   findings by the file/class/component they touch, as a subject × dimension
   grid, and count the *distinct dimensions* per subject (not raw findings).
   This view is mandatory and materialised: it catches a root cause whose
   symptoms differ, which the theme view structurally cannot. For each subject
   cited across 2+ dimensions, **interpret it, don't just count it** - name the
   distinct responsibilities/faults it carries (a God Object / Divergent Change
   for code; an overloaded shared partial or layout for UI), which predicts
   members no single finding flagged. It is a *cohesion* judgement, not a size
   one. **Escalate severity for convergence - this is a gate, not a
   suggestion:** once a subject crosses 3+ dimensions it gets its *own* finding
   at High (or higher), naming the responsibilities, and you may not lower that
   floor with a cohesion impression. The individual findings' severities do not
   cap it - three Lows on one subject still escalate. Trajectory and familiarity
   language - "not yet", "trending", "borderline", "normal for a Rails/framework
   class", "each method is individually small" - are *non-answers*: a God Object
   is diagnosed by responsibility count, and reaching for those phrases is the
   tell that you found one and flinched. To sink a subject below the floor you
   need evidence (see the self-grill in `rigour.md`), never a judgement.
7. **Turn the two views into a leverage-ordered fix list.** Order the fixes by
   *how many findings each dissolves* (not by how cheap each is), annotate rough
   cost, and span genuine one-liners through the expensive structural anchor.
   This list is the forcing function for steps 5-6: you cannot rank by
   findings-dissolved without both aggregations. Don't title it "quick wins" -
   that buries the high-leverage structural fix, usually the costly one.
8. **Rank, credit, and disclose.** Give every finding an explicit severity
   (High/Medium/Low), kept *separate* from the fix-list order, since "how
   alarmed to be" and "what to do first" legitimately diverge. Credit what
   already works so fixes land in context - but every credit is a claim, so
   **falsify it before you write it** (see `rigour.md`; this is where
   "confirm-delete is consistent" and "this is idempotent" go wrong). Note any
   coverage gaps honestly.

## Delivering the report

Steps 1-8 produce the findings; this is how to hand them over. Offer to save the
report as unstyled Markdown at the repo root, and ask before writing. The
report's internal layout - the fixed section order and the per-finding schema
every finding follows - lives in `references/report-format.md`; the file *shape*
(how many files) follows the execution mode:

- **Inline** - one file per lens: a separate file for the code-craft report and
  the ui-craft report, each carrying that lens's full findings and themes. Don't
  merge the two lenses into one file. An exhaustive inline review also produces
  the coverage sidecar (`rigour.md`) alongside the report(s); it is scaffolding,
  so keep it local and don't fold it into the report body.
- **Multi-agent fan-out (swarm)** - one pair of files for the whole review: the
  themed summary (`craft-review-summary.md`, the by-theme view) and the full
  findings (`craft-review-findings.md`).

Keep them local: don't publish them as artifacts.

**Open every report with a short coverage caveat.** Before the findings, state
plainly that a review is a sample of a larger space, that gaps are likely -
including high-severity ones - and that another independent pass is the most
reliable way to raise coverage. This is not reflexive hedging: no single pass is
complete, so the caveat sets honest expectations and invites the follow-up.

If the review was a single pass, once the report is delivered offer to run
another independent pass (a fresh critic) and diff it against this one - see
`rigour.md`. Make the offer even when the review felt thorough; a second pass's
value is independent blind spots, not diligence. (When several passes already
ran in parallel and were synthesised, a further one is optional.)

## Which dimensions need a whole-scope sweep

The dimensions a single-file read *structurally cannot* catch - because they
live in the relationships between files - are the point of the by-dimension
sweep. They are lens-specific, so they live in your lens's
`references/reviewing.md`: read that list and sweep each across the whole scope.
Everything else in the catalogues (long method, naming, one form's labels) an
ordinary read already catches.

## Make the pass repeatable

Steps 1-8 say *what* to produce; `rigour.md` says how to keep a single inline
pass from quietly under-covering - the catalogue-load ledger (proving every
mandatory catalogue was actually read, not just the sweep list), the credits
ledger (step 8), the instance census (steps 3, 5), the coverage attestation
(step 1), and a final self-grill.
On the inline path these are mandatory; the swarm earns their equivalents from
its Verify and subject-pivot stages.

## Failure modes that cause misses

Guard against each:

- Reading file by file instead of sweeping by dimension (misses cross-file
  duplication and dependency-direction / repeat-across-screens problems).
- Working from the lens overview *or the `reviewing.md` sweep list* instead of
  the catalogues themselves (misses connascence, Repeated Switch; landmark-naming
  and name/role/value sweeps - and, because the sweep list omits them, the flat
  single-subject checks: skip link, required-field marking, a non-SQL injection
  sink, a fail-open default). Guard: the catalogue-load ledger (`rigour.md` #1) -
  a pasted `Read` per mandatory catalogue, or its checks were never run.
- A single pass over risky code (code: security-only, missing the correctness
  bug in the same lines).
- No theme synthesis (lists two instances and stops when there are five).
- Clustering only by theme, so a root cause whose symptoms differ is never
  named - guard: the subject grid (step 6).
- Building the subject grid but only tallying counts, never naming the
  responsibility/fault behind a hotspot.
- Naming a convergence in the subject grid, then overriding its severity with a
  narrative cohesion judgement - the grid sets a floor and prose cannot lower it
  (guard: step 6 and the self-grill in `rigour.md`).
- Running the Large Class / fat-controller / Long Method census only on classes
  that *look* big, so the responsibility dimension is skipped on the subject
  that reads as ordinary (guard: the responsibility census in `rigour.md`).
- Praising a correct instance without checking its siblings (credit not
  falsified - guard: the credits ledger in `rigour.md`).
- Ordering the fix list by effort instead of leverage.
- Sampling files/screens silently and presenting the result as complete.

## Choosing the swarm (offer, never automatic)

Execution is decided at the confirm step, and the choice is the user's. **Never
launch the `craft-review-swarm` workflow unless that choice points to it or the
user explicitly asks for it** - if they asked for an inline review, or asked not
to use the workflow, stay inline. Scope being broad is a reason to *offer* the
swarm ("the scope is large enough that a fan-out would be more thorough, at more
cost - want that instead?"), never a reason to reach for it on your own; it is
opt-in and expensive. When the choice does point to it, the saved workflow is
`craft-review-swarm` (`~/.claude/workflows/craft-review-swarm.js`).
