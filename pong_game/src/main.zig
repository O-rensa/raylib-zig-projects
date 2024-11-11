const std = @import("std");
const rl = @import("raylib");

pub fn main() !void {
    const screen_width = 1280;
    const screen_height = 800;

    rl.initWindow(screen_width, screen_height, "raylib-zig Pong Game");
    defer rl.closeWindow(); // Close window and OpenGL context
    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        rl.beginDrawing();
        defer rl.endDrawing();

        // drawing
        {
            rl.drawLine(screen_width / 2, 0, screen_width / 2, screen_height, rl.Color.white);
            // draw circle on the middle of the screen;
            rl.drawCircle(screen_width / 2, screen_height / 2, 20, rl.Color.white);

            rl.drawRectangle(10, screen_height / 2 - 60, 25, 120, rl.Color.white);
            rl.drawRectangle(screen_width - 35, screen_height / 2 - 60, 25, 120, rl.Color.white);
        }
    }
}
