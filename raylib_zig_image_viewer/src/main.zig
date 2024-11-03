const std = @import("std");
const rl = @import("raylib");

const Texture2dArrayList = std.ArrayList(rl.Texture2D);
const CLEAR_TEXTURES_KEY = rl.KeyboardKey.key_backspace;
const MOUSE_WHEEL_MOVE_SENS = 0.01;

pub fn main() !void {
    const screenWidth = 800;
    const screenHeight = 450;

    rl.setConfigFlags(rl.ConfigFlags{ .window_resizable = true, .vsync_hint = true });
    rl.initWindow(screenWidth, screenHeight, "Raylib Image Viewer");
    defer rl.closeWindow(); // Close window and OpenGL context
    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    // arena allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var textures = Texture2dArrayList.init(allocator);
    defer {
        for (textures.items) |texture| {
            rl.unloadTexture(texture);
        }

        textures.deinit();
    }

    const txtr_filter = rl.TextureFilter.texture_filter_trilinear;
    var translation = rl.Vector2{ .x = 0, .y = 0 };
    var zoom: f32 = 0.3;

    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // deletes the all the picture(s) if backspace is clicked
        if (rl.isKeyPressed(CLEAR_TEXTURES_KEY)) {
            for (textures.items) |texture| {
                rl.unloadTexture(texture);
            }
            textures.clearRetainingCapacity();
        }

        if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_left)) {
            translation = rl.Vector2.add(translation, rl.getMouseDelta());
        }

        const mouse_wheel_move = rl.getMouseWheelMove();
        if (mouse_wheel_move != 0) {
            zoom += mouse_wheel_move * MOUSE_WHEEL_MOVE_SENS;
        }

        if (rl.isFileDropped()) {
            const dropped_files = rl.loadDroppedFiles();
            defer rl.unloadDroppedFiles(dropped_files);
            // convert to slice
            const dropped_files_slice = dropped_files.paths[0..dropped_files.count];
            for (dropped_files_slice) |dropped_file_path| {
                var texture = rl.loadTexture(dropped_file_path);
                if (0 == texture.id) continue;

                // generate mipmaps
                rl.genTextureMipmaps(&texture);
                if (1 == texture.mipmaps) { // check mipmaps
                    std.debug.print("{s}", .{"Mipmaps failed to generate! \n"});
                }

                // set texture filter
                rl.setTextureFilter(texture, txtr_filter);
                try textures.append(texture);
            }
        }

        { // drawing or rendering
            rl.beginDrawing();
            defer rl.endDrawing();
            rl.clearBackground(rl.Color.white); // background color

            var x: f32 = 0;

            for (textures.items) |texture| {
                rl.drawTextureEx(texture, rl.Vector2{ .x = x + translation.x, .y = 0 + translation.y }, 0, zoom, rl.Color.white);
                const width: f32 = @floatFromInt(texture.width);
                x += width * 0.3;
            }
        }
    }
}
