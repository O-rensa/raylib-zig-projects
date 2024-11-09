const std = @import("std");
const rl = @import("raylib");
const dg = @import("define_global.zig");
const deque = @import("deque");

const Deque = deque.Deque(rl.Vector2);

const Snake = @This();
// fields
body: Deque,
direction: rl.Vector2 = rl.Vector2{
    .x = 1,
    .y = 0,
},
addSegment: bool = false,

pub fn init() !Snake {
    var s = Snake{
        .body = try Deque.init(dg.ALLOCATOR),
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
        if (null == self.body.get(idx)) {
            break;
        }
        const pos_x: f32 = self.body.get(idx).?.x;
        const pos_y: f32 = self.body.get(idx).?.y;
        const segment = rl.Rectangle{
            .x = @as(f32, dg.OFFSET) + pos_x * @as(f32, dg.CELLSIZE),
            .y = @as(f32, dg.OFFSET) + pos_y * @as(f32, dg.CELLSIZE),
            .width = @as(f32, dg.CELLSIZE),
            .height = @as(f32, dg.CELLSIZE),
        };
        rl.drawRectangleRounded(segment, 0.5, 6, dg.DARK_GREEN);
    }
}

pub fn update(self: *Snake) !void {
    if (null == self.*.body.front()) {
        return;
    }

    const headVector = rl.Vector2{
        .x = self.*.body.front().?.x,
        .y = self.*.body.front().?.y,
    };
    try self.*.body.pushFront(rl.Vector2.add(headVector, self.*.direction));

    if (self.*.addSegment) {
        self.*.addSegment = false;
    } else {
        _ = self.*.body.popBack();
    }
}

pub fn reset(self: *Snake) !void {
    self.*.body.deinit();
    self.*.body = try Deque.init(dg.ALLOCATOR);
    try self.*.body.pushBack(rl.Vector2{ .x = 6, .y = 9 });
    try self.*.body.pushBack(rl.Vector2{ .x = 5, .y = 9 });
    try self.*.body.pushBack(rl.Vector2{ .x = 4, .y = 9 });
    self.*.direction = rl.Vector2{ .x = 1, .y = 0 };
}
