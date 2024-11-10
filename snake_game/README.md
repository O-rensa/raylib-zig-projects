# How to build?

1. Open terminal on current directory and run:

```bash
zig fetch --save https://github.com/Not-Nik/raylib-zig/archive/devel.tar.gz
```
```bash
zig fetch --save https://github.com/magurotuna/zig-deque/archive/refs/heads/main.zip
```
Disregard all of the dependency override error

2. Get the current directory PATH and copy

3. Open ./src/define_global.zig

4. On pub const CWD, change the value to PATH you copied

5. Save changes

Run:
```bash
zig build run
```