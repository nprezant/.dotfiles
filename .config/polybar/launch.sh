# Terminate already running bar instances
killall -q polybar

# Wait until processes have been shut down
while pgrep -u $UID -x polybar  >/dev/null; do sleep 1; done

# Launch polybar
#polybar noah -r &

# Launch Polybar, using default config location ~/.config/polybar/config.ini
polybar example 2>&1 | tee -a /tmp/polybar.log & disown
