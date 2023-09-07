export GDK_SCALE=2
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export ELM_SCALE=2

pamixer --set-volume 50 -m
mpd

xset s off
xset -dpms
setterm -blank 0 -powerdown 0

xrandr --output eDP-1 --dpi 192 --auto --output DP-3 --dpi 192 --left-of eDP-1

/usr/bin/xbacklight -set $(cat ~/.cache/i3brightness)

exec dbus-run-session i3
