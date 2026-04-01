const std = @import("std");

pub const Config = struct {
    pub const max_block_size: usize = 64;
    pub const Error = error{
        BlockSizeZero,
        BlockSizeTooLarge,
        NeighborhoodZero,
        MaxDisplacementZero,
        MaxDisplacementTooLarge,
        TransportRoundsZero,
    };

    block_size: usize = 32,
    valuation_cap: u8 = 8,
    neighborhood: usize = 8,
    max_displacement: usize = 4,
    transport_rounds: usize = 4,
    // Non-null limits are a diagnostic/testing escape hatch.
    // They intentionally weaken the full exactness guarantee because cleanup may stop early.
    cleanup_pass_limit: ?usize = null,

    pub fn validate(self: Config) Error!void {
        if (self.block_size == 0) return error.BlockSizeZero;
        if (self.block_size > max_block_size) return error.BlockSizeTooLarge;
        if (self.neighborhood == 0) return error.NeighborhoodZero;
        if (self.max_displacement == 0) return error.MaxDisplacementZero;
        if (self.max_displacement > std.math.maxInt(i8)) return error.MaxDisplacementTooLarge;
        if (self.transport_rounds == 0) return error.TransportRoundsZero;
    }
};

pub const default_config = Config{};
