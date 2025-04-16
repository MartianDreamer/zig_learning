const Socket = @import("socket.zig").Socket;

pub fn main() !void {
    const socket = Socket.init(8080);
    const server  = try socket.listen();
    const conn = try server.accept();
    _ = conn;
}   
