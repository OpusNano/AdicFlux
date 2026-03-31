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
