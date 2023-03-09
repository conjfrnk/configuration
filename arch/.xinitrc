export GDK_SCALE=2
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export ELM_SCALE=2
pamixer --set-volume 50 -m
xset s off
xset -dpms
setterm -blank 0 -powerdown 0
xrandr --output eDP1 --dpi 192 --auto --output DP3 --dpi 196 --left-of eDP1 --output DP4 --off
xinput set-prop 13 310 1
exec i3
