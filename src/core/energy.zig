const Config = @import("config.zig").Config;
const key = @import("key.zig");

pub fn pairWeight(comptime T: type, left: T, right: T, cfg: Config) u64 {
    return 1 + key.closenessBonus(T, left, right, cfg);
}

pub fn pairWeightFromKeys(comptime T: type, left_key: key.KeyType(T), right_key: key.KeyType(T), cfg: Config) u64 {
    return 1 + key.closenessBonusFromKeys(T, left_key, right_key, cfg);
}

pub fn pairEnergy(comptime T: type, left: T, right: T, cfg: Config) u64 {
    if (!key.greaterThan(T, left, right)) return 0;
    return pairWeight(T, left, right, cfg);
}

pub fn pairEnergyFromKeys(comptime T: type, left_key: key.KeyType(T), right_key: key.KeyType(T), cfg: Config) u64 {
    if (!key.greaterThanKeys(T, left_key, right_key)) return 0;
    return pairWeightFromKeys(T, left_key, right_key, cfg);
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

pub fn blockEnergyFromKeys(comptime T: type, keys: []const key.KeyType(T), cfg: Config) u64 {
    var total: u64 = 0;
    for (keys, 0..) |left_key, i| {
        var j = i + 1;
        while (j < keys.len) : (j += 1) {
            total += pairEnergyFromKeys(T, left_key, keys[j], cfg);
        }
    }
    return total;
}

pub fn energyAfterPermutationFromKeys(
    comptime T: type,
    keys: []const key.KeyType(T),
    source_to_final: []const usize,
    before_energy: u64,
    cfg: Config,
) u64 {
    var after_energy = before_energy;

    for (keys, 0..) |left_key, i| {
        var j = i + 1;
        while (j < keys.len) : (j += 1) {
            if (source_to_final[i] < source_to_final[j]) continue;

            const weight = pairWeightFromKeys(T, left_key, keys[j], cfg);
            if (left_key > keys[j]) {
                after_energy -= weight;
            } else if (left_key < keys[j]) {
                after_energy += weight;
            }
        }
    }

    return after_energy;
}
