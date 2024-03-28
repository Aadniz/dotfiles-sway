#!/bin/bash
VOLUME=$(pamixer --get-volume)
ISMUTED=$(pamixer --get-mute)
DATE=$(~/.config/sway/japtime)
BATTERY=$(cat /sys/class/power_supply/BAT0/capacity)

if [ "$ISMUTED" == "true" ]; then
	VOLUME="mute"
fi

echo -e "Volume: $VOLUME     $BATTERY   $DATE  "
