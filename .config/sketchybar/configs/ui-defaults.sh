#!/usr/bin/env bash

# File contains the default configuration for components.
# Then you can override the config per component if you need to

# Load defined colors
source "$CONFIG_DIR/configs/colors.sh"

BACKGROUND_PADDING=6
ITEM_PADDING=15
#FONT="Hack Nerd Font Mono"
#FONT="FiraCode Nerd Font Mono"
FONT="JetBrainsMonoNL Nerd Font Mono"

# Bar Appearance
bar=(
    color="${TRANSPARENT}"
    display="all"
    position=top
    topmost=off
    sticky=on
    height=30
    padding_left=4
    padding_right=4
    corner_radius=0
    blur_radius=32
    notch_width=170
)

# Item Defaults
item_defaults=(
    background.color="${LABEL_COLOR_NEGATIVE}"
    background.corner_radius=20
    background.height=32
    background.padding_left="${BACKGROUND_PADDING}"
    background.padding_right="${BACKGROUND_PADDING}"

    icon.background.corner_radius=4
    icon.color="${ICON_COLOR}"
    icon.font="${FONT}:Regular:11"
    icon.highlight_color="${HIGHLIGHT}"
    icon.padding_left=0
    icon.padding_right=0

    label.color="${LABEL_COLOR}"
    label.font="${FONT}:Regular:14"
    label.highlight_color="${HIGHLIGHT}"
    label.padding_left="${ITEM_PADDING}"
    label.padding_right="${ITEM_PADDING}"
    scroll_texts=on
    updates=when_shown
)
