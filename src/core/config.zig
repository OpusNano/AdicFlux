const std = @import("std");

pub const Config = struct {
    pub const max_block_size: usize = 64;

    block_size: usize = 32,
    valuation_cap: u8 = 8,
    neighborhood: usize = 8,
    max_displacement: usize = 4,
    transport_rounds: usize = 4,
    cleanup_pass_limit: ?usize = null,

    pub fn validate(self: Config) void {
        std.debug.assert(self.block_size > 0);
        std.debug.assert(self.block_size <= max_block_size);
        std.debug.assert(self.neighborhood > 0);
        std.debug.assert(self.max_displacement > 0);
        std.debug.assert(self.transport_rounds > 0);
    }
};

pub const default_config = Config{};
