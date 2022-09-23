#!/bin/bash
VOLUME=$(pamixer --get-volume)
#DATE=$(date +'%Y-%m-%d %H:%M:%S')
DATE=$(~/.config/sway/japtime)
echo "Volume: $VOLUME   $DATE  "
