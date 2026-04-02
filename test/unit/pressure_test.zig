const std = @import("std");
const adicflux = @import("adicflux");
const support = adicflux.unstable_test_support;
const Config = support.config.Config;
const energy = support.energy;
const key = support.key;
const pressure = support.pressure;

test "pressure points inverted endpoints toward each other" {
    const cfg = Config{ .neighborhood = 4 };
    const xs = [_]i32{ 9, 1, 2, 3 };
    var values = [_]i32{ 0, 0, 0, 0 };
    pressure.compute(i32, xs[0..], cfg, values[0..]);

    try std.testing.expect(values[0] > 0);
    try std.testing.expect(values[1] < values[2]);
    try std.testing.expect(values[1] < 0 or values[2] < 0 or values[3] < 0);
}

test "pressure proposals stay within displacement bounds" {
    const cfg = Config{ .neighborhood = 2, .max_displacement = 3 };
    const pressures = [_]i32{ -100, -2, 0, 9, 100 };
    var proposals = [_]i8{ 0, 0, 0, 0, 0 };
    pressure.proposalsFromPressure(pressures[0..], cfg, proposals[0..]);

    for (proposals) |proposal| {
        try std.testing.expect(proposal >= -3);
        try std.testing.expect(proposal <= 3);
    }
}

test "combined pressure and energy pass matches separate computations" {
    const cfg = Config{ .neighborhood = 3, .valuation_cap = 8 };
    const xs = [_]i32{ 5, 1, 4, 2, 3 };
    var keys = [_]key.KeyType(i32){ 0, 0, 0, 0, 0 };
    for (xs, 0..) |value, i| keys[i] = key.biasedKey(i32, value);

    var separate_pressures = [_]i32{ 0, 0, 0, 0, 0 };
    var combined_pressures = [_]i32{ 0, 0, 0, 0, 0 };

    pressure.computeFromKeys(i32, keys[0..], cfg, separate_pressures[0..]);
    const combined_energy = pressure.computeFromKeysWithEnergy(i32, keys[0..], cfg, combined_pressures[0..]);
    const separate_energy = energy.blockEnergy(i32, xs[0..], cfg);

    try std.testing.expectEqual(separate_energy, combined_energy);
    try std.testing.expectEqualSlices(i32, separate_pressures[0..], combined_pressures[0..]);
}
