# Writing accessible code

How code is written directly determines how assistive technologies interpret a
page. Grounded in WCAG 2.2 AA, with practical conventions from the GOV.UK Design
System and the dxw accessibility manual. Where a point is a house convention
rather than a hard requirement, it is flagged as such.

## The POUR frame (shared by all accessibility references)

WCAG organises accessibility under four principles. Use them as the checklist
spine across `accessible-code.md`, `content.md`, `forms.md`, and
`visual-design.md`:

- **Perceivable** - users can perceive the information (text alternatives,
  captions, sufficient contrast, content not conveyed by colour alone).
- **Operable** - users can operate the interface (keyboard operable, visible
  focus, enough time, no seizure triggers, clear navigation).
- **Understandable** - information and operation are understandable (readable
  language, predictable behaviour, input help and error handling).
- **Robust** - content works across user agents and assistive technologies
  (valid, semantic markup; correct name, role, value).

This file covers the developer's share: mostly Robust (semantics) and Operable
(keyboard and focus).

## Semantic structure (Robust)

### Language

- Set `lang` on `<html>` (e.g. `<html lang="en">`) so screen readers use the
  right pronunciation. Mark inline foreign-language fragments with their own
  `lang`.

### Titles and headings

- Every page needs unique `<title>` and `<h1>` content (they may match each
  other, but should differ from other pages).
- Headings follow a logical order and never skip levels; one `<h1>` per page.
- (Heading *wording* is covered in `content.md`.)

### Landmark elements

Landmarks (`<header>`, `<nav>`, `<main>`, `<footer>`) give screen readers a
broad outline to navigate by:

- Exactly one `<main>` per page, containing the primary content.
- Add a skip-to-main-content link at the top when the header repeats navigation.
- If a landmark appears more than once (e.g. two `<nav>` blocks), give each a
  unique label via `aria-labelledby` or `aria-label`.
- A top-level native `<header>`/`<footer>` already maps to the `banner` /
  `contentinfo` landmarks, so you do not need to add those roles. Only reach for
  explicit roles to disambiguate, or when the element is nested inside another
  landmark (where it loses the implicit mapping).

## Use the right HTML element (Robust)

The right native element gives you role, focusability, keyboard behaviour, and
semantics for free. Compare a link built from a `<div>`:

```html
<div role="link" tabindex="0" onclick="doSomething()" onkeydown="doSomethingIfEnterKey()" class="app-link">
  Link text
</div>
```

against the native element:

```html
<a href="/page-link">Link text</a>
```

The first rule of ARIA is: do not use ARIA if a native element will do.

- Check for a native element with the right default role before reaching for
  ARIA.
- If you assign a role manually, you own all the expected behaviour (e.g.
  `role="button"` needs a click handler, `tabindex="0"`, and Enter/Space key
  handling).
- Never give an element a role that conflicts with its semantics, and do not
  override elements that already carry the right ones.
- For genuinely custom widgets (menus, comboboxes, tabs), follow the
  [WAI-ARIA Authoring Practices Guide](https://www.w3.org/WAI/ARIA/apg/) rather
  than inventing interaction patterns.

## Naming interactive elements (Robust)

Buttons, links, and inputs must have unique, meaningful accessible names; the
visible text is the default name.

- If visible text is not unique (e.g. several "Edit" buttons in a table), add
  visually hidden context saying which record each relates to.
- For icon-only controls with no visible text, you need a name from somewhere.
  dxw's convention is to prefer visually hidden text (a CSS class) over
  `aria-label`, because some screen readers skip `aria-label` when translating a
  page and it can override an existing name. `aria-label` is still valid and
  common; treat visually-hidden-text as the safer default, not a prohibition.
- All `<input>` elements need an associated `<label>`. (Form specifics live in
  `forms.md`.)

### Checking accessible names

- Hover an element with the browser's element selector tool to see its computed
  name.
- Open your browser's accessibility inspector (the accessibility tree/pane in
  its developer tools; most major browsers have one) to see how the name was
  derived.

## Keyboard and focus (Operable)

Everything must work without a mouse, and the user must always be able to see
where they are.

- **Focus order** follows the visual/reading order; do not use positive
  `tabindex` values to reorder. Only make natively-focusable elements focusable
  (or add `tabindex="0"` to custom controls); use `tabindex="-1"` for
  programmatic-only focus.
- **No keyboard traps** - focus can always move on; the one deliberate exception
  is a modal, which should trap focus while open and restore it on close.
- **Visible focus** - include `:focus` (prefer `:focus-visible`), `:active`, and
  `:hover` states. If the design system has no focus style, keep the browser
  default; never remove an outline without replacing it. WCAG 2.2 also requires
  the focused element not be fully hidden behind sticky headers/footers
  (Focus Not Obscured, 2.4.11).
- **Focus management for dynamic content** - when content appears or the view
  changes without a full page load (modals, Turbo/SPA navigation, async
  results), move focus deliberately (into the dialog, to the new `<h1>`, or to
  an error summary) so keyboard and screen-reader users are not stranded.
- **Target size** - WCAG 2.2 AA (2.5.8) wants interactive targets at least
  24×24 CSS px, or with equivalent spacing. (Layout-side guidance in
  `visual-design.md`.)

## Announcing change (Operable / Robust)

- Use a **live region** (`aria-live="polite"`, or `role="status"` /
  `role="alert"`) to announce async updates (results loaded, item saved, an
  error) that happen without a page load, so screen-reader users hear them.
- Respect **`prefers-reduced-motion`**: gate non-essential animation and
  transitions behind the media query, and avoid anything that flashes more than
  three times a second (seizure risk).

## Testing (do not ship on inspection alone)

- **Automated**: run axe (axe DevTools / `axe-core`), Lighthouse, or WAVE. These
  catch perhaps a third of issues - necessary, not sufficient.
- **Manual keyboard**: tab through the whole page; can you reach and operate
  everything, in a sensible order, with focus always visible?
- **Screen reader**: test with at least one real screen-reader-and-browser
  combination (for example VoiceOver with Safari, or NVDA with Firefox); the
  accessibility tree tells you the computed semantics but not the lived
  experience.

## See also

- Forms (labels, fieldsets, error association and summaries) - `forms.md`.
- Wording of names, headings, and alt text - `content.md`.
- Contrast, non-colour state cues, zoom/reflow - `visual-design.md`.

## Further reading

- WCAG 2.2 quick reference - https://www.w3.org/WAI/WCAG22/quickref/
- WAI-ARIA Authoring Practices Guide - https://www.w3.org/WAI/ARIA/apg/
- dxw accessibility manual - https://accessibility.dxw.com/development/writing-acessible-code/
- MDN accessibility - https://developer.mozilla.org/en-US/docs/Web/Accessibility
