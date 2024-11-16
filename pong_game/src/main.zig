const std = @import("std");
const rl = @import("raylib");
const df = @import("define.zig");

const Ball = @import("ball.zig");
const Paddle = @import("paddles/paddle.zig");
const CPU = @import("paddles/cpu_paddle.zig");

pub fn main() !void {
    const screen_width: i32 = df.SCREEN_WIDTH;
    const screen_height: i32 = df.SCREEN_HEIGHT;

    rl.initWindow(screen_width, screen_height, "raylib-zig Pong Game");
    defer rl.closeWindow(); // Close window and OpenGL context
    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    // ball
    var ball = Ball.init(20, screen_width / 2, screen_height / 2, 7, 7);
    var player = Paddle.init(
        df.SCREEN_WIDTH - df.PADDLE_WIDTH - 10,
        (df.SCREEN_HEIGHT / 2) - (df.PADDLE_HEIGHT / 2),
    );
    var cpu = CPU.init(10, (df.SCREEN_HEIGHT / 2 - df.PADDLE_HEIGHT / 2));

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        rl.beginDrawing();
        defer rl.endDrawing();

        // update
        {
            ball.update();
            player.update();
            cpu.update(ball.y);
        }

        // drawing
        {
            // clear background
            rl.clearBackground(rl.Color.black);

            rl.drawLine(screen_width / 2, 0, screen_width / 2, screen_height, rl.Color.white);
            // draw circle on the middle of the screen;
            ball.draw();

            cpu.draw();
            player.draw();
        }
    }
}
