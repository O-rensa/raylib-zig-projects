const std = @import("std");
const rl = @import("raylib");
const dc = @import("define_const.zig");
const Food = @import("food.zig");
const Snake = @import("snake.zig");

const green: rl.Color = dc.GREEN;
const dark_green: rl.Color = dc.DARK_GREEN;
const cell_size: i32 = dc.CELLSIZE;
const cell_count: i32 = dc.CELLCOUNT;

pub fn main() !void {
    const screenWidth: i32 = cell_size * cell_count; // 750 px
    const screenHeight: i32 = cell_size * cell_count; // 750 px

    rl.initWindow(screenWidth, screenHeight, "Raylib Snake");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    // food
    const food = Food.init();
    defer food.deInit();
    // snake
    var snake = try Snake.init();
    defer snake.deinit();

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        rl.beginDrawing();
        defer rl.endDrawing();

        // drawing
        {
            try snake.update();
            rl.clearBackground(green);
            food.draw();
            snake.draw();
        }
    }
}
