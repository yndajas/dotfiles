# Accessible visual design

The visual layer is mostly about Perceivable (the first POUR principle): can
people see and distinguish the content, at their own text size and zoom?
Grounded in WCAG 2.2 AA, with practical framing from the dxw accessibility
manual and the DWP "dos and don'ts" posters.

## Colour contrast

Meet at least WCAG 2.2 AA:

- **Body text**: 4.5:1 against its background.
- **Large text** (18pt+, or 14pt+ bold): 3:1.
- **UI components and meaningful graphics**: 3:1 against adjacent colours (e.g.
  input borders, icons, chart segments).

### On extremes

Pure black on pure white (`#000` on `#fff`) can cause visual stress for some
readers, particularly with dyslexia. But some users - for example with low
vision - need maximum contrast. So this is a design consideration, not a rule:
never drop below AA to soften things, and if you want a gentler default (say
`#1a1a1a` on `#fff`), pair it with a high-contrast option rather than removing
the choice.

### Text over images

Avoid text directly over photos or textured backgrounds. If unavoidable, put a
solid or semi-transparent panel behind the text so the contrast ratio is
actually met across the whole image.

### Tools

- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/) -
  pass/fail against AA and AAA.
- [Who Can Use](https://www.whocanuse.com/) - shows a combination through
  different vision conditions.
- [Accessible Colors](https://accessible-colors.com/) - suggests nearby passing
  colours.

## Do not rely on colour alone

People with colour-vision deficiencies may not distinguish colours, so colour
must never be the only carrier of meaning (WCAG 1.4.1). Add a second cue:

- Text labels or icons on status indicators and chart series.
- Underlines on links, not just a colour change.
- Text (and position/icon) alongside error and success states (see `forms.md`).

## Typography

### Body text

- Minimum 16px (1rem) body text.
- Use relative units (`rem`, `em`, `%`) so users can resize; never fix text in
  `px` in a way that blocks browser text scaling.
- Line height around 1.5 for body copy.
- Keep line length readable - roughly 45-75 characters.

### Headings

- A clear visual hierarchy with distinct steps between levels (visual size is
  separate from semantic level - see `accessible-code.md`).
- Headings larger and bolder than body text, styled consistently throughout.

### Font choice

- Prefer widely available, plainly legible typefaces for body text; avoid
  decorative or highly stylised fonts for anything users must read.
- Check the font renders clearly at small sizes and survives browser text
  resizing.

## Zoom, reflow, and spacing (Perceivable / Operable)

- **Reflow** (WCAG 1.4.10): content must work at 400% zoom (roughly a 320px-wide
  viewport) without loss of information or two-dimensional scrolling. Use
  responsive, relative layouts, not fixed pixel widths.
- **Text spacing** (WCAG 1.4.12): the layout must not break when users override
  line height, paragraph, letter, and word spacing. Avoid fixed-height
  containers that clip text.
- **Reduced motion**: honour `prefers-reduced-motion` for parallax, autoplay,
  and large transitions (implementation in `accessible-code.md`).
- **Target size** (WCAG 2.2, 2.5.8): give interactive targets enough size and
  spacing (24×24 CSS px or equivalent) - a layout concern as much as a code
  one.

## The DWP "dos and don'ts" posters

A memorable practitioner summary (UK Home Office / DWP accessibility posters),
by broad user group:

- **Low vision**: use good contrast and a readable size; do not use low contrast
  or fix small font sizes.
- **D/deaf or hard of hearing**: caption and transcribe media, write plainly; do
  not bury information only in audio.
- **Dyslexia**: left-align text, break content into chunks, support text
  scaling; do not use dense blocks of text or justify text.
- **Motor difficulties**: large clickable targets, generous spacing, keyboard
  support; do not demand precision or bunch controls together.
- **Autism / cognitive load**: simple consistent layouts, plain language; do not
  overload with colour, motion, or figures of speech.
- **Screen reader users**: semantic structure, real labels, descriptive links;
  do not rely on shape, colour, or spatial words like "click the box on the
  right".

## Further reading

- dxw accessibility manual - designing accessible services - https://accessibility.dxw.com/interaction-design/
- Home Office / DWP accessibility posters - https://ukhomeoffice.github.io/accessibility-posters/
- Inclusive Design Principles - https://inclusivedesignprinciples.org/
- Microsoft Inclusive Design Toolkit - https://www.microsoft.com/design/inclusive/
