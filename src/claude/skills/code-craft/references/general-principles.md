# General engineering principles

Distilled from *The Pragmatic Programmer* (Hunt and Thomas) and *Code Complete*
(McConnell). Language-agnostic construction wisdom that sits underneath the more
specific lenses. Cite the source when you apply one.

## The Pragmatic Programmer

- **DRY - Don't Repeat Yourself.** Every piece of knowledge has one
  authoritative representation. DRY is about knowledge, not text: two identical
  lines that encode different decisions are not a violation; two different lines
  encoding the same decision are.
- **Orthogonality.** Keep unrelated things independent so a change in one place
  does not ripple. Decoupled components can be changed, tested, and reasoned
  about in isolation.
- **Reversibility.** Avoid decisions that are hard to undo; keep the design
  flexible about databases, vendors, and frameworks where the cost is low.
- **Tracer bullets.** Build a thin, end-to-end, working slice first, then flesh
  it out. Distinct from a prototype, which is throwaway.
- **Prototype to learn.** When exploring the unknown, build something disposable
  to answer the question, then discard it.
- **Don't live with broken windows.** Fix small problems (bad names, dead code,
  a failing test) as you see them; neglect signals that neglect is acceptable.
- **Design by Contract.** Be explicit about preconditions, postconditions, and
  invariants.
- **Crash early.** A dead program does less damage than a crippled one; fail
  fast and loudly rather than limping on with bad state.
- **Assertive programming.** Use assertions to state things that can never
  happen; if they can happen, handle them as errors instead.
- **Decoupling and the Law of Demeter.** Minimise what each module needs to know
  about others.
- **Configure, don't integrate.** Put changeable details in metadata/config, not
  hard-coded in logic.
- **"Good enough" software.** Involve users in the quality trade-off; know when
  more polish stops paying. Ship deliberately, not perfectionistically.
- **Estimate to avoid surprises.** Give ranges, track how estimates diverge from
  reality, and refine.

## Code Complete

- **Manage complexity.** The primary technical imperative. Every technique
  (routines, modules, abstraction, information hiding) exists to reduce the
  amount a reader must hold in their head at once.
- **Information hiding.** Design modules around a secret - a design decision
  likely to change - and hide it behind a stable interface.
- **Name well.** Names should describe the thing fully and unambiguously.
  Variables named for their meaning, not their type; routines named for what
  they return (functions) or what they do (procedures). Avoid abbreviations that
  save keystrokes and cost comprehension.
- **Strong cohesion.** A routine should do one thing completely; a class should
  group things that genuinely belong together (functional cohesion is the goal).
- **Loose coupling.** Minimise and simplify the connections between modules;
  prefer passing exactly what is needed.
- **Defensive programming.** Validate inputs at boundaries, decide barricade
  points beyond which data is trusted, and handle the errors you can while
  crashing early on the ones you cannot.
- **Pseudocode Programming Process.** Write a routine's intent in precise
  pseudocode first; refine it into comments and code. The pseudocode that
  survives becomes the documentation.
- **Table-driven methods.** Replace complicated conditional logic with a lookup
  when the branches are really data.
- **Keep routines small and single-purpose,** but let cohesion, not an arbitrary
  line count, be the deciding measure.
- **Refactor as construction, not repair.** Improve structure continuously as
  understanding grows; treat code as always in draft.
- **Programming into a language, not in it.** Let the design lead; do not let a
  language's limits shrink your thinking.

## How these interact with the specific lenses

These principles agree with Metz and Fowler far more than they conflict: DRY and
cohesion motivate Extract Function; information hiding and orthogonality
motivate dependency injection and the Law of Demeter; managing complexity is the
reason to keep classes and methods small. When a specific rule (e.g. Metz's
five-line method) seems to fight readability, fall back to the general
imperative - minimise complexity for the reader - and let that break the tie.
