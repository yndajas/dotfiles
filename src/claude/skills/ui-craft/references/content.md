# Accessible content

Content is where Perceivable and Understandable (the middle two POUR principles)
are mostly won or lost. Grounded in WCAG 2.2 AA, the dxw accessibility manual,
and GDS Content Design. Forms are covered separately in `forms.md`.

## Plain, readable language (Understandable)

- Use plain language; avoid jargon and complex sentence structures. GOV.UK aims
  for a reading age of around 9 - not because users cannot read, but because
  everyone, including experts and stressed or distracted users, reads simple
  text faster.
- Short sentences, short paragraphs, one idea at a time.
- Prefer the active voice ("we will email you", not "you will be emailed").
- Explain technical or legal terms the first time they must appear; better, find
  a common-language alternative.
- Structure content with headings, short paragraphs, and lists so it can be
  scanned (see `usability.md` - people scan, they do not read).

## Headings as a navigation aid (Perceivable / Operable)

Screen-reader users jump between headings to scan a page, so headings are
structure, not decoration. (The markup rules - one `<h1>`, no skipped levels -
are in `accessible-code.md`; this is about *wording*.)

- Make each heading descriptive and frontloaded, with the most important word
  first ("Report a change", not "How to report a change to us").
- Use headings to break content into logical sections a user can navigate by.
- Never style body text as a heading (or vice versa) just for visual effect.

## Link text (Perceivable / Understandable)

Screen readers can list all links out of context, so link text must make sense
on its own.

- Never use generic text like "click here", "read more", or "find out more".
- Start with a verb when you want the user to act ("check your application
  status").
- Match the link text to the destination page's title where you can.
- Use the same text for links going to the same place, and different text for
  links going to different places.

### Links, dexterity, and density (Operable)

- Avoid single-word links; they are small targets for people with motor
  difficulties (see also target size in `accessible-code.md`).
- Do not crowd links together; give them adequate spacing.
- Do not overload a page with links - it overwhelms everyone.
- Link to the page that hosts a document rather than directly to the file, so
  users get context (and format/size) before downloading.

## Alt text for images (Perceivable)

All non-text content needs a text alternative. Good alt text:

- Conveys the same information or function the image does, in context.
- Is concise - a short phrase, not a paragraph.
- Does not start with "image of" or "photo of"; assistive tech already announces
  it as an image.
- Is empty (`alt=""`) for purely decorative images, so screen readers skip them.

Use the [W3C alt-decision tree](https://www.w3.org/WAI/tutorials/images/decision-tree/)
to decide what (if anything) an image needs. Note: the dxw convention of ending
alt text with a full stop (to encourage a pause) is a house style, not a WCAG
requirement - harmless, but do not rely on it for meaning.

### Alt text for charts and data visualisations

Short alt rarely describes a chart adequately. Amy Cesal's pattern works well:

```
alt="[chart type] of [type of data] where [key finding or reason for including it]"
```

```html
<img src="admissions-chart.png"
     alt="Pie chart of 2022 school admissions where 43% of children did not get their preferred choice.">
```

Also link to the underlying data, and give complex visualisations a short
text explanation visible to everyone, not hidden in alt.

## Video and audio (Perceivable)

- **Video**: captions/subtitles, a transcript (including non-speech audio), and
  audio description (or an alternative version with it).
- **Audio-only** (e.g. a podcast): a descriptive transcript.
- You do not need these when the media is itself the text alternative for
  something else.

## Presenting data and tables (Perceivable / Robust)

- Use tables only for genuinely tabular data, never for layout.
- Give tables proper headers (`<th>`) with correct `scope`, and a `<caption>`
  describing the table.
- For a complex table, first ask whether the data can be split or presented more
  simply; consider offering it in more than one format (a table plus a summary
  sentence).

## Further reading

- dxw accessibility manual - https://accessibility.dxw.com/content/
- GDS Content Design guidance - https://www.gov.uk/guidance/content-design
- GOV.UK style guide - https://www.gov.uk/guidance/style-guide
- W3C images tutorial - https://www.w3.org/WAI/tutorials/images/
