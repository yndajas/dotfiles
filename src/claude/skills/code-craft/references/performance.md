# Performance as a design concern

Performance has two layers, and they call for opposite instincts. This file is
about the first; the second is measurement-driven and mostly handled in review.

- **Design-level performance** - algorithmic complexity, the data model, query
  patterns, data-structure choice, and where the caching and sync/async
  boundaries sit. These are *design decisions*: cheap to get right up front and
  expensive to reverse later (Fowler's reversibility). Think about them when you
  design.
- **Micro-optimisation** - hand-tuning a hot loop, shaving allocations. Local,
  low-level, and only worth doing once a profiler says so.

## The order of priorities

Make it **correct**, then **clear**, then **fast** - but do not read that as
"ignore performance until the end". The design-level choices below are part of
"clear and correct", because a design that cannot meet its performance need is
not actually correct for its job.

- **Premature optimisation is the root of all evil** (Knuth) - do not contort
  code for speed you have not measured a need for. The flip side is also true:
  do not choose a knowingly quadratic design when a linear one is no harder to
  write.
- **Measure, do not guess** (Jon Bentley, *Programming Pearls*) - before
  optimising anything below the design level, profile to find the actual hot
  spot. Intuition about where time goes is usually wrong.
- Optimise only what is both hot and measured, keep the improvement (benchmark
  before and after), and stop when it stops mattering.

## Get these right at design time

They are set by the shape of the design and painful to change afterwards:

- **Algorithmic complexity.** Know the big-O of the operation *and* the size of
  the data it will see in production. A linear scan is fine for 10 items and a
  disaster for 10 million. Watch for accidental nested iteration (O(n^2)).
- **The data model.** Schema shape, indexes, and normalisation decisions
  dominate the performance of data-heavy systems and are among the hardest
  things to change once there is live data.
- **Query patterns.** How you talk to the store, not just its structure - see
  the Rails notes below.
- **Data-structure choice.** A hash/set for membership tests instead of an array
  scan; the right structure removes whole classes of slow code.
- **Boundaries: caching, sync vs async, streaming vs loading.** Decide what work
  happens now vs in the background, what is cached and how it is invalidated,
  and whether large results are streamed rather than loaded whole. These are
  architectural seams, not tweaks.

## Rails and ActiveRecord specifics

Most Rails performance problems are design/abstraction problems in disguise:

- **N+1 queries** are the classic example - an abstraction leak, not a
  micro-issue. Use `includes`/`preload`/`eager_load`; the `bullet` gem surfaces
  them. They are frequently *triggered from the view layer*: an ordering scope
  or `.count` on an association inside a partial that renders once per row will
  re-query per row and silently defeat a controller's `includes`. A
  query-pattern sweep therefore has to read the templates, not just controllers
  and models - a Ruby-only reading passes the `includes` and never sees the
  `.ordered` that undoes it.
- **Do set work in the database, not in Ruby** - filter, count, and aggregate
  with SQL rather than loading records and looping.
- **Select only the columns you need**, and add **indexes** for the columns you
  filter and join on; consider **counter caches** for frequent counts.
- **Do not load huge collections into memory** - use `find_each`/`in_batches`.
- **Move slow or external work to background jobs**, and cache expensive
  render/compute with fragment or Russian-doll caching.

## A caveat on caching

Caching trades correctness risk for speed. Cache invalidation is genuinely hard,
so add a cache to solve a *measured* problem, keep its invalidation rules
simple, and prefer eliminating the work (a better query or index) over hiding it
behind a cache when you can.

## How this fits code-craft

Clean design and performance usually pull the same way: the coupling and
abstraction problems that `refactoring.md` and `solid.md` name are often the
same things that make code slow (an N+1 is a leaked abstraction). Where they
conflict, keep the code clear and isolate the optimised part behind a good
interface, so the speed hack does not spread.

## Further reading

- Jon Bentley, *Programming Pearls* (design-level performance thinking).
- Martin Kleppmann, *Designing Data-Intensive Applications* (for data systems at
  scale).
