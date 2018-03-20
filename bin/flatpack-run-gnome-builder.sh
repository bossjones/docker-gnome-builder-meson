#!/usr/bin/env bash

sudo mkdir /var/run/dbus
sudo dbus-daemon --system --fork

_DBUS_LAUNCH_OUTPUT=($(dbus-launch))

# eval _DBUS_LAUNCH_OUTPUT=$(dbus-launch)

env | grep -i dbus > ~/.dbusrc
sed -i "s,^,export ,g" ~/.dbusrc
echo 'export DBUS_SYSTEM_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS}"' >> ~/.dbusrc

source ~/.dbusrc

flatpak run --share=network --command=bash \
org.gnome.Builder -c "DISPLAY=$DISPLAY gnome-builder"