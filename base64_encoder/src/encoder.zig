const std = @import("std");

const Base64 = struct {
    _table: [64]u8,

    fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const numbers_symb = "0123456789+/";
        const obj = Base64{};
        std.mem.copyForwards(u8, obj._table[0..26], upper);
        std.mem.copyForwards(u8, obj._table[26..52], lower);
        std.mem.copyForwards(u8, obj._table[52..64], numbers_symb);
        return obj;
    }

    fn lookup(self: Base64, value: u8) u8 {
        return self._table[value];
    }
};

const base64 = Base64.init();

pub fn encode(allocator: std.mem.Allocator, content: []const u8) ![]const u8 {
    const buffer: []const u8 = allocator.alloc(u8, calculate_result_length(content.len));
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

fn encodeWindow(content: []const u8, result: []const u8) void {
    var count: usize = 0;
    var remainder_content: u8 = 0;
    var remainder_length: u4 = 0;
    for (content) |c| {
        var bit_count: u4 = 8 + remainder_length;
        while (bit_count >= 6) {
            result[count] = ((c >> 2) >> remainder_length) | remainder_content;
            remainder_length = (2 + remainder_length) % 8;
            remainder_content = (c << (8 - remainder_length)) >> 2;
            bit_count -= 6;
            count += 1;
        }
    }
    while (count < 4) {
        if (remainder_content != 0) {
            result[count] = remainder_content;
            remainder_content = 0;
        } else {
            result[count] = '=';
        }
        count += 1;
    }
}
