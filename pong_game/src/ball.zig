const std = @import("std");
const rl = @import("raylib");
const df = @import("define.zig");

const middle_pos_x: f32 = @as(f32, @floatFromInt(df.SCREEN_WIDTH)) / 2;
const middle_pos_y: f32 = @as(f32, @floatFromInt(df.SCREEN_HEIGHT)) / 2;

const Ball = @This();
x: f32,
y: f32,
speed_x: i32,
speed_y: i32,
radius: i32,
player_score: u16 = 0,
cpu_score: u16 = 0,

pub fn init(radius: i32, speed_x: i32, speed_y: i32) Ball {
    return Ball{
        .radius = radius,
        .x = middle_pos_x,
        .y = middle_pos_y,
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
    self.*.x += @as(f32, @floatFromInt(self.*.speed_x));

    const y: i32 = @intFromFloat(self.*.y);
    const x: i32 = @intFromFloat(self.*.x);

    if ((y + self.*.radius) >= rl.getScreenHeight() or (y - self.*.radius) <= 0) {
        self.*.speed_y *= -1;
    }

    if ((x + self.*.radius) >= rl.getScreenWidth()) {
        // cpu scores
        self.*.cpu_score += 1;
        resetBall(self);
    }

    if ((x - self.*.radius) <= 0) {
        // player scores
        self.*.player_score += 1;
        resetBall(self);
    }
}

pub fn checkForCollisionWithPaddle(self: *Ball, paddle: rl.Rectangle) void {
    const ballV2 = rl.Vector2{
        .x = self.*.x,
        .y = self.*.y,
    };

    if (rl.checkCollisionCircleRec(ballV2, @floatFromInt(self.*.radius), paddle)) {
        self.*.speed_x *= -1;
        self.*.x += @as(f32, @floatFromInt(self.*.speed_x));
    }
}

fn resetBall(self: *Ball) void {
    self.*.x = middle_pos_x;
    self.*.y = middle_pos_y;

    const speed_choices: [2]i8 = .{ -1, 1 };
    var idx: usize = 0;
    if (rl.getRandomValue(0, 1) != 0) {
        idx = 1;
    }
    self.*.speed_x *= speed_choices[idx];
    self.*.speed_y *= speed_choices[idx];
}
