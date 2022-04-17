# disable system beep
xset b off

# use UTF-8 everywhere
export LANG=en_US.UTF-8

xsetroot -name " "
#xrandr --dpi 192
xrdb -load $HOME/.Xresources

## START COMPOSITOR ###
picom &

## START NOTIFICATIONS ###
dunst &

## SETTING WALLPAPER ###
feh --no-fehbg --bg-fill ~/.local/wallpapers/text_puffy.png

if [ "$SSH_AGENT_PID" ]; then
  ssh-add -D < /dev/null
  eval `ssh-agent -s -k`
fi

oxbar connor &
exec cwm
