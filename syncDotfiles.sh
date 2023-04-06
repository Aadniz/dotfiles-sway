#!/bin/bash

#mkdir sway kitty nano rofi

# For symlinks
#cp ~/.cache/wal/colors-rofi-light.rasi main.rasi
#cp ~/.config/kitty/kitty-themes/themes/Monokai_Soda.conf kitty/theme.conf

rsync -avrtL ~/.config/sway .
rsync -avrtL ~/.config/kitty .
rsync -avrtL ~/.config/nano .
rsync -avrtL ~/.config/dunstrc .
rsync -avrtL ~/.config/rofi .
rsync -avrtL ~/.doom.d .
rsync -avrtL ~/.config/nvim .
rsync -avrtL ~/.zshrc .