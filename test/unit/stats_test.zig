const std = @import("std");
const adicflux = @import("adicflux");
const support = adicflux.unstable_test_support;

const Config = support.config.Config;
const Stats = support.stats.Stats;

test "sortWithStats records transport and cleanup activity" {
    const cfg = Config{
        .block_size = 8,
        .neighborhood = 2,
        .max_displacement = 2,
        .transport_rounds = 2,
    };

    var xs = [_]i32{ 9, 1, 8, 2, 7, 3, 6, 4, 5, 0 };
    var stats = Stats{};
    support.sortWithStats(i32, xs[0..], cfg, &stats);

    try std.testing.expect(stats.transport_blocks_visited > 0);
    try std.testing.expect(stats.transport_blocks_accepted + stats.transport_blocks_rejected == stats.transport_blocks_visited);
    try std.testing.expect(stats.cleanup_rounds > 0);
    try std.testing.expect(stats.cleanup_even_passes == stats.cleanup_rounds);
    try std.testing.expect(stats.cleanup_odd_passes == stats.cleanup_rounds);
}

test "cleanup pass limit zero suppresses cleanup work accounting" {
    const cfg = Config{
        .block_size = 4,
        .neighborhood = 1,
        .max_displacement = 1,
        .transport_rounds = 1,
        .cleanup_pass_limit = 0,
    };

    var xs = [_]i32{ 4, 3, 2, 1, 0 };
    var stats = Stats{};
    support.sortWithStats(i32, xs[0..], cfg, &stats);

    try std.testing.expectEqual(@as(usize, 0), stats.cleanup_rounds);
    try std.testing.expectEqual(@as(usize, 0), stats.cleanup_even_passes);
    try std.testing.expectEqual(@as(usize, 0), stats.cleanup_odd_passes);
}

test "sorted input performs cleanup accounting without swaps" {
    const cfg = Config{
        .block_size = 8,
        .neighborhood = 2,
        .max_displacement = 2,
        .transport_rounds = 2,
    };

    var xs = [_]i32{ -3, -1, 0, 2, 4, 9 };
    var stats = Stats{};
    support.sortWithStats(i32, xs[0..], cfg, &stats);

    try std.testing.expectEqual(@as(usize, 0), stats.transport_blocks_accepted);
    try std.testing.expect(stats.transport_blocks_rejected > 0);
    try std.testing.expectEqual(@as(usize, 1), stats.cleanup_rounds);
    try std.testing.expectEqual(@as(usize, 0), stats.cleanup_swaps);
}
