local wezterm = require("wezterm")

function get_prog()
    if wezterm.target_triple == "aarch64-apple-darwin" then
        return { "/bin/zsh", "-l", "-c", "tmux attach -d -t chungus || tmux new-session -s chungus" }
    else
        return { "tmux", "new", "-As0" }
    end
end

return {
    -- theme
    window_decorations = "RESIZE",
    color_scheme = "Catppuccin Mocha",
    adjust_window_size_when_changing_font_size = false, -- Prevent unnecessary resizing

    enable_tab_bar = false,
    enable_scroll_bar = false,
    window_background_opacity = 1.0, -- Avoid transparency to reduce rendering cost
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    
    -- fonts
    term = "xterm-256color",
    font = wezterm.font("FiraCode Nerd Font"),
    font_size = 20,

    -- behaviors
    audible_bell = "Disabled", -- Disable the bell sound
    scrollback_lines = 9999,

    -- tmux launch
    default_prog = get_prog(),


    -- performance -- use wezterm.gui.enumerate_gpus() to check the gpu it uses
    front_end = "WebGpu",
    webgpu_power_preference = "HighPerformance",
    animation_fps = 120, -- Match the ProMotion display on newer Macs (if applicable)
    max_fps = 120, -- Cap the frame rate to your display's refresh rate

    mouse_bindings = {
        -- Copy to clipboard on left mouse drag release
        {
            event = { Up = { streak = 1, button = "Left" } },
            mods = "NONE",
            action = wezterm.action { CopyTo = "Clipboard" },
        },
        -- Copy to clipboard during dragging (as a fallback)
        {
            event = { Drag = { streak = 1, button = "Left" } },
            mods = "NONE",
            action = wezterm.action { CopyTo = "Clipboard" },
        },
    },
}

