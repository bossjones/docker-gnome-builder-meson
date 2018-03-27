# docker-gnome-builder-meson
Run gnome-builder inside a docker container, without having to build/install dependencies on your host. Meson builds


# wrap-dbus

```
Since tumbler is a D-Bus service, rygel has to have access to a D-Bus session
bus. To accomplish this you need to copy the included D-Bus wrapper script
"wrap-dbus" somewhere and modify the upstart script to call a wrapped rygel:

 exec /usr/local/bin/wrap-dbus rygel

wrap-dbus makes sure that a session bus is running and will re-use an existing
bus it spawned itself.

After (re-) starting rygel, it should start requesting thumbnail generation
for files that don't have thumbnails. If you don't see them in your client
right away, you might have to refresh the view.
```

# Future usage

```
dnf -y reinstall "*" \
    dnf -y remove vim-minimal && \
    dnf -y install \
           abrt \
           bash-completion \
           bc \
           blktrace \
           btrfs-progs \
           crash \
           dnf-plugins-core \
           docker \
           docker-selinux \
           e2fsprogs \
           ethtool \
           file \
           findutils \
           fpaste \
           gcc \
           gdb \
           gdb-gdbserver \
           git \
           glibc-common \
           glibc-utils \
           hwloc \
           iotop \
           iproute \
           iputils \
           kernel \
           less \
           ltrace \
           mailx \
           man-db \
           nc \
           netsniff-ng \
           net-tools \
           numactl \
           numactl-devel \
           ostree \
           passwd \
           pciutils \
           pcp \
           perf \
           procps-ng \
           psmisc \
           python-dnf-plugins-extras* \
           python-docker-py \
           python-rhsm \
           rootfiles \
           rpm-ostree \
           screen \
           sos \
           strace \
           subscription-manager \
           sysstat \
           systemtap \
           systemtap-client \
           tar \
           tcpdump \
           vim-enhanced \
           which \
           xauth
```


# VNC (dockerfiles-fedora-firefox)
==========================

Fedora dockerfile for Firefox over VNC

Get the version of Docker

```
# docker version
```

To build:

Copy the sources down -

```
# docker build --rm -t <username>/firefox .
```

To run without building:

sudo atomic run docker.io/fedora/firefox

To run a local build:

```
# docker run -d -p 5901:5901 -v /etc/machine-id:/etc/machine-id <username>/firefox
```

Check the that the image launched successfully

```
# docker ps
CONTAINER ID        IMAGE                     COMMAND             CREATED             STATUS              PORTS                    NAMES
b1296df1a4e8        scollier/firefox:latest   vncserver -fg       3 seconds ago       Up 1 seconds        0.0.0.0:5901->5901/tcp   angry_brown
```

To test -

From the host that is running the container -

```
# vncviewer localhost:1
```

That's it.


# Test project to try out?

**SOURCE:https://fedoramagazine.org/debugging-gnome-builder/**

https://pagure.io/fedora-magazine/stop-watch.git

git@github.com:GNOME/gnome-music.git

# Docker X11 Client Via SSH
https://dzone.com/articles/docker-x11-client-via-ssh


# Things to try

```
sudo dbus-daemon --system --fork

[developer@dev-experimental docker-gnome-builder-meson]$ dbus-launch
DBUS_SESSION_BUS_ADDRESS=unix:abstract=/tmp/dbus-i1mFh6aILo,guid=c3b5c8beeb4a03267623fa0c5ab02d79
DBUS_SESSION_BUS_PID=198
DBUS_SESSION_BUS_WINDOWID=10485761
```


# jhbuild

**https://github.com/bossjones/boss-docker-jhbuild-pygobject3/blob/master/container/root/scripts/compile_jhbuild_and_deps.sh**

# Install all gnome dependencies using flatpak

**SOURCE: https://wiki.gnome.org/Apps/Evolution/Flatpak**
**SOURCE: https://wiki.debian.org/FlatpakHowto**
**SOURCE: https://fedoraproject.org/wiki/GNOME_Builder**

```
$ flatpak remote-add --from gnome https://sdk.gnome.org/gnome.flatpakrepo
$ flatpak remote-add --from gnome-apps https://sdk.gnome.org/gnome-apps.flatpakrepo
$ flatpak install gnome-apps org.gnome.Builder
```

```
flatpak --user remote-add --from gnome https://sdk.gnome.org/gnome.flatpakrepo
flatpak --user install gnome org.gnome.Platform//3.22
flatpak --user install gnome org.gnome.Sdk//3.22
```
