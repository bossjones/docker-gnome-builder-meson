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

# Error building flatpaks in containers

```
Installing: org.gnome.Sdk/x86_64/3.28 from flathub
[####################] 19 delta parts, 163 loose fetched; 358755 KiB transferred
Installing: org.freedesktop.Platform.ffmpeg/x86_64/1.6 from flathub
[####################] 1 delta parts, 2 loose fetched; 2652 KiB transferred in 1
Installing: org.gnome.Sdk.Locale/x86_64/3.28 from flathub
[####################] 5 delta parts, 120 loose fetched; 95189 KiB transferred i
Installing: org.gnome.Builder/x86_64/stable from flathub
[####################] 3 delta parts, 7 loose fetched; 20157 KiB transferred in bwrap: Creating new namespace failed: Operation not permitted
bwrap: Creating new namespace failed: Operation not permitted
bwrap: Creating new namespace failed: Operation not permitted
```

Git Issue: https://github.com/flatpak/flatpak/issues/1326

# Steps to run builder

NOTES FROM: http://kartoza.com/en/blog/how-to-run-a-linux-gui-application-on-osx-using-docker/

```
Start socat (in my testing it had to be done first)

Start XQuartz

Start Docker

Start gnome-builder from flatpak run command

```

# Break down socat command

`socat TCP-LISTEN:6001,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`

`Example DISPLAY=/private/tmp/com.apple.launchd.dfhdhfdh/org.macosforge.xquartz:0`

SOURCE: http://www.dest-unreach.org/socat/doc/socat.html#OPTION_REUSEADDR

```
socat

TCP-LISTEN:
--------------------------------
listen on port 6000, wait for an incoming connection

reuseaddr:
--------------------------------
Allows other sockets to bind to an address even if parts of it (e.g. the local port) are already in use by socat (example).

fork:
--------------------------------
after establishing a connection, handles its channel in a child process and keeps the parent process attempting to produce more connections, either by listening or by connecting in a loop (example).
OPENSSL-CONNECT and OPENSSL-LISTEN differ in when they actually fork off the child: OPENSSL-LISTEN forks before the SSL handshake, while OPENSSL-CONNECT forks afterwards. RETRY and FOREVER options are not inherited by the child process.
On some operating systems (e.g. FreeBSD) this option does not work for UDP-LISTEN addresses.

UNIX-CLIENT:
--------------------------------
EG. UNIX-CLIENT:<filename>
Communicates with the specified peer socket, defined by [<filename>] assuming it is a UNIX domain socket. It first tries to connect and, if that fails, assumes it is a datagram socket, thus supporting both types.
Option groups: FD,SOCKET,NAMED,UNIX
Useful options: bind
See also: UNIX-CONNECT, UNIX-SENDTO, GOPEN
```


# This is where we left off re: figuring out how to use remote display locally.

cc: https://unix.stackexchange.com/questions/242146/network-namespace-ssh-x11?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa

```
// access local display from ssh server, when ssh port forwarding is disabled
// socat must be installed on ssh server host
// might have to use xauth...
// this example is one-shot because ssh can handle only one channel
xterm1$ socat -d -d exec:"ssh www.dest-unreach.org rm -f /tmp/.X11-unix/X9; ~/bin/socat -d -d unix-l\:/tmp/.X11-unix/X9\,fork -" unix:/tmp/.X11-unix/X0
xterm2$ ssh target
target$ DISPLAY=:9 myxapplication
```

# docker login w/ secrets ( also see keyring.rst )

`~/.docker/config.json`

```
{
  "auths" : {
    "https://index.docker.io/v1/" : {

    }
  },
  "credsStore" : "secretservice"
}
```

`sudo dnf install python3-docker-pycreds.noarch python2-docker-pycreds.noarch`

# list authorized sessions

```
# lists xauth cookies existing

[oracle@localhost ~]$ xauth list
localhost.localdomain/unix:11  MIT-MAGIC-COOKIE-1  310f1b02c1080e73059391c193a1881b
localhost.localdomain/unix:10  MIT-MAGIC-COOKIE-1  41843db100830a2aa352641ac47bb759
```

# Setups to get working (4/12/2018)
1. xhost + $(ifconfig en0 | grep "inet "| awk '{print $2}')
1. open -a XQuartz
2. Verify DISPLAY has been set, eg `DISPLAY=/private/tmp/com.apple.launchd.bxHghBDDkr/org.macosforge.xquartz:0`
3. Run socat bind to 6000 + 1 port. `socat TCP-LISTEN:6001,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`
4. Run docker command.
