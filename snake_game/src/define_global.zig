const std = @import("std");
const rl = @import("raylib");
const deque = @import("deque");
const Deque = deque.Deque(rl.Vector2);

pub const GREEN = rl.Color.init(173, 204, 96, 255);
pub const DARK_GREEN = rl.Color.init(43, 51, 24, 255);
pub const CELLSIZE: i32 = 25;
pub const CELLCOUNT: i32 = 25;
pub const FOODPATH = "/home/orensa/Documents/GitHub/raylib-zig-projects/snake_game/src/graphics/food.png";
pub const ALLOCATOR = std.heap.page_allocator;
pub const OFFSET: i32 = 75;

pub fn elementInDeque(element: rl.Vector2, dq: Deque) bool {
    for (0..dq.len()) |idx| {
        if (dq.get(idx) != null) {
            const body = rl.Vector2{
                .x = dq.get(idx).?.x,
                .y = dq.get(idx).?.y,
            };
            if (1 == rl.Vector2.equals(body, element)) {
                return true;
            }
        }
    }

    return false;
}
