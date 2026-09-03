export const meta = {
  name: 'craft-review-swarm',
  description: 'Multi-agent code-craft / ui-craft review: enumerate scope, sweep one reviewer per skill reference, adversarially verify, then synthesise into a themed report',
  whenToUse: 'A whole-codebase or whole-interface review that is too broad for one pass. Fans out one reviewer per skill reference file, verifies each finding, and clusters the survivors into themes.',
  phases: [
    { title: 'Scope', detail: 'enumerate in-scope files, split by role, and discover the skill references' },
    { title: 'Review', detail: 'one agent per skill reference, each sweeping the whole scope' },
    { title: 'Verify', detail: 'adversarially verify each finding against the real code' },
    { title: 'Synthesise', detail: 'cluster confirmed findings into a themed, ranked report' },
  ],
}

// ---- Parameters (pass via the Workflow `args` input); defaults shown ----
//   lens:    'both'         // 'code' | 'ui' | 'both' - which skill(s) to apply
//   scope:   '.'            // path to review; the repo root by default. The Scope agent
//                           // narrows this to reviewable source, skipping vendored,
//                           // generated, and config files. Pass e.g. 'app' or 'src' to narrow.
//   depth:   'exhaustive'   // 'exhaustive' | 'headline' - how thorough each reviewer is
//   exclude: []             // reference basenames to skip; e.g. ['testing.md']
const lens = args?.lens || 'both'
const scopePath = args?.scope || '.'
const depth = args?.depth || 'exhaustive'
const excludedReferences = args?.exclude || []

// The dimensions are NOT hardcoded here: they are the skill's own reference
// files, discovered at runtime. Adding, renaming, or retuning a reference in a
// skill changes what this workflow reviews, with no edit here - so the workflow
// stays aligned with the skills by construction. reviewing.md is always treated
// as the shared protocol (read by every reviewer), never as a dimension.
//
// The skills live under ~/.claude/skills, but the workflow sandbox has no
// reliable $HOME (no Node/filesystem access) and Read won't expand ~, so the
// Scope agent (which runs with a real shell) returns $HOME and the absolute
// reference paths. No machine-specific path is embedded here.

// ---- Schemas ----
const DISCOVERY_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['home', 'codeFiles', 'uiFiles', 'codeReferences', 'uiReferences'],
  properties: {
    home: { type: 'string', description: 'absolute path of $HOME on this machine' },
    codeFiles: { type: 'array', items: { type: 'string' }, description: 'repo-relative paths of application-logic source files' },
    uiFiles: { type: 'array', items: { type: 'string' }, description: 'repo-relative paths of interface/markup/style files' },
    codeReferences: { type: 'array', items: { type: 'string' }, description: 'absolute paths of the code-craft reference .md files' },
    uiReferences: { type: 'array', items: { type: 'string' }, description: 'absolute paths of the ui-craft reference .md files' },
    stackNotes: { type: 'string', description: 'the detected language(s)/framework(s) and how files were classified' },
  },
}

const FINDINGS_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['findings'],
  properties: {
    findings: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['title', 'severity', 'term', 'file', 'line', 'description', 'fix'],
        properties: {
          title: { type: 'string' },
          severity: { type: 'string', enum: ['High', 'Medium', 'Low'] },
          term: { type: 'string', description: 'catalogue term: smell / principle / WCAG SC with level' },
          file: { type: 'string' },
          line: { type: 'string', description: 'line number or range, e.g. "42" or "40-53"' },
          description: { type: 'string' },
          fix: { type: 'string' },
        },
      },
    },
  },
}

const VERDICT_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['isReal', 'severity', 'reason'],
  properties: {
    isReal: { type: 'boolean' },
    severity: { type: 'string', enum: ['High', 'Medium', 'Low'] },
    reason: { type: 'string' },
  },
}

