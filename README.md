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
