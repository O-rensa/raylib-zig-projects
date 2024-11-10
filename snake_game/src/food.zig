const std = @import("std");
const rl = @import("raylib");
const dg = @import("define_global.zig");
const deque = @import("deque");

const Deque = deque.Deque(rl.Vector2);

const Food = @This();
// fields
texture: rl.Texture2D,
position: rl.Vector2,

pub fn init(snake_body: Deque) Food {
    const food_path = dg.CWD ++ dg.FOODPATH; // dg.CWD and dg.FOODPATH is both []const u8;
    const img = rl.loadImage(@as([*:0]const u8, @ptrCast(food_path))); // convert []const u8 to [*:0]const u8
    defer rl.unloadImage(img);
    const tx = rl.loadTextureFromImage(img);
    return Food{
        .texture = tx,
        .position = generateRandomPos(snake_body),
    };
}

pub fn deinit(self: Food) void {
    rl.unloadTexture(self.texture);
}

pub fn draw(self: Food) void {
    const pos_x: i32 = @intFromFloat(self.position.x);
    const pos_y: i32 = @intFromFloat(self.position.y);
    rl.drawTexture(self.texture, dg.OFFSET + pos_x * dg.CELLSIZE, dg.OFFSET + pos_y * dg.CELLSIZE, rl.Color.white);
}

pub fn generateRandomPos(snake_body: Deque) rl.Vector2 {
    var position = generateRandomCell();
    while (dg.elementInDeque(position, snake_body)) {
        position = generateRandomCell();
    }

    return position;
}

fn generateRandomCell() rl.Vector2 {
    const x = rl.getRandomValue(0, dg.CELLCOUNT - 1);
    const y = rl.getRandomValue(0, dg.CELLCOUNT - 1);

    return rl.Vector2{
        .x = @floatFromInt(x),
        .y = @floatFromInt(y),
    };
}
