# Testing as design

Good tests are a design tool, not a box to tick. This file gathers the lenses
worth applying when writing or reviewing tests. Cite the source when you apply
one. None of these are compulsory: they are frames for deciding, not rules to
obey.

## Five-factor testing (Sarah Mei)

A test has no inherent value. It is worth having only insofar as it supports one
or more of these five factors:

1. **Verify the code is working correctly** - immediate confidence that what you
   wrote does what you think.
2. **Prevent future regressions** - part of the suite that tells the next person
   they did not break your work.
3. **Document the code's behaviour** - executable documentation that cannot go
   stale; the easiest way to show intended use and edge cases.
4. **Provide design guidance** - writing a test gives the code a *secondary
   client*, forcing a small, non-speculative amount of generality and surfacing
   awkward design before it sets. Hard-to-test code is a design signal, not a
   testing problem.
5. **Support refactoring** - tests at the right level let you rearrange code
   underneath a stable interface without fear.

### How to use the factors

- This is a **framework for discussing test strategy, not a checklist**. You
  cannot maximise all five at once; they are in tension. Comprehensive unit
  tests document well (3) but ossify an interface, hurting refactoring (5).
  Slow top-level integration tests prove behaviour (1) and document (3) but, as
  they slow the suite, weaken regression value (2) because people stop running
  them.
- In review, ask of each test: **which factors does it serve, and are they the
  right ones here?** A test optimising for a factor that does not matter at this
  spot can often be simplified or deleted.
- Match strategy to the code's role: a rarely-changing public API leans toward
  documentation (3); a churny internal class leans toward light regression tests
  (2) that leave it free to refactor (5).
- Treat tests as living documents. As the team's needs change, the tests that
  earn their keep change too.

Vladimir Khorikov's "four pillars of a good test" (protection against
regressions, resistance to refactoring, fast feedback, maintainability) is a
more formal restatement of the same idea; reach for it when you want a rigorous
frame.

## What to test: the Magic Tricks (Sandi Metz)

The most actionable rules for deciding *what* a unit test should assert. Test an
object's interface, not its internals, by classifying each message:

