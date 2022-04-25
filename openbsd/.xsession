xset b off
export LANG=en_US.UTF-8

xsetroot -name " "
# disable screen blanking (just suspend lol)
xset s off;  xset -dpms;  xset s noblank

xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation" 1 
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Button" 2 
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Axes" 6 7 4 5
xinput set-prop "/dev/wsmouse" "Device Accel Constant Deceleration" 0.2

xrdb -load $HOME/.Xresources

## START NOTIFICATIONS ###
dunst &

## SETTING WALLPAPER ###
feh --no-fehbg --bg-fill ~/.local/wallpapers/text_puffy.png

if [ "$SSH_AGENT_PID" ]; then
  ssh-add -D < /dev/null
  eval `ssh-agent -s -k`
fi

#if [ -r ~/.profile ]; then . ~/.profile; fi
if [ -r ~/.bash_profile ]; then . ~/.bash_profile; fi

slstatus &
exec dwm
#oxbar connor &
#exec cwm
