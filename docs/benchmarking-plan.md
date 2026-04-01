# Benchmarking Plan

This repository intentionally does not publish benchmark numbers yet.

## Checklist version

This document now serves as benchmark-readiness checklist v1 for the repository. Future changes should update this version deliberately rather than letting benchmark prerequisites drift implicitly.

## Hard gate: do not benchmark until all items below are true

- public configuration fields are all semantically implemented or intentionally removed,
- correctness docs and README agree on exactness and stability wording,
- transport invariant tests cover acceptance, rejection, and permutation preservation,
- multi-block randomized tests cover sizes well beyond one block,
- reference-oracle coverage exists for larger arrays,
- debug instrumentation can report transport and cleanup work counts,
- algorithm structure is stable enough that benchmarked defaults are meaningful,
- benchmark methodology is documented before any numbers are published.

If any item above is false, benchmark work should stay deferred.

Benchmarks should be added only after:

- the algorithm and configuration surface stop changing rapidly,
- correctness tests are broad enough to trust aggressive refactors,
- the benchmark methodology is documented in advance.

When benchmarking is introduced, compare against:

- Zig standard-library integer sorting paths where applicable,
- a simple insertion sort baseline on tiny arrays,
- common comparison sorts for medium and large arrays.

Datasets should include:

- random integers,
- already sorted data,
- reverse sorted data,
- nearly sorted data,
- heavy-duplicate distributions,
- structured bit-pattern families.

Metrics should include:

- wall-clock time,
- throughput,
- allocation behavior,
- transport acceptance/rejection counts,
- cleanup pass and swap counts,
- branch/cache counters where available,
- sensitivity to block and valuation parameters.

Fairness controls should include:

- identical compiler version and flags,
- warmed caches versus cold starts reported separately,
- repeated trials with dispersion statistics,
- clear hardware and OS reporting.
