FROM fedora:28

LABEL Maintainer "Malcolm Jones <bossjones@theblacktonystark.com>"

ENV GOSS_VER=v0.3.4 \
    TMUX_VER=2.3 \
    DOCKER_VER=17.05.0-ce \
    DOCKER_COMPOSE_VER=1.18.0 \
    NON_ROOT_USER=developer \
    CFLAGS='-O2'

# source: https://hub.docker.com/_/fedora/
# source: https://github.com/fedora-cloud/Fedora-Dockerfiles/blob/master/tools/Dockerfile
ENV container docker

# LABEL RUN="docker run -it --name NAME --privileged --ipc=host --net=host --pid=host -e HOST=/host -e NAME=NAME -e IMAGE=IMAGE -v /run:/run -v /var/log:/var/log -v /etc/localtime:/etc/localtime -v /:/host IMAGE"

ARG HOST_USER_ID=1000
ENV HOST_USER_ID ${HOST_USER_ID}
ARG HOST_GROUP_ID=1000
ENV HOST_GROUP_ID ${HOST_GROUP_ID}

RUN echo "fastestmirror=True" >> /etc/dnf/dnf.conf && \
    [ -e /etc/yum.conf ] && sed -i '/tsflags=nodocs/d' /etc/yum.conf || true

# ENV LANG en_US.utf8
# RUN locale-gen en_US.UTF-8
# ENV LANG en_US.UTF-8
# ENV LANGUAGE en_US:en
# ENV LC_ALL en_US.UTF-8

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

# Sets term to xterm-256color - needed for proper coloring in tmux.
ENV TERM xterm-256color

# INFO: Pyenv requirements
# SOURCE: https://github.com/alexlarsson/broadway-docker/blob/391325140d8bfeda36d48d51b325b6ad8e689223/build/Dockerfile
RUN dnf -y update && \
        dnf -y reinstall "*" \
        dnf -y remove vim-minimal && \
        dnf -y install \
        abrt \
        bash-completion \
        bc \
        blktrace \
        btrfs-progs \
        crash \
        dnf-plugins-core && \
    dnf install -y gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel && \
    dnf install -y zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel && \
    dnf install -y @development-tools && \
    dnf reinstall -y glibc-devel.x86_64 && \
    dnf install python3-devel python3-pyOpenSSL.noarch python2-pyOpenSSL.noarch -y; \
    dnf group install "C Development Tools and Libraries" -y; \
    dnf install -y \
        wget \
        curl \
        vim \
        glibc-langpack-en.x86_64 \
        redhat-rpm-config \
        htop \
        perf \
        net-tools \
        file \
        atop \
        ltrace \
        bridge-utils \
        ca-certificates \
        iftop \
        iperf \
        iproute \
        bash \
        bash-completion \
        gettext \
        ncurses; \
    dnf install -y git \
        gcc-c++ \
        gjs \
        gjs-devel \
        libpeas-devel \
        gtksourceview3-devel \
        libgit2-devel \
        libgit2-glib-devel \
        clang-devel \
        file \
        vala-devel \
        vala \
        llvm-devel \
        vte-devel \
        vte291-devel \
        vala-tools \
        redhat-rpm-config; \
    dnf groupinstall -y development-libs \
                        development-tools \
                        gnome-software-development; \
    dnf -y install ninja-build \
        appstream-devel \
        autoconf \
        automake \
        boost-devel \
        ctags \
        ctags-etags \
        dbus-devel \
        dbus-x11 \
        desktop-file-utils \
        devhelp-devel \
        devhelp-libs \
        enchant-devel \
        file \
        findutils \
        flatpak-builder \
        flatpak-devel \
        flatpak-libs \
        elfutils \
        flex \
        bison \
        fpaste \
        gcc \
        gcc-c++ \
        gcc-gfortran \
        gcc-objc \
        gcc-objc++ \
        gdb \
        gdb-gdbserver \
        gettext \
        git-core \
        gmock-devel \
        gnustep-base-devel \
        gspell-devel \
        gtest-devel \
        java-devel \
        json-glib-devel \
        jsonrpc-glib-devel \
        libappstream-glib \
        libappstream-glib-builder-devel \
        libappstream-glib-devel \
        libdazzle-devel \
        libgcc \
        libgit2-glib-devel \
        libpeas-devel \
        libsoup-devel \
        libsysprof-ui \
        libxml2-devel \
        mono-core \
        mono-devel \
        procps-ng \
        psmisc \
        qt5-qtbase-devel \
        sudo \
        sysprof-devel \
        template-glib-devel \
        vala \
        vim \
        tmux \
        vte291-devel \
        webkit2gtk3-devel \
        wxGTK3-devel \
        "pkgconfig(protobuf)" \
        "pkgconfig(glib-2.0)" \
        "pkgconfig(gobject-introspection-1.0)" \
        "pkgconfig(zlib)"; \
        dnf install -y \
        yum-utils \
        rpm-build \
        pixman-devel \
        libpng-devel \
        libxml2-devel \
        freetype-devel \
        fontconfig-devel \
        gtk-doc \
        gnome-common \
        intltool \
        libjpeg-devel \
        libtiff-devel \
        hicolor-icon-theme \
        abattis-cantarell-fonts \
        liberation-mono-fonts \
        liberation-sans-fonts \
        liberation-serif-fonts \
        python-mako \
        ncurses-devel \
        icon-naming-utils \
        dbus-devel \
        desktop-file-utils \
        libuuid-devel \
        appdata-tools \
        iso-codes-devel \
        mozjs24-devel \
        readline-devel \
        dbus-glib-devel \
        gcc-c++ \
        createrepo \
        lighttpd \
        gnome-doc-utils \
        vala-devel \
        vala-tools \
        libxslt-devel \
        fuse-devel \
        libarchive-devel \
        libcroco-devel \
        libpeas-loader-python3.x86_64 \
        python3-lxml \
        python3-jedi.noarch \
        python2-jedi \
        vim-jedi; \
        dnf remove openssl-devel -y && \
        dnf install compat-openssl10-devel -y && \
        dnf install -y ruby-devel.x86_64 \
                       ruby-libs.x86_64; \
        dnf clean all

