wall=$(for a in $(find ~/Pictures/wallpapers/ -type f | shuf); do echo -en "$a\0icon\x1f$a\n" ; done | rofi -dmenu -show-icons -p "Wallpaper: " -theme /home/truegav/.local/share/rofi/themes/rofi-glass-wall.rasi)
echo $wall
echo "$wall" > /home/truegav/temp/wallpath
rm -rf /home/truegav/temp/wall
ln -s "$wall" /home/truegav/temp/wall

bash /home/truegav/.config/hypr/scripts/wall.sh -v -f "$wall" /home/truegav/.config/hypr/scripts/config.json 16 && bash /home/truegav/.config/hypr/scripts/reload-apps.sh    

