---
name: code-craft
description: >-
  Apply the combined lens of Sandi Metz (OOP design), Martin Fowler
  (refactoring and code smells), the Gang of Four (design patterns), general
  engineering wisdom (The Pragmatic Programmer, Code Complete), and test design
  (five-factor testing, the test pyramid) when reviewing, refactoring, deciding
  how to structure code, or deciding how to test it. Use when reviewing code for
  quality or maintainability, cleaning up code smells or technical debt,
  refactoring existing code, weighing whether a design pattern fits a new
  feature, judging whether a test earns its place or at what level to write it,
  or when the user mentions Sandi Metz, POODR, 99 Bottles, Fowler, refactoring,
  design patterns, Gang of Four, GoF, The Pragmatic Programmer, Code Complete,
  SOLID, Liskov, Open/Closed, connascence, data modelling, performance,
  idempotency, retries, reliability, test pyramid, or test design. Not for
  UI/UX concerns (see the ui-craft skill).
---

# code-craft

A single lens for improving code, drawing on four complementary sources.
Reviewers and designers apply these together, not one at a time, so this skill
unifies them and reconciles where they pull in different directions.

## The one guardrail that reconciles them

Prefer the simplest thing that works. Sandi Metz and Fowler push toward smaller,
clearer, behaviour-preserving code; the Gang of Four offers structures that add
indirection. These only conflict if you reach for a pattern speculatively.

**Introduce a pattern, abstraction, or indirection only to remove a problem
that exists now, never one you imagine might exist later.** When Fowler's smells
and a GoF pattern disagree, the smell wins: remove duplication and coupling
first; a pattern is justified only if it leaves the code simpler against a real,
present need. This is Fowler's "economics, not aesthetics" and the Pragmatic
Programmer's warning against speculative generality, in one rule. Put plainly:
YAGNI (you aren't gonna need it) and KISS (keep it simple) - prefer the simplest
thing that works until a concrete, present need proves otherwise.

## Cite your sources

When you apply advice from these sources, name the source so the reasoning is
traceable and the user can push back.

- **In responses**: attribute the idea as you give it - "Metz's rule: methods
  under five lines", "this is Feature Envy (Fowler)", "the Strategy pattern
  (GoF) fits here because...", "the Pragmatic Programmer's DRY".
- **In commit messages**: where a change is driven by one of these sources and
  naming it adds useful context, cite it in the body (not the subject) - for
  example, "Extract the parameter object to remove Fowler's Long Parameter List
  smell". Cite for context, not decoration; omit it when the diff speaks for
  itself.

## Learning mode

The user treats design choices as learning opportunities, not just output. When
you apply a named idea from the references (a smell, a refactoring, a pattern, a
SOLID principle, connascence), name it and say briefly why it applies here. On a
good teaching moment - a non-trivial refactor, a design or pattern decision, a
new abstraction - offer (do not force) a short exercise, and engage the
`learning-opportunities` skill on that specific principle rather than a generic
prompt. Skip this for trivial or mechanical changes.

## Three modes

**Review** - read the code, name issues by their catalogue term (smell, rule
violation) and cite the source, reference `file:line`, rank by impact, and say
plainly when code is fine as-is. Do not invent problems to look thorough.

**Refactor** - confirm tests exist and pass first. Apply changes in small,
behaviour-preserving steps, running tests between them. Narrate each step. Never
mix a refactor with a behaviour change in the same step.

**Architect** - when structuring a new feature, start from the simplest design
that satisfies the requirement. Reach for a pattern only when a concrete force
(varying behaviour, many collaborators, a hard-to-test seam) makes it pay for
itself. Name the pattern and the force it addresses.

## Which reference to read when

Read only what the task needs; each file is self-contained.

| Situation | Read |
|---|---|
| Ruby OOP sizing, class/method design, dependencies, Law of Demeter | `references/object-oriented-design.md` |
| Naming a code smell, choosing and safely applying a refactoring | `references/refactoring.md` |
| Deciding whether a classic pattern fits a new design | `references/design-patterns.md` |
| General construction quality, naming, defensiveness, decoupling | `references/general-principles.md` |
| OOP design principles - SOLID, coupling, connascence, module depth, data modelling | `references/solid.md` |
| Performance as a design concern - complexity, queries, caching | `references/performance.md` |
| Reliability of services - idempotency, retries, timeouts, failure handling | `references/reliability.md` |
| Whether a test earns its place, what to test, at what level | `references/testing.md` |

Most real reviews touch more than one. A typical flow: spot smells with Fowler,
size and shape objects with Metz, and only then ask whether a GoF pattern earns
its keep, checking the whole against the general principles.

## Language note

Metz's rules are Ruby-specific in their numbers but their intent (small,
single-responsibility, loosely-coupled objects) is general. Fowler, GoF, and the
general principles are language-agnostic. Adapt idioms to the language in front
of you.
