const std = @import("std");
const rl = @import("raylib");
const df = @import("../define.zig");
const Paddle = @import("paddle.zig");

const CPU = @This();
paddle: Paddle,

pub fn init(cpu_x: i32, cpu_y: i32) CPU {
    const super = Paddle.init(cpu_x, cpu_y);
    return CPU{
        .paddle = super,
    };
}

pub fn update(self: *CPU, ball_y: f32) void {
    const ball: i32 = @intFromFloat(ball_y);
    if (self.*.paddle.y + (@as(i32, @intFromFloat(df.PADDLE_HEIGHT)) / 2) > ball) {
        self.*.paddle.y = self.*.paddle.y - self.*.paddle.speed;
    }

    if (self.*.paddle.y + (@as(i32, @intFromFloat(df.PADDLE_HEIGHT)) / 2) <= ball) {
        self.*.paddle.y = self.*.paddle.y + self.*.paddle.speed;
    }

    self.*.paddle.limitMovement();
}

pub fn draw(self: CPU) void {
    self.paddle.draw();
}
