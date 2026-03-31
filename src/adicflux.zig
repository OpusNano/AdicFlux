const std = @import("std");

pub const Config = @import("core/config.zig").Config;
pub const DefaultConfig = @import("core/config.zig").default_config;

pub const testing = struct {
    pub const config = @import("core/config.zig");
    pub const key = @import("core/key.zig");
    pub const energy = @import("core/energy.zig");
    pub const pressure = @import("core/pressure.zig");
    pub const transport = @import("core/transport.zig");
    pub const cleanup = @import("core/cleanup.zig");
    pub const util = @import("internal/util.zig");
};

const cleanup = @import("core/cleanup.zig");
const transport = @import("core/transport.zig");
const util = @import("internal/util.zig");

pub fn sort(comptime T: type, xs: []T) void {
    sortWithConfig(T, xs, DefaultConfig);
}

pub fn sortWithConfig(comptime T: type, xs: []T, cfg: Config) void {
    util.assertIntegerType(T);
    cfg.validate();

    if (xs.len <= 1) return;

    var round: usize = 0;
    while (round < cfg.transport_rounds) : (round += 1) {
        var any_accepted = false;
        var start: usize = 0;

        while (start < xs.len) : (start += cfg.block_size) {
            const end = @min(start + cfg.block_size, xs.len);
            const result = transport.tryTransportBlock(T, xs[start..end], cfg);
            any_accepted = any_accepted or result.accepted;
        }

        if (!any_accepted) break;
    }

    cleanup.exactCleanup(T, xs, null);
}

pub fn isSorted(comptime T: type, xs: []const T) bool {
    return util.isSorted(T, xs);
}

test {
    std.testing.refAllDecls(@This());
}
