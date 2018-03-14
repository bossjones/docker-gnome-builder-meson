#!/usr/bin/env bash
set -e

DIR=$(basename $PWD)

export NON_ROOT_USER="developer"

docker run \
	-e UID \
	-e GID \
	-e DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /run/user/${UID:-1000}/pulse:/run/pulse \
	\
    -v $PWD:/home/$NON_ROOT_USER/$DIR \
	-v /usr/share/fonts:/usr/local/share/fonts:ro \
	-v /usr/share/themes:/usr/local/share/themes:ro \
	-v /usr/share/icons:/usr/local/share/icons:ro \
    -w /home/$NON_ROOT_USER/$DIR \
	\
	gnome-builder-meson


