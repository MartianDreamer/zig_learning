const std = @import("std");

const masks: [8]u8 = .{ 0b0000_0001, 0b0000_0011, 0b0000_0111, 0b0000_1111, 0b0001_1111, 0b0011_1111, 0b0111_1111, 0b1111_1111 };

pub fn decode(allocator: std.mem.Allocator, content: []const u8) ![]const u8 {
    const buffer: []u8 = try allocator.alloc(u8, calculate_result_length(content));
    var content_cur: usize = 0;
    var result_cur: usize = 0;
    while (content_cur < content.len) {
        const result_end: usize = if (buffer.len < result_cur + 3) buffer.len else result_cur + 3;
        try decode_window(content[content_cur .. content_cur + 4], buffer[result_cur..result_end]);
        content_cur += 4;
        result_cur = result_end;
    }
    return buffer;
}

pub const DecodingError = error{InvalidBase64String};

fn decode_char(ch: u8) !u8 {
    if (ch >= 'a') {
        return ch - 'a' + 26;
    } else if (ch >= 'A') {
        return ch - 'A';
    } else if (ch >= '0') {
        return ch - '0';
    } else if (ch == '+') {
        return 62;
    } else if (ch == '/') {
        return 63;
    }
    return DecodingError.InvalidBase64String;
}

fn calculate_result_length(input: []const u8) usize {
    var padding_count: usize = 0;
    var i: usize = input.len - 1;
    while (i >= 0) : (i -= 1) {
        if (input[i] != '=') {
            break;
        }
        padding_count += 1;
    }
    const true_length = input.len - padding_count;
    var result = (true_length / 4) * 3;
    result += (true_length % 4) - 1;
    return result;
}

fn decode_window(content: []const u8, result: []u8) !void {
    var cur: usize = 0;
    var cur_len: usize = 0;
    result[cur] = 0;
    for (content) |c| {
        if (c == '=') {
            break;
        }
        const decoded = try decode_char(c);
        result[cur] |= decoded << 2 >> @truncate(cur_len);
        if (cur_len + 6 < 8) {
            cur_len = 6;
            continue;
        }

        cur += 1;

        if (cur >= result.len) {
            break;
        }

        const used_bit: usize = 8 - cur_len;
        result[cur] = decoded << @truncate(2 + used_bit);
        cur_len = 6 - used_bit;
    }
}
