# Security

Grounded in the OWASP Top Ten and OWASP ASVS, the CWE catalogue for the specific
weaknesses, and the secure-design principles of Saltzer and Schroeder (1975).
Security is a **design concern first**: most of it is decided while architecting
and while writing the code (parameterise as you build the query, default to deny
as you design the access rule), and it is *also* a distinct lens when reviewing,
because the same lines that are correct and clean can still be exploitable. Like
reliability, match the control to a real threat rather than sprinkling defences
everywhere. Language-agnostic; Rails-flavoured examples where noted.

## Secure-design principles (Saltzer and Schroeder)

Reach for these when architecting - they shape the design before any specific
bug exists:

- **Least privilege** - grant the minimum access a component needs.
- **Fail-safe defaults** - default to deny; require an explicit grant. (An
  option that "fails open" to its least-safe value is a bug.)
- **Complete mediation** - check authority on every access, not once then cache.
- **Economy of mechanism** - the simplest design is the one you can actually
  secure; complexity hides holes.
- **Fail securely** - an error path must land in a safe, closed state, never an
  open one.

## Common weakness classes (a selection, not the taxonomy)

A working selection of the classes most often found by reading application code:
get them right as you write, and look for them when you review. It is
deliberately **not comprehensive**. The OWASP Top Ten is the current, versioned
category list (mappings below are to the 2021 edition, which is revised
periodically) and OWASP ASVS is the exhaustive, testable checklist - go there
for completeness rather than treating these bullets as a finish line. Classes
omitted here still apply: insecure design (A04), vulnerable/outdated components
(A06), software and data-integrity failures (A08), security logging and
monitoring failures (A09), and SSRF (A10).

- **Broken access control (A01).** Authorize every protected action, not just
  authenticate it. Load owned resources through the owner
  (`current_user.things.find`) so another user's id can't be reached (IDOR).
  Authorize *before* revealing a resource exists - a 404-for-missing but
  403-for-forbidden split is an existence oracle (CWE-203).
- **Injection (A03).** Parameterise every query; never interpolate user input
  into SQL, a shell, or a command. Know your template's output escaping: an
  autoescaping default is safe until someone reaches for `raw` / `html_safe`
  (XSS, CWE-79).
- **Identification and authentication failures (A07).** Sign-in, password-reset
  and account-lookup responses must not differ on hit vs miss, or they enumerate
  users (CWE-204). Regenerate the session on privilege change (fixation).
- **Cryptographic and sensitive-data failures (A02).** Generate tokens with a
  CSPRNG (not `rand`); never log or serialise secrets (filter sensitive params).
- **Security misconfiguration (A05).** Default-deny; ship a real Content
  Security Policy and security headers.
- **Information disclosure (CWE-200 family; surfaces under A01/A04/A05).** Error
  and log output must not leak internals (stack traces, SQL, secrets - CWE-209),
  and responses must not differ observably by timing or shape on the
  secret-bearing branch (CWE-208 / 203).

## When reviewing

Security is one of the review passes (code-craft SKILL.md): read the same files
as the correctness pass but ask "can this be abused?", not "is this right?". The
whole-scope authorization / error-path census in `craft-reviewing`'s `rigour.md`
is how you check A01 and information disclosure across every endpoint rather than
file-by-file.

## How this fits code-craft

Security pulls the same way as the rest of the lens more often than it conflicts:
least privilege and fail-safe defaults are the access-control side of Metz's and
`solid.md`'s dependency discipline, and economy of mechanism is Ousterhout's
manage-complexity by another name. Where a control genuinely adds friction,
isolate it behind a clear interface so it doesn't spread.

## Further reading

- OWASP Top Ten - https://owasp.org/www-project-top-ten/
- OWASP Application Security Verification Standard (ASVS) -
  https://owasp.org/www-project-application-security-verification-standard/
- OWASP Cheat Sheet Series - https://cheatsheetseries.owasp.org/
- Jerome Saltzer and Michael Schroeder, "The Protection of Information in
  Computer Systems" (1975) - the eight design principles.
- MITRE CWE - https://cwe.mitre.org/
