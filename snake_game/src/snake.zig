const std = @import("std");
const rl = @import("raylib");
const dc = @import("define_const.zig");

const cell_size = dc.CELLSIZE;
const dark_green = dc.DARK_GREEN;
const Snake = @This();
const allocator = std.heap.page_allocator;
const ArrayList = std.ArrayList(rl.Vector2);
// fields
body: ArrayList,

pub fn init() !Snake {
    var s = Snake{
        .body = ArrayList.init(allocator),
    };
    try s.body.append(rl.Vector2{
        .x = 6,
        .y = 9,
    });
    try s.body.append(rl.Vector2{
        .x = 5,
        .y = 9,
    });
    try s.body.append(rl.Vector2{
        .x = 4,
        .y = 9,
    });
    return s;
}

pub fn deinit(self: Snake) void {
    self.body.deinit();
}

pub fn draw(self: Snake) void {
    for (self.body.items) |item| {
        const pos_x: i32 = @intFromFloat(item.x);
        const pos_y: i32 = @intFromFloat(item.y);
        rl.drawRectangle(pos_x * cell_size, pos_y * cell_size, cell_size, cell_size, dark_green);
    }
}
