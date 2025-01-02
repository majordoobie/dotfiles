#!/bin/bash

# https://github.com/josean-dev/dev-environment-files/blob/main/.config/sketchybar/plugins/space_windows.sh

if [ "$SENDER" = "space_windows_change" ]; then
  space="$(echo "$INFO" | jq -r '.space')"
  apps="$(echo "$INFO" | jq -r '.apps | keys[]')"

  echo "$space"
  echo "$apps"

  icon_strip=" "
  if [ "${apps}" != "" ]; then
    while read -r app
    do
      icon_strip+=" $("$CONFIG_DIR"/plugins/icon_map_fn.sh "$app")"
    done <<< "${apps}"
  else
    icon_strip=" —"
  fi

  sketchybar --set space."$space" label="$icon_strip"
fi