// ---- Prompts ----
function discoveryPrompt() {
  const emptinessRule =
    lens === 'code' ? 'uiFiles and uiReferences may be empty ([]).'
      : lens === 'ui' ? 'codeFiles and codeReferences may be empty ([]).'
        : 'Populate every array.'
  return [
    `Gather the review scope and the skill references for a craft review of this repository.`,
    ``,
    `1) Files. List every source file under "${scopePath}" (use a tool; do not guess). Detect the`,
    `   project's language(s) and framework(s), then classify each in-scope file by ROLE, adapting`,
    `   to whatever stack this repo uses (Rails, React, Django, Go, etc.):`,
    `   - uiFiles: files that define or style a user interface - templates/markup, view components,`,
    `     client-side view logic, and stylesheets (e.g. .erb/.html/.jsx/.tsx/.vue/.svelte/.css/.scss,`,
    `     or this stack's equivalents).`,
    `   - codeFiles: application and business logic - the other source you would review for design`,
    `     quality (models, controllers, services, domain logic, and so on).`,
    `   Put each in-scope path (repo-relative) in exactly one array. Omit vendored, generated, and`,
    `   dependency files. ${emptinessRule}`,
    ``,
    `2) Home. Return $HOME in "home" (run: printf '%s' "$HOME").`,
    ``,
    `3) Skill references. The craft skills live under $HOME/.claude/skills. List the reference`,
    `   checklists (use a tool): return absolute paths to every .md under`,
    `   code-craft/references in "codeReferences", and every .md under ui-craft/references in`,
    `   "uiReferences" (return [] for a lens not in use for this run).`,
    ``,
    `Your response IS the data, not a message to a human.`,
  ].join('\n')
}

function reviewPrompt(reviewUnit) {
  if (!reviewUnit.files.length) {
    return `There are no in-scope files for the ${reviewUnit.lensName} lens, so there is nothing to review. Return an empty findings array.`
  }

  const depthLine = depth === 'exhaustive'
    ? 'Be exhaustive within your reference file\'s concerns.'
    : 'Report only high-confidence, higher-severity findings.'
  return [
    `You are a reviewer applying the ${reviewUnit.lensName} lens. Your assigned checklist is ONE`,
    `reference file; other reviewers cover the others.`,
    ``,
    `Read, in order (absolute paths):`,
    `1. ${reviewUnit.skillDoc} - how this lens works and how to cite sources.`,
    `2. ${reviewUnit.sharedProtocol} - the shared review protocol: enumerate the scope, sweep the`,
    `   WHOLE scope (not file by file), run the lens's orthogonal passes, and cluster into themes.`,
    `3. ${reviewUnit.dimensions} - the ${reviewUnit.lensName} dimensions that need a whole-scope sweep.`,
    `4. ${reviewUnit.reference} - YOUR dimension. Review only for the issues this file describes.`,
    ``,
    `Then review these in-scope files (repo-relative paths):`,
    reviewUnit.files.map((filePath) => `- ${filePath}`).join('\n'),
    ``,
    `Sweep the whole set for the issues your reference file covers; stay within its concerns. ${depthLine}`,
    `For each finding give a precise file:line, the catalogue term (smell / principle / WCAG success`,
    `criterion with its level), a one-line description, a concrete fix, and a severity (High/Medium/Low).`,
    `If your dimension is clean, return an empty findings array. Do not invent problems to look thorough.`,
    `Your response IS the data.`,
  ].join('\n')
}

function verifyPrompt(finding, reviewUnit) {
  return [
    `Adversarially verify this ${reviewUnit.lensName} finding. Open the cited file and check the`,
    `actual code or markup.`,
    ``,
    `Finding: [${finding.severity}] ${finding.title}`,
    `Location: ${finding.file}:${finding.line}`,
    `Term: ${finding.term}`,
    `Claim: ${finding.description}`,
    `Proposed fix: ${finding.fix}`,
    ``,
    `Decide: is it REAL (the problem genuinely exists at that location, as described)? Default to`,
    `isReal=false if the citation is wrong, the code already handles it, or the claim is speculative.`,
    `Judge whether the severity is right (adjust it if not) and confirm the file:line. Your response`,
    `IS the data.`,
  ].join('\n')
}

