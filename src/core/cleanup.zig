const key = @import("key.zig");

pub fn oddEvenPass(comptime T: type, xs: []T, parity: usize) bool {
    var swapped = false;
    var i = parity;
    while (i + 1 < xs.len) : (i += 2) {
        if (key.greaterThan(T, xs[i], xs[i + 1])) {
            const tmp = xs[i];
            xs[i] = xs[i + 1];
            xs[i + 1] = tmp;
            swapped = true;
        }
    }
    return swapped;
}

pub fn exactCleanup(comptime T: type, xs: []T, pass_limit: ?usize) void {
    if (xs.len <= 1) return;

    var pass: usize = 0;
    while (true) : (pass += 1) {
        if (pass_limit) |limit| {
            if (pass >= limit) break;
        }

        const swapped_even = oddEvenPass(T, xs, 0);
        const swapped_odd = oddEvenPass(T, xs, 1);
        if (!swapped_even and !swapped_odd) break;
    }
}
