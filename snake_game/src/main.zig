const std = @import("std");
const rl = @import("raylib");
const dg = @import("define_global.zig");
const Game = @import("game.zig");

const green: rl.Color = dg.GREEN;
const dark_green: rl.Color = dg.DARK_GREEN;
const cell_size: i32 = dg.CELLSIZE;
const cell_count: i32 = dg.CELLCOUNT;

pub fn main() !void {
    const screen_width: i32 = cell_size * cell_count; // 750 px
    const screen_height: i32 = cell_size * cell_count; // 750 px
    var last_update_time: f64 = 0;
    var hasError: bool = false;

    rl.initWindow(screen_width, screen_height, "Raylib Snake");
    defer {
        rl.closeWindow(); // Close window and OpenGL context
        last_update_time = 0; // set last_update_time = 0
        hasError = false;
    }

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    var g: ?Game = Game.init() catch null;
    defer g.?.deInit();

    // Main game loop
    while (!rl.windowShouldClose() and g != null and !hasError) { // Detect window close button or ESC key
        rl.beginDrawing();
        defer rl.endDrawing();

        const game = &(g.?);

        // update snake
        if (eventTriggered(0.2, &last_update_time)) {
            game.*.update() catch {
                hasError = true;
                continue;
            };
        }

        // events
        if (rl.isKeyPressed(rl.KeyboardKey.key_up) and game.*.snake.direction.y != 1) {
            game.*.snake.direction.x = 0;
            game.*.snake.direction.y = -1;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.key_down) and game.*.snake.direction.y != -1) {
            game.*.snake.direction.x = 0;
            game.*.snake.direction.y = 1;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.key_left) and game.*.snake.direction.x != 1) {
            game.*.snake.direction.x = -1;
            game.*.snake.direction.y = 0;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.key_right) and game.*.snake.direction.x != -1) {
            game.*.snake.direction.x = 1;
            game.*.snake.direction.y = 0;
        }

        // drawing
        {
            rl.clearBackground(green);
            game.*.draw();
        }
    }
}

fn eventTriggered(interval: f64, last_update_time: *f64) bool {
    const currentTime: f64 = rl.getTime();
    if ((currentTime - last_update_time.*) >= interval) {
        last_update_time.* = currentTime;
        return true;
    } else {
        return false;
    }
}
