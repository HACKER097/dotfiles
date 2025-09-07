#!/bin/bash

# Get battery percentage (works for systems with BAT0, adjust if needed)
level=$(cat /sys/class/power_supply/BAT1/capacity)
status=$(cat /sys/class/power_supply/BAT1/status)

# Only notify if not charging and below 15%
if [ "$status" = "Discharging" ] && [ "$level" -le 15 ]; then
    notify-send -u critical -a "Power indicator" -t 30000 "Low Battery" "Battery is at ${level}%!"
fi
