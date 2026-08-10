# Sandi Metz: object-oriented design

From *Practical Object-Oriented Design in Ruby* (POODR), *99 Bottles of OOP*,
and her "rules". Ruby-flavoured, but the intent generalises: small, focused,
loosely-coupled objects that are cheap to change.

## The four rules

Heuristics, not laws. They provoke better design by making bad design
uncomfortable. Break one only with a stated reason.

1. **A class can be no longer than 100 lines of code.**
2. **A method can be no longer than 5 lines of code.**
3. **Pass no more than 4 parameters into a method.** Hash options count.
4. **Controllers can instantiate only one object; views know only one instance
   variable.** (Rails-specific. The general form: keep the boundary between HTTP
   and the domain thin.)

Some formulations add: **no more than 4 instance variables** in a class.

### Counting precisely

- **Class/method lines**: count lines of actual code. Exclude blank lines,
  comments, the `def`/`class` line, and `end`.
- **Parameters**: count all explicit params including keyword args; `&block`
  does not count; defaults still count.

### Prioritising violations

- High: classes over 200 lines, methods over 10 lines, 6+ params, controllers
  carrying business logic.
- Medium: classes 100-200, methods 5-10, 5 params.
- Low: borderline cases; violations in migrations, routes, DSLs, config, or
  tests, where the rules often should be broken.

## The refactorings the rules push you toward

- **Long class** - extract a collaborator with its own responsibility (SRP);
  use composition or a module. Candidate patterns: Strategy, Decorator, Command,
  Facade.
- **Long method** - extract well-named sub-methods at one level of abstraction
  (Composed Method); guard clauses to flatten nesting; replace conditional with
  polymorphism.
- **Too many parameters** - introduce a Parameter Object for related args; move
  the method to the class that owns the data.
- **Fat controller** - extract a service object, use case, or interactor; move
  domain logic out of the HTTP layer.

## The design principles underneath the rules

The rules are the surface; POODR's real content is managing dependencies.

- **Single Responsibility** - a class should have one reason to change. Test:
  can you describe it in one sentence without "and"?
- **Depend on abstractions, not concretions** - inject dependencies; isolate the
  things most likely to change. Ask "what does this message need?" not "what
  class is this?".
- **Law of Demeter** - talk to your immediate collaborators, not their innards.
  `a.b.c.d` is a design smell; it couples you to a whole object graph.
- **Tell, Don't Ask** - send an object a message describing intent; let it
  decide how. Avoid pulling data out to make decisions the object should make.
- **Duck typing** - depend on what an object *does*, not what it *is*. Replace
  type-checking conditionals (`case obj.class`) with a shared message.
- **Prefer composition over inheritance** - inheritance is for genuine is-a
  specialisation only. Reach for composition (has-a) by default; it is easier to
  rearrange. Use inheritance when subclasses are true refinements sharing a
  stable interface.

## When to break the rules

Config, routes, migrations, generated code, DSLs, and tests are legitimate
exceptions. The overriding test is clarity: if following a rule makes the code
harder to understand, the rule loses. Always say *why* a violation is
acceptable rather than silently ignoring it.

## Enforcement

RuboCop `Metrics/ClassLength` (100), `Metrics/MethodLength` (5),
`Metrics/ParameterLists` (4). Reek for smells (LongMethod, LargeClass,
LongParameterList, FeatureEnvy). flog for complexity, flay for duplication.
