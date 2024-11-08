const std = @import("std");
const rl = @import("raylib");
const dc = @import("define_const.zig");
const Food = @import("food.zig");

const green: rl.Color = dc.GREEN;
const dark_green: rl.Color = dc.DARK_GREEN;
const cellsize: i32 = dc.CELLSIZE;
const cellcount: i32 = dc.CELLCOUNT;

pub fn main() !void {
    const screenWidth: i32 = cellsize * cellcount; // 750 px
    const screenHeight: i32 = cellsize * cellcount; // 750 px

    rl.initWindow(screenWidth, screenHeight, "Raylib Snake");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    const food = Food.init();
    defer food.deInit();

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        rl.beginDrawing();
        defer rl.endDrawing();

        // drawing
        {
            rl.clearBackground(green);
            food.draw();
        }
    }
}
