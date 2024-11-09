const Snake = @import("snake.zig");
const Food = @import("food.zig");

const Game = @This();

snake: Snake,
food: Food,

pub fn init() !Game {
    return Game{
        .snake = try Snake.init(),
        .food = Food.init(),
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
}
