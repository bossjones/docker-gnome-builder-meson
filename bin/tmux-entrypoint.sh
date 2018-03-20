#!/usr/bin/env bash
set -e

# FIXME: Make me into the end all starter script

# SOURCE: https://hub.docker.com/r/kayvan/scidvspc/

DIR=$(basename $PWD)

export NON_ROOT_USER="developer"
export _UID=$(id -u)
export _GID=$(id -g)
export DOCKER_DEVELOPER_CHROOT=".docker-${NON_ROOT_USER}-chroot"
export DOCKER_DEVELOPER_CHROOT_FULL_PATH=${HOME}/${DOCKER_DEVELOPER_CHROOT}
export _HOST_IP=$(ifconfig|grep 'inet '|grep -v '127.0.0.1'| head -1|awk '{print $2}')
export USERNAME=bossjones
export CONTAINER_NAME=gnome-builder-meson
export DISPLAY_MAC=$_HOST_IP:0
export NON_ROOT_USER_HOME_DIR=/home/${NON_ROOT_USER}

echo "INFO: Stop all running xquartz"
killall -0 quartz-wm > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "INFO: Quartz is not running. Start Quartz and try again."
  echo "Verify: XQuartz is not running"
  if [ -z "$(ps -ef|grep XQuartz|grep -v grep)" ] ; then
      echo "INFO: Starting XQuartz"
      open -a XQuartz
  fi
  echo "INFO: Stop all running socat processes"
  killall -0 socat > /dev/null 2>&1
  if [ $? -ne 0 ]; then
      echo "INFO: Socat is not running."
  fi
else
  echo "INFO: Bringing up socat"

  socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
  SOCAT_SCID_PID=$!

  docker run \
  --privileged \
  -it \
  --net host \
  -e HOME=${NON_ROOT_USER_HOME_DIR} \
  -e UID=${_UID} \
  -e GID=${_GID} \
  -e DISPLAY=${DISPLAY_MAC} \
  -e XAUTHORITY=/tmp/xauth \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.Xauthority:/tmp/xauth \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v DOCKER_DEVELOPER_CHROOT_FULL_PATH:${NON_ROOT_USER_HOME_DIR} \
  -v /run/user/${UID}/pulse:/run/pulse \
  \
  -v $PWD:/home/$NON_ROOT_USER/$DIR \
  -v /usr/share/fonts:/usr/local/share/fonts:ro \
  -v /usr/share/themes:/usr/local/share/themes:ro \
  -v /usr/share/icons:/usr/local/share/icons:ro \
  -w /home/$NON_ROOT_USER/$DIR \
  $USERNAME/$CONTAINER_NAME:latest tmux new bash

# FIXME: Add these lines so we can cache node modules etc
#   -v $HOME/.dev/.rbenv/versions:/home/dev/.rbenv/versions \
#   -v $HOME/.dev/.nodenv/versions:/home/dev/.nodenv/versions \

  kill $SOCAT_SCID_PID
fi

