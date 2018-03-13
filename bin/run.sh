#!/usr/bin/env bash
set -e

DIR=$(basename $PWD)

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
