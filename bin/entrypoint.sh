#!/bin/bash

set -e

# SOURCE: https://github.com/alexlarsson/broadway-docker/blob/391325140d8bfeda36d48d51b325b6ad8e689223/runtime/init.sh
# export LANG="en_US.UTF-8"
# export LC_MEASUREMENT="en_US.utf8"
# export LC_MONETARY="en_US.utf8"
# export LC_NUMERIC="en_US.utf8"
# export LC_PAPER="en_US.utf8"
# export LC_TIME="en_US.utf8"
# export XDG_CURRENT_DESKTOP=GNOME
# export XDG_MENU_PREFIX="gnome-"
# export HOME="/home/user"
# export SHELL="/bin/bash"

# Startup dbus session
ADDRESS_FILE=$(mktemp /tmp/gnomebuilder.XXXXXXXXX)
PID_FILE=$(mktemp /tmp/gnomebuilder.XXXXXXXXX)

dbus-daemon --session --print-address=0 --print-pid=1 --fork 0>"$ADDRESS_FILE" 1>"$PID_FILE"

export DBUS_SESSION_BUS_ADDRESS=$(cat "$ADDRESS_FILE")
PID=$(cat "$PID_FILE")

echo "export DBUS_SESSION_BUS_ADDRESS=$(cat "$ADDRESS_FILE")" > ~/.exports

echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"

trap 'kill -TERM $PID' EXIT

rm "$ADDRESS_FILE" "$PID_FILE"

exec "$@"
