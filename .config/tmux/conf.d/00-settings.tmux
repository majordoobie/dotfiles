# true-color & term settings
set -g default-terminal "tmux-256color"

set -g default-shell "/run/current-system/sw/bin/fish"

# tmux extension for RGB
set -ga terminal-overrides ",xterm-256color:Tc"
set -g allow-passthrough on

set -g base-index 1
setw -g pane-base-index 1


set -g mouse on
set -g status-keys vi
set -g mode-keys vi
set -g history-limit 1000000000
set -s escape-time 10                     # faster command sequences
set -sg repeat-time 600                   # increase repeat timeout
set -s focus-events on                    # send neovim focus status


set -g set-titles off          # set terminal title
set -g status-position bottom



# never let applications or tmux itself rename our windows
set -g allow-rename off
setw -g automatic-rename off
set -g renumber-windows on    # renumber windows when a window is closed


set -g display-panes-time 800 # slightly longer pane indicators display time
set -g display-time 1000      # slightly longer status messages display time


set -g status-interval 10     # redraw status line every 10 seconds

# activity
set -g monitor-activity off
set -g visual-activity off