| Message type | Definition | Test by |
|---|---|---|
| Incoming query | Returns a value, no side effect | Asserting the returned value |
| Incoming command | Causes a side effect | Asserting the direct public side effect |
| Sent to self (private) | Internal | Do not test at all |
| Outgoing query | You send it, no side effect on others | Ignore (it is the receiver's incoming query) |
| Outgoing command | You send it, causes a side effect elsewhere | Expecting it was sent (a mock) |

Rules of thumb: **test the incoming and the outgoing commands; ignore the
rest.** Never test private methods directly - if you feel you must, it is a sign
the object wants splitting. Assert on messages at the object's boundary, so
tests survive refactoring of the guts.

## Listen to the tests (GOOS, Freeman and Pryce)

*Growing Object-Oriented Software, Guided by Tests* turns factor 4 into a
practice: **test pain is design feedback.** If a test needs a huge fixture, deep
mock chains, or many collaborators just to run, the object under test is telling
you it has too many dependencies, is doing too much, or is missing a
collaborator to talk to. Fix the design, not the test.

- **Outside-in TDD** - start from the outermost behaviour you want (an
  acceptance test), and let the objects and their roles emerge as you drive
  inward. Discover interfaces by using them from the test first.
- **Mock roles, not objects** - mock the interface a collaborator plays, not a
  concrete class, so the test documents a genuine seam in the design.
- Only mock types you own; wrap third-party APIs behind your own interface
  (ports and adapters) and mock that.

## Test doubles and the mockist / classicist choice

Fowler's "Mocks Aren't Stubs" gives the vocabulary and the debate.

**The five doubles (Meszaros):**
- **Dummy** - passed but never used, just to fill a signature.
- **Stub** - returns canned answers to calls made during the test.
- **Spy** - a stub that also records how it was called.
- **Mock** - pre-programmed with expectations; verification is the assertion.
- **Fake** - a working but simplified implementation (e.g. an in-memory repo).

**Two schools:**
- **Classicist / Detroit / sociable** - use real collaborators where cheap; test
  a cluster through its outermost object; double only awkward dependencies
  (network, time, randomness). Fewer doubles, tests survive internal
  refactoring, but failures localise less precisely.
- **Mockist / London / solitary** - isolate the unit and double every
  collaborator. Failures pinpoint the class, and it drives interface discovery
  (GOOS), but tests couple tightly to the interaction and can ossify.

Default to the classicist style for internal logic (it protects refactoring),
and reach for mockist isolation at genuine seams and outgoing commands. Double
what is slow, non-deterministic, or has real side effects; use the real thing
otherwise.

## Test smells (Meszaros)

Tests rot in recognisable ways; naming the smell points to the cure.

- **Fragile Test** - breaks on unrelated changes. Usually over-mocking or
  asserting on internals; assert on behaviour at the boundary instead.
- **Obscure Test** - the reader cannot tell what is being verified. Extract
  setup, name things, use the four-phase shape (arrange, act, assert, teardown).
- **Mystery Guest** - the test depends on external data not visible in the test.
  Make the relevant fixture explicit and local.
- **Test Code Duplication** - the same setup copy-pasted. Extract helpers or
  factories, but keep each test's intent readable.
- **Erratic / Flaky Test** - passes and fails non-deterministically. Remove
  shared state, time, ordering, and network dependence.
- **Slow Test** - see the pyramid; push it down a level.

## The practical test pyramid (Fowler)

Write tests at different granularities, and **the higher the level, the fewer
you should have**.

- **Unit (broad base)** - a unit from a single method to a class, in isolation,
  fast. Test observable behaviour, not implementation detail. The bulk of the
  suite.
- **Integration (middle)** - the code working with a real external part
  (database, filesystem, another service), one integration point at a time. Use
  test doubles for third parties where sensible.
- **End-to-end / UI (narrow top)** - the whole system through its UI or API.
  Notoriously slow and flaky; reserve for a few critical user journeys.

### Principles

- **Push tests as far down the pyramid as you can.** If a lower, faster test can
  give the same confidence, prefer it.
- **Avoid the ice-cream cone** - the inverted shape (many slow e2e tests, few
  unit tests) that is slow, flaky, and hard to diagnose.
- **Do not duplicate coverage across layers.** Once a lower level proves a
  detail, do not re-assert it higher up; higher tests should cover integration
  and journeys, not logic already pinned below.
- Keep the suite fast enough that people actually run it (Mei's rough threshold:
  once it passes ~ten minutes, start speeding it up), because a suite people
  skip stops preventing regressions.

Kent C. Dodds' **Testing Trophy** is the modern counterpoint, especially in
frontend/JS: bias toward integration tests as the best confidence-per-cost, with
static analysis and types forming the base. Use it when end-to-end behaviour and
component integration matter more than isolated units.

## BDD and Given-When-Then (Cucumber and friends)

Behaviour-Driven Development (Dan North) reframes TDD around behaviour described
in domain language rather than "tests." Its scenario shape is **Given** a
context, **When** an event, **Then** an outcome. **Cucumber** makes this literal
and executable: plain-language Gherkin feature files wired to step definitions,
readable by non-developers.

This is **one option, not a default.** Given-When-Then is a convention you can
apply anywhere - it is the same shape as Arrange-Act-Assert, and RSpec's
`describe`/`context`/`it` is already BDD-flavoured - so you do not need Cucumber
or Gherkin to get its benefit. Reach for full Gherkin/Cucumber when the
readable, stakeholder-facing spec is itself valuable (shared acceptance criteria
with product or users); skip it when the step-definition layer would be pure
overhead and a plain feature spec or request spec would document the journey
just as well.

Where it fits: acceptance scenarios sit at the **top of the pyramid**, strong on
factor 1 (verify) and especially factor 3 (document), and slow. So express a few
**critical user journeys in domain language**, and push exhaustive edge cases
and logic down to faster unit and integration tests rather than enumerating them
in Gherkin.

## The design-guidance connection

Everything above points one way: if code is hard to test, the fix is usually a
design change, not a cleverer test. A fat constructor, Feature Envy, or a
missing collaborator shows up first as test pain. That is Metz's and Fowler's
advice arriving through the test suite - which is why testing lives inside
code-craft rather than beside it.

## Relation to your workflow

Your always-on TDD habit (write the failing test first, confirm it fails for the
right reason) lives in CLAUDE.md and is not repeated here. This file is the
*why* and *what-level* behind that habit.

## Further reading and other frameworks

- Sarah Mei, "Five Factor Testing" (Made in Tandem).
- Sandi Metz, "The Magic Tricks of Testing" (RailsConf talk).
- Freeman and Pryce, *Growing Object-Oriented Software, Guided by Tests*.
- Martin Fowler, "The Practical Test Pyramid" and "Mocks Aren't Stubs" -
  https://martinfowler.com/articles/practical-test-pyramid.html
- Dan North, "Introducing BDD".
- Gerard Meszaros, *xUnit Test Patterns* (test doubles and test smells).
- Vladimir Khorikov, *Unit Testing: Principles, Practices, and Patterns*.
- **F.I.R.S.T.** - Fast, Independent, Repeatable, Self-validating, Timely.
- Kent Beck, "Test Desiderata" (12 properties of a good test).
- Michael Feathers, *Working Effectively with Legacy Code* (characterization
  tests, seams).
