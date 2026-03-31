const Config = @import("config.zig").Config;
const key = @import("key.zig");

pub fn pairWeight(comptime T: type, left: T, right: T, cfg: Config) u64 {
    return 1 + key.closenessBonus(T, left, right, cfg);
}

pub fn pairEnergy(comptime T: type, left: T, right: T, cfg: Config) u64 {
    if (!key.greaterThan(T, left, right)) return 0;
    return pairWeight(T, left, right, cfg);
}

pub fn blockEnergy(comptime T: type, xs: []const T, cfg: Config) u64 {
    var total: u64 = 0;
    for (xs, 0..) |left, i| {
        var j = i + 1;
        while (j < xs.len) : (j += 1) {
            total += pairEnergy(T, left, xs[j], cfg);
        }
    }
    return total;
}
