#!/usr/bin/env bash

# Convert bytes to speed and choose appropriate unit
convert_speed() {
  local speed=$1
  local unit="KB/s"

  if (( $(echo "$speed >= 1024" | bc -l) )); then
    speed=$(awk "BEGIN {print $speed / 1024}")
    unit="MB/s"
  fi

  printf "%.2f %s" "$speed" "$unit"
}

# Define the primary network interface (default to Wi-Fi, replace with "en0" or others as needed)
INTERFACE=$(route get default | grep interface | awk '{print $2}')

# Temporary files to store previous values
RX_PREV_FILE="/tmp/network_rx"
TX_PREV_FILE="/tmp/network_tx"

# $3 ~ /<Link#/ -- Matches only on the Link row which is the aggrigate of ipv4/6/etc
RX_CUR=$(netstat -ibn | awk -v iface="$INTERFACE" '$1 == iface && $3 ~ /<Link#/ {print $7}')
TX_CUR=$(netstat -ibn | awk -v iface="$INTERFACE" '$1 == iface && $3 ~ /<Link#/ {print $10}')

# Read previous RX and TX values
RX_PREV=$(cat "$RX_PREV_FILE" 2>/dev/null || echo 0)
TX_PREV=$(cat "$TX_PREV_FILE" 2>/dev/null || echo 0)

# Calculate the difference (current - previous)
RX_DIFF=$((RX_CUR - RX_PREV))
TX_DIFF=$((TX_CUR - TX_PREV))

# Store the current values for the next run
echo "$RX_CUR" > "$RX_PREV_FILE"
echo "$TX_CUR" > "$TX_PREV_FILE"

# Convert to KBes
RX_SPEED=$(awk "BEGIN {print $RX_DIFF / 1024}")
TX_SPEED=$(awk "BEGIN {print $TX_DIFF / 1024}")

# Format the speeds with appropriate units
RX_OUTPUT=$(convert_speed "$RX_SPEED")
TX_OUTPUT=$(convert_speed "$TX_SPEED")

sketchybar --set $NAME label="⬆️ $TX_OUTPUT ⬇️ $RX_OUTPUT"


