# Reviewing more than one file (code-craft)

The shared review protocol and rigour apparatus live in the `craft-reviewing`
skill - load it first. This file adds only the code-craft dimensions to sweep
for - the ones a single-file read structurally cannot catch.

## Which dimensions need a whole-scope sweep

The catalogues are the full checklist - read `refactoring.md`, `solid.md` and
`object-oriented-design.md` and work through them. This section deliberately
does not restate their contents (that would only drift). It calls out the few
dimensions a single-file read *structurally cannot* catch, because they live in
the relationships between files rather than in any one file - so they are what
the by-dimension sweep is *for*.

**Sweep each dimension below with an actual search across the whole scope, and
record the command and its result in the coverage sidecar (see `craft-reviewing`'s
`rigour.md`). Reading the dimension is not sweeping it: a dimension with no
recorded search is *unswept*, not swept.** The searches are described in
language-neutral terms; any concrete command shown is a Ruby/Rails-flavoured
*example* to adapt to the stack in front of you (same convention as `rigour.md`),
not a fixed incantation.

- **Duplication across files** - the same logic in two controllers/models/
  services, often already drifted. Invisible unless you hold several files
  against each other. *Sweep:* grep the suspected shared verb/idiom across the
  layer and compare each hit.
- **Dependency direction** - a lower or more stable layer reaching *up* into a
  higher one (a model depending on a query/presentation object's constants, say).
  Only visible when you trace who-depends-on-whom across the layers. *Sweep:*
  grep the lower/more-stable layer for references to higher-layer type or
  constant names; any hit is a candidate inverted dependency.
- **Connascence spread across places** - of position (index-aligned rows and
  headers), of meaning (a stringly-typed format agreed by convention across
  several files - a status string, a composite key, a serialised option shape),
  of value. Connascence gets worse the further apart the coupled points are, so
  the worst cases are cross-file by definition.
  *Sweep:* grep the literal/format across the whole scope and count the distinct
  files that must agree on it.
- **Duplicated roster / attribute set** - one domain's field list re-stated in
  models, serialisers, params, and views. *Sweep (a census, not one grep):* list
  every name in the roster, search each across the scope, and record the file
  count per name; anything in 3+ files is a finding. Do not stop at the first two
  copies you happen to notice.
- **Repeated Switch / type switches** - a conditional on type, class or flag that
  the object could answer for itself, especially the *same* switch appearing in
  more than one place. *Sweep:* grep the language's type-dispatch idioms across
  the scope.
- **God Object / Divergent Change** - a class quietly accreting
  responsibilities. You only see it by weighing the whole class against its
  collaborators, not by reading one method. In a by-dimension sweep no single
  dimension owns it, so it surfaces only via the subject-pivot (protocol
  step 6): it appears as one class collecting findings from several dimensions
  at once. *Sweep:* fill the responsibility census (`rigour.md` #2) for **every**
  unit of the relevant kind (not the ones that look big), with a responsibility
  count each.
- **Behaviour hiding in templates (performance / N+1)** - I/O triggered from a
  view: a per-row query, ordering, or count inside a loop, or a call on an
  already-loaded collection that silently re-fetches and defeats an eager-load,
  plus domain logic or a type switch in a template. Invisible if the sweep is
  scoped to the application-code files alone; scope by lens, not file type
  (protocol step 1). *Sweep:* for **every** template that iterates a collection,
  name the per-row call(s) and state whether each triggers I/O. The query-pattern
  case is worked through in `performance.md`, which an exhaustive review must
  cover rather than treat as optional (protocol confirm step).

Everything else in the catalogues (Long Method, primitive obsession, naming,
guard clauses) an ordinary single-file read already catches; it doesn't need the
sweep, so it isn't listed here.
