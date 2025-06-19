#!/usr/bin/env bash

# Single script to update all CPU cores efficiently
CORE_COUNT=$(sysctl -n hw.ncpu)

# Call powermetrics once and parse all core data
POWERMETRICS_OUTPUT=$(sudo powermetrics --samplers cpu_power -n 1 -i 500 2>/dev/null)

if [ -n "$POWERMETRICS_OUTPUT" ]; then
    # Try to extract individual CPU core data
    CORE_DATA=$(echo "$POWERMETRICS_OUTPUT" | grep "CPU [0-9]* active residency" | awk '{print $5}' | sed 's/%//')
    
    if [ -n "$CORE_DATA" ]; then
        # Update each core with individual data
        CORE_NUM=0
        echo "$CORE_DATA" | while read -r usage; do
            if [[ "$usage" =~ ^[0-9]+\.?[0-9]*$ ]] && [ $CORE_NUM -lt "${CORE_COUNT}" ]; then
                USAGE_INT=$(printf "%.0f" "$usage")
                
                # Set color based on CPU usage
                if [ $USAGE_INT -lt 25 ]; then
                    COLOR="${GREEN}"  # Green for low usage
                elif [ $USAGE_INT -lt 50 ]; then
                    COLOR="${YELLOW}"  # Yellow for medium usage
                elif [ $USAGE_INT -lt 75 ]; then
                    COLOR="${ORANGE}"  # Orange for high usage
                else
                    COLOR="${RED}"  # Red for very high usage
                fi
              
                sketchybar --set "cpu.core$CORE_NUM" background.color="${COLOR}"
                CORE_NUM=$((CORE_NUM + 1))
            fi
        done
    fi
fi
