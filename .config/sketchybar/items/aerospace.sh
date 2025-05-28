#!/usr/bin/env bash

source "$HOME/.config/sketchybar/configs/icon.sh"

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
    aerospace_set=(
        icon="${ICON_YABAI_GRID}"
        background.drawing=off
        click_script="aerospace workspace ${sid}"
        script="$HOME/.config/sketchybar/plugins/aerospace_plugin.sh"
    )
    space="space.${sid}"

    sketchybar --add item "${space}" left \
        --subscribe "${space}" aerospace_workspace_change \
        --set "${space}" "${aerospace_set[@]}"
done

# yabai=(
#   icon=$ICON_YABAI_GRID
#   icon.padding_left=$PADDINGS
#   icon.padding_right=$((PADDINGS + 2))
#   label.padding_right=$PADDINGS
#   script="$PLUGIN_DIR/yabai.sh"
# )
#
# # Allows my shortcut / workflow in Alfred to trigger things in Sketchybar
# sketchybar --add event alfred_trigger
# sketchybar --add event update_yabai_icon
#
# sketchybar --add item yabai left                   \
#            --set yabai "${yabai[@]}"               \
#            --set yabai "${bracket_defaults[@]}"    \
#            --subscribe yabai space_change          \
#                              mouse.scrolled.global \
#                              mouse.clicked         \
#                              front_app_switched    \
#                              space_windows_change  \
#                              alfred_trigger        \
#                              update_yabai_icon
