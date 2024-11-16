const std = @import("std");
const rl = @import("raylib");

const Ball = @This();
x: f32,
y: f32,
speed_x: i32,
speed_y: i32,
radius: i32,

pub fn init(radius: i32, x_pos: f32, y_pos: f32, speed_x: i32, speed_y: i32) Ball {
    return Ball{
        .radius = radius,
        .x = x_pos,
        .y = y_pos,
        .speed_x = speed_x,
        .speed_y = speed_y,
    };
}

pub fn draw(self: Ball) void {
    const x: i32 = @intFromFloat(self.x);
    const y: i32 = @intFromFloat(self.y);
    const radius: f32 = @floatFromInt(self.radius);
    rl.drawCircle(x, y, radius, rl.Color.white);
}

pub fn update(self: *Ball) void {
    self.*.y += @as(f32, @floatFromInt(self.*.speed_y));
    self.*.x += @as(f32, @floatFromInt(self.speed_x));

    const y: i32 = @intFromFloat(self.*.y);
    const x: i32 = @intFromFloat(self.*.x);

    if ((y + self.*.radius) >= rl.getScreenHeight() or (y - self.*.radius) <= 0) {
        self.*.speed_y *= -1;
    }

    if ((x + self.*.radius) >= rl.getScreenWidth() or (x - self.*.radius) <= 0) {
        self.*.speed_x *= -1;
    }
}
