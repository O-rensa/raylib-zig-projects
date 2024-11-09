const std = @import("std");
const rl = @import("raylib");
const Snake = @import("snake.zig");
const Food = @import("food.zig");

const Game = @This();

snake: Snake,
food: Food,

pub fn init() !Game {
    const s = try Snake.init();
    return Game{
        .snake = s,
        .food = Food.init(s.body),
    };
}

pub fn deInit(self: Game) void {
    self.snake.deInit();
    self.food.deInit();
}

pub fn draw(self: Game) void {
    self.food.draw();
    self.snake.draw();
}

pub fn update(self: *Game) !void {
    try self.*.snake.update();
    checkCollisionWithFood(self);
}

pub fn checkCollisionWithFood(self: *Game) void {
    if (null == self.*.snake.body.front()) {
        return;
    }

    const snake_head = rl.Vector2{
        .x = self.*.snake.body.front().?.x,
        .y = self.*.snake.body.front().?.y,
    };

    if (1 == rl.Vector2.equals(snake_head, self.*.food.position)) {
        self.*.food.position = Food.generateRandomPos(self.*.snake.body);
        self.*.snake.addSegment = true;
    }
}
