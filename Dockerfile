FROM fedora:rawhide

LABEL Maintainer "Malcolm Jones <bossjones@theblacktonystark.com>"

ENV JVMTOP_VER=0.8.0 \
    GOSS_VER=v0.3.4 \
    TMUX_VER=2.3 \
    DOCKER_VER=17.05.0-ce \
    DOCKER_COMPOSE_VER=1.18.0

# source: https://hub.docker.com/_/fedora/
# source: https://github.com/fedora-cloud/Fedora-Dockerfiles/blob/master/tools/Dockerfile
ENV container docker

# LABEL RUN="docker run -it --name NAME --privileged --ipc=host --net=host --pid=host -e HOST=/host -e NAME=NAME -e IMAGE=IMAGE -v /run:/run -v /var/log:/var/log -v /etc/localtime:/etc/localtime -v /:/host IMAGE"


RUN echo "fastestmirror=True" >> /etc/dnf/dnf.conf
RUN [ -e /etc/yum.conf ] && sed -i '/tsflags=nodocs/d' /etc/yum.conf || true

ARG HOST_USER_ID=1000
ENV HOST_USER_ID ${HOST_USER_ID}
ARG HOST_GROUP_ID=1000
ENV HOST_GROUP_ID ${HOST_GROUP_ID}

# ENV LANG en_US.utf8
# RUN locale-gen en_US.UTF-8
# ENV LANG en_US.UTF-8
# ENV LANGUAGE en_US:en
# ENV LC_ALL en_US.UTF-8

# Sets term to xterm-256color - needed for proper coloring in tmux.
ENV TERM xterm-256color

RUN dnf -y update && \
    dnf group install "C Development Tools and Libraries" -y; \
    dnf install -y wget curl vim \
    glibc-langpack-en.x86_64 \
    redhat-rpm-config htop perf \
    net-tools file atop ltrace bridge-utils \
    ca-certificates iftop iperf iproute bash \
    bash-completion gettext ncurses; \
    dnf -y install git gcc-c++ gjs gjs-devel libpeas-devel \
    gtksourceview3-devel libgit2-devel libgit2-glib-devel clang-devel file vala-devel vala llvm-devel vte-devel \
    vte291-devel vala-tools redhat-rpm-config; \
    dnf groupinstall -y development-libs development-tools gnome-software-development; \
    dnf clean all

# # Install all useful packages
# RUN set -x; \
#     dnf -y update && \
#     # Reinstall all packages to get man pages for them
#     dnf -y reinstall "*" \
#     dnf -y remove vim-minimal && \
#     dnf -y install \
#     abrt \
#     bash-completion \
#     bc \
#     blktrace \
#     btrfs-progs \
#     crash \
#     dnf-plugins-core \

RUN dnf -y install ninja-build \
    libdazzle-devel json-glib-devel jsonrpc-glib-devel vte291-devel libxml2-devel desktop-file-utils webkit2gtk3-devel appstream-devel libappstream-glib libappstream-glib-devel libappstream-glib-builder-devel ctags ctags-etags devhelp-libs devhelp-devel flatpak-devel flatpak-libs flatpak-builder gspell-devel sysprof-devel autoconf automake enchant-devel template-glib-devel \
    gcc gcc-c++ \
    gcc-gfortran gcc-objc \
    gcc-objc++ java-devel \
    mono-core mono-devel \
    libgcc \
    libgit2-glib-devel \
    libpeas-devel \
    libsoup-devel \
    libsysprof-ui \
    libxml2-devel \
    template-glib-devel \
    vala \
    boost-devel \
    gtest-devel \
    gmock-devel \
    qt5-qtbase-devel \
    wxGTK3-devel \
    flex bison \
    gettext \
    gnustep-base-devel \
    git-core \
    vim \
    sudo \
    dbus-x11 \
    dbus-devel \
    gdb \
    gdb-gdbserver \
    file \
    findutils \
    fpaste \
    procps-ng \
    psmisc \
    "pkgconfig(protobuf)" \
    "pkgconfig(glib-2.0)" \
    "pkgconfig(gobject-introspection-1.0)" \
    "pkgconfig(zlib)"; \
    dnf clean all


RUN cd /usr/local/src/; \
    curl -s -q -L 'https://bootstrap.pypa.io/ez_setup.py' > ez_setup.py; \
    curl -s -q -L 'https://bootstrap.pypa.io/get-pip.py' > get-pip.py; \
    python ez_setup.py; \
    python get-pip.py; \
    dnf install python3-devel -y; \
    cd /usr/local/src/; \
    python3 ez_setup.py; \
    python3 get-pip.py; \
    pip3 install -I path.py==7.7.1; \
    pip3 install virtualenv virtualenvwrapper ipython; \
    pip3 install meson

RUN cd /usr/local/src && \
    git clone git://git.gnome.org/gnome-builder && \
    cd gnome-builder && \
    meson --prefix=/usr build && \
    ninja -C build && \
    ninja -C build install

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    echo "%developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

RUN set -xe \
    && useradd -U -d /home/developer -m -r -G adm,sudo,dip,plugdev,tty,audio,docker developer \
    && usermod -a -G developer -s /bin/bash -u ${HOST_USER_ID} dev \
    && groupmod -g ${HOST_GROUP_ID} developer \
    && ( mkdir /home/developer/.ssh \
    && chmod og-rwx /home/developer/.ssh \
    && echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > /home/developer/.ssh/authorized_keys \
    ) \
    && echo 'developer     ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo '%developer     ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && cat /etc/sudoers \
    && echo 'developer:developer' | chpasswd

# RUN useradd -m -d /home/developer developer

USER developer

# USER developer
# ENV HOME /home/developer
# CMD dbus-daemon --system --fork && /usr/bin/firefox

COPY ./bin/entrypoint.sh /entrypoint.sh

# ENTRYPOINT ["/entrypoint.sh"]

# CMD ["/usr/bin/gnome-builder"]
