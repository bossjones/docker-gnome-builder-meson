#!/bin/bash

set -e

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
