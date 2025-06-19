#!/usr/bin/env bash

# Get CPU usage using top
CPU_LINE=$(top -l 1 -n 0 | grep "CPU usage")

if [ -n "$CPU_LINE" ]; then
    # Parse: "CPU usage: 3.6% user, 8.52% sys, 88.41% idle"
    CPU_USER=$(echo "$CPU_LINE" | awk '{print $3}' | sed 's/%//')
    CPU_SYS=$(echo "$CPU_LINE" | awk '{print $5}' | sed 's/%//')
    
    # Ensure we have valid numbers
    if ! [[ "$CPU_USER" =~ ^[0-9]+\.?[0-9]*$ ]]; then
        CPU_USER=0
    fi
    if ! [[ "$CPU_SYS" =~ ^[0-9]+\.?[0-9]*$ ]]; then
        CPU_SYS=0
    fi
    
    # Convert to integers for SketchyBar
    CPU_USER_INT=$(printf "%.0f" "$CPU_USER")
    CPU_SYS_INT=$(printf "%.0f" "$CPU_SYS")
    
    # Calculate total CPU usage
    TOTAL_CPU=$(echo "$CPU_USER + $CPU_SYS" | bc -l 2>/dev/null || echo "0")
    TOTAL_CPU_INT=$(printf "%.0f" "$TOTAL_CPU")
    
    # Update the graphs and label
    sketchybar --push cpu.user "$CPU_USER_INT" \
               --push cpu.sys "$CPU_SYS_INT" \
               --set cpu.percent label="${TOTAL_CPU_INT}%"
else
    # Fallback values
    sketchybar --push cpu.user 0 \
               --push cpu.sys 0 \
               --set cpu.percent label="0%"
fi