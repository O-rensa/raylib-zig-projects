const std = @import("std");
const rl = @import("raylib");
const dg = @import("define_global.zig");
const Game = @import("game.zig");

pub fn main() !void {
    const screen_width: i32 = (2 * dg.OFFSET) + dg.CELLSIZE * dg.CELLCOUNT;
    const screen_height: i32 = (2 * dg.OFFSET) + dg.CELLSIZE * dg.CELLCOUNT;
    var last_update_time: f64 = 0;
    var hasError: bool = false;
    var canChangeDirectionParams: bool = false;

    const rect = rl.Rectangle{
        .x = @floatFromInt(dg.OFFSET - 5),
        .y = @floatFromInt(dg.OFFSET - 5),
        .height = @floatFromInt(dg.CELLSIZE * dg.CELLCOUNT + 10),
        .width = @floatFromInt(dg.CELLSIZE * dg.CELLCOUNT + 10),
    };

    rl.initWindow(screen_width, screen_height, "Raylib Snake");
    defer {
        rl.closeWindow(); // Close window and OpenGL context
        last_update_time = 0; // set last_update_time = 0
        hasError = false;
    }

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    var g: ?Game = Game.init() catch null;
    defer g.?.deinit();

    // Main game loop
    while (!rl.windowShouldClose() and g != null and !hasError) { // Detect window close button or ESC key
        rl.beginDrawing();
        defer rl.endDrawing();

        const game = &(g.?);

        // update snake
        if (eventTriggered(0.2, &last_update_time)) {
            canChangeDirectionParams = true;
            game.*.update() catch {
                hasError = true;
                continue;
            };
        }

        // events
        if (rl.isKeyPressed(rl.KeyboardKey.key_up) and game.*.snake.direction.y != 1) {
            if (canChangeDirectionParams) {
                game.*.snake.direction.x = 0;
                game.*.snake.direction.y = -1;
                canChangeDirectionParams = false;
            }
            game.*.running = true;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.key_down) and game.*.snake.direction.y != -1) {
            if (canChangeDirectionParams) {
                game.*.snake.direction.x = 0;
                game.*.snake.direction.y = 1;
                canChangeDirectionParams = false;
            }
            game.*.running = true;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.key_left) and game.*.snake.direction.x != 1) {
            if (canChangeDirectionParams) {
                game.*.snake.direction.x = -1;
                game.*.snake.direction.y = 0;
                canChangeDirectionParams = false;
            }
            game.*.running = true;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.key_right) and game.*.snake.direction.x != -1) {
            if (canChangeDirectionParams) {
                game.*.snake.direction.x = 1;
                game.*.snake.direction.y = 0;
                canChangeDirectionParams = false;
            }
            game.*.running = true;
        }

        // drawing
        {
            rl.clearBackground(dg.GREEN);
            rl.drawRectangleLinesEx(rect, 5, dg.DARK_GREEN);
            rl.drawText("Retro Snake", dg.OFFSET - 5, 20, 40, dg.DARK_GREEN);
            rl.drawText(rl.textFormat("%i", .{game.*.score}), dg.OFFSET - 5, dg.OFFSET + dg.CELLSIZE * dg.CELLCOUNT + 10, 40, dg.DARK_GREEN);
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