function synthesisPrompt(confirmedFindings, concentration) {
  const pivotBlock = concentration.length
    ? [
        ``,
        `Findings pivoted by file. A file cited across several DIFFERENT dimensions is a`,
        `candidate structural root cause (a God Object / Divergent Change; for UI an`,
        `overloaded partial or layout) that theme-clustering misses, because its symptoms`,
        `are dissimilar:`,
        ...concentration.map((e) =>
          `- ${e.file}: ${e.count} findings across ${e.dimensions.length} dimensions (${e.dimensions.join(', ')})`),
      ].join('\n')
    : ''
  return [
    `You are synthesising a ${lens} review of "${scopePath}" from these verified findings (JSON):`,
    ``,
    JSON.stringify(confirmedFindings, null, 2),
    pivotBlock,
    ``,
    `Produce a Markdown review that:`,
    `- opens with a one-paragraph verdict and a severity count (High / Medium / Low),`,
    `- credits what already works (a dimension with no findings is a signal), but falsifies each credit against its siblings/counterexamples before stating it and scopes it to what was checked,`,
    `- clusters the findings into a few recurring THEMES, each with its instances as file:line,`,
    `- THEN pivots by subject: for any file above cited across 3+ dimensions (or fewer with clear`,
    `  shared ownership), name that file ITSELF as a structural root-cause finding - even though no`,
    `  single reviewer raised it - and list which theme-findings it absorbs. Weight by dimension`,
    `  diversity, not raw count.`,
    `- ranks by impact, with accessibility and security blockers first,`,
    `- ends with a short "if you do N things" ROI list, ordered so a single root-cause fix that`,
    `  dissolves several findings ranks first.`,
    `Cite sources (smell / principle / WCAG SC). Do not list every finding twice. Return only the Markdown.`,
  ].join('\n')
}

// Pivot confirmed findings by the file they touch. A file cited by findings
// across several DIFFERENT dimensions is a candidate structural root cause (God
// Object / Divergent Change; for UI, an overloaded partial or layout) that
// theme-clustering cannot see, because its symptoms are dissimilar and scatter
// across themes. Computed deterministically so the synthesis agent can't skip
// it. Weighted by dimension diversity, not raw count.
function concentrationByFile(findings) {
  const byFile = {}
  for (const finding of findings) {
    const entry = (byFile[finding.file] ||= { count: 0, dimensions: new Set() })
    entry.count += 1
    if (finding.dimension) entry.dimensions.add(finding.dimension)
  }
  return Object.entries(byFile)
    .map(([file, e]) => ({ file, count: e.count, dimensions: [...e.dimensions] }))
    .filter((e) => e.dimensions.length >= 2)
    .sort((a, b) => b.dimensions.length - a.dimensions.length || b.count - a.count)
}

