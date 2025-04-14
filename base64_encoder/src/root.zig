const std = @import("std");
const testing = std.testing;
const expect = testing.expect;
const encoder = @import("encoder.zig");
const decoder = @import("decoder.zig");

pub const encode = encoder.encode;
pub const decode = decoder.decode;

test "test encode" {
    // prepare
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // act
    const encoded1 = try encode(allocator, "I'm testing base64 encoder");
    const encoded2 = try encode(allocator, "This one is encoded correctly. $@#$*@(===9+/");
    std.debug.print("{s}\n", encoded1);
    std.debug.print("{s}\n", encoded2);
    const test1 = std.mem.eql(u8, encoded1, "SSdtIHRlc3RpbmcgYmFzZTY0IGVuY29kZXI=");
    const test2 = std.mem.eql(u8, encoded2, "VGhpcyBvbmUgaXMgZW5jb2RlZCBjb3JyZWN0bHkuICRAIyQqQCg9PT05Ky8=");

    // assert
    try expect(test1);
    try expect(test2);
}
