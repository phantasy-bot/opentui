// iTerm2 inline images protocol commands

const std = @import("std");

// iTerm2 inline images protocol
// Format: ESC ] 1337;File=inline=1:[options]:<base64-data> BEL
pub const IMAGE = struct {
    // Write iTerm2 inline image
    pub fn write(writer: anytype, width: u32, height: u32, base64_data: []const u8) void {
        // iTerm2 uses PNG format, inline=1 means display inline
        // Width and height are in pixels
        std.fmt.format(writer, "\x1b]1337;File=inline=1;width={d}px;height={d}px:{s}\x07", .{
            width, height, base64_data,
        }) catch {};
    }

    // Write iTerm2 inline image with aspect ratio control
    pub fn writeWithAspect(writer: anytype, width: u32, height: u32, base64_data: []const u8, preserveAspectRatio: bool) void {
        var opts = std.ArrayList(u8).init(std.heap.page_allocator);
        defer opts.deinit();

        std.fmt.format(opts.writer(), "inline=1;width={d}px;height={d}px", .{ width, height }) catch {};

        if (!preserveAspectRatio) {
            std.fmt.format(opts.writer(), ";preserveAspectRatio=0") catch {};
        }

        std.fmt.format(writer, "\x1b]1337;File={s}:{s}\x07", .{ opts.items, base64_data }) catch {};
    }
};
