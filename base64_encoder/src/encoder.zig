const std = @import("std");

const Base64 = struct {
    _table: [64]u8,

    fn init() Base64 {
        const obj = Base64{ ._table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".* };
        return obj;
    }

    fn lookup(self: Base64, value: u8) u8 {
        return self._table[value];
    }
};

const base64 = Base64.init();

pub fn encode(allocator: std.mem.Allocator, content: []const u8) ![]const u8 {
    const buffer: []u8 = try allocator.alloc(u8, calculate_result_length(content.len));
    var content_cur: usize = 0;
    var result_cur: usize = 0;
    while (content_cur < content.len) {
        const content_end: usize = if (content.len < content_cur + 3) content.len else content_cur + 3;
        encodeWindow(content[content_cur..content_end], buffer[result_cur .. result_cur + 4]);
        result_cur += 4;
        content_cur = content_end;
    }
    return buffer;
}

fn calculate_result_length(input_length: usize) usize {
    const length: usize = (input_length / 3) * 4;
    if (input_length % 3 == 0) {
        return length;
    }
    return length + 4;
}

fn encodeWindow(content: []const u8, result: []u8) void {
    var count: usize = 0;
    var remainder_content: u8 = 0;
    var remainder_length: usize = 0;
    // mapping all available character
    for (content) |c| {
        var bit_count: usize = 8 + remainder_length;
        while (bit_count >= 6) {
            result[count] = base64.lookup(((c >> 2) >> @truncate(remainder_length)) | remainder_content);
            remainder_length = (2 + remainder_length) % 8;
            remainder_content = (c << @truncate(8 - remainder_length)) >> 2;
            bit_count -= 6;
            count += 1;
        }
    }
    // mapping missing byte in result
    while (count < 4) {
        if (remainder_content != 0) {
            result[count] = base64.lookup(remainder_content);
            remainder_content = 0;
        } else {
            result[count] = '=';
        }
        count += 1;
    }
}