# SOURCE: https://bugzilla.redhat.com/show_bug.cgi?id=1259643
# Warning: python3-lxml is not installed, no documentation will be available in Python auto-completion
# jedi not found, python auto-completion not possible.

# pip3 install -I path.py==7.7.1; \
RUN cd /usr/local/src/; \
    curl -s -q -L 'https://bootstrap.pypa.io/ez_setup.py' > ez_setup.py; \
    curl -s -q -L 'https://bootstrap.pypa.io/get-pip.py' > get-pip.py; \
    python ez_setup.py; \
    python get-pip.py; \
    cd /usr/local/src/; \
    python3 ez_setup.py; \
    python3 get-pip.py; \
    pip3 install virtualenv virtualenvwrapper ipython; \
    pip3 install meson

# DISABLED(4/10/2018): WE don't need to compile it from source if we have it available in flatpak already
# RUN cd /usr/local/src && \
#     git clone git://git.gnome.org/gnome-builder && \
#     cd gnome-builder && \
#     git checkout 3.28.0 && \
#     meson --prefix=/usr build && \
#     ninja -C build && \
#     ninja -C build install

RUN set -xe \
    && useradd -U -d /home/developer -m -r -G adm,tty,audio developer \
    && usermod -a -G developer -s /bin/bash -u ${HOST_USER_ID} developer \
    && groupmod -g ${HOST_GROUP_ID} developer \
    && ( mkdir /home/developer/.ssh \
    && chmod og-rwx /home/developer/.ssh \
    && echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > /home/developer/.ssh/authorized_keys \
    ) \
    && echo 'developer     ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo '%developer     ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && cat /etc/sudoers \
    && echo 'developer:developer' | chpasswd && \
    mkdir /home/${NON_ROOT_USER}/dev && \
    mkdir -p /home/${NON_ROOT_USER}/.local/share/fonts && \
    chown developer:developer -Rv /home/developer

RUN mkdir /var/run/dbus

# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8.5.0

# install nvm
# SOURCE: https://gist.github.com/remarkablemark/aacf14c29b3f01d6900d13137b21db3a
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# confirm installation
RUN node -v
RUN npm -v

RUN chown ${NON_ROOT_USER}:${NON_ROOT_USER} -R /usr/local/nvm

# https://github.com/pyenv/pyenv/issues/950
# SOURCE: https://github.com/pyenv/pyenv/issues/950#issuecomment-348373683
# RUN dnf remove openssl-devel -y && dnf install compat-openssl10-devel -y && dnf install -y ruby-devel.x86_64 ruby-libs.x86_64

# SOURCE: https://docs.docker.com/engine/reference/builder/#copy
COPY --chown=developer:developer ./ /app

USER developer

####################################
ENV LANG C.UTF-8
# ENV CI true
ENV PYENV_ROOT /home/${NON_ROOT_USER}/.pyenv
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"

RUN curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash && \
    git clone --depth 1 https://github.com/pyenv/pyenv-virtualenvwrapper /home/${NON_ROOT_USER}/.pyenv/plugins/pyenv-virtualenvwrapper && \
    git clone --depth 1 https://github.com/pyenv/pyenv-pip-rehash /home/${NON_ROOT_USER}/.pyenv/plugins/pyenv-pip-rehash && \
    git clone --depth 1 https://github.com/pyenv/pyenv-pip-migrate /home/${NON_ROOT_USER}/.pyenv/plugins/pyenv-pip-migrate && \
    pyenv install 3.5.2

