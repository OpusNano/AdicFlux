const std = @import("std");

pub fn UnsignedOf(comptime T: type) type {
    return std.meta.Int(.unsigned, @bitSizeOf(T));
}

pub fn SignedOf(comptime T: type) type {
    return std.meta.Int(.signed, @bitSizeOf(T));
}
