#Source Config
unbind r
bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"


# Change prefix to Ctrl-A
unbind C-b
set -g prefix C-a                         # Preferable alternative to Ctrl-B :contentReference[oaicite:6]{index=6}


# create session
bind C-c new-session


# split, inherit cwd
bind - split-window -v -c "#{pane_current_path}"
bind _ split-window -h -c "#{pane_current_path}"


# new window inherit cwd
unbind c
bind c new-window -c "#{pane_current_path}"


# swap panes
unbind -T prefix h
unbind -T prefix j
unbind -T prefix k
unbind -T prefix l
bind h swap-pane -D  # Swap with previous
bind l swap-pane -U  # Swap with next

# pane resizing
bind -r H resize-pane -L 2
bind -r J resize-pane -D 2
bind -r K resize-pane -U 2
bind -r L resize-pane -R 2

# window navigation
unbind n
unbind p
bind -r C-h previous-window                             # select previous window
bind -r C-l next-window                                 # select next window
bind -r C-S-Left swap-window -t -1 \; select-window -t -1  # swap current window with the previous one
bind -r C-S-Right swap-window -t +1 \; select-window -t +1  # swap current window with the next one
bind Tab last-window                                    # move to last active window

bind n command-prompt "rename-window %%"
bind N command-prompt "rename-session %%"
