const std = @import("std");
const rl = @import("raylib");
const dg = @import("define_global.zig");
const deque = @import("deque");

const cell_size: i32 = dg.CELLSIZE;
const cell_count: i32 = dg.CELLCOUNT;
const food_path = dg.FOODPATH;
const Deque = deque.Deque(rl.Vector2);

const Food = @This();
// fields
texture: rl.Texture2D,
position: rl.Vector2,

pub fn init(snake_body: Deque) Food {
    const img = rl.loadImage(food_path);
    defer rl.unloadImage(img);
    const tx = rl.loadTextureFromImage(img);
    return Food{
        .texture = tx,
        .position = generateRandomPos(snake_body),
    };
}

pub fn deInit(self: Food) void {
    rl.unloadTexture(self.texture);
}

pub fn draw(self: Food) void {
    const pos_x: i32 = @intFromFloat(self.position.x);
    const pos_y: i32 = @intFromFloat(self.position.y);
    rl.drawTexture(self.texture, pos_x * cell_size, pos_y * cell_size, rl.Color.white);
}

pub fn generateRandomPos(snake_body: Deque) rl.Vector2 {
    var position = generateRandomCell();
    while (dg.elementInDeque(position, snake_body)) {
        position = generateRandomCell();
    }

    return position;
}

fn generateRandomCell() rl.Vector2 {
    const x = rl.getRandomValue(0, cell_count - 1);
    const y = rl.getRandomValue(0, cell_count - 1);

    return rl.Vector2{
        .x = @floatFromInt(x),
        .y = @floatFromInt(y),
    };
}
