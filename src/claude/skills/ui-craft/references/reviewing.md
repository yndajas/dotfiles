# Reviewing more than one screen (ui-craft)

The shared review protocol and rigour apparatus live in the `craft-reviewing`
skill - load it first. This file adds only the ui-craft dimensions to sweep for -
the ones a single-screen review structurally cannot catch.

## Which dimensions need a whole-scope sweep

`accessible-code.md`, `usability.md`, `forms.md`, `content.md` and
`visual-design.md` are the full checklist - read them and work through them.
This section deliberately does not restate their contents (that would only
drift). It calls out the few dimensions a single-screen review *structurally
cannot* catch, because they only show up across screens or across a shared
stylesheet - so they are what the sweep is *for*.

**Sweep each dimension below across the whole scope with an actual search or a
per-screen enumeration, and record it in the coverage sidecar (see
`craft-reviewing`'s `rigour.md`). Reading the dimension is not sweeping it: a
dimension with no recorded search/enumeration is *unswept*, not swept.** Any
concrete command shown is an example to adapt to the templating/markup in front
of you, not a fixed incantation.

- **Name/role/value and status parity** - `aria-current` on the current item
  across every navigation-like control, and `role="status"`/`"alert"` on live
  regions. The finding is almost always "one component does it, its siblings
  don't", which you only see across screens. *Sweep:* enumerate every
  current/active/selected cue and every live region across the scope and check
  each has the announced equivalent.
- **Landmark naming and bypass** - multiple `nav`s each needing a distinct
  `aria-label`, and a skip link with a targetable `main`. Consistency across the
  set is the point, so it's a whole-scope check. *Sweep:* grep every landmark
  element across the scope and record which carry a distinct accessible name;
  confirm one skip link resolves to a real target.
- **Heading levels across a shared partial's contexts** - a shared partial that
  emits a heading at a hardcoded level can be correct in one context and skip a
  level in another; you only catch it by checking every page the partial renders
  in. *Sweep:* for each
  shared partial that emits a heading, list every screen that renders it and
  record the surrounding heading level at each site.
- **Focus indicator and contrast across all themes** - both are asserted once in
  the stylesheet and affect every screen and every theme, so they're inherently
  whole-scope. *Sweep:* enumerate every theme and record, per theme, the focus
  cue and whether interactive elements carry a non-colour distinction (do not
  trust a blanket "AA verified" comment - compute or check the tightest pairs
  and the focus state).
- **A shared partial or layout as the single point behind many failures** - the
  same partial, component, or layout recurring across findings from several
  different criteria. Only visible once findings are pivoted by the file they
  touch (protocol step 6), not by criterion - the instances otherwise scatter
  across themes.
- **Per-screen basics that must hold on every screen** - a distinct page title,
  a sensible heading order, and consistent persistent navigation. Each is
  trivial per screen but only reliably caught by a row-per-screen check, because
  the misses hide on the screens you didn't open (a drill-down/leaf page that
  drops the sub-nav, a modal flow with no title). *Sweep:* one coverage-matrix
  row per screen with a cell for title / heading order / nav present, filled for
  *every* screen including leaf and error pages, not just the index screens.
- **Content and accessible names living outside the template** - the text a
  screen reader announces or a user reads (error and status messages, link and
  button labels, alt text, accessible names) is often assembled in application
  code or a translation/config file, not in the markup, so scope by lens, not
  file type (protocol step 1). The content case is worked through in `content.md`.

Per-screen criteria (a single form's labels, one image's alt text, one link's
wording) belong to the references and to the ordinary screen-level review; they
don't need the sweep, so they aren't listed here - *except* where the per-screen
basics above make a row-per-screen pass the only reliable way to catch them.
