# Set color pallete
set -g @catppuccin_flavor "mocha"

# Pane styling options
set -g @catppuccin_pane_border_style "fg=#{@thm_overlay_0}"
set -g @catppuccin_pane_active_border_style "##{?pane_in_mode,fg=#{@thm_lavender},##{?pane_synchronized,fg=#{@thm_mauve},fg=#{@thm_lavender}}}"

# Window options
set -g @catppuccin_window_status_style "rounded"
set -g @catppuccin_window_text " #W"
set -g @catppuccin_window_current_number_color "#{@thm_peach}"
set -g @catppuccin_window_current_text " #W"
set -g @catppuccin_window_flags "icon"

# Load catppuccin
run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux

set -g "@catppuccin_application_icon" " "
set -g "@catppuccin_session_icon" "🐈‍⬛ "

set -g status-right-length 100
set -g status-left-length 100
set -g status-right "#{E:@catppuccin_status_application}#{E:@catppuccin_status_session}"
set -g status-left ""


# Disable half drawn border when there is only two panes
set-option -g pane-border-indicators off
