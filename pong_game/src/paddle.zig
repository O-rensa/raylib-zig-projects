const std = @import("std");
const rl = @import("raylib");

const Paddle = @This();
x: i32,
y: i32,
width: f32,
height: f32,
speed: i32,

pub fn init(player_x: i32, player_y: i32, width: f32, height: f32, speed: i32) Paddle {
    return Paddle{
        .x = player_x,
        .y = player_y,
        .width = width,
        .height = height,
        .speed = speed,
    };
}

pub fn update(self: *Paddle) void {
    if (rl.isKeyDown(rl.KeyboardKey.key_up)) {
        self.*.y = self.*.y - self.*.speed;
    }

    if (rl.isKeyDown(rl.KeyboardKey.key_down)) {
        self.*.y = self.*.y + self.*.speed;
    }

    if (self.*.y <= 0) {
        self.*.y = 0;
    }

    if (self.*.y + @as(i32, @intFromFloat(self.*.height)) >= rl.getScreenHeight()) {
        self.*.y = rl.getScreenHeight() - @as(i32, @intFromFloat(self.*.height));
    }
}

pub fn draw(self: Paddle) void {
    rl.drawRectangle(self.x, self.y, @intFromFloat(self.width), @intFromFloat(self.height), rl.Color.white);
}
