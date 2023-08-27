#!/bin/bash
sleep 2

###
##  Autostart on spesific monitors
###

# Center monitor
swaymsg "workspace 1; exec firefox"

sleep 1
# Top monitor
swaymsg "workspace 9; exec radeon-profile"
swaymsg "workspace 8; exec kitty --session /home/chiya/.config/kitty/session.conf"

sleep 1
# Left monitor
swaymsg "workspace 20; exec discord & discord-canary"
swaymsg "workspace 20; exec element-desktop"

sleep 1
# Right monitor
swaymsg "workspace 11; exec spotify-adblock"
swaymsg "workspace 13; exec thunderbird"


bash /home/chiya/Documents/scripts/autostart/mount.sh &