// Deterministic full-findings document, rendered in JS (not by an agent) so it
// is guaranteed complete: every confirmed finding, with its verifier verdict.
// The synthesis agent writes the shorter themed summary; this renders the long
// form. Both are returned as ready-to-save, unstyled Markdown.
function renderFindingsMarkdown(findings) {
  const rank = (map, key) => (map[key] === undefined ? 9 : map[key])
  const sevRank = { High: 0, Medium: 1, Low: 2 }
  const lensRank = { 'code-craft': 0, 'ui-craft': 1 }
  const prefix = { 'code-craft': 'C', 'ui-craft': 'U' }
  const lensLabel = { 'code-craft': 'Code-craft findings', 'ui-craft': 'UI-craft findings' }

  const sorted = [...findings].sort((a, b) =>
    rank(lensRank, a.lens) - rank(lensRank, b.lens) ||
    rank(sevRank, a.severity) - rank(sevRank, b.severity) ||
    (a.dimension || '').localeCompare(b.dimension || ''))

  const tally = (pick) => findings.reduce((acc, finding) => {
    const key = pick(finding)
    acc[key] = (acc[key] || 0) + 1
    return acc
  }, {})
  const sev = tally((finding) => finding.severity)
  const byLens = tally((finding) => finding.lens)

  const out = [
    `# Code and UI craft review: \`${scopePath}\` - all findings`,
    ``,
    `_${findings.length} findings, each adversarially verified against the real code. ` +
      `Severity: ${sev.High || 0} High / ${sev.Medium || 0} Medium / ${sev.Low || 0} Low. ` +
      `Lens: ${byLens['code-craft'] || 0} code-craft / ${byLens['ui-craft'] || 0} ui-craft._`,
    ``,
    `Grouped by lens, then ordered by severity. Each entry gives the reviewer's finding ` +
      `(principle, location, description, fix) and the independent verifier's verdict.`,
  ]

  // Subject-pivot: files touched by findings across more than one dimension.
  // A file spanning several dimensions is a candidate structural root cause that
  // theme-clustering does not surface, because its symptoms are dissimilar.
  const concentration = concentrationByFile(findings)
  if (concentration.length) {
    out.push(``, `---`, ``, `## Findings by subject`, ``,
      `Files cited by findings across more than one dimension. A file spanning several ` +
      `dimensions is a candidate structural root cause (God Object / Divergent Change; for a ` +
      `shared partial or layout, an overloaded component) that theme-clustering does not surface, ` +
      `because its symptoms are dissimilar. Weight by dimension count, not raw total.`, ``)
    for (const entry of concentration) {
      out.push(`- \`${entry.file}\` - ${entry.count} findings across ${entry.dimensions.length} ` +
        `dimensions (${entry.dimensions.join(', ')})`)
    }
  }

  let currentLens = null
  const counters = {}
  for (const finding of sorted) {
    if (finding.lens !== currentLens) {
      currentLens = finding.lens
      const count = sorted.filter((other) => other.lens === finding.lens).length
      out.push(``, `---`, ``, `# ${lensLabel[finding.lens] || finding.lens} (${count})`)
    }
    counters[finding.lens] = (counters[finding.lens] || 0) + 1
    const id = `${prefix[finding.lens] || '?'}${counters[finding.lens]}`
    let location = `\`${finding.file}\``
    if (finding.line) location += ` - ${finding.line}`
    out.push(``, `## ${id}. ${finding.title}`, ``,
      `**${finding.severity}** · _${finding.dimension || ''}_ · ${location}`)
    if (finding.term) out.push(``, `> **Principle:** ${finding.term}`)
    out.push(``, `**Finding.** ${(finding.description || '').trim()}`)
    out.push(``, `**Fix.** ${(finding.fix || '').trim()}`)
    const verdict = finding.verdict
    if (verdict) {
      out.push(``, `**Verified** (${verdict.isReal ? 'confirmed' : 'disputed'}, ` +
        `severity ${verdict.severity || finding.severity}). ${(verdict.reason || '').trim()}`)
    }
  }
  return out.join('\n')
}

// ---- Run ----
phase('Scope')
const discovery = await agent(discoveryPrompt(), { schema: DISCOVERY_SCHEMA, label: 'discover-scope' })

const codeFiles = discovery?.codeFiles || []
const uiFiles = discovery?.uiFiles || []
const codeReferences = discovery?.codeReferences || []
const uiReferences = discovery?.uiReferences || []
log(`Scope: ${codeFiles.length} code files, ${uiFiles.length} UI files`)

