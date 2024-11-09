const std = @import("std");
const rl = @import("raylib");
const dc = @import("define_const.zig");
const deque = @import("deque");

const cell_size = dc.CELLSIZE;
const dark_green = dc.DARK_GREEN;
const Snake = @This();
const allocator = std.heap.page_allocator;
const Deque = deque.Deque(rl.Vector2);
// fields
body: Deque,

pub fn init() !Snake {
    var s = Snake{
        .body = try Deque.init(allocator),
    };
    try s.body.pushBack(rl.Vector2{
        .x = 6,
        .y = 9,
    });
    try s.body.pushBack(rl.Vector2{
        .x = 5,
        .y = 9,
    });
    try s.body.pushBack(rl.Vector2{
        .x = 4,
        .y = 9,
    });
    return s;
}

pub fn deinit(self: Snake) void {
    self.body.deinit();
}

pub fn draw(self: Snake) void {
    for (0..self.body.len()) |idx| {
        const pos_x: f32 = self.body.get(idx).?.x;
        const pos_y: f32 = self.body.get(idx).?.y;
        const segment = rl.Rectangle{
            .x = pos_x * @as(f32, cell_size),
            .y = pos_y * @as(f32, cell_size),
            .width = @as(f32, cell_size),
            .height = @as(f32, cell_size),
        };
        rl.drawRectangleRounded(segment, 0.5, 6, dark_green);
    }
}
