function make_mouse_binding(dir, streak, button, mods, action)
  return {
    event = { [dir] = { streak = streak, button = button } },
    mods = mods,
    action = action,
  }
end

local wezterm = require("wezterm")

-- holds onto the configuration
local config = wezterm.config_builder()

local tmux = {}

if wezterm.target_triple == "aarch64-apple-darwin" then
    tmux = { "/bin/zsh", "-l", "-c", "tmux attach -d -t chungus || tmux new-session -s chungus" }
else
    tmux = { "tmux", "new", "-As0" }
end

-- scrollback
config.scrollback_lines = 9999

-- fonts
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 20

-- startup
config.default_prog = tmux

-- theme
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Mocha"

-- copy on select
config.mouse_bindings = {
    make_mouse_binding('Up', 1, 'Left', 'NONE', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
    make_mouse_binding('Up', 1, 'Left', 'SHIFT', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
    make_mouse_binding('Up', 1, 'Left', 'ALT', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
    make_mouse_binding('Up', 1, 'Left', 'SHIFT|ALT', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
    make_mouse_binding('Up', 2, 'Left', 'NONE', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
    make_mouse_binding('Up', 3, 'Left', 'NONE', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
}

return config
