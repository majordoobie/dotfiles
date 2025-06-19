#!/usr/bin/env bash

source "$HOME/.config/sketchybar/configs/icon.sh"
source "$HOME/.config/sketchybar/configs/colors.sh"

# item must be called "time" as the binary will be updating the time.label
time_config=(
    label.color="${LABEL_COLOR}"
)
sketchybar --add item time right \
    --set time "${time_config[@]}"

# Invoke binary that updates the time.label field using strftime string format
${CONFIG_DIR}/compiled_components/build/bin/sketchybar_clock "%d-%b-%y %T" &

# date=(
#     icon=􀀁
#     icon.drawing=off
#     icon.font.size=6
#     icon.padding_right=1
#     icon.color=$(getcolor yellow)
#     icon.y_offset=1.5
#     label.font="$FONT:Semibold:7"
#     label.padding_right=4
#     y_offset=5
#     width=0
#     update_freq=60
#     script='sketchybar --set $NAME label="$(date "+%a, %b %d")"'
#     click_script="open -a Calendar.app"
# )
#
# clock=(
#     "${menu_defaults[@]}"
#     label.padding_left=$PADDINGS
#     label.padding_right=4
#     icon.drawing=off
#     label.color=$LABEL_COLOR
#     label.font="$FONT:Bold:9"
#     y_offset=-2
#     update_freq=10
#     popup.align=right
#     script="$PLUGIN_DIR/nextevent.sh"
#     click_script="sketchybar --set clock popup.drawing=toggle; open -a Calendar.app"
# )
#
# calendar_popup=(
#     icon.drawing=off
#     label.padding_left=0
#     label.max_chars=32
#     label.scroll_duration=100
# )
#
# sketchybar \
#     --add item date right \
#     --set date "${date[@]}" \
#     --subscribe date system_woke \
#     mouse.entered \
#     mouse.exited \
#     mouse.exited.global \
#     --add item date.details popup.date \
#     --set date.details "${menu_item_defaults[@]}" \
#     \
#     --add item clock right \
#     --set clock "${clock[@]}" \
#     --subscribe clock system_woke \
#     mouse.entered \
#     mouse.exited \
#     mouse.exited.global \
#     --add item clock.next_event popup.clock \
#     --set clock.next_event "${menu_item_defaults[@]}" "${calendar_popup[@]}"
