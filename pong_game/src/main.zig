const std = @import("std");
const rl = @import("raylib");

const Ball = @import("ball.zig");
const Paddle = @import("paddle.zig");

pub fn main() !void {
    const screen_width: i32 = 1280;
    const screen_height: i32 = 800;
    const player_width: f32 = 25;
    const player_height: f32 = 120;
    const player_speed: i32 = 6;

    rl.initWindow(screen_width, screen_height, "raylib-zig Pong Game");
    defer rl.closeWindow(); // Close window and OpenGL context
    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    // ball
    var ball = Ball.init(20, screen_width / 2, screen_height / 2, 7, 7);
    var player = Paddle.init(screen_width - player_width - 10, (screen_height / 2) - (player_height / 2), player_width, player_height, player_speed);

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        rl.beginDrawing();
        defer rl.endDrawing();

        // update
        {
            ball.update();
            player.update();
        }

        // drawing
        {
            // clear background
            rl.clearBackground(rl.Color.black);

            rl.drawLine(screen_width / 2, 0, screen_width / 2, screen_height, rl.Color.white);
            // draw circle on the middle of the screen;
            ball.draw();

            rl.drawRectangle(0, screen_height / 2 - 60, 25, 120, rl.Color.white);
            player.draw();
        }
    }
}
