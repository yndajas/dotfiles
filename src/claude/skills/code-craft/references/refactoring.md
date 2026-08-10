# Martin Fowler: refactoring and code smells

From *Refactoring: Improving the Design of Existing Code* (2nd edition).
Language-agnostic.

## The discipline

Refactoring is improving the internal structure of code **without changing its
observable behaviour**. It is not rewriting.

- Work in **small, behaviour-preserving steps**.
- **Run the tests between every step.** If there is no test coverage, add it
  before refactoring, or refactor only under the compiler's protection using
  the most mechanical steps.
- Never refactor and change behaviour in the same step.
- Refactoring is **opportunistic** - done in small doses as part of everyday
  work, to make a needed change easier ("first make the change easy, then make
  the easy change"), not as a separate grand-redesign phase.
- **Economics, not aesthetics.** Favour the smallest refactoring that removes
  the obstacle in front of you.

## Code smells (Fowler's catalogue, grouped)

A smell is a surface indication of a deeper problem. Naming it points to the
cure.

**Bloaters** - things that have grown too big.
- Long Method, Large Class, Primitive Obsession (using primitives instead of
  small objects), Long Parameter List, Data Clumps (the same group of fields
  travelling together).

**Object-orientation abusers** - OO applied incompletely.
- Switch Statements (type-based conditionals begging for polymorphism),
  Temporary Field, Refused Bequest (a subclass ignoring inherited behaviour),
  Alternative Classes with Different Interfaces.

**Change preventers** - one change forces many edits.
- Divergent Change (one class changed for many different reasons), Shotgun
  Surgery (one change scattered across many classes), Parallel Inheritance
  Hierarchies.

**Dispensables** - things adding no value.
- Comments (often deodorant for bad code), Duplicated Code, Dead Code, Lazy
  Class, Speculative Generality (abstraction for a future that never came),
  Data Class.

**Couplers** - excessive coupling.
- Feature Envy (a method more interested in another class's data), Inappropriate
  Intimacy, Message Chains (`a.b().c().d()`), Middle Man (a class that only
  delegates), Insider Trading.

## Smell to refactoring

- Duplicated Code -> Extract Function/Method, Pull Up Method.
- Long Method -> Extract Function, Replace Temp with Query, Decompose
  Conditional, Replace Nested Conditional with Guard Clauses.
- Long Parameter List / Data Clumps -> Introduce Parameter Object, Preserve
  Whole Object, Replace Parameter with Query.
- Large Class -> Extract Class, Extract Superclass, Replace Type Code with
  Subclasses/State/Strategy.
- Switch on type -> Replace Conditional with Polymorphism.
- Feature Envy -> Move Function/Field.
- Message Chains -> Hide Delegate, Extract Function.
- Primitive Obsession -> Replace Primitive with Object, Replace Type Code with
  Class.

## Core mechanics worth knowing

- **Extract Function** - name a fragment by its intent; the strongest, most-used
  move. Prefer intent-revealing names over implementation-revealing ones.
- **Inline Function/Variable** - when the indirection no longer earns its keep.
- **Rename** - a rename is a real refactoring; good names are the cheapest
  documentation.
- **Replace Conditional with Polymorphism** - when behaviour varies by type.
- **Introduce Parameter Object** - turn a recurring data clump into a type.
- **Replace Temp with Query** - extract the computation behind a temp so it can
  be reused and named.

## When *not* to refactor

- When you need to rewrite from scratch, or the code is about to be deleted.
- When you are mid behaviour-change: finish that, then refactor separately.
- When there are no tests and you cannot add them and the change is risky:
  characterise behaviour first.
- When "ugly but stable and untouched" code is not blocking the current change.
  Refactor code you are about to work in, not everything you can see.

## Further reading

- Refactoring Guru - refactoring catalogue and smells (illustrated):
  https://refactoring.guru/refactoring
- thoughtbot, *Ruby Science* - Ruby/Rails-specific smells and cures (fat models,
  callbacks, view logic, Rails anti-patterns):
  https://thoughtbot.com/ruby-science
