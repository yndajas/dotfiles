#!/bin/sh

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

if [[ "$PERCENTAGE" -gt 20 ]] && [[ -z "$CHARGING" ]]; then
  sketchybar --set "$NAME" icon.drawing=off label.drawing=off
else
  sketchybar --set "$NAME" icon.drawing=on label.drawing=on
fi

if [[ "$PERCENTAGE" -le 10 ]]; then
  ICON=""
  COLOR="0xfff38ba8"
elif [[ "$PERCENTAGE" -le 20 ]]; then
  ICON=""
  COLOR="0xfffab387"
elif [[ "$PERCENTAGE" -le 60 ]]; then
  ICON=""
  COLOR="0xfff9e2af"
elif [[ "$PERCENTAGE" -le 90 ]]; then
  ICON=""
  COLOR="0xffffffff"
else
  ICON=""
  COLOR="0xffffffff"
fi

if [[ -n "$CHARGING" ]]; then
  ICON=" $ICON"
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" \
                 icon="$ICON" \
                 label="${PERCENTAGE}%" \
                 icon.color="$COLOR" \
                 label.color="$COLOR"
