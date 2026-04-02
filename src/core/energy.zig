const Config = @import("config.zig").Config;
const key = @import("key.zig");

pub fn buildGroupedState(
    comptime T: type,
    keys: []const key.KeyType(T),
    distinct_keys_out: []key.KeyType(T),
    group_ids_out: []u8,
    group_counts_out: []usize,
) usize {
    var distinct_count: usize = 0;
    @memset(group_counts_out, 0);

    for (keys, 0..) |value, idx| {
        var group: usize = 0;
        while (group < distinct_count and distinct_keys_out[group] != value) : (group += 1) {}
        if (group == distinct_count) {
            distinct_keys_out[distinct_count] = value;
            distinct_count += 1;
        }
        group_ids_out[idx] = @intCast(group);
        group_counts_out[group] += 1;
    }

    var sorted_old_ids: [Config.max_block_size]u8 = undefined;
    for (0..distinct_count) |i| sorted_old_ids[i] = @intCast(i);

    var i: usize = 1;
    while (i < distinct_count) : (i += 1) {
        const current_id = sorted_old_ids[i];
        const current_key = distinct_keys_out[current_id];
        var j = i;
        while (j > 0 and distinct_keys_out[sorted_old_ids[j - 1]] > current_key) : (j -= 1) {
            sorted_old_ids[j] = sorted_old_ids[j - 1];
        }
        sorted_old_ids[j] = current_id;
    }

    var sorted_keys: [Config.max_block_size]key.KeyType(T) = undefined;
    var sorted_counts: [Config.max_block_size]usize = undefined;
    var remap: [Config.max_block_size]u8 = undefined;
    for (sorted_old_ids[0..distinct_count], 0..) |old_id, new_id| {
        sorted_keys[new_id] = distinct_keys_out[old_id];
        sorted_counts[new_id] = group_counts_out[old_id];
        remap[old_id] = @intCast(new_id);
    }
    @memcpy(distinct_keys_out[0..distinct_count], sorted_keys[0..distinct_count]);
    @memcpy(group_counts_out[0..distinct_count], sorted_counts[0..distinct_count]);

    for (group_ids_out[0..keys.len]) |*group| {
        group.* = remap[group.*];
    }

    return distinct_count;
}

pub fn buildGroupWeightMatrix(
    comptime T: type,
    distinct_keys: []const key.KeyType(T),
    cfg: Config,
    weight_matrix: []u16,
) void {
    const stride = distinct_keys.len;
    for (distinct_keys, 0..) |left_key, i| {
        for (distinct_keys, 0..) |right_key, j| {
            const index = i * stride + j;
            if (left_key > right_key) {
                weight_matrix[index] = @intCast(pairWeightFromKeys(T, left_key, right_key, cfg));
            } else {
                weight_matrix[index] = 0;
            }
        }
    }
}

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

pub fn blockEnergyFromGroupIds(group_ids: []const u8, distinct_count: usize, weight_matrix: []const u16) u64 {
    var counts: [Config.max_block_size]usize = [_]usize{0} ** Config.max_block_size;
    var total: u64 = 0;

    var idx = group_ids.len;
    while (idx > 0) {
        idx -= 1;
        const group = group_ids[idx];
        var smaller: usize = 0;
        while (smaller < group) : (smaller += 1) {
            total += @as(u64, counts[smaller]) * weight_matrix[@as(usize, group) * distinct_count + smaller];
        }
        counts[group] += 1;
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

pub fn energyAfterPermutationFromMovedKeys(
    comptime T: type,
    keys: []const key.KeyType(T),
    source_to_final: []const usize,
    moved_indices: []const usize,
    before_energy: u64,
    cfg: Config,
) u64 {
    var moved_mask: [Config.max_block_size]bool = [_]bool{false} ** Config.max_block_size;
    for (moved_indices) |idx| moved_mask[idx] = true;

    var after_energy = before_energy;
    for (moved_indices) |moved_idx| {
        var other: usize = 0;
        while (other < keys.len) : (other += 1) {
            if (other == moved_idx) continue;
            if (moved_mask[other] and other < moved_idx) continue;

            const left_index = @min(moved_idx, other);
            const right_index = @max(moved_idx, other);
            const new_ordered = source_to_final[left_index] < source_to_final[right_index];
            if (new_ordered) continue;

            const left_key = keys[left_index];
            const right_key = keys[right_index];
            const weight = pairWeightFromKeys(T, left_key, right_key, cfg);
            if (left_key > right_key) {
                after_energy -= weight;
            } else if (left_key < right_key) {
                after_energy += weight;
            }
        }
    }

    return after_energy;
}
