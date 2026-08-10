# Forms

Forms are where a lot of real interaction happens, and where usability and
accessibility problems hurt users most. This is the single home for form
guidance; `accessible-code.md`, `content.md`, and `usability.md` defer here. The
guidance below is general; points that are a GOV.UK convention rather than a
universal rule are flagged, and GOV.UK-specific components are gathered at the
end. Grounded in WCAG 2.2 AA, Luke Wroblewski's *Web Form Design*, the dxw
accessibility manual, and the GOV.UK Design System.

## Flow and structure

- **Keep each screen focused.** Asking a single question (or one tightly related
  group) per screen lowers cognitive load, makes error recovery easier, and
  works better on small screens and for screen readers. This is GOV.UK's "one
  thing per page" default, and a good default generally; a well-grouped single
  page can be fine for short forms.
- **Order deliberately.** Put eligibility and filtering questions first so
  people who need not continue find out early.
- **Use conditional logic** so users only see questions relevant to them,
  instead of "if this applies to you" branches within a page.
- **Ask for the minimum.** Every field is a cost and a reason to abandon. For
  each one, ask who uses the answer and what breaks if you drop it. Do not
  collect data you do not need.
- **Group related fields** in a `<fieldset>` with a `<legend>` (e.g. the parts
  of an address, or a single question with radio options).

## Labels and field markup (Robust)

- Every input has an associated, ideally visible, `<label>` (`for`/`id`, or
  wrapping). A visible label beats a placeholder - placeholders vanish on input,
  are low-contrast, and are not a reliable accessible name.
- Do not use a placeholder as the only label. If you use placeholders, use them
  for genuine examples, and still provide a real label.
- For a group of controls answering one question (radios, checkboxes), the
  `<legend>` is the question and each `<label>` is an option.
- Mark required vs optional unambiguously. One low-noise convention (GOV.UK's)
  is to mark the few optional fields "(optional)" rather than starring the many
  required ones.
- Attach help text (hints, examples, where to find information) to the field via
  `aria-describedby`, not as ambiguous nearby prose.

## Inclusive field design

Do not encode narrow assumptions about people into fields:

- Do not restrict text to Latin characters - names include accents and
  non-Latin scripts.
- Do not set minimum lengths on names - some are very short.
- Do not offer only "female/male" for gender (listed alphabetically to avoid
  implying a default), and only ask when you genuinely need it.
- Do not impose time limits on completion; if a technical timeout is
  unavoidable, warn the user and let them extend it (WCAG 2.2.1).
- Do not use CAPTCHAs that depend on interpreting images, maths, or puzzles;
  prefer accessible anti-spam approaches.
- **Accept input in whatever format users have it**, then normalise in code
  (e.g. a card number or phone number with or without spaces and punctuation).
  Do not reject formatting differences.
- Set `autocomplete` attributes and an appropriate `inputmode`/`type` so
  browsers can autofill and mobile keyboards suit the field.

## Errors (Understandable)

- **Prevent first** (WCAG best practice, and Nielsen): good defaults, clear
  formats, and confirmation for consequential or destructive actions beat any
  message.
- **Validate helpfully.** Say what is wrong and how to fix it, in plain
  language, next to the field - not a generic banner and not jargon.
- **Show an error summary.** On a failed submit, list each error at the top of
  the page as a link to its field, and move focus to the summary. This is what
  screen-reader and keyboard users rely on to find the errors at all. (The
  GOV.UK error-summary component implements exactly this pattern.)
- **Do not rely on colour alone** to mark errors - pair it with text and a clear
  position or icon.
- **Preserve the user's input** on failure; never make them re-type.
- Associate each message with its field programmatically (`aria-describedby`,
  plus `aria-invalid` on the input).

## Confirmation and next steps

After submission, tell the user:

- what they submitted (or that a copy has been sent to them);
- what happens next, and any deadline, if there is one;
- whether they need to do anything else, and how.

## GOV.UK components (when in that context)

For Service Standard work, prefer the tested building blocks over rolling your
own: the
[error message](https://design-system.service.gov.uk/components/error-message/),
[error summary](https://design-system.service.gov.uk/components/error-summary/),
[text input](https://design-system.service.gov.uk/components/text-input/),
[radios](https://design-system.service.gov.uk/components/radios/), and the
[question pages pattern](https://design-system.service.gov.uk/patterns/question-pages/).
Still test the assembled form as you would hand-written markup.

## Further reading

- Luke Wroblewski, *Web Form Design: Filling in the Blanks*.
- GOV.UK Design System - form components and patterns - https://design-system.service.gov.uk/
- dxw accessibility manual - accessible forms - https://accessibility.dxw.com/content/
