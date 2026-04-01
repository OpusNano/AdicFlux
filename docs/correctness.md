# Correctness

## What is proved by the implementation structure

The repository relies on two monotone mechanisms.

1. Accepted transport moves strictly decrease the chosen block-local energy.
2. The default cleanup stage repeatedly removes adjacent inversions and terminates only when none remain.

The first statement is enforced directly: the code computes energy before and after a proposed block permutation and accepts the permutation only when the new energy is strictly smaller.

The second statement is classical. Odd-even transposition cleanup swaps an adjacent pair only when it is out of order. Every swap decreases the ordinary inversion count of the full array, which is a nonnegative integer. Therefore repeated cleanup cannot continue forever and terminates in a sorted state.

These two facts live at different scopes:

- transport proves a local property about one block and one chosen energy,
- cleanup proves the global sortedness result for the whole slice.

## What is not claimed

- No proof that the transport phase improves asymptotic complexity.
- No proof that the weighted energy is globally minimized before cleanup.
- No proof that local transport descent implies monotone descent of any global array-wide energy.
- No formal proof yet that the whole implementation is stable for every accepted transport move.

## Proof sketch for exactness

Let `I(xs)` be the ordinary inversion count of the full slice under the order-preserving key transform.

- `I(xs) >= 0` for every slice.
- During cleanup, each adjacent swap occurs only for a strict inversion.
- Swapping a strict adjacent inversion decreases `I(xs)` by exactly `1`.
- Therefore cleanup terminates after finitely many swaps.
- A slice with no adjacent inversions is sorted.

So the final array after full cleanup is sorted.

Transport affects only how much progress may occur before cleanup. It is not required for correctness.

## Configuration caveat

The public configuration currently includes `cleanup_pass_limit` as a diagnostic/testing escape hatch. When it is left at `null`, cleanup runs to completion and the exactness argument above applies. When a finite limit is supplied, cleanup may stop early and the library does not claim that the output is fully sorted.
