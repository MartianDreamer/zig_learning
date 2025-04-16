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
    const encoded3 = try encode(allocator, "当然可以！以下是一个300字的中文段落：在快速发展的现代社会中，科技正在以惊人的速度改变我们的生活。从智能手机到人工智能，科技创新赋予人们无数新的可能性。它不仅提高了我们的工作效率，还使沟通变得更加方便。然而，这种技术的飞速发展也带来了挑战，比如信息安全问题和过度依赖。面对这些问题，我们需要保持警惕，合理使用科技工具，同时培养批判性思维，以适应不断变化的世界。科技虽是双刃剑，但它也为解决许多全球性问题提供了希望，例如气候变化、疾病治疗和资源管理。未来，我们应更智慧地运用技术，使其成为推动社会进步的重要力量，而不是对人类产生负面影响。通过教育和创新，我们可以在享受科技带来的便利的同时，促进可持续发展，为下一代创造更美好的世界。这个段落涵盖了科技发展的优劣势以及对未来的展望，希望能够满足您的要求！如果需要调整或添加内容，请告诉我。\n");
    
    const test1 = std.mem.eql(u8, encoded1, "SSdtIHRlc3RpbmcgYmFzZTY0IGVuY29kZXI=");
    const test2 = std.mem.eql(u8, encoded2, "VGhpcyBvbmUgaXMgZW5jb2RlZCBjb3JyZWN0bHkuICRAIyQqQCg9PT05Ky8=");
    const test3 = std.mem.eql(u8, encoded3, "5b2T54S25Y+v5Lul77yB5Lul5LiL5piv5LiA5LiqMzAw5a2X55qE5Lit5paH5q616JC977ya5Zyo5b+r6YCf5Y+R5bGV55qE546w5Luj56S+5Lya5Lit77yM56eR5oqA5q2j5Zyo5Lul5oOK5Lq655qE6YCf5bqm5pS55Y+Y5oiR5Lus55qE55Sf5rS744CC5LuO5pm66IO95omL5py65Yiw5Lq65bel5pm66IO977yM56eR5oqA5Yib5paw6LWL5LqI5Lq65Lus5peg5pWw5paw55qE5Y+v6IO95oCn44CC5a6D5LiN5LuF5o+Q6auY5LqG5oiR5Lus55qE5bel5L2c5pWI546H77yM6L+Y5L2/5rKf6YCa5Y+Y5b6X5pu05Yqg5pa55L6/44CC54S26ICM77yM6L+Z56eN5oqA5pyv55qE6aOe6YCf5Y+R5bGV5Lmf5bim5p2l5LqG5oyR5oiY77yM5q+U5aaC5L+h5oGv5a6J5YWo6Zeu6aKY5ZKM6L+H5bqm5L6d6LWW44CC6Z2i5a+56L+Z5Lqb6Zeu6aKY77yM5oiR5Lus6ZyA6KaB5L+d5oyB6K2m5oOV77yM5ZCI55CG5L2/55So56eR5oqA5bel5YW377yM5ZCM5pe25Z+55YW75om55Yik5oCn5oCd57u077yM5Lul6YCC5bqU5LiN5pat5Y+Y5YyW55qE5LiW55WM44CC56eR5oqA6Jm95piv5Y+M5YiD5YmR77yM5L2G5a6D5Lmf5Li66Kej5Yaz6K645aSa5YWo55CD5oCn6Zeu6aKY5o+Q5L6b5LqG5biM5pyb77yM5L6L5aaC5rCU5YCZ5Y+Y5YyW44CB55a+55eF5rK755aX5ZKM6LWE5rqQ566h55CG44CC5pyq5p2l77yM5oiR5Lus5bqU5pu05pm65oWn5Zyw6L+Q55So5oqA5pyv77yM5L2/5YW25oiQ5Li65o6o5Yqo56S+5Lya6L+b5q2l55qE6YeN6KaB5Yqb6YeP77yM6ICM5LiN5piv5a+55Lq657G75Lqn55Sf6LSf6Z2i5b2x5ZON44CC6YCa6L+H5pWZ6IKy5ZKM5Yib5paw77yM5oiR5Lus5Y+v5Lul5Zyo5Lqr5Y+X56eR5oqA5bim5p2l55qE5L6/5Yip55qE5ZCM5pe277yM5L+D6L+b5Y+v5oyB57ut5Y+R5bGV77yM5Li65LiL5LiA5Luj5Yib6YCg5pu0576O5aW955qE5LiW55WM44CC6L+Z5Liq5q616JC95ra155uW5LqG56eR5oqA5Y+R5bGV55qE5LyY5Yqj5Yq/5Lul5Y+K5a+55pyq5p2l55qE5bGV5pyb77yM5biM5pyb6IO95aSf5ruh6Laz5oKo55qE6KaB5rGC77yB5aaC5p6c6ZyA6KaB6LCD5pW05oiW5re75Yqg5YaF5a6577yM6K+35ZGK6K+J5oiR44CCCg==");

    // assert
    try expect(test1);
    try expect(test2);
    try expect(test3);
}

