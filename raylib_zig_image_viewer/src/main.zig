const std = @import("std");
const rl = @import("raylib");

const Texture2dArrayList = std.ArrayList(rl.Texture2D);

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

    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
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
                rl.setTextureFilter(texture, rl.TextureFilter.texture_filter_trilinear);
                try textures.append(texture);
            }
        }

        { // drawing
            rl.beginDrawing();
            defer rl.endDrawing();
            rl.clearBackground(rl.Color.white); // background color

            var x: i32 = 0;

            for (textures.items) |texture| {
                rl.drawTextureEx(texture, rl.Vector2{ .x = @floatFromInt(x), .y = 0 }, 0, 0.3, rl.Color.white);
                x += texture.width;
            }
        }
    }
}
