# Literature Review Log

This file turns the positioning checklist into concrete source-backed review tasks.

Each task should end with at least one real citation and a short note about whether the source changes AdicFlux wording or comparisons.

## Active review tasks

### Task 1: Odd-even transposition / brick sort baseline

Status: active

Questions:

- What standard references are appropriate for the exact cleanup stage?
- What stability and worst-case guarantees are standard for that family?
- Which parts of AdicFlux exactness reduce directly to this background?

Capture:

- citation:
- result/theorem:
- overlap with AdicFlux:
- wording impact:

### Task 2: Local-exchange or cellular sorting processes

Status: active

Questions:

- Are there prior sorting schemes driven by neighborhood interactions or local drift?
- Do those methods define an explicit energy or acceptance criterion?
- Are they exact by themselves or paired with a fallback stage?

Capture:

- citation:
- family/category:
- strongest similarity:
- strongest difference:
- wording impact:

### Task 3: Bit-structured integer sorting outside radix framing

Status: active

Questions:

- Which methods inspect bit structure without following classic radix passes?
- Are any of them comparison-based or energy-based rather than counting-based?
- Do any use valuation-like or bit-closeness ideas relevant to AdicFlux wording?

Capture:

- citation:
- bit-structure role:
- overlap with AdicFlux:
- wording impact:

### Task 4: Stability proof techniques for local permutations

Status: active

Questions:

- What proof patterns exist for stable local movement or stable transposition systems?
- Can any of them transfer to AdicFlux transport acceptance?
- Do they suggest stronger or narrower wording for current stability claims?

Capture:

- citation:
- proof technique:
- possible transfer to AdicFlux:
- wording impact:

## Exit criteria for stronger positioning language

- every active task above has at least one concrete source recorded,
- any novelty-sensitive wording in `README.md` or `docs/positioning.md` has been reviewed against those notes,
- unresolved overlap questions are explicitly listed instead of silently ignored.
