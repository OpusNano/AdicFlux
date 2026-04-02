const std = @import("std");
const Config = @import("config.zig").Config;
const energy = @import("energy.zig");
const key = @import("key.zig");

pub fn compute(comptime T: type, block: []const T, cfg: Config, pressures: []i32) void {
    std.debug.assert(pressures.len >= block.len);

    @memset(pressures[0..block.len], 0);
    if (block.len <= 1) return;

    for (block, 0..) |left, i| {
        const end = @min(block.len, i + cfg.neighborhood + 1);
        var j = i + 1;
        while (j < end) : (j += 1) {
            const right = block[j];
            switch (key.compare(T, left, right)) {
                .gt => {
                    const w: i32 = @intCast(energy.pairWeight(T, left, right, cfg));
                    pressures[i] += w;
                    pressures[j] -= w;
                },
                .lt => {
                    pressures[i] -= 1;
                    pressures[j] += 1;
                },
                .eq => {},
            }
        }
    }
}

pub fn computeFromKeys(comptime T: type, keys: []const key.KeyType(T), cfg: Config, pressures: []i32) void {
    std.debug.assert(pressures.len >= keys.len);

    @memset(pressures[0..keys.len], 0);
    if (keys.len <= 1) return;

    for (keys, 0..) |left_key, i| {
        const end = @min(keys.len, i + cfg.neighborhood + 1);
        var j = i + 1;
        while (j < end) : (j += 1) {
            const right_key = keys[j];
            if (left_key > right_key) {
                const w: i32 = @intCast(energy.pairWeightFromKeys(T, left_key, right_key, cfg));
                pressures[i] += w;
                pressures[j] -= w;
            } else if (left_key < right_key) {
                pressures[i] -= 1;
                pressures[j] += 1;
            }
        }
    }
}

pub fn computeFromKeysWithEnergy(comptime T: type, keys: []const key.KeyType(T), cfg: Config, pressures: []i32) u64 {
    std.debug.assert(pressures.len >= keys.len);

    @memset(pressures[0..keys.len], 0);
    if (keys.len <= 1) return 0;

    var total_energy: u64 = 0;
    for (keys, 0..) |left_key, i| {
        const pressure_end = @min(keys.len, i + cfg.neighborhood + 1);
        var j = i + 1;
        while (j < keys.len) : (j += 1) {
            const right_key = keys[j];
            const in_pressure_window = j < pressure_end;

            if (left_key > right_key) {
                const weight = energy.pairWeightFromKeys(T, left_key, right_key, cfg);
                total_energy += weight;
                if (in_pressure_window) {
                    const w: i32 = @intCast(weight);
                    pressures[i] += w;
                    pressures[j] -= w;
                }
            } else if (left_key < right_key and in_pressure_window) {
                pressures[i] -= 1;
                pressures[j] += 1;
            }
        }
    }

    return total_energy;
}

pub fn proposalsFromPressure(pressures: []const i32, cfg: Config, proposals: []i8) void {
    std.debug.assert(proposals.len >= pressures.len);

    const divisor: i32 = @intCast(@max(@as(usize, 1), cfg.neighborhood));
    const max_disp: i32 = @intCast(cfg.max_displacement);

    for (pressures, 0..) |pressure_value, i| {
        var displacement = @divTrunc(pressure_value, divisor);
        displacement = std.math.clamp(displacement, -max_disp, max_disp);
        proposals[i] = @intCast(displacement);
    }
}
