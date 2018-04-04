#!/usr/bin/env bash
# set -e

# FIXME: Make me into the end all starter script

# SOURCE: https://hub.docker.com/r/kayvan/scidvspc/

DIR=$(basename $PWD)

n_procs=()

export NON_ROOT_USER="developer"
export _UID=$(id -u)
export _GID=$(id -g)
export DOCKER_DEVELOPER_CHROOT=".docker-${NON_ROOT_USER}-chroot"
export DOCKER_DEVELOPER_CHROOT_FULL_PATH=${HOME}/${DOCKER_DEVELOPER_CHROOT}
# export _HOST_IP=$(ifconfig|grep 'inet '|grep -v '127.0.0.1'| head -1|awk '{print $2}')
export _HOST_IP=$(ifconfig|grep 'inet '|grep -v '127.0.0.1'| head -1|awk '{print $2}')
export DISPLAY_MAC=$_HOST_IP:0
export USERNAME=bossjones
export CONTAINER_NAME=gnome-builder-meson
export NON_ROOT_USER_HOME_DIR=/home/${NON_ROOT_USER}

# run xhost and allow connections from your local machine:
xhost + $_HOST_IP

echo "INFO: Stop all running xquartz"
# pgrep procname || echo Not running
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
  sleep 10

  echo "INFO: Starting up socat."
  socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
  # FIXME: Verify this works!
  # SOURCE: https://stackoverflow.com/questions/356100/how-to-wait-in-bash-for-several-subprocesses-to-finish-and-return-exit-code-0?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa#
  n_procs[${i}]=$!
  # SOCAT_SCID_PID=$!

  # for i in $n_procs; do ./procs[${i}] & ; pids[${i}]=$!; done; for pid in ${pids[*]}; do wait $pid; done;

  for pid in ${n_procs[*]}; do
    touch SOCAT_PID
    echo $pid > SOCAT_PID
    wait $pid;
  done;
  # SOCAT_SCID_PID=$!
  # touch SOCAT_PID
  # echo ${SOCAT_SCID_PID} > SOCAT_PID

else
  echo "INFO: Bringing up socat"

  # if [[ -f $DIR/SOCAT_PID ]]; then
  #   kill $(/bin/cat ${DIR}/SOCAT_PID)
  # fi

  #   # this does not work after a docker run command
  # # FIXME: Add these lines so we can cache node modules etc
  # #   -v $HOME/.dev/.rbenv/versions:/home/dev/.rbenv/versions \
  # #   -v $HOME/.dev/.nodenv/versions:/home/dev/.nodenv/versions \

  #   kill $SOCAT_SCID_PID

  socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
  n_procs[${i}]=$!
  # SOCAT_SCID_PID=$!

  # for i in $n_procs; do ./procs[${i}] & ; pids[${i}]=$!; done; for pid in ${pids[*]}; do wait $pid; done;

  for pid in ${n_procs[*]}; do
    echo $pid > SOCAT_PID
    wait $pid;
  done;

  export LC_ALL="en_US.UTF-8"
  export LANG="en_US.UTF-8"
  export LANGUAGE="en_US.UTF-8"
  export C_CTYPE="en_US.UTF-8"
  export LC_NUMERIC=
  export LC_TIME=en"en_US.UTF-8"

  # export LC_ALL="en_US"
  # export LANG="en_US"
  # export LANGUAGE="en_US"
  # export C_CTYPE="en_US"
  # export LC_NUMERIC=
  # export LC_TIME=en"en_US"

  docker run \
  --privileged \
  -it \
  --net host \
  -e HOME=${NON_ROOT_USER_HOME_DIR} \
  -e UID \
  -e GID \
  -e DISPLAY=${DISPLAY_MAC} \
  -e XAUTHORITY=/tmp/xauth \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.Xauthority:/tmp/xauth \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $DOCKER_DEVELOPER_CHROOT_FULL_PATH:$HOME \
  -v /run/user/${UID}/pulse:/run/pulse \
  \
  -v $PWD:/home/$NON_ROOT_USER/$DIR \
  -v /usr/share/fonts:/usr/local/share/fonts:ro \
  -v /usr/share/themes:/usr/local/share/themes:ro \
  -v /usr/share/icons:/usr/local/share/icons:ro \
  -w /home/$NON_ROOT_USER/$DIR \
  $USERNAME/$CONTAINER_NAME:latest bash

fi

