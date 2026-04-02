const std = @import("std");
const adicflux = @import("adicflux");
const support = adicflux.unstable_test_support;
const Config = support.config.Config;
const energy = support.energy;
const key = support.key;

test "pair energy is zero for ordered and equal pairs" {
    const cfg = Config{};
    try std.testing.expectEqual(@as(u64, 0), energy.pairEnergy(i32, -3, 9, cfg));
    try std.testing.expectEqual(@as(u64, 0), energy.pairEnergy(i32, 4, 4, cfg));
}

test "block energy matches hand checked example" {
    const cfg = Config{ .valuation_cap = 4 };
    const xs = [_]u8{ 3, 2, 1 };

    const e32 = energy.pairWeight(u8, 3, 2, cfg);
    const e31 = energy.pairWeight(u8, 3, 1, cfg);
    const e21 = energy.pairWeight(u8, 2, 1, cfg);
    try std.testing.expectEqual(e32 + e31 + e21, energy.blockEnergy(u8, xs[0..], cfg));
}

test "permutation delta energy matches exact recomputation" {
    const cfg = Config{ .valuation_cap = 8 };
    const xs = [_]i32{ 5, 1, 4, 2 };
    const perm = [_]usize{ 2, 0, 3, 1 };
    var permuted = [_]i32{ 0, 0, 0, 0 };
    var keys = [_]key.KeyType(i32){ 0, 0, 0, 0 };

    for (xs, 0..) |value, i| {
        permuted[perm[i]] = value;
        keys[i] = key.biasedKey(i32, value);
    }

    const before = energy.blockEnergy(i32, xs[0..], cfg);
    const after_exact = energy.blockEnergy(i32, permuted[0..], cfg);
    const after_delta = energy.energyAfterPermutationFromKeys(i32, keys[0..], perm[0..], before, cfg);

    try std.testing.expectEqual(after_exact, after_delta);
}
