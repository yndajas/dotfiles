# Design principles: SOLID, connascence, module depth

SOLID is a widely-used acronym (coined by Michael Feathers) collecting five
object-oriented design principles about managing dependencies so code is easier
to change. The substance predates the acronym; each is attributed to its source
below. Treat them as heuristics, not laws, and apply them to remove a real
problem, not pre-emptively (YAGNI, KISS).

## The five principles

### S - Single Responsibility

A class should have one reason to change. This is *cohesion* from structured
design (Constantine, Yourdon, DeMarco): group what changes together, separate
what changes for different reasons. Test: can you describe the class in one
sentence without "and"? Metz teaches the same idea - see
`object-oriented-design.md`. The Fowler smells it cures are Divergent Change and
Large Class.

### O - Open/Closed (Bertrand Meyer, 1988)

Software entities should be open for extension but closed for modification: you
should be able to add behaviour without editing existing, working code. Achieve
it with polymorphism behind a stable abstraction, so a new case is a new class
rather than another branch in a `case` statement (this is the Strategy and
State patterns in `design-patterns.md`). Caveat: do not build the abstraction
speculatively. Wait until a real axis of variation appears - the first time you
would edit existing code to add a case is the signal to make it open/closed
there.

### L - Liskov Substitution (Barbara Liskov, 1987; Liskov and Wing, 1994)

A subtype must be usable anywhere its supertype is expected, without surprising
the caller. Concretely, an override must not strengthen preconditions or weaken
postconditions, must honour the base type's invariants, and must not throw where
the base does not. A subclass that overrides an inherited method to raise
"not supported" violates LSP - and is Fowler's Refused Bequest smell. When a
subtype cannot honour the contract, prefer composition over inheritance (see
`object-oriented-design.md`).

### I - Interface Segregation

Clients should not be forced to depend on methods they do not use. Prefer
several small, role-specific interfaces over one fat general-purpose one, so a
change to one role does not ripple to unrelated clients. This is interface
cohesion, and relates to Fowler's "role interfaces". In a duck-typed language
like Ruby there is no `interface` keyword, so the principle becomes: keep the
*role* an object depends on narrow - depend on the few messages you actually
send, not on a large concrete class.

### D - Dependency Inversion

High-level policy should not depend on low-level detail; both should depend on
an abstraction. In practice: depend on an interface or injected collaborator,
not a hard-coded concrete class. This is GoF's "program to an interface, not an
implementation" and Fowler's Inversion of Control / Dependency Injection, and it
is the dependency-management heart of Metz's POODR
(`object-oriented-design.md`). It is what lets you substitute a test double, or
swap an implementation, without touching the policy.

## Connascence: a finer lens on coupling

Connascence (Meilir Page-Jones; popularised in the Ruby community by Jim
Weirich) is a vocabulary for *kinds* and *strength* of coupling, more precise
than "coupling bad" or even the Law of Demeter. Two components are connascent if
changing one requires changing the other to keep the system correct.

**Static kinds** (visible in the code), roughly weakest to strongest:
- **Name** - agree on a name (a method name). Weakest and unavoidable.
- **Type** - agree on a type.
- **Meaning** - agree on the meaning of a value (e.g. `true` means admin).
- **Position** - agree on order (positional arguments).
- **Algorithm** - agree on an algorithm (both sides must hash the same way).

**Dynamic kinds** (only at runtime), generally stronger and worse:
- **Execution** (order of calls matters), **Timing**, **Value** (values must
  change together), **Identity** (must reference the same instance).

**Three rules of thumb:**
1. **Minimise** overall connascence (reduce coupling).
2. **Prefer weaker forms** - e.g. replace connascence of Position (positional
   args) with connascence of Name (keyword arguments or a parameter object).
3. **Keep strong connascence local** - strong coupling within one class is
   tolerable; the same coupling across module boundaries is not.

Connascence is the most actionable way to *rank* coupling problems in review.

## Module depth: the counter-tension (John Ousterhout)

*A Philosophy of Software Design* frames the goal as **reducing complexity**,
and warns against over-decomposition. Its key idea, **deep modules**, is a
useful counterweight to Metz's very small methods:

- A **deep module** has a simple interface hiding a substantial implementation -
  high value for low interface cost. A **shallow module** exposes almost as much
  as it hides, so splitting it adds interface overhead without hiding much.
- "Classitis" - reflexively chopping code into many tiny classes and methods -
  can *increase* total complexity, because each boundary is another interface to
  learn. Small is good until the cost of an extra interface exceeds the benefit
  of the split.
- So hold Metz's five-line rule and Ousterhout's depth together: extract to name
  a concept and cut duplication, but not past the point where the fragments are
  harder to follow than the whole. Judge by reader complexity, not line count.
- Related Ousterhout ideas worth applying: **information hiding** (a module's
  job is to hide a design decision), **define errors out of existence**
  (design APIs so exceptional cases cannot arise), and **strategic over
  tactical** (invest a little in design as you go rather than only ever
  bolting on the next feature).

## Model so illegal states are unrepresentable

Data-structure and type choices are design decisions about *correctness and
clarity*, not only performance. Choose the representation that makes the problem
obvious and makes bad states hard or impossible to construct (type-driven
design; Scott Wlaschin, *Domain Modeling Made Functional*, and Alexis King's
"parse, don't validate"):

- Replace bare primitives with **value objects** that carry their own rules (a
  `Money`, an `EmailAddress`) - the cure for Fowler's Primitive Obsession and a
  core Metz move (`refactoring.md`, `object-oriented-design.md`).
- Prefer a **closed set** (an enum, or a small set of subclasses) over free-form
  strings or boolean flags when the valid values are fixed.
- Pick the structure that matches the access pattern **and expresses intent** -
  a `Set` for uniqueness, a `Hash` for a mapping - so the structure itself
  documents the constraint.
- The aim: if a state should never occur, make the code unable to represent it,
  rather than guarding against it at every call site. This removes whole classes
  of bug and defensive checks (validate once at the boundary, then trust the
  type).

## How this fits the rest of code-craft

- SRP and DIP are the principled statement of what `object-oriented-design.md`
  teaches.
- OCP, ISP, and DIP are why the `design-patterns.md` patterns exist (Strategy,
  Decorator, and the rest are ways to be open/closed and depend on
  abstractions).
- Connascence refines the coupling smells in `refactoring.md` into a ranking.
- Ousterhout's depth keeps the "make everything tiny" instinct honest.

## Further reading

- Bertrand Meyer, *Object-Oriented Software Construction* (Open/Closed).
- Barbara Liskov and Jeannette Wing, "A Behavioral Notion of Subtyping" (1994).
- Meilir Page-Jones, *What Every Programmer Should Know About Object-Oriented
  Design*; https://connascence.io for a concise catalogue.
- John Ousterhout, *A Philosophy of Software Design*.
