#!/bin/bash
sleep 2

###
##  Autostart on spesific monitors
###

# Center monitor
swaymsg "workspace 1; exec firefox"

sleep 1
# Top monitor
swaymsg "workspace 39; exec radeon-profile"
swaymsg "workspace 31; exec kitty --session /home/chiya/.config/kitty/session.conf"

sleep 1
# Left monitor
swaymsg "workspace 11; exec discord"
swaymsg "workspace 11; exec element-desktop"

sleep 1
# Right monitor
swaymsg "workspace 21; exec spotify-adblock"
swaymsg "workspace 23; exec thunderbird"