local wezterm = require("wezterm")

-- holds onto the configuration
local config = wezterm.config_builder()

local tmux = {}

if wezterm.target_triple == "aarch64-apple-darwin" then
    --tmux = { "/opt/homebrew/bin/tmux", "new-session", "-A", "-s", "chungus", "source-file", "~/.config/tmux/tmux.conf" }
    tmux = { "/bin/zsh", "-l", "-c", "tmux attach -d -t chungus || tmux new-session -s chungus" }
else
    tmux = { "tmux", "new", "-As0" }
end


-- fonts
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 20

-- startup
config.default_prog = tmux

config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Mocha"

return config
