#!/usr/bin/env bash
set -e

DIR=$(basename $PWD)
IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')

# xhost is a program that controls access for X server. You can use xhost to limit access for X server for security reasons. The following message is what you get when connection is rejected by xhost:
xhost + $IP

docker run \
	-e UID \
	-e GID \
	-e DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /run/user/$UID/pulse:/run/pulse \
	\
	-v $HOME:/home/developer \
	-v /usr/share/fonts:/usr/local/share/fonts:ro \
	-v /usr/share/themes:/usr/local/share/themes:ro \
	-v /usr/share/icons:/usr/local/share/icons:ro \
	\
	gnome-builder-meson
