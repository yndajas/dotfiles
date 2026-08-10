# Gang of Four: design patterns

From *Design Patterns: Elements of Reusable Object-Oriented Software* (Gamma,
Helm, Johnson, Vlissides). Patterns are a shared vocabulary for recurring design
problems, not a checklist to satisfy.

## Read this before reaching for a pattern

- A pattern is a response to a **force** that exists now: behaviour that varies,
  a dependency you must invert, a construction that is getting complex, a graph
  you must traverse uniformly. No force, no pattern.
- Patterns add indirection. Indirection is a cost paid for flexibility. Only buy
  flexibility you need. Forcing a pattern is Fowler's Speculative Generality and
  the Pragmatic Programmer's over-engineering.
- The book's two maxims are still the best summary: **"program to an interface,
  not an implementation"** and **"favour object composition over class
  inheritance"**.
- Many patterns are lighter in dynamic languages. In Ruby, blocks/procs replace
  much of Strategy, Command, and Template Method; duck typing removes the need
  for explicit abstract types. Reach for the intent, not the C++/Java ceremony.

## The 23 patterns by intent

### Creational - how objects get made

- **Factory Method** - defer which class to instantiate to a subclass/override.
  Force: a class can't anticipate the concrete type it must create.
- **Abstract Factory** - create families of related objects without naming
  concretes. Force: the product set must swap as a group (e.g. per platform).
- **Builder** - assemble a complex object step by step. Force: many optional
  parts, or the same construction should yield different representations. Cures
  Long Parameter List in constructors.
- **Prototype** - create by cloning an existing instance. Force: instantiation
  is expensive or configured at runtime.
- **Singleton** - one instance, global access. Use sparingly; it is global
  state and hurts testability. Often a smell in disguise.

### Structural - how objects are composed

- **Adapter** - make an incompatible interface fit an expected one. Force:
  reusing a class whose interface you cannot change.
- **Decorator** - add responsibilities to an object dynamically by wrapping.
  Force: optional, combinable behaviours without a subclass explosion.
- **Facade** - one simple interface over a complex subsystem. Force: callers
  drowning in a subsystem's detail. Pairs with Metz's thin-controller aim.
- **Composite** - treat individual objects and compositions uniformly. Force: a
  part-whole tree the client should walk without special-casing leaves.
- **Proxy** - a stand-in controlling access (lazy load, caching, remote, auth).
- **Bridge** - separate an abstraction from its implementation so both vary
  independently. Force: a class hierarchy exploding along two dimensions.
- **Flyweight** - share fine-grained objects to save memory. Rarely needed;
  performance-specific.

### Behavioural - how objects interact and share responsibility

- **Strategy** - encapsulate interchangeable algorithms behind one interface.
  Force: behaviour varies and you keep writing conditionals to switch it. The
  usual cure for Switch Statements. In Ruby, often just a passed block/callable.
- **Observer** - notify dependents when state changes. Force: many objects must
  react to one object's changes without it knowing them (pub/sub, callbacks).
- **Command** - wrap a request as an object. Force: you need to queue, log,
  undo, or parameterise actions (service objects, jobs, interactors).
- **Template Method** - fix an algorithm's skeleton, let subclasses fill steps.
  Force: several variants share a stable overall flow.
- **State** - let an object change behaviour when its internal state changes.
  Force: sprawling conditionals on a status field driving behaviour.
- **Iterator** - traverse a collection without exposing its structure. Mostly
  built into languages (Ruby's Enumerable).
- **Chain of Responsibility** - pass a request along handlers until one takes it
  (middleware pipelines).
- **Mediator** - centralise complex many-to-many communication in one object.
- **Memento** - capture and restore an object's state without breaking
  encapsulation (undo, snapshots).
- **Visitor** - add operations to an object structure without changing its
  classes. Force: stable class hierarchy, frequently added operations. Heavy;
  use only when that trade-off is real.
- **Interpreter** - represent and evaluate a simple grammar. Niche.

## Choosing between the common ones

- Varying algorithm behind one call -> **Strategy**.
- Conditionals on a status/type that drive behaviour -> **State** or
  **Replace Conditional with Polymorphism** (Fowler) first.
- Optional, stackable enhancements -> **Decorator**, not subclasses.
- Taming a messy subsystem for callers -> **Facade**.
- Actions you must queue/undo/log -> **Command**.
- Complex construction with many options -> **Builder**.
- Fitting a class you cannot modify -> **Adapter**.

If two patterns seem to fit, pick the one that removes the most present
complexity with the least indirection, and name the force it addresses.

## Further reading

- Refactoring Guru - design patterns catalogue with diagrams and per-language
  examples: https://refactoring.guru/design-patterns
