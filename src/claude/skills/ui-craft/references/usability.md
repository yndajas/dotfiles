# Usability

From Steve Krug's *Don't Make Me Think*, Jakob Nielsen's usability heuristics,
Don Norman's *The Design of Everyday Things*, and the GOV.UK Design Principles.
The goal: interfaces a user understands and can act on without conscious effort.

## Krug's first law: don't make me think

Every question a page forces the user to ask ("Where am I? Where do I start? Is
this clickable? Is this the same as that?") is friction. A page should be
**self-evident** - obvious at a glance. Where that is impossible (complex flows,
novel interactions), aim for **self-explanatory**: no instructions needed to
work out what to do next.

### How people really use interfaces

Design for these facts, not for an idealised attentive reader.

- **We scan, we don't read.** Users glance for something matching their goal.
  Support scanning with clear headings, short paragraphs, lists, and highlighted
  keywords.
- **We satisfice, we don't optimise.** Users pick the first reasonable option,
  not the best one. Make good options obvious and hard to miss.
- **We muddle through.** Users rarely read instructions; they form a rough
  mental model and press on, keeping it even when wrong. Make the right path the
  path of least resistance.

### Krug's practical rules

- **Clear visual hierarchy** - more important means more prominent; related
  things grouped; the appearance mirrors the structure of the content.
- **Follow conventions** - established patterns (nav placement, link styling, a
  clickable logo home) spend none of the user's thinking budget. Innovate only
  where it clearly pays.
- **Make clickable things obviously clickable** and non-clickable things
  obviously not.
- **Omit needless words. Then omit half of what's left.** Cut instructions,
  welcome text, and happy talk so the meaningful content stands out.
- **Break the page into clearly defined areas** so users can decide fast what to
  focus on and what to ignore. Minimise noise.

## Nielsen's 10 usability heuristics

The standard checklist for a systematic review (heuristic evaluation). Walk the
interface against each:

1. **Visibility of system status** - the system keeps users informed through
   timely feedback (loading, saved, progress).
2. **Match between system and the real world** - speak the user's language and
   follow real-world conventions, not internal jargon.
3. **User control and freedom** - clear exits, undo and redo; do not trap users
   in a flow.
4. **Consistency and standards** - same words and actions mean the same thing;
   follow platform conventions.
5. **Error prevention** - design so mistakes cannot happen (constraints,
   confirmations, good defaults), better than good error messages.
6. **Recognition rather than recall** - make options and information visible;
   do not force users to remember things across screens.
7. **Flexibility and efficiency of use** - accelerators for experts that do not
   get in beginners' way.
8. **Aesthetic and minimalist design** - no irrelevant or rarely-needed
   content; every extra unit competes with the relevant ones.
9. **Help users recognise, diagnose, and recover from errors** - plain-language
   messages that state the problem and suggest a fix.
10. **Help and documentation** - ideally unnecessary, but when needed, easy to
    search, task-focused, and concrete.

## Norman: the theory underneath

*The Design of Everyday Things* explains *why* the above works.

- **Affordances and signifiers** - an affordance is a possible action; a
  signifier is the perceivable cue that advertises it. "Make clickable things
  look clickable" is a plea for good signifiers. A button that does not look
  pressable has the affordance but lacks the signifier.
- **Mapping** - controls should map naturally to their effects (spatial layout
  matching real arrangement, order matching sequence).
- **Feedback** - every action needs a prompt, visible response; silence makes
  users repeat or abandon actions (ties to Nielsen 1).
- **Conceptual model** - the interface should project a model that matches how
  users think about the task, so their guesses are right.
- **Constraints** - limit possible actions to prevent error (ties to Nielsen 5).
- **Slips vs mistakes** - slips are right-intention wrong-action (fix with
  better signifiers and constraints); mistakes are wrong-intention (fix with a
  clearer conceptual model). Design for both; assume human error is normal.

## Interaction laws worth knowing

- **Fitts's Law** - time to hit a target grows with distance and shrinks with
  size. Make important and frequent targets large and close; do not place tiny
  controls far from where the user is looking. (See also dexterity and
  link-spacing guidance in `content.md`.)
- **Hick's Law** - decision time grows with the number and complexity of
  choices. Reduce and group options; reveal advanced choices progressively.

## GOV.UK Design Principles

The layer above any component library, and the right default for public-sector
service work:

1. Start with user needs.
2. Do less.
3. Design with data.
4. Do the hard work to make it simple.
5. Iterate. Then iterate again.
6. This is for everyone (accessibility is not optional - see the accessibility
   references).
7. Understand context.
8. Build digital services, not websites.
9. Be consistent, not uniform.
10. Make things open: it makes things better.

## Navigation

- Answer on every page: **Where am I? Where can I go? Where is the home?**
- Keep **persistent navigation** consistent across pages; the logo links home.
- Show the user's location (highlighted section, **breadcrumbs**, a clear page
  name).
- Provide obvious **search** for anything non-trivial; many users navigate by
  searching, not browsing.

## Test it cheaply

Krug's central practical claim: **a little usability testing, done often, beats
a lot done late.** Watching a few real users attempt a task surfaces the big
problems fast. When reviewing, flag the places a first-time user would pause and
ask a question - those are the ones worth testing.

## Further reading

- Steve Krug, *Don't Make Me Think* and *Rocket Surgery Made Easy*.
- Jakob Nielsen, "10 Usability Heuristics for User Interface Design" (Nielsen
  Norman Group).
- Don Norman, *The Design of Everyday Things*.
- GOV.UK Design Principles - https://www.gov.uk/guidance/government-design-principles
