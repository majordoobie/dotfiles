#!/usr/bin/env bash

# Get real per-core CPU usage using powermetrics
# Note: This requires sudo access for powermetrics
CORE_DATA=$(sudo powermetrics --samplers cpu_power -n 1 -i 1000 2>/dev/null | grep "CPU.*active residency" | awk '{print $3}' | sed 's/%//')

# If powermetrics fails (no sudo), fall back to top
if [ -z "$CORE_DATA" ]; then
    # Fallback to overall CPU usage
    CPU_LINE=$(top -l 1 -n 0 -s 0 | grep "CPU usage")
    if [ -n "$CPU_LINE" ]; then
        CPU_USER=$(echo "$CPU_LINE" | awk '{print $3}' | sed 's/%//')
        CPU_SYS=$(echo "$CPU_LINE" | awk '{print $5}' | sed 's/%//')
        
        # Ensure valid numbers
        if ! [[ "$CPU_USER" =~ ^[0-9]+\.?[0-9]*$ ]]; then CPU_USER=0; fi
        if ! [[ "$CPU_SYS" =~ ^[0-9]+\.?[0-9]*$ ]]; then CPU_SYS=0; fi
        
        TOTAL_CPU=$(echo "$CPU_USER + $CPU_SYS" | bc -l 2>/dev/null || echo "0")
        TOTAL_CPU_INT=$(printf "%.0f" "$TOTAL_CPU")
        
        # Update single CPU display
        sketchybar --set cpu.percent label="${TOTAL_CPU_INT}%" \
                   --push cpu.user "$CPU_USER" \
                   --push cpu.sys "$CPU_SYS"
    fi
else
    # Process per-core data from powermetrics
    CORE_COUNT=0
    echo "$CORE_DATA" | while read -r usage; do
        if [[ "$usage" =~ ^[0-9]+\.?[0-9]*$ ]]; then
            USAGE_INT=$(printf "%.0f" "$usage")
            sketchybar --push "cpu.core$CORE_COUNT" "$USAGE_INT"
            CORE_COUNT=$((CORE_COUNT + 1))
        fi
    done
fi