# Complexity

This document separates implemented costs from conjecture.

## Per-pass costs in the current implementation

- Block energy evaluation is `O(b^2)` for block size `b`.
- Pressure computation is `O(b * neighborhood)`.
- Stable target resolution is `O(b^2)` in the current insertion-sort-based implementation.
- With `n / b` blocks and `O(b^2)` local work per block in the current implementation, one full transport round is conservatively `O(n * b)`.

If block size is treated as a fixed tuning constant, that makes the transport phase linear in `n` with a potentially large constant factor. If block size is allowed to scale with `n`, the bound should be read as `O(n * b)` instead.

## Cleanup complexity

Odd-even cleanup has conservative worst-case `O(n^2)` time and `O(1)` extra memory.

## Best case

- Already sorted input may cause all transport moves to be rejected quickly.
- Cleanup then exits after one even pass and one odd pass.

## Conservative worst case

- Transport provides no useful acceleration.
- Cleanup performs the full exact work.
- Overall worst-case time is therefore conservatively quadratic in `n`.

## What is expected but not established

- Some structured inputs may benefit from transport before cleanup.
- Better transport policies may reduce the amount of cleanup work.

Neither point is currently presented as a theorem or benchmark-backed claim.
