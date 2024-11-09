const std = @import("std");
const rl = @import("raylib");
const Snake = @import("snake.zig");
const Food = @import("food.zig");
const dg = @import("define_global.zig");
const deque = @import("deque");

const Deque = deque.Deque(rl.Vector2);
const Game = @This();

snake: Snake,
food: Food,
running: bool = true,

pub fn init() !Game {
    const s = try Snake.init();
    return Game{
        .snake = s,
        .food = Food.init(s.body),
    };
}

pub fn deinit(self: Game) void {
    self.snake.deinit();
    self.food.deinit();
}

pub fn draw(self: Game) void {
    self.food.draw();
    self.snake.draw();
}

pub fn update(self: *Game) !void {
    if (self.*.running) {
        try self.*.snake.update();
        checkCollisionWithFood(self);
        try checkCollisionWithEdges(self);
        try checkCollisionWithTail(self);
    }
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

pub fn checkCollisionWithEdges(self: *Game) !void {
    if (null == self.*.snake.body.front()) {
        return;
    }

    const head = self.*.snake.body.front().?;
    if (head.x == dg.CELLCOUNT or -1 == head.x) {
        try gameOver(self);
    }
    if (head.y == dg.CELLCOUNT or -1 == head.y) {
        try gameOver(self);
    }
}

pub fn checkCollisionWithTail(self: *Game) !void {
    if (null == self.*.snake.body.front()) {
        return;
    }

    const head = rl.Vector2{
        .x = self.*.snake.body.front().?.x,
        .y = self.*.snake.body.front().?.y,
    };

    var head_less_body = try Deque.init(dg.ALLOCATOR);
    defer head_less_body.deinit();
    for (1..self.*.snake.body.len()) |idx| {
        const temp = rl.Vector2{
            .x = self.*.snake.body.get(idx).?.x,
            .y = self.*.snake.body.get(idx).?.y,
        };
        try head_less_body.pushBack(temp);
    }

    if (dg.elementInDeque(head, head_less_body)) {
        try gameOver(self);
    }
}

pub fn gameOver(self: *Game) !void {
    try self.*.snake.reset();
    self.*.food.position = Food.generateRandomPos(self.*.snake.body);
    self.*.running = false;
}
