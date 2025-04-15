const std = @import("std");

pub fn encode(allocator: std.mem.Allocator, content: []const u8) ![]const u8 {
    const buffer: []u8 = try allocator.alloc(u8, calculate_result_length(content.len));
    var content_cur: usize = 0;
    var result_cur: usize = 0;
    while (content_cur < content.len) {
        const content_end: usize = if (content.len < content_cur + 3) content.len else content_cur + 3;
        encode_window(content[content_cur..content_end], buffer[result_cur .. result_cur + 4]);
        result_cur += 4;
        content_cur = content_end;
    }
    return buffer;
}

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

fn calculate_result_length(input_length: usize) usize {
    const length: usize = (input_length / 3) * 4;
    if (input_length % 3 == 0) {
        return length;
    }
    return length + 4;
}

fn encode_window(content: []const u8, result: []u8) void {
    var remainder: u8 = 0;
    var remainder_length: usize = 0;

    for (0..4, 0..4) |i, j| {
        if (j < content.len) {
            const c: u8 = content[j];
            result[i] = base64.lookup(((c >> 2) >> @truncate(remainder_length)) | remainder);
            remainder_length = (2 + remainder_length) % 8;
            remainder = (c << @truncate(8 - remainder_length)) >> 2;
        } else if (remainder_length != 0) {
            result[i] = base64.lookup(remainder);
            remainder_length = 0;
        } else {
            result[i] = '=';
        }
    }
}
