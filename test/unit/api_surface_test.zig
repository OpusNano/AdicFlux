const std = @import("std");
const adicflux = @import("adicflux");

test "public isSorted helper matches sort semantics" {
    var xs = [_]i32{ 3, 1, 2 };
    try std.testing.expect(!adicflux.isSorted(i32, xs[0..]));

    adicflux.sort(i32, xs[0..]);
    try std.testing.expect(adicflux.isSorted(i32, xs[0..]));
}

test "public isSorted reflects limited cleanup diagnostic runs" {
    var xs = [_]i32{ 5, 4, 3, 2, 1 };
    const cfg = adicflux.Config{
        .block_size = 4,
        .neighborhood = 1,
        .max_displacement = 1,
        .transport_rounds = 1,
        .cleanup_pass_limit = 0,
    };

    adicflux.sortWithConfig(i32, xs[0..], cfg);
    try std.testing.expect(!adicflux.isSorted(i32, xs[0..]));
}
