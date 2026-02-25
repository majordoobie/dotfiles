# —–––– Detect WSL / macOS / Linux and set copy-command –––—
# set-clipboard does not work with copy-pipe
set -s set-clipboard off

# based on os, set the copy-command to an external binary
if-shell 'grep -qi microsoft /proc/version' {
  set -s copy-command "iconv -f utf-8 -t utf-16le | /mnt/c/WINDOWS/system32/clip.exe"
} {
  if-shell 'uname | grep -q Darwin' {
    set -s copy-command "pbcopy"
  } {
    set -s copy-command "xclip -in -selection clipboard"
  }
}

# Enter copy mode
bind Enter copy-mode

bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi C-v send -X rectangle-toggle
bind -T copy-mode-vi Escape send -X cancel
bind -T copy-mode-vi H send -X start-of-line
bind -T copy-mode-vi L send -X end-of-line

# Bind vi-mode yank (prefix+[ → v/y) to pipe to copy-command
unbind -T copy-mode-vi y
bind -T copy-mode-vi y send-keys -X copy-pipe

# Bind Enter to exit copy mode without clearing the buffer
unbind -T copy-mode-vi Enter
bind -T copy-mode-vi Enter send-keys -X cancel

# Bind mouse drag end to the same action
unbind -T copy-mode-vi MouseDragEnd1Pane
bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel

unbind -n MouseDragEnd1Pane
bind -n MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel

# Set the yank to be yellow
set -g mode-style fg=black,bg=yellow
