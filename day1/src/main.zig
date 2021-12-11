const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub fn readFileU32(comptime filename: []const u8, allocator: Allocator) anyerror!ArrayList(u32) {
    var list = ArrayList(u32).init(allocator);

    var file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var pval = try std.fmt.parseInt(u32, line, 10);
        try list.append(pval);
        //std.log.info("Data {d}", .{std.fmt.parseInt(u32, line, 10)}); // do something with line...
    }
    return list;
}

pub fn main() anyerror!void {
    const allocator = std.heap.page_allocator;
    var intlist = try readFileU32("input.txt", allocator);
    defer (intlist.deinit());

    var count: u32 = 0;
    var prev: u32 = undefined;
    for (intlist.items) |val, i| {
        //std.log.info("item {d} {d}", .{ i, val });
        if (i == 0) {
            // first
            prev = val;
            continue;
        }
        if (val > prev) {
            //std.log.info("{d} is larger than {d}", .{ val, prev });
            count = count + 1;
        }
        prev = val;
    }
    std.log.info("Part1 count: {d}", .{count});

    var num_items = intlist.items.len;
    count = 0;
    prev = 0;
    var index: usize = 1;
    prev = intlist.items[0] + intlist.items[1] + intlist.items[2];
    while (index < num_items - 2) {
        var curr = intlist.items[index] + intlist.items[index + 1] + intlist.items[index + 2];
        //std.log.info("Curr: {d} Prev: {d}", .{ curr, prev });
        if (curr > prev) {
            //  std.log.info("curr larger than prev", .{});
            count += 1;
        }
        prev = curr;

        index += 1;
    }
    std.log.info("Part2 count: {d}", .{count});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
