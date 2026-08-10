---
name: ui-craft
description: >-
  Apply the combined lens of usability (Steve Krug's "Don't Make Me Think",
  Jakob Nielsen's heuristics, Don Norman) and accessibility (WCAG 2.2, the
  GOV.UK Design System and Design Principles, the dxw accessibility manual) when
  designing, building, or reviewing user interfaces - web pages, Rails views,
  forms, navigation, content, and visual design. Use when creating or changing
  UI markup, templates, or flows, reviewing a screen or form, writing
  user-facing content or alt text, choosing colours or typography, or when the
  user mentions usability, UX, accessibility, a11y, WCAG, screen readers, alt
  text, colour contrast, semantic HTML, heuristics, or Steve Krug. For code
  quality, refactoring, patterns, and test design in non-UI code, use the
  code-craft skill instead.
---

# ui-craft

A single lens for building interfaces people can actually use, combining two
complementary concerns that a good reviewer applies together:

- **Usability** (Krug, Nielsen, Norman) - can a user understand and act without
  effort?
- **Accessibility** (WCAG / GOV.UK / dxw) - can everyone, including disabled
  users and assistive-technology users, do so?

These reinforce each other far more than they conflict: an accessible interface
is almost always more usable, and Krug's "don't make me think" is the usability
statement of what accessibility enforces structurally.

## The guiding principle

Reduce the effort a user must spend to understand and act. Every question a page
forces ("Where am I? Is this clickable? What went wrong? What is this image?")
is friction, and for an assistive-technology user that friction is often a hard
barrier rather than a mild annoyance. Prefer semantic, conventional, plainly
labelled interfaces over clever ones.

## Cite your sources

When you apply a principle, name where it comes from so the reasoning is
traceable - "Krug: make the clickable things obviously clickable", "Nielsen:
visibility of system status", "WCAG 2.2 AA: body text needs 4.5:1 contrast",
"GOV.UK error message component". In commit messages, cite in the body where it
adds useful context, not as decoration.

## Learning mode

The user treats design choices as learning opportunities, not just output. When
you apply a named idea from the references (a usability heuristic, an
accessibility/WCAG criterion, a Norman or Krug principle), name it and say
briefly why it applies here. On a good teaching moment - a non-trivial layout,
component, form, or interaction decision - offer (do not force) a short
exercise, and engage the `learning-opportunities` skill on that specific
principle rather than a generic prompt. Skip this for trivial or mechanical
changes.

## Two modes

**Build** - reach for the right semantic element first, label everything, follow
conventions, and meet the accessibility baseline as you write markup, not as a
later pass. In a Service Standard context, prefer GOV.UK Design System
components, but test the assembled result regardless.

**Review** - walk the interface as a first-time user and as an assistive-tech
user. Nielsen's ten heuristics are a good systematic checklist. Flag each spot
where either user would have to stop and ask a question, cite the principle and
(for accessibility) the WCAG criterion or GOV.UK guidance, and rank by impact.
Accessibility failures that block a task outrank cosmetic usability nits.

## Which reference to read when

Read only what the task needs; each file is self-contained.

| Situation | Read |
|---|---|
| Overall usability, heuristics, navigation, clarity, "does this make me think?" | `references/usability.md` |
| Markup, semantics, ARIA, landmarks, headings, accessible names, focus | `references/accessible-code.md` |
| Alt text, link text, headings, plain language, media, data/tables | `references/content.md` |
| Anything to do with forms - flow, labels, fields, errors, confirmation | `references/forms.md` |
| Colour contrast, using colour, typography, visual design | `references/visual-design.md` |

Most real UI work touches more than one. A typical flow: get the structure and
semantics right (`accessible-code`), make it usable and conventional
(`usability`), write clear content and labels (`content`), handle any forms
(`forms`), and check the visual layer (`visual-design`). The three accessibility
files share one frame - WCAG's POUR principles (Perceivable, Operable,
Understandable, Robust), set out at the top of `accessible-code.md`.

## Context note

The accessibility references lean on the GOV.UK Design System and dxw's
accessibility manual, which is the right default for GOV.UK and public-sector
service work. The underlying standards (WCAG 2.2 AA, semantic HTML) apply to any
web interface; adapt the GOV.UK-specific component advice to the design system
in front of you.
