#!/usr/bin/env bash
# Modified script from:
#   --> https://github.com/josean-dev/dev-environment-files/blob/main/.config/sketchybar/plugins/space_windows.sh
#   --> https://nikitabobko.github.io/AeroSpace/goodies#show-aerospace-workspaces-in-sketchybar
#
# This script is called with each available space in a for LOOP.
#
# NAME:                 The full name of the item; typically "space.$1"
# WORKSPACE:            The workspace to manipulate
# FOCUSED_WORKSPACE:    The current workspace that the user is presented with

# Make colors available here
source "$CONFIG_DIR/plugins/colors.sh"

WORKSPACE="$1"

# Set the highlight for the space
if [ "$WORKSPACE" = "$FOCUSED_WORKSPACE" ]; then
    # When space is active
    sketchybar --set "$NAME" \
        background.color="$CATPPUCCIN_MOCHA_MAROON" \
        label.color="$CATPPUCCIN_MOCHA_CRUST" \
        icon.color="$CATPPUCCIN_MOCHA_CRUST"
else
    # Whens space is inactive
    sketchybar --set "$NAME" \
        background.color="$CATPPUCCIN_MOCHA_GREEN" \
        label.color="$CATPPUCCIN_MOCHA_CRUST" \
        icon.color="$CATPPUCCIN_MOCHA_CRUST"
fi


# Set the icon for the space
if [ "$WORKSPACE" = "$FOCUSED_WORKSPACE" ]; then

  apps="$(aerospace list-windows --workspace $WORKSPACE --json | jq -r '.[]."app-name"')"

  icon_strip=" "
  if [ "${apps}" != "" ]; then
    while read -r app
    do
      icon_strip+=" $("$CONFIG_DIR"/plugins/icon_map_fn.sh "$app")"
    done <<< "${apps}"
  else
    icon_strip="" 
  fi

  sketchybar --set space."$WORKSPACE" label="$icon_strip"
fi
