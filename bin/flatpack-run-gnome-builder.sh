#!/usr/bin/env bash

[[ ! -d /var/run/dbus ]] && sudo mkdir /var/run/dbus

sudo dbus-daemon --system --fork

_DBUS_LAUNCH_OUTPUT=($(dbus-launch))

export $_DBUS_LAUNCH_OUTPUT

# eval _DBUS_LAUNCH_OUTPUT=$(dbus-launch)

env | grep -i DBUS_SESSION_BUS_ADDRESS > ~/.dbusrc
sed -i "s,^,export ,g" ~/.dbusrc
echo 'export DBUS_SYSTEM_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS}"' >> ~/.dbusrc

cat ~/.dbusrc

source ~/.dbusrc

flatpak run --share=network --command=bash \
org.gnome.Builder -c "DISPLAY=$DISPLAY gnome-builder"

# XDG_RUNTIME_DIR=/run/user/1000 strace -o log -f flatpak run --share=network --command=bash \
# org.gnome.Builder -c "DISPLAY=:1 gnome-builder"

# strace -o log -f flatpak run --share=network org.gnome.Builder
