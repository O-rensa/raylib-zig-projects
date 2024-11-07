const std = @import("std");
const rl = @import("raylib");
const dc = @import("define_const.zig");

// food struct
// private
const cellSize: i32 = dc.CELLSIZE;
const darkGreen: rl.Color = dc.DARK_GREEN;

// public
pub var position = rl.Vector2{
    .x = 5,
    .y = 6,
};

pub fn newFood() type {
    return @This();
}

pub fn draw() void {
    const pos_x: i32 = @intFromFloat(position.x);
    const pos_y: i32 = @intFromFloat(position.y);
    rl.drawRectangle(pos_x * cellSize, pos_y * cellSize, cellSize, cellSize, darkGreen);
}