// Build one review unit per reference file (reviewing.md and any excluded
// references dropped). The protocol and SKILL.md paths are derived from the same
// references directory, so no path convention is hardcoded twice.
function buildReviewUnits(lensName, referencePaths, files) {
  const reviewingDoc = referencePaths.find((referencePath) => referencePath.endsWith('/reviewing.md'))
  const skillDoc = reviewingDoc?.replace('/references/reviewing.md', '/SKILL.md')
  // The shared protocol now lives in the craft-reviewing skill, reached via
  // $HOME (returned by the Scope agent); each lens's reviewing.md holds only its
  // whole-scope sweep dimensions. Fall back to reviewing.md if home is missing.
  const sharedProtocol = discovery?.home
    ? `${discovery.home}/.claude/skills/craft-reviewing/references/protocol.md`
    : reviewingDoc
  return referencePaths
    .filter((referencePath) => {
      const basename = referencePath.split('/').pop()
      return basename !== 'reviewing.md' && !excludedReferences.includes(basename)
    })
    .map((referencePath) => ({
      lensName,
      reference: referencePath,
      name: referencePath.split('/').pop().replace(/\.md$/, ''),
      dimensions: reviewingDoc,
      sharedProtocol,
      skillDoc,
      files,
    }))
}

const reviewUnits = []
if (lens === 'code' || lens === 'both') reviewUnits.push(...buildReviewUnits('code-craft', codeReferences, codeFiles))
if (lens === 'ui' || lens === 'both') reviewUnits.push(...buildReviewUnits('ui-craft', uiReferences, uiFiles))
log(`Reviewing ${reviewUnits.length} dimensions: ${reviewUnits.map((reviewUnit) => reviewUnit.name).join(', ')}`)

// Review each dimension, then verify its findings as soon as that dimension
// finishes (pipeline - no barrier between review and verify).
const reviewedDimensions = await pipeline(
  reviewUnits,
  (reviewUnit) => agent(reviewPrompt(reviewUnit), { schema: FINDINGS_SCHEMA, phase: 'Review', label: `review:${reviewUnit.name}` }),
  (review, reviewUnit) => {
    const findings = review?.findings || []
    if (!findings.length) return []
    return parallel(findings.map((finding) => () =>
      agent(verifyPrompt(finding, reviewUnit), { schema: VERDICT_SCHEMA, phase: 'Verify', label: `verify:${reviewUnit.name}` })
        .then((verdict) => ({ ...finding, dimension: reviewUnit.name, lens: reviewUnit.lensName, verdict })),
    ))
  },
)

const confirmedFindings = reviewedDimensions
  .flat()
  .filter(Boolean)
  .filter((finding) => finding.verdict?.isReal)
  .map((finding) => ({ ...finding, severity: finding.verdict?.severity || finding.severity }))

log(`${confirmedFindings.length} findings confirmed across ${reviewUnits.length} dimensions`)

phase('Synthesise')
const concentration = concentrationByFile(confirmedFindings)
if (concentration.length) {
  const top = concentration[0]
  log(`Subject-pivot: ${top.file} cited across ${top.dimensions.length} dimensions`)
}
const report = await agent(synthesisPrompt(confirmedFindings, concentration), { label: 'synthesise' })

const findingsMarkdown = renderFindingsMarkdown(confirmedFindings)
log('Two documents are ready to save: the themed summary and the full findings.')

// The workflow sandbox cannot write files, so the caller (main loop) does the
// saving. saveInstructions tells it to OFFER saving both, as unstyled local
// Markdown at the repo root, and to ask before writing (never publish).
return {
  saveInstructions:
    'Offer to save two unstyled Markdown files to the repository root, and ask before writing ' +
    '(local files only, do not publish): craft-review-summary.md from the `summaryMarkdown` field ' +
    '(the themed synthesis) and craft-review-findings.md from the `findingsMarkdown` field (all ' +
    'confirmed findings in full).',
  lens,
  scope: scopePath,
  confirmedCount: confirmedFindings.length,
  summaryMarkdown: report,
  findingsMarkdown,
  findings: confirmedFindings,
  report,
}