test "test decode" {
    // prepare
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // act
    const decoded1 = try decode(allocator, "SSdtIHRlc3RpbmcgYmFzZTY0IGVuY29kZXI=");
    const decoded2 = try decode(allocator, "VGhpcyBvbmUgaXMgZW5jb2RlZCBjb3JyZWN0bHkuICRAIyQqQCg9PT05Ky8=");
    const decoded3 = try decode(allocator, "5b2T54S25Y+v5Lul77yB5Lul5LiL5piv5LiA5LiqMzAw5a2X55qE5Lit5paH5q616JC977ya5Zyo5b+r6YCf5Y+R5bGV55qE546w5Luj56S+5Lya5Lit77yM56eR5oqA5q2j5Zyo5Lul5oOK5Lq655qE6YCf5bqm5pS55Y+Y5oiR5Lus55qE55Sf5rS744CC5LuO5pm66IO95omL5py65Yiw5Lq65bel5pm66IO977yM56eR5oqA5Yib5paw6LWL5LqI5Lq65Lus5peg5pWw5paw55qE5Y+v6IO95oCn44CC5a6D5LiN5LuF5o+Q6auY5LqG5oiR5Lus55qE5bel5L2c5pWI546H77yM6L+Y5L2/5rKf6YCa5Y+Y5b6X5pu05Yqg5pa55L6/44CC54S26ICM77yM6L+Z56eN5oqA5pyv55qE6aOe6YCf5Y+R5bGV5Lmf5bim5p2l5LqG5oyR5oiY77yM5q+U5aaC5L+h5oGv5a6J5YWo6Zeu6aKY5ZKM6L+H5bqm5L6d6LWW44CC6Z2i5a+56L+Z5Lqb6Zeu6aKY77yM5oiR5Lus6ZyA6KaB5L+d5oyB6K2m5oOV77yM5ZCI55CG5L2/55So56eR5oqA5bel5YW377yM5ZCM5pe25Z+55YW75om55Yik5oCn5oCd57u077yM5Lul6YCC5bqU5LiN5pat5Y+Y5YyW55qE5LiW55WM44CC56eR5oqA6Jm95piv5Y+M5YiD5YmR77yM5L2G5a6D5Lmf5Li66Kej5Yaz6K645aSa5YWo55CD5oCn6Zeu6aKY5o+Q5L6b5LqG5biM5pyb77yM5L6L5aaC5rCU5YCZ5Y+Y5YyW44CB55a+55eF5rK755aX5ZKM6LWE5rqQ566h55CG44CC5pyq5p2l77yM5oiR5Lus5bqU5pu05pm65oWn5Zyw6L+Q55So5oqA5pyv77yM5L2/5YW25oiQ5Li65o6o5Yqo56S+5Lya6L+b5q2l55qE6YeN6KaB5Yqb6YeP77yM6ICM5LiN5piv5a+55Lq657G75Lqn55Sf6LSf6Z2i5b2x5ZON44CC6YCa6L+H5pWZ6IKy5ZKM5Yib5paw77yM5oiR5Lus5Y+v5Lul5Zyo5Lqr5Y+X56eR5oqA5bim5p2l55qE5L6/5Yip55qE5ZCM5pe277yM5L+D6L+b5Y+v5oyB57ut5Y+R5bGV77yM5Li65LiL5LiA5Luj5Yib6YCg5pu0576O5aW955qE5LiW55WM44CC6L+Z5Liq5q616JC95ra155uW5LqG56eR5oqA5Y+R5bGV55qE5LyY5Yqj5Yq/5Lul5Y+K5a+55pyq5p2l55qE5bGV5pyb77yM5biM5pyb6IO95aSf5ruh6Laz5oKo55qE6KaB5rGC77yB5aaC5p6c6ZyA6KaB6LCD5pW05oiW5re75Yqg5YaF5a6577yM6K+35ZGK6K+J5oiR44CCCg==");

    const test1 = std.mem.eql(u8, decoded1, "I'm testing base64 encoder");
    const test2 = std.mem.eql(u8, decoded2, "This one is encoded correctly. $@#$*@(===9+/");
    const test3 = std.mem.eql(u8, decoded3, "当然可以！以下是一个300字的中文段落：在快速发展的现代社会中，科技正在以惊人的速度改变我们的生活。从智能手机到人工智能，科技创新赋予人们无数新的可能性。它不仅提高了我们的工作效率，还使沟通变得更加方便。然而，这种技术的飞速发展也带来了挑战，比如信息安全问题和过度依赖。面对这些问题，我们需要保持警惕，合理使用科技工具，同时培养批判性思维，以适应不断变化的世界。科技虽是双刃剑，但它也为解决许多全球性问题提供了希望，例如气候变化、疾病治疗和资源管理。未来，我们应更智慧地运用技术，使其成为推动社会进步的重要力量，而不是对人类产生负面影响。通过教育和创新，我们可以在享受科技带来的便利的同时，促进可持续发展，为下一代创造更美好的世界。这个段落涵盖了科技发展的优劣势以及对未来的展望，希望能够满足您的要求！如果需要调整或添加内容，请告诉我。\n");

    // assert
    try expect(test1);
    try expect(test2);
    try expect(test3);
}
