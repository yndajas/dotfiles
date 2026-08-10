# Reliability: designing for failure

Reliability is about behaving well when things go wrong - especially in services
with background jobs, queues, external APIs, and networks between them. The
techniques here are **situational design attributes**: reach for one where its
failure mode is real, not everywhere. Adding retry or circuit-breaker machinery
to a purely in-process, single-run operation is over-engineering.

## Idempotency

An operation is **idempotent** if performing it more than once has the same
effect as performing it once. Design for it wherever an operation can run or be
delivered more than once:

- background jobs and message consumers (almost all queues are *at-least-once* -
  a job will eventually run twice);
- webhooks and outbound API calls that may be retried;
- money-moving or state-changing operations where a duplicate is harmful;
- HTTP semantics - GET, PUT, and DELETE are expected to be idempotent, POST is
  not, so design endpoints accordingly.

Ways to achieve it:

- **Naturally idempotent operations** - "set status to `paid`" is safe to
  repeat; "increment balance" is not. Prefer the former where you can.
- **Idempotency keys** - the caller sends a unique request id; you record it and
  ignore or return the prior result on a repeat.
- **Upserts / find-or-create**, guarded by a **unique constraint** so a race
  cannot create duplicates (the database is the last line of defence).
- **Record processed message ids** and skip ones already handled.

## Retries and backoff

Assume transient failures (a dropped connection, a rate limit, a brief outage).

- Retry with **exponential backoff plus jitter**, and a cap on attempts, so
  retries neither hammer a struggling dependency nor synchronise into a
  thundering herd.
- **Only retry safe/idempotent operations** - retrying a non-idempotent write
  can double its effect.
- Distinguish **retryable** failures (timeouts, `5xx`, `429`) from
  **non-retryable** ones (`4xx` validation errors); do not retry a request that
  will always be rejected.

## Timeouts

- **Never make an unbounded call to anything external.** Set connect and read
  timeouts on every HTTP client, database call, and lock acquisition.
- A missing timeout is a latent outage: one slow dependency ties up your
  threads or connection pool until the whole service stalls.

## Delivery semantics

- Most queues and job systems are **at-least-once**. True **exactly-once**
  delivery is effectively a myth in distributed systems.
- So aim for **effectively-once** by making consumers **idempotent** and
  deduplicating, rather than trusting the transport to deliver exactly once.

## Failure handling and graceful degradation

- Decide, per dependency, what happens when it is down: fail fast, fall back to
  a default, degrade the feature, or queue the work for later.
- Use a **circuit breaker** for a dependency that is failing repeatedly, so you
  stop hammering it and fail fast until it recovers.
- Do not let a **non-critical** dependency take down the whole request (the
  bulkhead idea - isolate failures so one leak does not sink the ship).
- Keep failures honest: crash early on genuine programmer errors (see
  `general-principles.md`), but handle expected external failures deliberately.

## Rails and jobs specifics

- Sidekiq / Active Job **retry**, so jobs **must be idempotent**. Use a unique
  job/lock or an idempotency key; lean on a DB **unique index** as the final
  dedup guard.
- Wrap external calls (Faraday, `Net::HTTP`) with explicit **timeouts**.
- Use database **transactions** for atomicity so a partial failure does not
  leave half-applied state.
- For webhooks you receive, store and check the provider's event id to ignore
  redeliveries.

## When not to reach for this

Match the mechanism to a real failure mode. An in-process pure function does not
need an idempotency key; a synchronous call within one request does not need a
circuit breaker. Reliability machinery has a cost in complexity - spend it where
the network, retries, or repeated delivery make failure genuinely likely.

## Further reading

- Michael Nygard, *Release It!* (timeouts, circuit breakers, bulkheads, and
  other stability patterns).
- Martin Kleppmann, *Designing Data-Intensive Applications* (delivery semantics,
  consistency).
- AWS Architecture Blog, "Exponential Backoff and Jitter".
