const std = @import("std");
const rl = @import("raylib");
const dc = @import("define_const.zig");

const cell_size: i32 = dc.CELLSIZE;
const cell_count: i32 = dc.CELLCOUNT;
const food_path = dc.FOODPATH;

const Food = @This();
// fields
texture: rl.Texture2D,
position: rl.Vector2,

pub fn init() Food {
    const img = rl.loadImage(food_path);
    defer rl.unloadImage(img);
    const tx = rl.loadTextureFromImage(img);
    return Food{
        .texture = tx,
        .position = generateRandomPos(),
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

pub fn generateRandomPos() rl.Vector2 {
    const x = rl.getRandomValue(0, cell_count - 1);
    const y = rl.getRandomValue(0, cell_count - 1);

    return rl.Vector2{
        .x = @floatFromInt(x),
        .y = @floatFromInt(y),
    };
}
