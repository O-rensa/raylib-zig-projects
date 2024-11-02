const std = @import("std");
const rlz = @import("raylib");

pub fn main() !void {
    const screenWidth = 800;
    const screenHeight = 450;

    rlz.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rlz.closeWindow(); // Close window and OpenGL context

    rlz.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!rlz.windowShouldClose()) { // Detect window close button or ESC key
        rlz.beginDrawing();
        defer rlz.endDrawing();

        rlz.clearBackground(rlz.Color.white);

        rlz.drawText("Congrats! You created your first window!", 190, 200, 20, rlz.Color.light_gray);
    }
}
