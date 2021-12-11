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
    }
    return list;
}
pub fn readFilept2(comptime filename: []const u8) anyerror!void {
    var file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;
    var depth: i32 = 0;
    var pos: i32 = 0;
    var aim: i32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var it = std.mem.split(u8, line, " ");

        // it.next() is an optional, of type ?T, meaning it could be 'null'
        // if its null, orelse unreachable makes the program crash
        var cmd = it.next() orelse unreachable;
        var valstr = it.next() orelse unreachable;
        var val = try std.fmt.parseInt(i32, valstr, 10);

        std.log.info("command: '{s}' value: '{d}' ", .{ cmd, val });
        if (std.mem.eql(u8, cmd, "forward")) {
            std.log.info("Command -> forward", .{});
            pos += val;
            depth += aim * val;
        } else if (std.mem.eql(u8, cmd, "up")) {
            std.log.info("Command -> up", .{});
            aim -= val;
        } else if (std.mem.eql(u8, cmd, "down")) {
            std.log.info("Command -> down", .{});
            aim += val;
        } else {
            std.log.info("Unknown command: '{s}'", .{cmd});
        }
    }
    std.log.info("Depth: {} Pos: {} mul: {}", .{ depth, pos, depth * pos });
}

pub fn readFilept1(comptime filename: []const u8) anyerror!void {
    var file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;
    var depth: i32 = 0;
    var pos: i32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var it = std.mem.split(u8, line, " ");

        // it.next() is an optional, of type ?T, meaning it could be 'null'
        // if its null, orelse unreachable makes the program crash
        var cmd = it.next() orelse unreachable;
        var valstr = it.next() orelse unreachable;
        var val = try std.fmt.parseInt(i32, valstr, 10);

        std.log.info("command: '{s}' value: '{d}' ", .{ cmd, val });
        if (std.mem.eql(u8, cmd, "forward")) {
            std.log.info("Command -> forward", .{});
            pos += val;
        } else if (std.mem.eql(u8, cmd, "up")) {
            std.log.info("Command -> up", .{});
            depth -= val;
        } else if (std.mem.eql(u8, cmd, "down")) {
            std.log.info("Command -> down", .{});
            depth += val;
        } else {
            std.log.info("Unknown command: '{s}'", .{cmd});
        }
    }
    std.log.info("Depth: {} Pos: {} mul: {}", .{ depth, pos, depth * pos });
}

pub fn main() anyerror!void {
    try readFilept1("input.txt");
    try readFilept2("input.txt");
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
