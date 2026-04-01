# API

## Public entry points

### `sort`

```zig
pub fn sort(comptime T: type, xs: []T) void
```

Sorts an integer slice in place using the default AdicFlux configuration.

### `sortWithConfig`

```zig
pub fn sortWithConfig(comptime T: type, xs: []T, cfg: Config) void
```

Sorts an integer slice in place using a caller-provided configuration.

Invalid configurations panic with the validation error name. This keeps the public API small while still enforcing release-mode safety constraints.

### `isSorted`

```zig
pub fn isSorted(comptime T: type, xs: []const T) bool
```

Checks whether a slice is nondecreasing under AdicFlux's key ordering.

## `Config`

### `block_size`

Size of each transport block. Must be between `1` and `Config.max_block_size` inclusive.

### `valuation_cap`

Maximum extra weight contributed by the 2-adic closeness term `ctz(x xor y)`.

### `neighborhood`

How many forward neighbors each element inspects when accumulating local pressure.

### `max_displacement`

Maximum absolute movement proposed from one transport step. Must fit in the current `i8` proposal representation.

### `transport_rounds`

Maximum number of full block-transport rounds attempted before exact cleanup.

### `cleanup_pass_limit`

Optional diagnostic/testing limit for odd-even cleanup rounds.

- `null` means cleanup runs to completion and preserves the exactness guarantee.
- a finite value may stop cleanup early and therefore may leave the output not fully sorted.

## Non-stable internal support

Internal modules used by the test suite are exposed under `adicflux.unstable_test_support`.

That namespace exists for repository development and tests. It is intentionally non-stable and may change without notice.
