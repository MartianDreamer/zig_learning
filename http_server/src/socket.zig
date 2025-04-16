const std = @import("std");
const net = std.net;

pub const Socket = struct {
    _address: net.Address,

    pub fn init(port: u16) Socket {
        const ip = [4]u8{127, 0, 0, 1};
        const address = net.Address.initIp4(ip, port);
        return Socket{ ._address = address };
    }

    pub fn listen(self: Socket) !net.Server {
        return self._address.listen(.{});
    }
};
