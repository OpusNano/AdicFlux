# Literature Review Log

This file turns the positioning checklist into concrete source-backed review tasks.

Each task should end with at least one real citation and a short note about whether the source changes AdicFlux wording or comparisons.

## Active review tasks

### Task 1: Odd-even transposition / brick sort baseline

Status: first citations recorded

Questions:

- What standard references are appropriate for the exact cleanup stage?
- What stability and worst-case guarantees are standard for that family?
- Which parts of AdicFlux exactness reduce directly to this background?

Capture:

- citation: Nico Habermann, "Parallel Neighbor Sort (or the Glory of the Induction Principle)," Carnegie-Mellon University Computer Science Department report, 1972. Cited in the odd-even sort literature as the original parallel-neighbor presentation of odd-even transposition sorting.
- result/theorem: establishes the odd-even neighbor-transposition baseline for locally connected processors.
- overlap with AdicFlux: AdicFlux's exact cleanup stage is an odd-even adjacent compare-swap process, so its global exactness fallback belongs in this background family.
- wording impact: strengthens the repo's current wording that cleanup is not novel by itself; novelty-sensitive language should stay focused on the weighted transport proposal, not the fallback stage.

- citation: Donald E. Knuth, *The Art of Computer Programming, Volume 3: Sorting and Searching*, 2nd ed., Addison-Wesley, 1998, section on sorting networks / odd-even transposition methods.
- result/theorem: standard reference background for compare-exchange-based transposition sorting and 0-1-principle-style correctness framing.
- overlap with AdicFlux: supports the repository's use of classical compare-exchange reasoning for the exact cleanup stage and its conservative complexity discussion.
- wording impact: supports keeping the cleanup discussion framed as inherited classical machinery rather than a novel exact sorting claim.

### Task 2: Local-exchange or cellular sorting processes

Status: first citation recorded

Questions:

- Are there prior sorting schemes driven by neighborhood interactions or local drift?
- Do those methods define an explicit energy or acceptance criterion?
- Are they exact by themselves or paired with a fallback stage?

Capture:

- citation: S. Lakshmivarahan, S. K. Dhall, and L. L. Miller, "Parallel Sorting Algorithms," *Advances in Computers* 23 (1984), 295-351, doi:10.1016/S0065-2458(08)60467-2.
- family/category: survey of parallel and local-neighbor sorting methods, including odd-even style neighbor interaction schemes and merge-splitting variants.
- strongest similarity: AdicFlux transport also works through local block interactions rather than global partition/merge recursion.
- strongest difference: the current AdicFlux proposal uses a bespoke weighted energy, 2-adic closeness term, and accept-on-descent rule rather than a standard fixed local schedule.
- wording impact: justifies comparing AdicFlux to local-exchange and neighbor-driven sorting families, while still leaving the specific weighted transport mechanism described as an experimental proposal.

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

## Current wording impact summary

- The exact cleanup stage should continue to be described as classical odd-even transposition-style machinery used as a correctness fallback.
- The transport phase can still be described as experimental and project-specific in its current combination of weighted energy, 2-adic closeness, and accept-on-descent block moves.
- No recorded source so far justifies stronger novelty wording or any performance-oriented claim.
