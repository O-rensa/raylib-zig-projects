const std = @import("std");
const rl = @import("raylib");
const dc = @import("define_const.zig");

const cellSize: i32 = dc.CELLSIZE;
const darkGreen: rl.Color = dc.DARK_GREEN;
const foodPath = dc.FOODPATH;

const Food = @This();
// fields
texture: rl.Texture2D,
position: rl.Vector2 = rl.Vector2{
    .x = 5,
    .y = 6,
},

pub fn init() Food {
    const img = rl.loadImage(foodPath);
    defer rl.unloadImage(img);
    const tx = rl.loadTextureFromImage(img);
    return Food{
        .texture = tx,
    };
}

pub fn deInit(self: Food) void {
    rl.unloadTexture(self.texture);
}

pub fn draw(self: Food) void {
    const pos_x: i32 = @intFromFloat(self.position.x);
    const pos_y: i32 = @intFromFloat(self.position.y);
    rl.drawTexture(self.texture, pos_x * cellSize, pos_y * cellSize, rl.Color.white);
}