# ########################[EDITOR RELATED SETUP STUFF]################################

# # Install rbenv to manage ruby versions
RUN git clone --depth 1 https://github.com/rbenv/rbenv.git ~/.rbenv && \
    cd ~/.rbenv && src/configure && make -C src && \
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc && \
    git clone --depth 1 https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# # Install vim-plug
# RUN curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ENV DOTFILE_VERSION master
RUN git clone --depth 1 --branch ${DOTFILE_VERSION} https://github.com/bossjones/linux-dotfiles.git /home/${NON_ROOT_USER}/.dotfiles;

# RUN git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git /home/${NON_ROOT_USER}/dev/nerd-fonts

# # RUN bash -c "source /home/${NON_ROOT_USER}/.dotfiles/install.sh"

# # FIXME: Enable this!!!!!!!!
# RUN pip3 install --upgrade pip && \
# pip3 install --user neovim jedi mistune psutil setproctitle
# pip install gitpython ptpython ipython

ENV NODE_VERSION 6.9.1
ENV RUBY_VERSION 2.4.2

# Compile and speed up ruby compilation
# RUN bash -c "source ~/.bashrc; RUBY_CFLAGS=\"-03\" rbenv install $RUBY_VERSION"

# # NOTE: https://github.com/jarolrod/vim-python-ide
# FIXME: Eanble this back again
# RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/jarolrod/vim-python-ide/master/setup.sh)" && \
#     git clone https://github.com/chriskempson/base16-shell.git /home/${NON_ROOT_USER}/.config/base16-shell
RUN echo 'BASE16_SHELL=$HOME/.config/base16-shell/' >> ~/.bashrc
RUN echo '[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"'  >> ~/.bashrc

# # FIXME: Add this to your vimrc file
# # if filereadable(expand("~/.vimrc_background"))
# #   let base16colorspace=256
# #   source ~/.vimrc_background
# # endif

# # Install neovim plugins
# # vundle
# RUN bash -c "nvim +PluginInstall +qall"

RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(pyenv init -)"' >> ~/.bashrc
RUN echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
# SOURCE: https://github.com/pyenv/pyenv-virtualenvwrapper
RUN echo 'export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"' >> ~/.bashrc

# # Setup virtualenvwrapper overall
RUN set -x; . /home/$NON_ROOT_USER/.bashrc; \
    pyenv global 3.5.2; pyenv virtualenvwrapper; \
    pip3 install --upgrade pip && \
    pip install --user neovim jedi mistune psutil setproctitle && \
    pip install gitpython ptpython ipython

# # FIXME: bashrc is not being sourced, .profile is!! Fix this!

# # RUN npm install -g neovim && \
# #     gem install neovim

RUN mkdir -p ~/.local/share/fonts/ && \
    git clone --depth 1 git://github.com/powerline/fonts.git ~/.config/powerline/fonts && \
    bash ~/.config/powerline/fonts/install.sh && \
    pip install --user powerline-status powerline-gitstatus==1.2.1
# # ####################################


# USER developer
# ENV HOME /home/developer
# CMD dbus-daemon --system --fork && /usr/bin/firefox


# ENTRYPOINT ["/entrypoint.sh"]

# CMD ["/usr/bin/gnome-builder"]

############################################################
#### If we ever decide to include vnc stuff
############################################################

# # RUN label is for atomic cli, allows for ease of use
# LABEL RUN='docker run -d -p 5901:5901 -v /etc/machine-id:/etc/machine-id:ro $IMAGE'

# # Install the appropriate software
# RUN dnf -y update && \
#     dnf -y install firefox \
#     xorg-x11-twm \
#     tigervnc-server \
#     xterm \
#     dejavu-sans-fonts  \
#     dejavu-serif-fonts \
#     xdotool && \
#     dnf clean all

# xdotool: fake keyboard/mouse input, window management, and more
# twm: twm (Tab Window Manager) is a window manager for the X Window System.

# # Add the xstartup file into the image and set the default password.
# RUN mkdir /root/.vnc
# ADD ./xstartup /root/.vnc/
# RUN chmod -v +x /root/.vnc/xstartup
# RUN echo 123456 | vncpasswd -f > /root/.vnc/passwd
# RUN chmod -v 600 /root/.vnc/passwd

# RUN sed -i '/\/etc\/X11\/xinit\/xinitrc-common/a [ -x /usr/bin/firefox ] && /usr/bin/firefox &' /etc/X11/xinit/xinitrc

# EXPOSE 5901

# CMD    ["vncserver", "-fg" ]

RUN echo 'export PATH="/app/bin:$PATH"' >> ~/.bashrc
