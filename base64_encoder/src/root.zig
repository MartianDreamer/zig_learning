//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;

pub extern fn encode(allocator: std.mem.Allocator, byteArray: []const u8) []const u8;
pub extern fn decode(allocator: std.mem.Allocator, byteArray: []const u8) []const u8;
