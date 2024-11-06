const std = @import("std");
const rl = @import("raylib");

const Texture2dArrayList = std.ArrayList(rl.Texture2D);
const CLEAR_TEXTURES_KEY = rl.KeyboardKey.key_backspace;
const MOUSE_WHEEL_MOVE_SENS = 0.1;
//const TOGGLE_FULLSCREEN_KEY = rl.KeyboardKey.key_f;

pub fn main() !void {
    const screenWidth = 800;
    const screenHeight = 450;
    const VECTOR2ZERO = rl.Vector2.zero();

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
    var target_zoom: f32 = 1;
    var target_rotation: f32 = 0;

    var camera = rl.Camera2D{
        .offset = VECTOR2ZERO,
        .target = VECTOR2ZERO,
        .rotation = 0,
        .zoom = 1,
    };

    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        const mouse_pos = rl.getMousePosition();
        const mouse_wheel_move = rl.getMouseWheelMove();
        const frame_time = rl.getFrameTime();
        // toggle fullscreen
        //if (rl.isKeyPressed(TOGGLE_FULLSCREEN_KEY)) {
        //    rl.toggleFullscreen();
        //}

        // set zoom back to 1
        if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_middle)) {
            camera = focusCamera(camera, mouse_pos);
            target_zoom = 1;
        }

        // deletes the all the picture(s) if backspace is clicked
        if (rl.isKeyPressed(CLEAR_TEXTURES_KEY)) {
            for (textures.items) |texture| {
                rl.unloadTexture(texture);
            }
            textures.clearRetainingCapacity();
        }

        // move the image
        if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_left)) {
            const translation = rl.Vector2.negate(rl.Vector2.scale(rl.getMouseDelta(), 1 / target_zoom));
            camera.target = rl.Vector2.add(camera.target, rl.Vector2.rotate(translation, camera.rotation * (3.14169265 / 180.0) * (-1)));
        }

        // zoom or rotate
        if (mouse_wheel_move != 0) {
            if (rl.isKeyDown(rl.KeyboardKey.key_left_shift)) { // left shiftkey + mouse wheel move
                // rotate
                target_rotation += mouse_wheel_move * 15;
                camera = focusCamera(camera, mouse_pos);
                camera.rotation = rl.math.lerp(camera.rotation, target_rotation, (frame_time / 0.2));
            } else {
                // zoom
                if (target_zoom >= 0.3) {
                    target_zoom += mouse_wheel_move * MOUSE_WHEEL_MOVE_SENS;
                    camera = focusCamera(camera, mouse_pos);
                    camera.zoom *= std.math.pow(f32, (target_zoom / camera.zoom), (frame_time / 0.2));
                } else {
                    target_zoom = 0.3;
                }
            }
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

            var x: i32 = 0;

            {
                rl.beginMode2D(camera);
                defer rl.endMode2D();

                for (textures.items) |texture| {
                    rl.drawTexture(texture, x, 0, rl.Color.white);
                    x += texture.width;
                }
            }
        }
    }
}

fn focusCamera(camera: rl.Camera2D, screen_position: rl.Vector2) rl.Camera2D {
    var cam = camera; // always assume pass by reference, therefore create a clone
    cam.target = rl.getScreenToWorld2D(screen_position, cam);
    cam.offset = screen_position;
    return cam;
}

// I always prefer not using pointers so the code below would not be used
fn focusCameraPointer(camera: *rl.Camera2D, screen_position: rl.Vector2) void {
    // pointer.* => this is how you dereference a pointer in zig
    camera.*.target = rl.getScreenToWorld2D(screen_position, camera.*);
    camera.*.offset = screen_position;
}
