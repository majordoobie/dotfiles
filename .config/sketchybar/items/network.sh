#!/usr/bin/env sh

source "$CONFIG_DIR/plugins/colors.sh"

upload="􀄨"
download="􀄩"
connected="􀙇"
disconnected="􀙈"
router="􁓤"
vpn="􀒲"


local wifi_down = sbar.add("item", "widgets.wifi2", {
  position = "right",
  padding_left = -5,
  icon = {
    padding_right = 0,
    font = {
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    string = icons.wifi.download,
  },
  label = {
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    color = colors.blue,
    string = "??? Bps",
  },
  y_offset = -4,
})
sketchybar  --add item      ns.top right        \
            --set ns.top                        \
                padding_left=-5         \
                y_offset=4              \
                width=0                 \
                icon="$upload"          \
                    icon.font="$FONT:bold:9.0" \
                label="??? Bps"         \
                    label.font="$FONT:bold:9.0" \
                    label.color="$RED"  \
                    \
                    \
                    \
            --add item      ns.down right       \
            --set ns.down                       \
                padding_left=-5         \
                y_offset=-4             \
                icon="$download"        \
                    icon.font="$FONT:bold:9.0" \
                    icon.color="$BLUE"   \
                label="??? Bps"         \
                    label.font="$FONT:bold:9.0" \
                    label.color
                        
            
                



# Add network speed to the bar
sketchybar --add item network_speed right \
           --set network_speed update_freq=1 \
                              script="$PLUGIN_DIR/network_speed.sh" \
                              icon="🌐" \
                              label.font="JetBrainsMono Nerd Font:Bold:14.0" \
                              label.color="$BLACK_TEXT" \
                              background.color="$CATPPUCCIN_MOCHA_BLUE" \
                              background.height=24 \
                              background.corner_radius=5 \
                              icon.padding_left=4 \
                              icon.padding_right=4
